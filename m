Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaG3Sqh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 14:46:37 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:52903 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbaG3Sqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 14:46:35 -0400
X-Originating-IP: 173.246.103.110
Date: Wed, 30 Jul 2014 11:46:27 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Update my email addresses and related info
Message-ID: <20140730184540.GA7351@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My IBM email addresses haven't worked for years; also map some
old-but-functional forwarding addresses to my canonical address.

Update my GPG key fingerprint; I moved to 4096R a long time ago.

Update description.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 .mailmap                | 5 +++++
 CREDITS                 | 7 ++++---
 MAINTAINERS             | 2 +-
 kernel/rcu/rcutorture.c | 4 ++--
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/.mailmap b/.mailmap
index df1baba..1ad6873 100644
--- a/.mailmap
+++ b/.mailmap
@@ -62,6 +62,11 @@ Jeff Garzik <jgarzik@pretzel.yyz.us>
 Jens Axboe <axboe@suse.de>
 Jens Osterkamp <Jens.Osterkamp@de.ibm.com>
 John Stultz <johnstul@us.ibm.com>
+<josh@joshtriplett.org> <josh@freedesktop.org>
+<josh@joshtriplett.org> <josh@kernel.org>
+<josh@joshtriplett.org> <josht@linux.vnet.ibm.com>
+<josh@joshtriplett.org> <josht@us.ibm.com>
+<josh@joshtriplett.org> <josht@vnet.ibm.com>
 Juha Yrjola <at solidboot.com>
 Juha Yrjola <juha.yrjola@nokia.com>
 Juha Yrjola <juha.yrjola@solidboot.com>
diff --git a/CREDITS b/CREDITS
index 28ee151..a80b667 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3511,10 +3511,11 @@ S: MacGregor A.C.T 2615
 S: Australia
 
 N: Josh Triplett
-E: josh@freedesktop.org
-P: 1024D/D0FE7AFB B24A 65C9 1D71 2AC2 DE87  CA26 189B 9946 D0FE 7AFB
-D: rcutorture maintainer
+E: josh@joshtriplett.org
+P: 4096R/8AFF873D 758E 5042 E397 4BA3 3A9C  1E67 0ED9 A3DF 8AFF 873D
+D: RCU and rcutorture
 D: lock annotations, finding and fixing lock bugs
+D: kernel tinification
 
 N: Winfried Trümper
 E: winni@xpilot.org
diff --git a/MAINTAINERS b/MAINTAINERS
index 702ca10..b2a42e6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7387,7 +7387,7 @@ S:	Orphan
 F:	drivers/net/wireless/ray*
 
 RCUTORTURE MODULE
-M:	Josh Triplett <josh@freedesktop.org>
+M:	Josh Triplett <josh@joshtriplett.org>
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
 L:	linux-kernel@vger.kernel.org
 S:	Supported
diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
index 7fa34f8..948a769 100644
--- a/kernel/rcu/rcutorture.c
+++ b/kernel/rcu/rcutorture.c
@@ -18,7 +18,7 @@
  * Copyright (C) IBM Corporation, 2005, 2006
  *
  * Authors: Paul E. McKenney <paulmck@us.ibm.com>
- *	  Josh Triplett <josh@freedesktop.org>
+ *	  Josh Triplett <josh@joshtriplett.org>
  *
  * See also:  Documentation/RCU/torture.txt
  */
@@ -51,7 +51,7 @@
 #include <linux/torture.h>
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@freedesktop.org>");
+MODULE_AUTHOR("Paul E. McKenney <paulmck@us.ibm.com> and Josh Triplett <josh@joshtriplett.org>");
 
 
 torture_param(int, fqs_duration, 0,
-- 
2.0.1

