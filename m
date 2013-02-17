Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab3BQXBJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 18:01:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45781 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756306Ab3BQWzl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:41 -0500
Message-Id: <20130217225006.630501393@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:44 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        Stephen Hemminger <stephen.hemminger@vyatta.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 43/66] MAINTAINERS: Stephen Hemminger email change
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Hemminger <stephen.hemminger@vyatta.com>

[ Upstream commit adbbf69d1a54abf424e91875746a610dcc80017d ]

I changed my email because the vyatta.com mail server is now
redirected to brocade.com; and the Brocade mail system
is not friendly to Linux desktop users.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 82d7fa6..83f156e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2584,7 +2584,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4475,7 +4475,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
@@ -5993,7 +5993,7 @@ S:	Maintained
 F:	drivers/usb/misc/sisusbvga/
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*


