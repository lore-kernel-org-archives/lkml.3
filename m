Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753703Ab3JCIrk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:47:40 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:62755 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3JCIrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:47:39 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH] perf tool: ignore output from timechart
Date: Thu,  3 Oct 2013 14:10:36 +0530
Message-Id: <1380789636-4512-1-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 8f8fbc2..782d86e 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -13,6 +13,7 @@ perf*.html
 common-cmds.h
 perf.data
 perf.data.old
+output.svg
 perf-archive
 tags
 TAGS
-- 
1.8.4.477.g5d89aa9

