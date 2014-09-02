Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912AbaIBJzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:55:25 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43398 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbaIBJzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:55:24 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s829tJVF015888, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: [PATCH net-next 0/2] r8152: random MAC address
Date: Tue, 2 Sep 2014 17:55:09 +0800
Message-ID: <1394712342-15778-26-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the interface has invalid MAC address, it couldn't
be used. In order to let it work normally, give a
random one.

Hayes Wang (2):
  r8152: change the location of rtl8152_set_mac_address
  r8152: use eth_hw_addr_random

 drivers/net/usb/r8152.c | 65 ++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 28 deletions(-)

-- 
1.9.3

