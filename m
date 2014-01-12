Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270AbaALRYG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:24:06 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:59036 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbaALRYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:24:04 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] scripts: Fix comment and message typo in checkpatch.pl
Date: Mon, 13 Jan 2014 02:23:55 +0900
Message-Id: <1389547435-23207-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.309.ga25014b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch corrected a spelling typo in comment
and messages in checkpatch.pl.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index e530d90..76ef5a6 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -4218,7 +4218,7 @@ sub process {
 			}
 		}
 
-# check for case / default statements not preceeded by break/fallthrough/switch
+# check for case / default statements not preceded by break/fallthrough/switch
 		if ($line =~ /^.\s*(?:case\s+(?:$Ident|$Constant)\s*|default):/) {
 			my $has_break = 0;
 			my $has_statement = 0;
@@ -4239,7 +4239,7 @@ sub process {
 			}
 			if (!$has_break && $has_statement) {
 				WARN("MISSING_BREAK",
-				     "Possible switch case/default not preceeded by break or fallthrough comment\n" . $herecurr);
+				     "Possible switch case/default not preceded by break or fallthrough comment\n" . $herecurr);
 			}
 		}
 
-- 
1.8.5.2.309.ga25014b

