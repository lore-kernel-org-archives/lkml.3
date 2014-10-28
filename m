Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136AbaJ1GGN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 02:06:13 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:49245 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759085AbaJ1GGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 02:06:06 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9S661oQ009801, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/2] r8152: support nway_reset
Date: Tue, 28 Oct 2014 14:05:50 +0800
Message-ID: <1394712342-15778-66-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the CHECK from checkpatch.pl and support nway_reset.

Hayes Wang (2):
  r8152: rename tx_underun
  r8152: support nway_reset of ethtool

 drivers/net/usb/r8152.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

-- 
1.9.3

