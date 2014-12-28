Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaL1JMU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 04:12:20 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:53840 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbaL1JMQ (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Sun, 28 Dec 2014 04:12:16 -0500
From: Davidlohr Bueso <dave@stgolabs.net>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Davidlohr Bueso <dave@stgolabs.net>, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 1/8] Documentation/memory-barriers.txt: Fix smp typo
Date: Sun, 28 Dec 2014 01:11:16 -0800
Message-Id: <1419757883-4423-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
References: <1419757883-4423-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 Documentation/memory-barriers.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index 70a09f8..7086f83 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -750,7 +750,7 @@ In summary:
       However, they do -not- guarantee any other sort of ordering:
       Not prior loads against later loads, nor prior stores against
       later anything.  If you need these other forms of ordering,
-      use smb_rmb(), smp_wmb(), or, in the case of prior stores and
+      use smp_rmb(), smp_wmb(), or, in the case of prior stores and
       later loads, smp_mb().
 
   (*) If both legs of the "if" statement begin with identical stores
-- 
2.1.2

