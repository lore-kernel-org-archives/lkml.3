Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227AbaCDMBw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 07:01:52 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:36548 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703AbaCDMBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 07:01:48 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s24C1jYn025481, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 00/12] r8152: new features
Date: Tue, 4 Mar 2014 20:00:52 +0800
Message-ID: <1393934464-23675-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.4.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides the adjustment of the code, support rx checksum,
TCP large send, and IPv6.

Hayes Wang (12):
  r8152: deal with the empty line and space
  r8152: replace tp->netdev with netdev
  r8152: remove rtl8152_get_stats
  r8152: replace spin_lock_irqsave and spin_unlock_irqrestore
  r8152: check tx agg list before spin lock
  r8152: up the priority of the transmission
  r8152: support rx checksum
  r8152: support TSO
  r8152: support IPv6
  r8152: reduce the numbers of the bulks
  r8152: add additional parameter for non x86 platform
  r8152: modify the tx timeout funcfion

 drivers/net/usb/r8152.c | 436 +++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 343 insertions(+), 93 deletions(-)

-- 
1.8.4.2

