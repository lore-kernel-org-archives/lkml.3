Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbaHTI7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:59:24 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34236 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTI7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:59:21 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7K8xHvs002796, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/4] r8152: firmware support
Date: Wed, 20 Aug 2014 16:58:35 +0800
Message-ID: <1394712342-15778-16-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parsing, checking, and writing the firmware.

Hayes Wang (4):
  r8152: check code with checkpatch.pl
  r8152: replace strncpy with strlcpy
  r8152: remove clear_bp function
  r8152: support firmware files

 drivers/net/usb/r8152.c | 961 +++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 903 insertions(+), 58 deletions(-)

-- 
1.9.3

