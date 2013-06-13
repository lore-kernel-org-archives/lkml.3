Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757183Ab3FMMVg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:21:36 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31965 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755152Ab3FMMVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:30 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 10/10] metag/.gitignore: Extend the *.dtb pattern to match the dtb.S files
Date: Thu, 13 Jun 2013 13:19:41 +0100
Message-ID: <1371125981-5184-11-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
References: <1371125981-5184-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_06_13_13_21_25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Markos Chandras <markos.chandras@imgtec.com>

The .SECONDARY rule for generating the *.dtb.S files added in
0b4184c26b18ecbc0ec0657f514b087c3a6216fb
"metag: avoid unnecessary builtin dtb rebuilds"

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/boot/.gitignore | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/boot/.gitignore b/arch/metag/boot/.gitignore
index a021da2..2d6c0c1 100644
--- a/arch/metag/boot/.gitignore
+++ b/arch/metag/boot/.gitignore
@@ -1,4 +1,4 @@
 vmlinux*
 uImage*
 ramdisk.*
-*.dtb
+*.dtb*
-- 
1.8.1.2


