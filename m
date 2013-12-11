Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3LKLFz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752187Ab3LKLFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:50 -0500
Date: Wed, 11 Dec 2013 03:05:27 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-6f1d0c866261ec1e42850b2bf760484c100b6dd6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <46cb069a4ce21141057a07c0b50baa9968e3228c.1386629050.git.yangds.fnst@cn.fujitsu.com>
References: <46cb069a4ce21141057a07c0b50baa9968e3228c.1386629050.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate: Fix typo
Git-Commit-ID: 6f1d0c866261ec1e42850b2bf760484c100b6dd6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6f1d0c866261ec1e42850b2bf760484c100b6dd6
Gitweb:     http://git.kernel.org/tip/6f1d0c866261ec1e42850b2bf760484c100b6dd6
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 9 Dec 2013 17:47:48 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:22:21 -0300

perf annotate: Fix typo

A typo in comment of builtin-annotate.c about 'that'.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/46cb069a4ce21141057a07c0b50baa9968e3228c.1386629050.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4087ab1..6fd52c8 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -373,7 +373,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	if (argc) {
 		/*
-		 * Special case: if there's an argument left then assume tha
+		 * Special case: if there's an argument left then assume that
 		 * it's a symbol filter:
 		 */
 		if (argc > 1)
