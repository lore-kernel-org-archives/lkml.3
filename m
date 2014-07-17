Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503AbaGQPwO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 11:52:14 -0400
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:34434 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757457AbaGQPwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 11:52:11 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:1978:1981:2194:2198:2199:2200:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3865:3867:5007:6261:10004:10026:10848:11658:11914:12043:12517:12519:12555:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: blow55_2fe94b85d3104
X-Filterd-Recvd-Size: 1994
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>,
        Hartley Sweeten <HartleyS@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] checkpatch: Add signed generic types
Date: Thu, 17 Jul 2014 08:52:02 -0700
Message-Id: <8081f8a4e30a9035697cbc2791be54a9ee39ca74.1405609481.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405609481.git.joe@perches.com>
References: <cover.1405609481.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current generic types are unsigned or unspecified.
Add signed to the types.

Reorder the types to find the longest match first.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index d81e4ab..1bfe2fc 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -355,15 +355,15 @@ our $signature_tags = qr{(?xi:
 
 our @typeList = (
 	qr{void},
-	qr{(?:unsigned\s+)?char},
-	qr{(?:unsigned\s+)?short\s+int},
-	qr{(?:unsigned\s+)?short},
-	qr{(?:unsigned\s+)?int},
-	qr{(?:unsigned\s+)?long},
-	qr{(?:unsigned\s+)?long\s+int},
-	qr{(?:unsigned\s+)?long\s+long},
-	qr{(?:unsigned\s+)?long\s+long\s+int},
-	qr{unsigned},
+	qr{(?:(?:un)?signed\s+)?char},
+	qr{(?:(?:un)?signed\s+)?short\s+int},
+	qr{(?:(?:un)?signed\s+)?short},
+	qr{(?:(?:un)?signed\s+)?int},
+	qr{(?:(?:un)?signed\s+)?long\s+int},
+	qr{(?:(?:un)?signed\s+)?long\s+long\s+int},
+	qr{(?:(?:un)?signed\s+)?long\s+long},
+	qr{(?:(?:un)?signed\s+)?long},
+	qr{(?:un)?signed},
 	qr{float},
 	qr{double},
 	qr{bool},
-- 
1.8.1.2.459.gbcd45b4.dirty

