Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaLBItC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 03:49:02 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:38371 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaLBItA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 03:49:00 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB28mk56032092, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 0/2] r8169:change hardware setting
Date: Tue, 2 Dec 2014 16:48:29 +0800
Message-ID: <1417510111-3568-1-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains two hardware setting modification to prevent
hardware become abnormal.

Chunhao Lin (2):
  r8169:prevent enable hardware tx/rx too early
  r8169:disable rtl8168ep cmac engine

 drivers/net/ethernet/realtek/r8169.c | 33 ++++++++++++++++++++++-----------
 1 file changed, 22 insertions(+), 11 deletions(-)

-- 
1.9.1

