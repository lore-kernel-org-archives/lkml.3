Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbaJ2DQb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 23:16:31 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55479 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbaJ2DQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 23:16:29 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s9T3GPYe004736, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/3] r8152: patches for autosuspend
Date: Wed, 29 Oct 2014 11:12:14 +0800
Message-ID: <1394712342-15778-69-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are unexpected processes when enabling autosuspend.
These patches are used to fix them.

Hayes Wang (3):
  r8152: clear SELECTIVE_SUSPEND when autoresuming
  r8152: reset tp->speed before autoresuming in open function
  r8152: check WORK_ENABLE in suspend function

 drivers/net/usb/r8152.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

-- 
1.9.3

