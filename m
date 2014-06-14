Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaFNVsA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 17:48:00 -0400
Received: from mout.gmx.net ([212.227.15.15]:64913 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbaFNVr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 17:47:59 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: linux-arm-kernel@lists.infradead.org
Cc: Russell King <linux@arm.linux.org.uk>, Jon Medhurst <tixy@linaro.org>,
        dave.long@linaro.org, Ben Dooks <ben.dooks@codethink.co.uk>,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH] ARM: kprobes: Fix non-ANSI declaration of arch_init_kprobes()
Date: Sat, 14 Jun 2014 23:46:38 +0200
Message-Id: <1402782398-7602-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:WqwV+mHYUdbeOYnzka/hp7yCQRJ3laPJbRoYFkswgwhAUrSrVGf
 8DWkJDQhhJUDqE+gzoV8GAT9IHCcC2llxPSDohoB8Inlv6AWRMGgAa3as3D8HVFrdS+mTNB
 4hUSKlJqNBCL/zllX+se3+DCtv2EY6wVQYY1yUfjfRO1/nXVci6P2Dr1BG1NsQBBcA73TaN
 PgYxwE3VYaKpVrV1eTCZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix sparse warning "non-ANSI function declaration of function
'arch_init_kprobes'".

Signed-off-by: Christian Engelmayer <cengelma@gmx.at>
---
 arch/arm/kernel/kprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/kernel/kprobes.c b/arch/arm/kernel/kprobes.c
index 6d64420..18b79a7 100644
--- a/arch/arm/kernel/kprobes.c
+++ b/arch/arm/kernel/kprobes.c
@@ -615,7 +615,7 @@ static struct undef_hook kprobes_arm_break_hook = {
 
 #endif /* !CONFIG_THUMB2_KERNEL */
 
-int __init arch_init_kprobes()
+int __init arch_init_kprobes(void)
 {
 	arm_probes_decode_init();
 #ifdef CONFIG_THUMB2_KERNEL
-- 
1.9.1

