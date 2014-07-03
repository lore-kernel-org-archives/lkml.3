Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965152AbaGCWIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 18:08:53 -0400
Received: from smtprelay0081.hostedemail.com ([216.40.44.81]:33758 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S964867AbaGCWIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 18:08:38 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1431:1534:1541:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3350:3865:3872:5007:6119:6261:7809:8957:10004:10026:10848:11026:11232:11657:11658:11914:12043:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: boys37_2e02fbbd9d04c
X-Filterd-Recvd-Size: 1756
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 16/16] MAINTAINERS: Update rcu torture patterns
Date: Thu,  3 Jul 2014 15:08:00 -0700
Message-Id: <0b75a7766bc8b511b0397a7bf8b76643d0a0680c.1404425177.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1404425176.git.joe@perches.com>
References: <cover.1404425176.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 51b1130eb582 ("rcutorture: Abstract rcu_torture_random()")
moved the file, update the patterns

Signed-off-by: Joe Perches <joe@perches.com>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index de0d181..473c00c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7374,7 +7374,7 @@ L:	linux-kernel@vger.kernel.org
 S:	Supported
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git
 F:	Documentation/RCU/torture.txt
-F:	kernel/rcu/torture.c
+F:	kernel/rcu/rcutorture.c
 
 RCUTORTURE TEST FRAMEWORK
 M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
@@ -7418,7 +7418,7 @@ X:	Documentation/RCU/torture.txt
 F:	include/linux/rcu*
 X:	include/linux/srcu.h
 F:	kernel/rcu/
-X:	kernel/rcu/torture.c
+X:	kernel/torture.c
 
 REAL TIME CLOCK (RTC) SUBSYSTEM
 M:	Alessandro Zummo <a.zummo@towertech.it>
-- 
1.8.1.2.459.gbcd45b4.dirty

