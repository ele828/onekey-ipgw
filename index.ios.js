/**
 * Author: Eric Wong
 * 东大网关一键登录
 * @flow
 */

import React, {
  AppRegistry,
  Component,
  StyleSheet,
  View,
  Dimensions,
  WebView
} from 'react-native';

const LOGIN_URL = 'http://ipgw.neu.edu.cn:803/srun_portal_phone.php?ac_id=1&';

const injectedJS = `
  var $ = document.querySelectorAll.bind(document);
  var form = document.form2;
  var loginBtn = $('.weui_btn_primary')[0];
  var switcher = $('.weui_switch')[0];
  var inputs = $('.weui_input');
  var userInput = inputs[0];
  var passInput = inputs[1];

  var retBtn = $('.weui_btn_warn')[0];

  // 返回按钮
  // 重定向会导致JS注入脚本执行不正确
  // 这里暂时写死手机端地址
  // FIXME: 是否有更好的办法？
  if (retBtn.innerHTML.indexOf('重新') > 0) {
    retBtn.setAttribute('href', '${LOGIN_URL}');
  }

  form.setAttribute('onsubmit', 'return false');

  // 自动填写密码
  var saved = {
    username: localStorage.getItem('username'),
    password: localStorage.getItem('password')
  };

  if (saved.username && saved.password) {
    userInput.value = saved.username;
    passInput.value = saved.password;
  }

  loginBtn.addEventListener('click', function() {

    var username = userInput.value;
    var password = passInput.value;
    var remember = switcher.checked;

    if (!username || !password)
      return alert('请输入用户名和密码！');

    // 记住密码
    if (remember) {
      localStorage.setItem('username', username);
      localStorage.setItem('password', password);
    }

    form.submit();
  });
`;

class ipgw extends Component {

  render() {
    return (
      <View style={styles.container}>
        <WebView
          ref='webview'
          automaticallyAdjustContentInsets={false}
          style={styles.webView}
          source={{uri: LOGIN_URL}}
          javaScriptEnabled={true}
          injectedJavaScript={injectedJS}
          domStorageEnabled={true}
          decelerationRate="normal"
          startInLoadingState={true}
        />
      </View>
    );
  }
}

const {height, width} = Dimensions.get('window');

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#FBF9FE',
  },
  webView: {
    marginTop: 20,
    height: height/2,
    width: width
  },
});

AppRegistry.registerComponent('ipgw', () => ipgw);
