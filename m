Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750790Ab3JLEHd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Oct 2013 00:07:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53991 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701Ab3JLEHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Oct 2013 00:07:32 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: takata@linux-m32r.org
Cc: swarren@nvidia.com, jesper.nilsson@axis.com, geert@linux-m68k.org,
        johnstul@us.ibm.com, linux-m32r@ml.linux-m32r.org,
        linux-m32r-ja@ml.linux-m32r.org, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] m32r: remove deprecated IRQF_DISABLED
Date: Sat, 12 Oct 2013 06:07:28 +0200
Message-Id: <1381550848-5958-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the use of the IRQF_DISABLED flag

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/m32r/kernel/time.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 1a15f81..093f276 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -134,7 +134,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "MFT2",
 };
 
-- 
1.8.1.2

