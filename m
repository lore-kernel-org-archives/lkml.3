Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934474Ab3BSTE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:04:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54372 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab3BSSww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:52 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 45/81] MAINTAINERS: Stephen Hemminger email change
Date: Tue, 19 Feb 2013 15:49:08 -0300
Message-Id: <1361299784-8830-46-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen.hemminger@vyatta.com>

commit adbbf69d1a54abf424e91875746a610dcc80017d upstream.

I changed my email because the vyatta.com mail server is now
redirected to brocade.com; and the Brocade mail system
is not friendly to Linux desktop users.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0d67d1b..5927882 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2663,7 +2663,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4385,7 +4385,7 @@ S:	Maintained
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*
@@ -4630,7 +4630,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
-- 
1.7.9.5

