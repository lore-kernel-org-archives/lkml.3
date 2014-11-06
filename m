Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450AbaKFEsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:48:17 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:53497 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027AbaKFEsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:48:13 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA64lwYk011569, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/3] r8152: rtl_ops_init modify
Date: Thu, 6 Nov 2014 12:47:37 +0800
Message-ID: <1394712342-15778-84-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initialize the ops through tp->version. This could skip checking
each VID/PID.

Hayes Wang (3):
  r8152: move r8152b_get_version
  r8152: modify rtl_ops_init
  r8152: remove the definitions of the PID

 drivers/net/usb/r8152.c | 92 +++++++++++++++++--------------------------------
 1 file changed, 32 insertions(+), 60 deletions(-)

-- 
1.9.3

