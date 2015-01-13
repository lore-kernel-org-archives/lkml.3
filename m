Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395AbbAMTUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 14:20:50 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42149 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbbAMTUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 14:20:48 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: peterz@infradead.org, mingo@redhat.com, corbet@lwn.net
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Documentation: locking: update code path
Date: Wed, 14 Jan 2015 04:22:01 +0900
Message-Id: <1421176921-27688-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep code have been moved from kernel/ to kernel/locking/ by commit
8eddac3f103736163f49255bcb109edadea167f6 ("locking: Move the lockdep
code to kernel/locking/"). But, path to lockdep code in document was not
updated.

This commit updates the path.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/locking/lockdep-design.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/locking/lockdep-design.txt b/Documentation/locking/lockdep-design.txt
index 5dbc99c..5001280 100644
--- a/Documentation/locking/lockdep-design.txt
+++ b/Documentation/locking/lockdep-design.txt
@@ -34,7 +34,7 @@ The validator tracks lock-class usage history into 4n + 1 separate state bits:
 - 'ever held with STATE enabled'
 - 'ever held as readlock with STATE enabled'
 
-Where STATE can be either one of (kernel/lockdep_states.h)
+Where STATE can be either one of (kernel/locking/lockdep_states.h)
  - hardirq
  - softirq
  - reclaim_fs
-- 
1.9.1

