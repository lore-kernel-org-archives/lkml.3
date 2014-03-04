Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbaCDVPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:15:33 -0500
Received: from top.free-electrons.com ([176.31.233.9]:44475 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932906AbaCDVP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:15:28 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: takata@linux-m32r.org
Cc: linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND] m32r: remove deprecated IRQF_DISABLED
Date: Tue,  4 Mar 2014 22:15:20 +0100
Message-Id: <1393967720-17875-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386566651-19681-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1386566651-19681-1-git-send-email-michael.opdenacker@free-electrons.com>
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
1.8.3.2

