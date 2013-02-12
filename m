Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab3BLUvC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:51:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53917 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758267Ab3BLUlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:41:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 10/36] MAINTAINERS: Stephen Hemminger email change
Date: Tue, 12 Feb 2013 12:41:04 -0800
Message-Id: <20130212203858.527799257@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203857.305594226@linuxfoundation.org>
References: <20130212203857.305594226@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2627,7 +2627,7 @@ S:	Maintained
 F:	drivers/net/ethernet/i825xx/eexpress.*
 
 ETHERNET BRIDGE
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	bridge@lists.linux-foundation.org
 L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
@@ -4312,7 +4312,7 @@ S:	Maintained
 
 MARVELL GIGABIT ETHERNET DRIVERS (skge/sky2)
 M:	Mirko Lindner <mlindner@marvell.com>
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/ethernet/marvell/sk*
@@ -4563,7 +4563,7 @@ S:	Supported
 F:	drivers/infiniband/hw/nes/
 
 NETEM NETWORK EMULATOR
-M:	Stephen Hemminger <shemminger@vyatta.com>
+M:	Stephen Hemminger <stephen@networkplumber.org>
 L:	netem@lists.linux-foundation.org
 S:	Maintained
 F:	net/sched/sch_netem.c


