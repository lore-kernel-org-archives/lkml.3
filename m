Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbaJAFZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 01:25:34 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48506 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaJAFZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 01:25:32 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s915PSFB001081, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/2] r8152: patches about firmware
Date: Wed, 1 Oct 2014 13:25:09 +0800
Message-ID: <1394712342-15778-51-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patches fix the issues when the firmware exists.

For the multiple OS, the firmware may be loaded by the
driver of the other OS. And the Linux driver has influences
on it.

Hayes Wang (2):
  r8152: remove clearing bp
  r8152: disable power cut for RTL8153

 drivers/net/usb/r8152.c | 30 ++----------------------------
 1 file changed, 2 insertions(+), 28 deletions(-)

-- 
1.9.3

