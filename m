Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485AbbAKMk1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 07:40:27 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:63843 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbbAKMkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 07:40:22 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] perf: Uncomment setup_pager() for pagination activation
Date: Sun, 11 Jan 2015 18:40:06 +0600
Message-Id: <1420980006-13600-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.2.1.268.g1e6f5b2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Uncomment setup_pager() call at the commit_pager_choice routine for paging output

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 tools/perf/perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 3700a7f..c24f5e5 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -117,7 +117,7 @@ static void commit_pager_choice(void)
 		setenv("PERF_PAGER", "cat", 1);
 		break;
 	case 1:
-		/* setup_pager(); */
+		setup_pager();
 		break;
 	default:
 		break;
-- 
2.2.1.268.g1e6f5b2

