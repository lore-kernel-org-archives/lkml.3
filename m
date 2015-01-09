Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107AbbAIP0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:26:20 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:57155 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757870AbbAIP0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:26:15 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID t09FQB3p025958, This message is accepted by code: ctloc85258
From: Chunhao Lin <hau@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Chunhao Lin <hau@realtek.com>
Subject: [PATCH net-next v2 0/8]r8169:update hardware parameter
Date: Fri, 9 Jan 2015 23:25:58 +0800
Message-ID: <1420817166-9868-1-git-send-email-hau@realtek.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These series of patch include the pcie ephy parameter update of
following adapters.
rtl8411
rtl8168f
rtl8168evl
rtl8168dp
rtl8105
rtl8402

And include jumbo frame patch update of following adapters.
rtl8168dp
rtl8168e
rtl8168evl

Also remove unnecessary function rtl_hw_start_8168dp and add function
rtl_hw_start_8168f_2 to set rtl8168f rev.b pcie ephy parameters.

In v2 patch, give more explanation about pcie ephy parameter update.

Chunhao Lin (8):
  r8169:change rtl8168dp jumbo frame patch
  r8169:update rtl8168e and rtl8168evl jumbo frame patch
  r8169:correct the way of setting rtl8168dp pcie ephy parameters
  r8169:rtl8168dp rev.c pcie ephy setting is the same as rtl8168dp rev.b
  r8169:update rtl8168dp pcie ephy parameters to improve power
    consumption
  r8169:update pcie ephy parameters to decrease the resume time from L0s
    to L0
  r8169:update rtl8402 pcie ephy parameter
  r8169:update rtl8168f rev.b pcie ephy parameter

 drivers/net/ethernet/realtek/r8169.c | 112 +++++++++++++++--------------------
 1 file changed, 49 insertions(+), 63 deletions(-)

--
1.9.1

