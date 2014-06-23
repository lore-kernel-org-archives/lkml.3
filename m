Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaFWQhI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:37:08 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:38807 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756460AbaFWQgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:36:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1539:1568:1711:1714:1730:1747:1777:1792:2197:2199:2393:2559:2562:3138:3139:3140:3141:3142:3865:3866:3868:3872:4321:4605:5007:6261:10004:10026:10848:11232:11658:11914:12043:12517:12519:12555:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quill58_34dc51d7e1f25
X-Filterd-Recvd-Size: 1553
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jean Delvare <jdelvare@suse.de>, Andy Whitcroft <apw@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] checkpatch: Change blank line after declaration type to "LINE_SPACING"
Date: Mon, 23 Jun 2014 09:35:54 -0700
Message-Id: <17f831b83d32613174f63d5b7a33f72bd5a0fd85.1403541113.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403541113.git.joe@perches.com>
References: <cover.1403541113.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make it consistent with the other missing or multiple blank line tests.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 3d6dea6..9795844 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2351,7 +2351,7 @@ sub process {
 		      $sline =~ /^\+\s+\(?\s*(?:$Compare|$Assignment|$Operators)/) &&
 			# indentation of previous and current line are the same
 		    (($prevline =~ /\+(\s+)\S/) && $sline =~ /^\+$1\S/)) {
-			WARN("SPACING",
+			WARN("LINE_SPACING",
 			     "Missing a blank line after declarations\n" . $hereprev);
 		}
 
-- 
1.8.1.2.459.gbcd45b4.dirty

