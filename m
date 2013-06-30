Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913Ab3F3M4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jun 2013 08:56:53 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:48844 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab3F3M43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jun 2013 08:56:29 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Dave Young <dyoung@redhat.com>
Subject: [PATCH 2/4] selftests: fix clean target in kcmp Makefile
Date: Sun, 30 Jun 2013 18:23:09 +0530
Message-Id: <1372596791-12968-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
References: <1372596791-12968-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/testing/selftests/kcmp/Makefile | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kcmp/Makefile b/tools/testing/selftests/kcmp/Makefile
index 56eb552..d7d6bbe 100644
--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -25,5 +25,4 @@ run_tests: all
 	@./kcmp_test || echo "kcmp_test: [FAIL]"
 
 clean:
-	rm -fr ./run_test
-	rm -fr ./test-file
+	$(RM) kcmp_test kcmp-test-file
-- 
1.8.3.1.643.gebeea52.dirty

