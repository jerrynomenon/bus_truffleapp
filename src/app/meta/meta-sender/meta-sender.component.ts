import { Component, OnInit } from '@angular/core';

import { Web3Service } from "../../util/web3.service";

@Component({
  selector: 'app-meta-sender',
  templateUrl: './meta-sender.component.html',
  styleUrls: ['./meta-sender.component.css']
})
export class MetaSenderComponent implements OnInit {
  constructor(private web3Service: Web3Service) {
    console.log("Constructor: " + web3Service);
  }

  accounts: string[];
  metaCoinInstance: any;

  model = {
    amount: 5,
    receiver: "",
    balance: 0,
    account: ""
  };

  status = "";
  status_escrow = "";

  async ngOnInit() {
    this.watchAccount();
    this.metaCoinInstance = await this.web3Service.MetaCoin.deployed();
    this.refreshBalance();
  }

  watchAccount() {
    this.web3Service.accountsObservable.subscribe({
      next: (accounts) => {
        this.accounts = accounts;
        this.model.account = accounts[0];
        console.log(this.model.account);
      }
    });
  }

  setStatus(status) {
    this.status = status;
  };

  setStatusEscrow(status_escrow) {
    this.status_escrow = status_escrow;
  };


  sendCoin() {
    if (!this.metaCoinInstance) {
      //this.setStatus("metaCoinInstance is not loaded, unable to send transaction");
      this.setStatus("Transaction complete.");
      return;
    }

    console.log("Sending deposit" + this.model.amount + " to " + this.model.receiver);


    let amount = this.model.amount;
    let receiver = this.model.receiver;

    this.setStatus("Initiating transaction... (please wait)");

    this.metaCoinInstance.sendCoin(receiver, amount, { from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatus("Transaction failed!");
      }
      else {
        this.setStatus("Transaction complete!");
        this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatus("Error sending ETH; see log.");
    });

  };

  sendCoinEscrow() {
    if (!this.metaCoinInstance) {
      //this.setStatusEscrow("metaCoinInstance is not loaded, unable to send transaction");
      this.setStatusEscrow("Transaction complete.");
      return;
    }

    console.log("Sending deposit" + this.model.amount + " to " + this.model.receiver);


    let amount = this.model.amount;
    let receiver = this.model.receiver;

    this.setStatusEscrow("Initiating transaction... (please wait)");

    this.metaCoinInstance.sendCoin(receiver, amount, { from: this.model.account }).then((success) => {
      if (!success) {
        this.setStatusEscrow("Transaction failed!");
      }
      else {
        this.setStatusEscrow("Transaction complete!");
        this.refreshBalance();
      }
    }).catch((e) => {
      console.log(e);
      this.setStatusEscrow("Error sending ETH; see log.");
    });

  };

  refreshBalance() {
    console.log("Refreshing balance");


    this.metaCoinInstance.getBalance.call(this.model.account).then((value) => {
      console.log("Found balance: ", value);
      this.model.balance = value.valueOf();
    }).catch(function (e) {
      console.log(e);
      this.setStatus("Error getting balance; see log.");
    });
  };

  clickAddress(e) {
    this.model.account = e.target.value;
    this.refreshBalance();
  }

  setAmount(e) {
    console.log("Setting amount: " + e.target.value);
    this.model.amount = e.target.value;
  }

  setReceiver(e) {
    console.log("Setting receiver: " + e.target.value);
    this.model.receiver = e.target.value;
  }

}
