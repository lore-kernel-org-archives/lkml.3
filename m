Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3KSDZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 22:25:24 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:59020 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab3KSDZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 22:25:22 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID rAJ3PI9w016282, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v4 0/4] r8152 bug fixes
Date: Tue, 19 Nov 2013 11:25:07 +0800
Message-ID: <1384831511-1625-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
References: <1384502279-9959-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the patch #1, I modify the type of the variable "pkt_len" from "unsigned"
to "unsigned int".

Hayes Wang (4):
  r8152: fix tx/rx memory overflow
  r8152: modify the tx flow
  r8152: support stopping/waking tx queue
  r8152: fix incorrect type in assignment

 drivers/net/usb/r8152.c | 109 ++++++++++++++++++++----------------------------
 1 file changed, 45 insertions(+), 64 deletions(-)

-- 
1.8.3.1

