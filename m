Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497AbaAZJQE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 04:16:04 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34263 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892AbaAZJQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 04:16:00 -0500
Date: Sun, 26 Jan 2014 01:15:31 -0800
From: tip-bot for Baruch Siach <tipbot@zytor.com>
Message-ID: <tip-0d4dd797564cddc1f71ab0b239e9ea50ddd40b2a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, acme@ghostprotocols.net,
        baruch@tkos.co.il, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        baruch@tkos.co.il, acme@ghostprotocols.net, tglx@linutronix.de
In-Reply-To: <4c54761865d40210be0628cb84701afc5d57b5d8.1390686193.git.baruch@tkos.co.il>
References: <4c54761865d40210be0628cb84701afc5d57b5d8.1390686193.git.baruch@tkos.co.il>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/doc:
  Remove mention of non-existent set_perf_event_pending() from design.txt
Git-Commit-ID: 0d4dd797564cddc1f71ab0b239e9ea50ddd40b2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 26 Jan 2014 01:15:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0d4dd797564cddc1f71ab0b239e9ea50ddd40b2a
Gitweb:     http://git.kernel.org/tip/0d4dd797564cddc1f71ab0b239e9ea50ddd40b2a
Author:     Baruch Siach <baruch@tkos.co.il>
AuthorDate: Sat, 25 Jan 2014 23:50:23 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 26 Jan 2014 09:37:48 +0100

perf/doc: Remove mention of non-existent set_perf_event_pending() from design.txt

set_perf_event_pending() was removed in e360adbe ("irq_work: Add
generic hardirq context callbacks").

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/4c54761865d40210be0628cb84701afc5d57b5d8.1390686193.git.baruch@tkos.co.il
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 tools/perf/design.txt | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index 67e5d0c..63a0e6f 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -454,7 +454,6 @@ So to start with, in order to add HAVE_PERF_EVENTS to your Kconfig, you
 will need at least this:
 	- asm/perf_event.h - a basic stub will suffice at first
 	- support for atomic64 types (and associated helper functions)
-	- set_perf_event_pending() implemented
 
 If your architecture does have hardware capabilities, you can override the
 weak stub hw_perf_event_init() to register hardware counters.
