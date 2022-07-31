function registration() {
    const slackToken = document.getElementById('registrationSlackToken').value;
    const appId = document.getElementById('registrationAppId').value;

    const method = "POST";
    const headers = {
      'Content-Type': 'application/json'
    };
    const obj = { 'slackToken': slackToken, 'appId': appId };
    const body = JSON.stringify(obj);

    const url = 'https://3asu6ywuha2eezgaqlw2sf7ghe0yzzho.lambda-url.ap-northeast-1.on.aws/'

    fetch(url, {method, headers, body})
      .then(response => {
        if (!response.ok) {
          console.error('response.ok:', response.ok);
          console.error('esponse.status:', response.status);
          console.error('esponse.statusText:', response.statusText);
          throw new Error(response.statusText);
        }
        return response.json();
    })
    .then(json => {
        alert(json['message']);
    })
    .catch(error => {
        console.error('エラーが発生しました', error);
        alert('エラーが発生しました');
    });
}


function unregistration() {
  const slackToken = document.getElementById('unregistrationSlackToken').value;

  const method = "POST";
  const headers = {
    'Content-Type': 'application/json'
  };
  const obj = { 'slackToken': slackToken };
  const body = JSON.stringify(obj);

  const url = 'https://3asu6ywuha2eezgaqlw2sf7ghe0yzzho.lambda-url.ap-northeast-1.on.aws/'

  fetch(url, {method, headers, body})
    .then(response => {
      if (!response.ok) {
        console.error('response.ok:', response.ok);
        console.error('esponse.status:', response.status);
        console.error('esponse.statusText:', response.statusText);
        throw new Error(response.statusText);
      }
      return response.json();
  })
  .then(json => {
      alert(json['message']);
  })
  .catch(error => {
      console.error('エラーが発生しました', error);
      alert('エラーが発生しました');
  });
}
