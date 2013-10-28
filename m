Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3J1L6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 07:58:35 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35707 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755683Ab3J1L6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 07:58:33 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.37 with qID r9SBwUrV016679, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH 0/5] r8152 bug fixes
Date: Mon, 28 Oct 2013 19:58:09 +0800
Message-ID: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.218]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These could fix some driver issues.

Hayes Wang (5):
  net/usb/r8152: fix tx/rx memory overflow
  net/usb/r8152: make sure the tx checksum setting is correct
  net/usb/r8152: modify the tx flow
  net/usb/r8152: fix incorrect type in assignment
  net/usb/r8152: code adjust

 drivers/net/usb/r8152.c | 145 +++++++++++++++++++-----------------------------
 1 file changed, 57 insertions(+), 88 deletions(-)

-- 
1.8.3.1

