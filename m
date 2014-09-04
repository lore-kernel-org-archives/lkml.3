Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753814AbaIDP61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 11:58:27 -0400
Received: from mail-yh0-f53.google.com ([209.85.213.53]:34504 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaIDP60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 11:58:26 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
To: Shuah Khan <shuahkh@osg.samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        David Herrmann <dh.herrmann@gmail.com>,
        linux-api@vger.kernel.org (open list:KERNEL SELFTEST F...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH Resend] memfd_test: Add missing argument to printf()
Date: Thu,  4 Sep 2014 11:58:19 -0400
Message-Id: <1409846302-3513-1-git-send-email-bobby.prani@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a missing path argument buf to printf() 

Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
---
 tools/testing/selftests/memfd/memfd_test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/memfd/memfd_test.c b/tools/testing/selftests/memfd/memfd_test.c
index 3634c90..c343df8 100644
--- a/tools/testing/selftests/memfd/memfd_test.c
+++ b/tools/testing/selftests/memfd/memfd_test.c
@@ -205,7 +205,7 @@ static void mfd_fail_open(int fd, int flags, mode_t mode)
 	sprintf(buf, "/proc/self/fd/%d", fd);
 	r = open(buf, flags, mode);
 	if (r >= 0) {
-		printf("open(%s) didn't fail as expected\n");
+		printf("open(%s) didn't fail as expected\n", buf);
 		abort();
 	}
 }
-- 
2.1.0

