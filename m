Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781Ab3J2H4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 03:56:43 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:57306 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab3J2H4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 03:56:41 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9T7udlv005120, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/3] r8152 bug fixes
Date: Tue, 29 Oct 2013 15:56:14 +0800
Message-ID: <1383033377-1178-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These could fix some driver issues.

Hayes Wang (3):
  r8152: fix tx/rx memory overflow
  r8152: modify the tx flow
  r8152: fix incorrect type in assignment

 drivers/net/usb/r8152.c | 100 +++++++++++++++++-------------------------------
 1 file changed, 36 insertions(+), 64 deletions(-)

-- 
1.8.3.1

