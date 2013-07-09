Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab3GIKEo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 06:04:44 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:41101 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab3GIKEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 06:04:34 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH v3 5/5] perf/Perf-Trace-Util: add .gitignore
Date: Tue,  9 Jul 2013 15:30:33 +0530
Message-Id: <1373364033-7918-6-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.2.736.g869de25
In-Reply-To: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
References: <1373364033-7918-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/scripts/perl/Perf-Trace-Util/.gitignore | 5 +++++
 1 file changed, 5 insertions(+)
 create mode 100644 tools/perf/scripts/perl/Perf-Trace-Util/.gitignore

diff --git a/tools/perf/scripts/perl/Perf-Trace-Util/.gitignore b/tools/perf/scripts/perl/Perf-Trace-Util/.gitignore
new file mode 100644
index 0000000..7cc5ef2
--- /dev/null
+++ b/tools/perf/scripts/perl/Perf-Trace-Util/.gitignore
@@ -0,0 +1,5 @@
+MYMETA.json
+MYMETA.yml
+Makefile
+blib/
+pm_to_blib
-- 
1.8.3.2.736.g869de25

