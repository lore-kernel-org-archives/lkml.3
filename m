Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaJTKwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:52:18 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:34804 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaJTKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:52:10 -0400
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 2/2] ftracetest: sort testcases
Date: Mon, 20 Oct 2014 12:52:03 +0200
Message-Id: <1413802323-5297-3-git-send-email-heiko.carstens@de.ibm.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102010-0009-0000-0000-00000198754A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make sure the order of the executed testcases is always the same.

Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 tools/testing/selftests/ftrace/ftracetest | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/ftracetest b/tools/testing/selftests/ftrace/ftracetest
index a8f81c782856..2007a2cde56f 100755
--- a/tools/testing/selftests/ftrace/ftracetest
+++ b/tools/testing/selftests/ftrace/ftracetest
@@ -37,7 +37,7 @@ abspath() {
 }
 
 find_testcases() { #directory
-  echo `find $1 -name \*.tc`
+  echo `find $1 -name \*.tc | sort`
 }
 
 parse_opts() { # opts
-- 
1.8.5.5

