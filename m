Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760AbaKGJ4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:56:07 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:55351 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbaKGJz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:55:26 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA79tKHq019413, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net-next 0/2] r8152: adjust rx functions
Date: Fri, 7 Nov 2014 17:55:09 +0800
Message-ID: <1394712342-15778-88-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adjust some flows and codes which are relative to r8152_submit_rx()
and rtl_start_rx().

Hayes Wang (2):
  r8152: adjust r8152_submit_rx
  r8152: adjust rtl_start_rx

 drivers/net/usb/r8152.c | 51 +++++++++++++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 23 deletions(-)

-- 
1.9.3

