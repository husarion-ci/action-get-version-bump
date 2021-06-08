const core = require('@actions/core');
const github = require('@actions/github');

try {
  const inputText = core.getInput('text');

  if (inputText.indexOf('bump::major') >= 0) {
    core.setOutput('bump', 'major');
  }
  else if (inputText.indexOf('bump::minor') >= 0) {
    core.setOutput('bump', 'minor')
  }
  else if (inputText.indexOf('bump::patch') >= 0) {
    core.setOutput('bump', 'patch')
  }

} catch (error) {
  core.setFailed(error.message);
}