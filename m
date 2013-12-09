Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760497Ab3LITle (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 14:41:34 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54984 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761332Ab3LIThW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 14:37:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dongsheng Yang <yangds.fnst@cn.fujitsu.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/21] perf archive: Remove duplicated 'runs' in man page
Date: Mon,  9 Dec 2013 16:37:01 -0300
Message-Id: <1386617830-18926-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386617830-18926-1-git-send-email-acme@infradead.org>
References: <1386617830-18926-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>

Two 'runs' here breaks the sentence in Description of 'perf archive'
command.

Signed-off-by: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
Link: http://lkml.kernel.org/r/78a15a9f4f500b6074a1e25917d6e8251f894628.1386629050.git.yangds.fnst@cn.fujitsu.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-archive.txt | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-archive.txt b/tools/perf/Documentation/perf-archive.txt
index 5032a142853e..ac6ecbb3e669 100644
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
-- 
1.8.1.4

