Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab3LJJRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:17:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44115 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752718Ab3LJJR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:17:26 -0500
Date: Tue, 10 Dec 2013 01:16:55 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-316bd98a9aa47693215e0d3a5bcc83f51691ba93@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, dsahern@gmail.com,
        tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, dsahern@gmail.com, tglx@linutronix.de,
        yangds.fnst@cn.fujitsu.com
In-Reply-To: <6124d9eb10a3f1f6b399d1db660110bc7a60fd6b.1386197481.git.yangds.fnst@cn.fujitsu.com>
References: <6124d9eb10a3f1f6b399d1db660110bc7a60fd6b.1386197481.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Fix spurious '=' use in man page
Git-Commit-ID: 316bd98a9aa47693215e0d3a5bcc83f51691ba93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:17:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  316bd98a9aa47693215e0d3a5bcc83f51691ba93
Gitweb:     http://git.kernel.org/tip/316bd98a9aa47693215e0d3a5bcc83f51691ba93
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Wed, 4 Dec 2013 17:56:43 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:04:44 -0300

perf kvm: Fix spurious '=' use in man page

As option --host and --guest request no input for it, there should not
be a '=' after them in the man page sources.

And --output expects a filename as the input, so there should be a '='
after it.

This patch removes the needless '=' after --guest and --host, and adds a
'=' after --output in perf-kvm.txt.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/6124d9eb10a3f1f6b399d1db660110bc7a60fd6b.1386197481.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-kvm.txt | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/Documentation/perf-kvm.txt b/tools/perf/Documentation/perf-kvm.txt
index f52f94d..7953227 100644
--- a/tools/perf/Documentation/perf-kvm.txt
+++ b/tools/perf/Documentation/perf-kvm.txt
@@ -60,14 +60,14 @@ There are a couple of variants of perf kvm:
 OPTIONS
 -------
 -i::
---input=::
+--input=<path>::
         Input file name.
 -o::
---output::
+--output=<path>::
         Output file name.
---host=::
+--host::
         Collect host side performance profile.
---guest=::
+--guest::
         Collect guest side performance profile.
 --guestmount=<path>::
 	Guest os root file system mount directory. Users mounts guest os
