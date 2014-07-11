Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbaGKI0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 04:26:30 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57110 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbaGKI0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 04:26:24 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s6B8QDvX023074, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <nic_swsd@realtek.com>
Subject: [PATCH net-next 0/3] r8169: support IPv6
Date: Fri, 11 Jul 2014 16:25:55 +0800
Message-ID: <1394712342-15778-10-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The RTL8168C and the later chips support the hardware checksum
for IPv6. Adjust some code and add the relative code.

Hayes Wang (3):
  r8169: split rtl8169_tso_csum
  r8169: use Giant Send
  r8169: support IPv6

 drivers/net/ethernet/realtek/r8169.c | 220 ++++++++++++++++++++++++++++-------
 1 file changed, 181 insertions(+), 39 deletions(-)

-- 
1.9.3

