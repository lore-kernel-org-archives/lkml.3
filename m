Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbaLCWHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 17:07:19 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:32857 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbaLCWHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 17:07:16 -0500
From: Andrew Shewmaker <agshew@gmail.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, corbet@lwn.net,
        jhs@mojatatu.com, davem@davemloft.net,
        Andrew Shewmaker <agshew@gmail.com>
Subject: [PATCH net] Update old iproute2 and Xen Remus links
Date: Wed,  3 Dec 2014 14:07:31 -0800
Message-Id: <1417644451-7305-1-git-send-email-agshew@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andrew Shewmaker <agshew@gmail.com>
---
 Documentation/Changes | 2 +-
 net/sched/Kconfig     | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/Changes b/Documentation/Changes
index 1de131b..74bdda9 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -383,7 +383,7 @@ o  <http://www.iptables.org/downloads.html>
 
 Ip-route2
 ---------
-o  <ftp://ftp.tux.org/pub/net/ip-routing/iproute2-2.2.4-now-ss991023.tar.gz>
+o  <https://www.kernel.org/pub/linux/utils/net/iproute2/>
 
 OProfile
 --------
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index a1a8e29..d17053d 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -22,8 +22,9 @@ menuconfig NET_SCHED
 	  This code is considered to be experimental.
 
 	  To administer these schedulers, you'll need the user-level utilities
-	  from the package iproute2+tc at <ftp://ftp.tux.org/pub/net/ip-routing/>.
-	  That package also contains some documentation; for more, check out
+	  from the package iproute2+tc at
+	  <https://www.kernel.org/pub/linux/utils/net/iproute2/>.  That package
+	  also contains some documentation; for more, check out
 	  <http://www.linuxfoundation.org/collaborate/workgroups/networking/iproute2>.
 
 	  This Quality of Service (QoS) support will enable you to use
@@ -336,7 +337,7 @@ config NET_SCH_PLUG
 	  of virtual machines by allowing the generated network output to be rolled
 	  back if needed.
 
-	  For more information, please refer to http://wiki.xensource.com/xenwiki/Remus
+	  For more information, please refer to <http://wiki.xenproject.org/wiki/Remus>
 
 	  Say Y here if you are using this kernel for Xen dom0 and
 	  want to protect Xen guests with Remus.
-- 
2.1.0

