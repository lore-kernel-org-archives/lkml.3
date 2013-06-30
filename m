Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3F3M46 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 08:56:58 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:52487 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751587Ab3F3M4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 08:56:31 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Subject: [PATCH 3/4] selftests: add .gitignore for kcmp
Date: Sun, 30 Jun 2013 18:23:10 +0530
Message-Id: <1372596791-12968-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
References: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/testing/selftests/kcmp/.gitignore | 2 ++
 1 file changed, 2 insertions(+)
 create mode 100644 tools/testing/selftests/kcmp/.gitignore

diff --git a/tools/testing/selftests/kcmp/.gitignore b/tools/testing/selftests/kcmp/.gitignore
new file mode 100644
index 0000000..5a9b373
--- /dev/null
+++ b/tools/testing/selftests/kcmp/.gitignore
@@ -0,0 +1,2 @@
+kcmp_test
+kcmp-test-file
-- 
1.8.3.1.643.gebeea52.dirty

