Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3AXURz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 15:17:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50177 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755930Ab3AXUIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 15:08:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 57/74] perf tools: Get rid of unused include of config.mak
Date: Thu, 24 Jan 2013 17:08:06 -0300
Message-Id: <1359058103-31645-58-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1359058103-31645-1-git-send-email-acme@infradead.org>
References: <1359058103-31645-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
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
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1358337594-10916-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index e18163b..6aef6d0 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -534,9 +534,6 @@ ifneq ($(MAKECMDGOALS),tags)
 # because maintaining the nesting to match is a pain.  If
 # we had "elif" things would have been much nicer...
 
--include config.mak.autogen
--include config.mak
-
 ifdef NO_LIBELF
 	NO_DWARF := 1
 	NO_DEMANGLE := 1
-- 
1.8.1.1.361.gec3ae6e

