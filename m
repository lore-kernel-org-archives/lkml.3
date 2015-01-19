Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751387AbbASHNx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 02:13:53 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:40516 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164AbbASHNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 02:13:51 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J7Dla8003926, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/7] r8152: adjust the code
Date: Mon, 19 Jan 2015 15:13:30 +0800
Message-ID: <1394712342-15778-118-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Code adjustment.

Hayes Wang (7):
  r8152: adjust rx_bottom
  r8152: adjust lpm timer
  r8152: check linking status with netif_carrier_ok
  r8152: check RTL8152_UNPLUG for rtl8152_close
  r8152: adjust the link feed for hw_features
  r8152: replace get_protocol with vlan_get_protocol
  r8152: use BIT macro

 drivers/net/usb/r8152.c | 99 +++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 53 deletions(-)

-- 
2.1.0

