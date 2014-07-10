Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbaGJSxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:53:54 -0400
Received: from smtprelay0033.hostedemail.com ([216.40.44.33]:35262 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752163AbaGJSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:53:51 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 64,4,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1730:1747:1777:1792:2332:2393:2559:2562:3138:3139:3140:3141:3142:3352:3653:3865:4321:5007:6261:7903:10004:10026:10848:11658:11914:12296:12517:12519:12555:13311:13357:14096:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: moon33_3e7392d26472a
X-Filterd-Recvd-Size: 1612
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] checkpatch: Use the correct indentation for which()
Date: Thu, 10 Jul 2014 11:53:39 -0700
Message-Id: <0c81e9419cdb0af60aa4ae156fb40dd4ad7a3d70.1405018255.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1405018255.git.joe@perches.com>
References: <cover.1405018255.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I copied the which subroutine from get_maintainer.pl.

Unfortunately, get_maintainer uses a 4 space indentation
so use the proper tab indentation instead.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 7c29069..569ba31 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -710,15 +710,15 @@ sub format_email {
 }
 
 sub which {
-    my ($bin) = @_;
+	my ($bin) = @_;
 
-    foreach my $path (split(/:/, $ENV{PATH})) {
-	if (-e "$path/$bin") {
-	    return "$path/$bin";
+	foreach my $path (split(/:/, $ENV{PATH})) {
+		if (-e "$path/$bin") {
+			return "$path/$bin";
+		}
 	}
-    }
 
-    return "";
+	return "";
 }
 
 sub which_conf {
-- 
1.8.1.2.459.gbcd45b4.dirty

