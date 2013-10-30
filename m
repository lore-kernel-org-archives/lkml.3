Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab3J3HOL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 03:14:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35379 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625Ab3J3HOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 03:14:08 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9U7E67r031787, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net v2 0/3] r8152 bug fixes
Date: Wed, 30 Oct 2013 15:13:37 +0800
Message-ID: <1383117220-893-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383033377-1178-1-git-send-email-hayeswang@realtek.com>
References: <1383033377-1178-1-git-send-email-hayeswang@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have update the commit messages. I hope they are clear enough.

I remove the stop/wake tx queue from the second patch first, until
I find a way to determine which value is suitable for TX_QLEN.

Hayes Wang (3):
  r8152: fix tx/rx memory overflow
  r8152: modify the tx flow
  r8152: fix incorrect type in assignment

 drivers/net/usb/r8152.c | 94 +++++++++++++++----------------------------------
 1 file changed, 29 insertions(+), 65 deletions(-)

-- 
1.8.3.1

