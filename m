Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3JOF3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932181Ab3JOF3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:44 -0400
Date: Mon, 14 Oct 2013 22:29:33 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-f3c236b0c7a84e5d59cc639a1673a20b0a59ecc0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1380789636-4512-1-git-send-email-artagnon@gmail.com>
References: <1380789636-4512-1-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Ignore 'perf timechart' output file
Git-Commit-ID: f3c236b0c7a84e5d59cc639a1673a20b0a59ecc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3c236b0c7a84e5d59cc639a1673a20b0a59ecc0
Gitweb:     http://git.kernel.org/tip/f3c236b0c7a84e5d59cc639a1673a20b0a59ecc0
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 3 Oct 2013 14:10:36 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:37 -0300

perf tools: Ignore 'perf timechart' output file

The default output file produced by the 'perf timechart' tool is called
output.svg, add it to .gitignore.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1380789636-4512-1-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
