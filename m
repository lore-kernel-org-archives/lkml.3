Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027Ab3F3M44 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 08:56:56 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:46670 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab3F3M42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 08:56:28 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Subject: [PATCH 1/4] selftests: add .gitignore for vm
Date: Sun, 30 Jun 2013 18:23:08 +0530
Message-Id: <1372596791-12968-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
References: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/testing/selftests/vm/.gitignore | 4 ++++
 1 file changed, 4 insertions(+)
 create mode 100644 tools/testing/selftests/vm/.gitignore

diff --git a/tools/testing/selftests/vm/.gitignore b/tools/testing/selftests/vm/.gitignore
new file mode 100644
index 0000000..ff1bb16
--- /dev/null
+++ b/tools/testing/selftests/vm/.gitignore
@@ -0,0 +1,4 @@
+hugepage-mmap
+hugepage-shm
+map_hugetlb
+thuge-gen
-- 
1.8.3.1.643.gebeea52.dirty

