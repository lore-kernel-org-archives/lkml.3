Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaGJThU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:37:20 -0400
Received: from mail-yh0-f50.google.com ([209.85.213.50]:40442 "EHLO
	mail-yh0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbaGJThS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:37:18 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: trivial@kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] doc: fix acronym for read-modify-write
Date: Thu, 10 Jul 2014 15:37:32 -0400
Message-Id: <1405021052-8760-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix acronym for read-modify-write from RMV to RMW

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
---
 Documentation/this_cpu_ops.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/this_cpu_ops.txt b/Documentation/this_cpu_ops.txt
index 1a4ce7e..9e44fdf 100644
--- a/Documentation/this_cpu_ops.txt
+++ b/Documentation/this_cpu_ops.txt
@@ -21,7 +21,7 @@ Read-modify-write operations are of particular interest. Frequently
 processors have special lower latency instructions that can operate
 without the typical synchronization overhead but still provide some
 sort of relaxed atomicity guarantee. The x86 for example can execute
-RMV (Read Modify Write) instructions like inc/dec/cmpxchg without the
+RMW (Read Modify Write) instructions like inc/dec/cmpxchg without the
 lock prefix and the associated latency penalty.
 
 Access to the variable without the lock prefix is not synchronized but
-- 
1.9.1

