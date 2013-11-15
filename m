Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3KOH6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:58:30 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:56218 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831Ab3KOH6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:58:18 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAF7wG6p026091, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v3 0/4] r8152 bug fixes
Date: Fri, 15 Nov 2013 15:57:55 +0800
Message-ID: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I split the code of stopping/waking tx queue into the another patch.

Hayes Wang (4):
  r8152: fix tx/rx memory overflow
  r8152: modify the tx flow
  r8152: support stopping/waking tx queue
  r8152: fix incorrect type in assignment

 drivers/net/usb/r8152.c | 109 ++++++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 64 deletions(-)

-- 
1.8.3.1

