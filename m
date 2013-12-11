Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221Ab3LKLFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 06:05:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60207 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab3LKLFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 06:05:40 -0500
Date: Wed, 11 Dec 2013 03:05:17 -0800
From: tip-bot for Dongsheng Yang <tipbot@zytor.com>
Message-ID: <tip-f113bee01956d4a2efde461443b09ab1020f4b17@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, yangds.fnst@cn.fujitsu.com
In-Reply-To: <78a15a9f4f500b6074a1e25917d6e8251f894628.1386629050.git.yangds.fnst@cn.fujitsu.com>
References: <78a15a9f4f500b6074a1e25917d6e8251f894628.1386629050.git.yangds.fnst@cn.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf archive: Remove duplicated 'runs'
  in man page
Git-Commit-ID: f113bee01956d4a2efde461443b09ab1020f4b17
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 11 Dec 2013 03:05:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f113bee01956d4a2efde461443b09ab1020f4b17
Gitweb:     http://git.kernel.org/tip/f113bee01956d4a2efde461443b09ab1020f4b17
Author:     Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
AuthorDate: Mon, 9 Dec 2013 17:47:47 -0500
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 9 Dec 2013 15:21:45 -0300

perf archive: Remove duplicated 'runs' in man page

Two 'runs' here breaks the sentence in Description of 'perf archive'
command.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/78a15a9f4f500b6074a1e25917d6e8251f894628.1386629050.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-archive.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
index 5032a14..ac6ecbb 100644
--- a/tools/perf/Documentation/perf-archive.txt
+++ b/tools/perf/Documentation/perf-archive.txt
@@ -12,9 +12,9 @@ SYNOPSIS
 
 DESCRIPTION
 -----------
-This command runs runs perf-buildid-list --with-hits, and collects the files
-with the buildids found so that analysis of perf.data contents can be possible
-on another machine.
+This command runs perf-buildid-list --with-hits, and collects the files with the
+buildids found so that analysis of perf.data contents can be possible on another
+machine.
 
 
 SEE ALSO
