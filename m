Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037AbaKXDKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 22:10:17 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:45236 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750804AbaKXDKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 22:10:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAO3ABZs004180, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/2] r8152: use ECM mode for future chips
Date: Mon, 24 Nov 2014 11:09:47 +0800
Message-ID: <1394712342-15778-101-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the future chips which the r8152 doesn't support yet, we could
still use ECM mode for basic transmission.

Hayes Wang (2):
  r8152: redefine REALTEK_USB_DEVICE
  r8152: use ECM mode for unsupported chips

 drivers/net/usb/r8152.c | 118 +++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 107 insertions(+), 11 deletions(-)

-- 
1.9.3

