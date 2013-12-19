Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab3LSI3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 03:29:31 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:58175 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab3LSI3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 03:29:30 -0500
From: Chunwei Chen <tuxoko@gmail.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Chunwei Chen <tuxoko@gmail.com>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] perf config: ignore generated files in feature-checks
Date: Thu, 19 Dec 2013 16:29:21 +0800
Message-Id: <1387441761-2153-1-git-send-email-tuxoko@gmail.com>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Chunwei Chen <tuxoko@gmail.com>
---
 tools/perf/config/feature-checks/.gitignore |    2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/perf/config/feature-checks/.gitignore

diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
new file mode 100644
index 0000000..9662c68
--- /dev/null
+++ b/tools/perf/config/feature-checks/.gitignore
@@ -0,0 +1,2 @@
+test-all
+*.d
-- 
1.7.9.5

