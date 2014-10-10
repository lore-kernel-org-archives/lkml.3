Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176AbaJJI0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 04:26:00 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:62834 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaJJIYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 04:24:08 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-09-543797a41a24
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 1/4] mfd: max77693: Remove unused define
Date: Fri, 10 Oct 2014 10:23:53 +0200
Message-id: <1412929436-22001-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIJMWRmVeSWpSXmKPExsVy+t/xK7pLppuHGPw5KW+xccZ6VovrX56z
	Wrx+YWhxtukNu8X9r0cZLS7vmsNmsfbIXXaL240r2CxOd7M6cHrcubaHzWPeyUCPvi2rGD0+
	b5ILYInisklJzcksSy3St0vgyri/oZ+14BtLxdW+c+wNjDNYuhg5OSQETCQW7f/ACmGLSVy4
	t56ti5GLQ0hgKaPEvPV72CGcPiaJM8+esYFUsQkYS2xevgSsSkRgN6PEt72LmEAcZoGjjBLT
	e98ygVQJC1hIbDx6HsxmEVCV+DZzInMXIwcHr4C7xOztNRDr5CROHpvMOoGRewEjwypG0dTS
	5ILipPRcI73ixNzi0rx0veT83E2MkGD5uoNx6TGrQ4wCHIxKPLwXZMxDhFgTy4orcw8xSnAw
	K4nw6psChXhTEiurUovy44tKc1KLDzEycXBKNTC2NJy64XiV1XW93/nm7eH5N97531C+6iP0
	sVrwG78832fXZUJK7HeeB1pHy4ZfWXdQ6/T6p4cWL39z8rpktCCf1+YWqTclm24JXq+aPNdD
	YK2cwrJDfpfXV9YG3XJ7I2zHaL9n1o3lTlorM+6K682c4cOnaT8hkf+qSamXgnnniZi9CneS
	WG2VWIozEg21mIuKEwEMacm+9AEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove old MAX77693_NUM_IRQ_MUIC_REGS define. Not used anywhere.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 include/linux/mfd/max77693-private.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mfd/max77693-private.h b/include/linux/mfd/max77693-private.h
index 4f1a80b66ecf..3c51c4d01306 100644
--- a/include/linux/mfd/max77693-private.h
+++ b/include/linux/mfd/max77693-private.h
@@ -26,7 +26,6 @@
 
 #include <linux/i2c.h>
 
-#define MAX77693_NUM_IRQ_MUIC_REGS	3
 #define MAX77693_REG_INVALID		(0xff)
 
 /* Slave addr = 0xCC: PMIC, Charger, Flash LED */
-- 
1.9.1

