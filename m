Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933866Ab3FSAD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:03:29 -0400
Received: from sam.nabble.com ([216.139.236.26]:39104 "EHLO sam.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933850Ab3FSADR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:03:17 -0400
Date: Tue, 18 Jun 2013 17:02:51 -0700 (PDT)
From: ghostrain <605033747@qq.com>
To: linux-kernel@vger.kernel.org
Message-ID: <1371600171271-670040.post@n7.nabble.com>
Subject: How to modify channel width with ath9k driver?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there!
 
I am hacking into linux wireless driver to modify channel width dynamicly.
Basicly, what I want to do is:
 
1) initially, the client uses 20MHz channel width and receives data at 20MHz
rates from the AP
 
2) then, the client switches to 40MHz channel width and receives data from
AP at 40MHz rates
 
What I have done now is:
 
1) in 20MHz mode, client sends an action frame to AP requesting using 40MHz
rates (I used the Notify Channel Width field defined in 11n spec)
 
2) on receiving request, AP sends back an ACK frame (what I want to but
haven't done here is changing AP's channel width to 40MHz)
 
3) client receives the ACK (and what I want to but haven't done is changing
client's channel width from 20MHz to 40MHz)
 
action frame is received and handled in ieee80211_rx_h_action() in
net/mac80211/rx.c
 
I truly appreciate your time and suggestions!
Thanks!



--
View this message in context: http://linux-kernel.2935.n7.nabble.com/How-to-modify-channel-width-with-ath9k-driver-tp670040.html
Sent from the Linux Kernel mailing list archive at Nabble.com.
