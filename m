Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaILDj1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 23:39:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:55307 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaILDj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 23:39:26 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8C3dMuF015393, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: <netdev@vger.kernel.org>
CC: <nic_swsd@realtek.com>, <linux-kernel@vger.kernel.org>,
        Hayes Wang <hayeswang@realtek.com>
Subject: [PATCH net 0/2] r8169: fix rx vlan
Date: Fri, 12 Sep 2014 11:35:10 +0800
Message-ID: <1394712342-15778-38-Taiwan-albertk@realtek.com>
X-Mailer: Microsoft Office Outlook 11
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.71.44]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two issues for hw rx vlan. The patches are
used to fix them.

Hayes Wang (2):
  r8169: fix the default setting of rx vlan
  r8169: fix setting rx vlan

 drivers/net/ethernet/realtek/r8169.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

-- 
1.9.3

