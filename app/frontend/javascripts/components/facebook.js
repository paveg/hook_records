import React, {Component} from 'react';
import FacebookLogin from 'react-facebook-login';

export default class Facebook extends Component {
    state = {
        isLoggedIn: false,
        userId: '',
        name: '',
        email: '',
        picture: ''
    };

    responseFacebook = response => {
        console.log(response);
    };

    componenteClicked = () => console.log('clicked');

    render() {
        let fbContent;
        if (this.state.isLoggedIn) {
            fbContent = null;
        } else {
            fbContent = (
                <FacebookLogin
                    appId="423417918170411"
                    autoLoad={true}
                    fields="name,email,picture"
                    onclick={this.componenteClicked}
                    callback={this.responseFacebook}
                />
            )
        }
        return (
            <div>
                {fbContent}
            </div>
        )
    }
}
