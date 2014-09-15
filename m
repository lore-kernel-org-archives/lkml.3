Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbaIOWpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:45:09 -0400
Received: from qmta14.westchester.pa.mail.comcast.net ([76.96.59.212]:60887
	"EHLO qmta14.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755690AbaIOWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:40:23 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Sep 2014 18:40:23 EDT
From: Shuah Khan <shuahkh@osg.samsung.com>
To: akpm@linux-foundation.org, gregkh@linuxfoundation.org,
        colin.king@canonical.com, dbueso@suse.de, ebiederm@xmission.com,
        serge.hallyn@ubuntu.com, thierry@linux.vnet.ibm.com,
        felipensp@gmail.com
Cc: Shuah Khan <shuahkh@osg.samsung.com>, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] selftests: add header file for test exit code defines
Date: Mon, 15 Sep 2014 16:33:56 -0600
Message-Id: <1410820442-8774-2-git-send-email-shuahkh@osg.samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
References: <1410820442-8774-1-git-send-email-shuahkh@osg.samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new header file that defines exit codes for individual
tests to use to communicate test results. These defines are
intended to provide a common and uniform way for selftests
to report results. pass/fail/xfail/xpass/skip/unsupported
are defined.

Signed-off-by: Shuah Khan <shuahkh@osg.samsung.com>
---
 tools/testing/selftests/kselftest.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)
 create mode 100644 tools/testing/selftests/kselftest.h

diff --git a/tools/testing/selftests/kselftest.h b/tools/testing/selftests/kselftest.h
new file mode 100644
index 0000000..1b1c9cb
--- /dev/null
+++ b/tools/testing/selftests/kselftest.h
@@ -0,0 +1,20 @@
+/*
+ * kselftest.h - kselftest framework return codes to include from
+ *		 selftests.
+ *
+ * Copyright (c) 2014 Shuah Khan <shuahkh@osg.samsung.com>
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd.
+ *
+ * This file is released under the GPLv2.
+ */
+#ifndef __KSELFTEST_H
+#define __KSELFTEST_H
+
+#define	EXIT_PASS		0
+#define	EXIT_FAIL		1
+#define	EXIT_XFAIL		2
+#define	EXIT_XPASS		3
+#define	EXIT_SKIP		4
+#define	EXIT_UNSUPPORTED	EXIT_SKIP
+
+#endif /* __KSELFTEST_H */
-- 
1.9.1

