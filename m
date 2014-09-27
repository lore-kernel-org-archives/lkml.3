Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaI0GjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:39:05 -0400
Received: from top.free-electrons.com ([176.31.233.9]:38290 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750887AbaI0GjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:39:03 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: takata@linux-m32r.org, akpm@linux-foundation.org
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] m32r: remove deprecated IRQF_DISABLED
Date: Sat, 27 Sep 2014 08:38:56 +0200
Message-Id: <1411799936-19040-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395129627-17605-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1395129627-17605-1-git-send-email-michael.opdenacker@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the use of the IRQF_DISABLED flag
from arch/m32r/kernel/time.c

It's a NOOP since 2.6.35 and it will be removed one day.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 arch/m32r/kernel/time.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/m32r/kernel/time.c b/arch/m32r/kernel/time.c
index 1a15f81ea1bd..093f2761aa51 100644
--- a/arch/m32r/kernel/time.c
+++ b/arch/m32r/kernel/time.c
@@ -134,7 +134,6 @@ static irqreturn_t timer_interrupt(int irq, void *dev_id)
 
 static struct irqaction irq0 = {
 	.handler = timer_interrupt,
-	.flags = IRQF_DISABLED,
 	.name = "MFT2",
 };
 
-- 
1.9.1

