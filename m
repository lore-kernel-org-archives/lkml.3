Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab3APMAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 07:00:17 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54225 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3APMAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 07:00:09 -0500
X-AuditID: 9c93016f-b7b70ae000000e36-77-50f69646ef45
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/2] perf tools: Get rid of unused include of config.mak
Date: Wed, 16 Jan 2013 20:59:54 +0900
Message-Id: <1358337594-10916-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1358337594-10916-1-git-send-email-namhyung@kernel.org>
References: <1358337594-10916-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

These lines are came from GIT Makefile and never used for perf.
I found it from make -d output during working on previous patch.

Updating makefiles....
 Considering target file `arch/x86/Makefile'.
 No need to remake target `arch/x86/Makefile'.
 Considering target file `config.mak'.
  File `config.mak' does not exist.
 Must remake target `config.mak'.
 Failed to remake target file `config.mak'.
 Considering target file `config.mak.autogen'.
  File `config.mak.autogen' does not exist.
 Must remake target `config.mak.autogen'.
 Failed to remake target file `config.mak.autogen'.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index bdbd54edf8cc..e6f314540cf5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -533,9 +533,6 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
--include config.mak.autogen
--include config.mak
-
 ifdef NO_LIBELF
 	NO_DWARF := 1
 	NO_DEMANGLE := 1
-- 
1.7.11.7

