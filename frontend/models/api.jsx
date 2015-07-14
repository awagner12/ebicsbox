class Api {
  // Account api

  static fetchAllAccounts() {
    return this.get(`/accounts`)
  }

  static fetchAccount(id) {
    return this.get(`/accounts/${id}`)
  }

  static createAccount(data) {
    return this.post('/accounts', data)
  }

  static updateAccount(id, data) {
    return fetch(`/accounts/${id}`, { method: 'put', headers: this.headers, body: JSON.stringify(data) })
      .then(this.status)
      .then(this.json);
  }

  // generic api methods

  static post(path, data) {
    return fetch(path, { method: 'post', headers: this.headers, body: JSON.stringify(data) })
      .then(this.status)
      .then(this.json);
  }

  static get(path) {
    return fetch(path, { method: 'get', headers: this.headers })
      .then(this.status)
      .then(this.json);
  }

  static status(response) {
    if (response.status >= 200 && response.status < 300) {
      return response
    }
    return response.json().then((data) => { throw new Error(data.error) });
  }

  static json(response) {
    return response.json()
  }
}

Api.headers = {
  'Accept': 'application/json',
  'Content-Type': 'application/json'
}

export default Api
