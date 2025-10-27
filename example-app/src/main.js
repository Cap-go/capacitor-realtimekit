
import './style.css';
import { CapacitorRealtimekit } from '@capgo/capacitor-realtimekit';

const plugin = CapacitorRealtimekit;
const state = {
  initialized: false
};


const actions = [
{
              id: 'initialize',
              label: 'Initialize RealtimeKit',
              description: 'Initializes the RealtimeKit plugin. Must be called before using other methods.',
              inputs: [],
              run: async (values) => {
                await plugin.initialize();
                state.initialized = true;
                return { success: true, message: 'RealtimeKit initialized successfully' };
              },
            },
{
              id: 'start-meeting',
              label: 'Start Meeting',
              description: 'Starts a meeting with the built-in UI. Requires an auth token from your Cloudflare Calls backend.',
              inputs: [
                { name: 'authToken', label: 'Auth Token', type: 'text', value: 'demo-token-123', placeholder: 'Enter your auth token' },
                { name: 'enableAudio', label: 'Enable Audio', type: 'checkbox', value: true },
                { name: 'enableVideo', label: 'Enable Video', type: 'checkbox', value: true }
              ],
              run: async (values) => {
                if (!state.initialized) {
                  return { error: 'Please initialize the plugin first' };
                }
                await plugin.startMeeting({
                  authToken: values.authToken,
                  enableAudio: values.enableAudio,
                  enableVideo: values.enableVideo
                });
                return {
                  success: true,
                  message: 'Meeting started',
                  config: {
                    authToken: values.authToken.substring(0, 10) + '...',
                    enableAudio: values.enableAudio,
                    enableVideo: values.enableVideo
                  }
                };
              },
            },
{
              id: 'get-version',
              label: 'Get Plugin Version',
              description: 'Gets the current plugin version from the native layer.',
              inputs: [],
              run: async (values) => {
                const { version } = await plugin.getPluginVersion();
                return { version };
              },
            }
];

const actionSelect = document.getElementById('action-select');
const formContainer = document.getElementById('action-form');
const descriptionBox = document.getElementById('action-description');
const runButton = document.getElementById('run-action');
const output = document.getElementById('plugin-output');

function buildForm(action) {
  formContainer.innerHTML = '';
  if (!action.inputs || !action.inputs.length) {
    const note = document.createElement('p');
    note.className = 'no-input-note';
    note.textContent = 'This action does not require any inputs.';
    formContainer.appendChild(note);
    return;
  }
  action.inputs.forEach((input) => {
    const fieldWrapper = document.createElement('div');
    fieldWrapper.className = input.type === 'checkbox' ? 'form-field inline' : 'form-field';

    const label = document.createElement('label');
    label.textContent = input.label;
    label.htmlFor = `field-${input.name}`;

    let field;
    switch (input.type) {
      case 'textarea': {
        field = document.createElement('textarea');
        field.rows = input.rows || 4;
        break;
      }
      case 'select': {
        field = document.createElement('select');
        (input.options || []).forEach((option) => {
          const opt = document.createElement('option');
          opt.value = option.value;
          opt.textContent = option.label;
          if (input.value !== undefined && option.value === input.value) {
            opt.selected = true;
          }
          field.appendChild(opt);
        });
        break;
      }
      case 'checkbox': {
        field = document.createElement('input');
        field.type = 'checkbox';
        field.checked = Boolean(input.value);
        break;
      }
      case 'number': {
        field = document.createElement('input');
        field.type = 'number';
        if (input.value !== undefined && input.value !== null) {
          field.value = String(input.value);
        }
        break;
      }
      default: {
        field = document.createElement('input');
        field.type = 'text';
        if (input.value !== undefined && input.value !== null) {
          field.value = String(input.value);
        }
      }
    }

    field.id = `field-${input.name}`;
    field.name = input.name;
    field.dataset.type = input.type || 'text';

    if (input.placeholder && input.type !== 'checkbox') {
      field.placeholder = input.placeholder;
    }

    if (input.type === 'checkbox') {
      fieldWrapper.appendChild(field);
      fieldWrapper.appendChild(label);
    } else {
      fieldWrapper.appendChild(label);
      fieldWrapper.appendChild(field);
    }

    formContainer.appendChild(fieldWrapper);
  });
}

function getFormValues(action) {
  const values = {};
  (action.inputs || []).forEach((input) => {
    const field = document.getElementById(`field-${input.name}`);
    if (!field) return;
    switch (input.type) {
      case 'number': {
        values[input.name] = field.value === '' ? null : Number(field.value);
        break;
      }
      case 'checkbox': {
        values[input.name] = field.checked;
        break;
      }
      default: {
        values[input.name] = field.value;
      }
    }
  });
  return values;
}

function setAction(action) {
  descriptionBox.textContent = action.description || '';
  buildForm(action);
  output.textContent = 'Ready to run the selected action.';
}

function populateActions() {
  actionSelect.innerHTML = '';
  actions.forEach((action) => {
    const option = document.createElement('option');
    option.value = action.id;
    option.textContent = action.label;
    actionSelect.appendChild(option);
  });
  setAction(actions[0]);
}

actionSelect.addEventListener('change', () => {
  const action = actions.find((item) => item.id === actionSelect.value);
  if (action) {
    setAction(action);
  }
});

runButton.addEventListener('click', async () => {
  const action = actions.find((item) => item.id === actionSelect.value);
  if (!action) return;
  const values = getFormValues(action);
  try {
    const result = await action.run(values);
    if (result === undefined) {
      output.textContent = 'Action completed.';
    } else if (typeof result === 'string') {
      output.textContent = result;
    } else {
      output.textContent = JSON.stringify(result, null, 2);
    }
  } catch (error) {
    output.textContent = `Error: ${error?.message ?? error}`;
  }
});

populateActions();
