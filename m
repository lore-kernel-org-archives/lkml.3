Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654AbaAIGvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 01:51:10 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36695 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbaAIGvA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 01:51:00 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s096onED032539, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <oliver@neukum.org>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] r8152: behavior modification
Date: Thu, 9 Jan 2014 14:50:29 +0800
Message-ID: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose is to add a choice for determining whether add the
limitation between r8152 and ecm drivers or not.

Hayes Wang (3):
  r8152: change the descriptor
  r8152: fix the warnings and a error from checkpatch.pl
  r8152: add supporting the vendor mode only

 drivers/net/usb/Kconfig     | 14 ++++++++--
 drivers/net/usb/cdc_ether.c |  2 +-
 drivers/net/usb/r8152.c     | 62 ++++++++++++++++++++++-----------------------
 drivers/net/usb/r815x.c     |  4 +--
 4 files changed, 45 insertions(+), 37 deletions(-)

-- 
1.8.4.2

