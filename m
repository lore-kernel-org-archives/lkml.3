Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222Ab3H2KHp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 06:07:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34971 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079Ab3H2KHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 06:07:44 -0400
Date: Thu, 29 Aug 2013 03:07:22 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-fe32ee0fc1c43f780529da79329d8c87ebc51464@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        jolsa@redhat.com
In-Reply-To: <1376512573-85012-1-git-send-email-dsahern@gmail.com>
References: <1376512573-85012-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Remove force option to cmd_record
Git-Commit-ID: fe32ee0fc1c43f780529da79329d8c87ebc51464
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 03:07:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fe32ee0fc1c43f780529da79329d8c87ebc51464
Gitweb:     http://git.kernel.org/tip/fe32ee0fc1c43f780529da79329d8c87ebc51464
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 14 Aug 2013 14:36:13 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 16 Aug 2013 17:17:57 -0300

perf kvm: Remove force option to cmd_record

4a4d371a missed builtin-kvm in the cleanup to remove the force option
to cmd_record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1376512573-85012-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index fa2f3d7..6cd4de5 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -1305,7 +1305,6 @@ kvm_events_record(struct perf_kvm_stat *kvm, int argc, const char **argv)
 	const char * const record_args[] = {
 		"record",
 		"-R",
-		"-f",
 		"-m", "1024",
 		"-c", "1",
 	};
