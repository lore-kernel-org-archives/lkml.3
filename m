Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752913AbaIYM5D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 08:57:03 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49295 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaIYM5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 08:57:00 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8PCs9Km029479, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] r8152: support setting eee by ethtool
Date: Thu, 25 Sep 2014 20:53:59 +0800
Message-ID: <1394712342-15778-46-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modify some definitions about EEE, and add the support of setting
the EEE through ethtool.

Hayes Wang (3):
  r8152: change the EEE definition
  r8152: add functions to set EEE
  r8152: support ethtool eee

 drivers/net/usb/r8152.c | 246 ++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 209 insertions(+), 37 deletions(-)

-- 
1.9.3

