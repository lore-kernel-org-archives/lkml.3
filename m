Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760328Ab3HNUgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 16:36:20 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56770 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760268Ab3HNUgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 16:36:18 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf kvm: remove force option to cmd_record
Date: Wed, 14 Aug 2013 14:36:13 -0600
Message-Id: <1376512573-85012-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4a4d371a missed builtin-kvm in the cleanup to remove the force option
to cmd_record.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-kvm.c |    1 -
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
-- 
1.7.10.1

