Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab3FMMXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 08:23:18 -0400
Received: from multi.imgtec.com ([194.200.65.239]:31966 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab3FMMV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 08:21:29 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Markos Chandras <markos.chandras@imgtec.com>,
        James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 05/10] metag/mm/cache: Restrict scope for metag_lnkget_probe
Date: Thu, 13 Jun 2013 13:19:36 +0100
Message-ID: <1371125981-5184-6-git-send-email-james.hogan@imgtec.com>
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

Hide symbol since it's only used within the cache.c file

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 arch/metag/mm/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/metag/mm/cache.c b/arch/metag/mm/cache.c
index b5d3b2e..a622852 100644
--- a/arch/metag/mm/cache.c
+++ b/arch/metag/mm/cache.c
@@ -45,7 +45,7 @@ static volatile u32 lnkget_testdata[16] __initdata __aligned(64);
 
 #define LNKGET_CONSTANT 0xdeadbeef
 
-void __init metag_lnkget_probe(void)
+static void __init metag_lnkget_probe(void)
 {
 	int temp;
 	long flags;
-- 
1.8.1.2


