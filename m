Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751381Ab3HBLK4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:10:56 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:49188 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab3HBLKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:10:54 -0400
Date: Fri, 2 Aug 2013 13:10:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: Fix typo in annotated output browser
Message-ID: <20130802111050.GA29126@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index cc64d3f..2245dc3 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -495,7 +495,7 @@ static bool annotate_browser__jump(struct annotate_browser *browser)
 
 	dl = annotate_browser__find_offset(browser, dl->ops.target.offset, &idx);
 	if (dl == NULL) {
-		ui_helpline__puts("Invallid jump offset");
+		ui_helpline__puts("Invalid jump offset");
 		return true;
 	}
 
