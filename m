Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab3BLUyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:54:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53717 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757277Ab3BLUhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:37:11 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 06/22] MAINTAINERS: Stephen Hemminger email change
Date: Tue, 12 Feb 2013 12:36:49 -0800
Message-Id: <20130212203414.749976588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203413.459836020@linuxfoundation.org>
References: <20130212203413.459836020@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Stephen Hemminger <stephen.hemminger@vyatta.com>

[ Upstream commit adbbf69d1a54abf424e91875746a610dcc80017d ]

I changed my email because the vyatta.com mail server is now
redirected to brocade.com; and the Brocade mail system
is not friendly to Linux desktop users.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 MAINTAINERS |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2491,7 +2491,7 @@ S:	Maintained
 F:	drivers/net/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@linux-foundation.org>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4327,7 +4327,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@linux-foundation.org>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c
@@ -5779,7 +5779,7 @@ S:	Maintained
 F:	drivers/usb/misc/sisusbvga/
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
-M:	Stephen Hemminger <shemminger@linux-foundation.org>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/skge.*


