Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840Ab3GIM1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:27:40 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40305 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617Ab3GIM1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:27:37 -0400
From: SeongJae Park <sj38.park@gmail.com>
To: rob@landley.net
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] Documentation: Fix typo on memory-barriers.txt
Date: Tue,  9 Jul 2013 21:28:02 +0900
Message-Id: <1373372882-12669-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'==' for initial status explanation has miswritten as '='.
Fix it.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 Documentation/memory-barriers.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/memory-barriers.txt b/Documentation/memory-barriers.txt
index fa5d8a9..23a1ad7 100644
--- a/Documentation/memory-barriers.txt
+++ b/Documentation/memory-barriers.txt
@@ -148,7 +148,7 @@ As a further example, consider this sequence of events:
 
 	CPU 1		CPU 2
 	===============	===============
-	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
+	{ A == 1, B == 2, C == 3, P == &A, Q == &C }
 	B = 4;		Q = P;
 	P = &B		D = *Q;
 
@@ -452,7 +452,7 @@ following sequence of events:
 
 	CPU 1		CPU 2
 	===============	===============
-	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
+	{ A == 1, B == 2, C == 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
 	P = &B
@@ -479,7 +479,7 @@ between the address load and the data load:
 
 	CPU 1		CPU 2
 	===============	===============
-	{ A == 1, B == 2, C = 3, P == &A, Q == &C }
+	{ A == 1, B == 2, C == 3, P == &A, Q == &C }
 	B = 4;
 	<write barrier>
 	P = &B
-- 
1.7.9.5

