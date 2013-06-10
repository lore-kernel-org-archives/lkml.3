Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754300Ab3FJWVx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 18:21:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59551 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754191Ab3FJWVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 18:21:51 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] checkpatch: Add a placeholder to check blank lines before declarations
Date: Mon, 10 Jun 2013 15:20:45 -0700
Message-Id: <092aa1992375ba2e01486127fca0035411d7b3bc.1370902448.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1370902448.git.joe@perches.com>
References: <cover.1370902448.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Figure out first how to determine if this is
in a struct declaration or in a function body
before enabling this.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 93b8e66..4ad4052 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2750,6 +2750,14 @@ sub process {
 			      "space required before the open brace '{'\n" . $herecurr);
 		}
 
+## # check for blank lines before declarations
+##		if ($line =~ /^.\t+$Type\s+$Ident(?:\s*=.*)?;/ &&
+##		    $prevrawline =~ /^.\s*$/) {
+##			WARN("SPACING",
+##			     "No blank lines before declarations\n" . $hereprev);
+##		}
+##
+
 # closing brace should have a space following it when it has anything
 # on the line
 		if ($line =~ /}(?!(?:,|;|\)))\S/) {
-- 
1.8.1.2.459.gbcd45b4.dirty

