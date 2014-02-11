Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaBKRKz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 12:10:55 -0500
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:25451 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752189AbaBKRKv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 12:10:51 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Cc: Pawel Moll <pawel.moll@arm.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 06/12] mfd: vexpress-sysreg: Add labels to gpio banks
Date: Tue, 11 Feb 2014 17:10:30 +0000
Message-Id: <1392138636-29240-7-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
References: <1392138636-29240-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... so debugfs interfaces are easier to use.

Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <gnurou@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-sysreg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index f639dff..ece5ac8 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -133,16 +133,19 @@ void __init vexpress_sysreg_early_init(void __iomem *base)
 /* The sysreg block is just a random collection of various functions... */
 
 static struct bgpio_pdata vexpress_sysreg_sys_led_pdata = {
+	.label = "sys_led",
 	.base = -1,
 	.ngpio = 8,
 };
 
 static struct bgpio_pdata vexpress_sysreg_sys_mci_pdata = {
+	.label = "sys_mci",
 	.base = -1,
 	.ngpio = 2,
 };
 
 static struct bgpio_pdata vexpress_sysreg_sys_flash_pdata = {
+	.label = "sys_flash",
 	.base = -1,
 	.ngpio = 1,
 };
-- 
1.8.3.2

