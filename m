Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbaLIQqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 11:46:13 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:49396 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757073AbaLIQqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 11:46:12 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sB9Gk9RN025872, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next 0/9] r8169:update hardware ephy parameter
Date: Wed, 10 Dec 2014 00:45:54 +0800
Message-ID: <1418143563-7652-1-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update hardware ephy parameter to improve pcie compatibility.

These series of patch include the ephy update of following adapters.
rtl8168g
rtl8168gu
rtl8411b
rtl8411
rtl8168fb
rtl8168e-vl
rtl8168dp
rtl8105
rtl8402

Chunhao Lin (9):
  r8169:update rtl8168g ephy parameter
  r8169:update rtl8168gu ephy parameter
  r8169:update rtl8411b ephy parameter
  r8169:update rtl8411 ephy parameter
  r8169:update rtl8168fb ephy parameter
  r8169:update rtl8168e-vl ephy parameter
  r8169:update rtl8168dp ephy parameter
  r8169:update rtl8105e ephy parameter
  r8169:update rtl8402 ephy parameter

 drivers/net/ethernet/realtek/r8169.c | 127 +++++++++++++++++++++--------------
 1 file changed, 78 insertions(+), 49 deletions(-)

-- 
1.9.1

