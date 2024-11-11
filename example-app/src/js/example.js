import { Mixpanel } from 'capacitor-mixpanel';

window.testEcho = () => {
    const inputValue = document.getElementById("echoInput").value;
    Mixpanel.echo({ value: inputValue })
}
