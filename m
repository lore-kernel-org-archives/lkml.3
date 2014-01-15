Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaAOCmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:42:36 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36494 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaAOCmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:42:33 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s0F2gLSw019167, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <oliver@neukum.org>, <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next v2 0/3] r8152: remove limitation
Date: Wed, 15 Jan 2014 10:42:13 +0800
Message-ID: <1389753736-2218-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
References: <1389250232-8663-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the limitation between ecm mode and vendor mode.

v2: replace the patch #3 with "ecm and vendor modes coexist".

Hayes Wang (3):
  r8152: change the descriptor
  r8152: fix the warnings and a error from checkpatch.pl
  r8152: ecm and vendor modes coexist

 drivers/net/usb/Kconfig     |  5 ++--
 drivers/net/usb/cdc_ether.c |  9 -------
 drivers/net/usb/r8152.c     | 62 ++++++++++++++++++---------------------------
 drivers/net/usb/r815x.c     |  8 ------
 4 files changed, 27 insertions(+), 57 deletions(-)

-- 
1.8.4.2

