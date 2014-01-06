Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbaAFGjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 01:39:43 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:43070 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaAFGjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 01:39:41 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s066db0q018984, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] adjust the code of r8152
Date: Mon, 6 Jan 2014 14:39:23 +0800
Message-ID: <1388990366-8508-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace some tabs and modify the return value of rtl_ops_init().

Hayes Wang (3):
  r8152: replace some tabs with spaces
  r8152: move the actions of saving the information of the device
  r8152: replace the return value of rtl_ops_init

 drivers/net/usb/r8152.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

-- 
1.8.4.2

