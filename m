Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890Ab3AYLzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:55:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755422Ab3AYLzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:55:39 -0500
Date: Fri, 25 Jan 2013 03:55:17 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-1aa3d1780f518080e6a51a5288cd05fb4b34d82c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@kernel.org
In-Reply-To: <1358337594-10916-2-git-send-email-namhyung@kernel.org>
References: <1358337594-10916-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Get rid of unused include of config.mak
Git-Commit-ID: 1aa3d1780f518080e6a51a5288cd05fb4b34d82c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:55:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1aa3d1780f518080e6a51a5288cd05fb4b34d82c
Gitweb:     http://git.kernel.org/tip/1aa3d1780f518080e6a51a5288cd05fb4b34d82c
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 16 Jan 2013 20:59:54 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:44 -0300

perf tools: Get rid of unused include of config.mak

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
