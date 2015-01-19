Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbbASJEK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 04:04:10 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33402 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751357AbbASJEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 04:04:07 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t0J9426w024172, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/2] r8152: couldn't read OCP_SRAM_DATA
Date: Mon, 19 Jan 2015 17:02:44 +0800
Message-ID: <1394712342-15778-126-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.122]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Read OCP_SRAM_DATA would read additional bytes and may let
the hw abnormal.

Hayes Wang (2):
  r8152: remove generic_ocp_read before writing
  r8152: remove sram_read

 drivers/net/usb/r8152.c | 30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

-- 
2.1.0

