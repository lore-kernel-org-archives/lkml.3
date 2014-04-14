Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaDNJVi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 05:21:38 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:52272 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132AbaDNJRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 05:17:39 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-bb-534ba7b01604
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v5 6/9] mfd: max14577: Add MAX14577 prefix to IRQ defines
Date: Mon, 14 Apr 2014 11:17:17 +0200
Message-id: <1397467040-30502-7-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
References: <1397467040-30502-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd0Ny72DDe4utrHYOGM9q8XUh0/Y
	LK5/ec5q8fqFocXZpjfsFve/HmW0+Halg8ni8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4EefVtWMXp83iQXwBbFZZOSmpNZllqkb5fAlTHxw3bGgnsyFau6d7E1
	MP4R72Lk5JAQMJGYffM2E4QtJnHh3nq2LkYuDiGBpYwSj9bfZ4Fw+pgklkxuYAapYhMwlti8
	fAlYlYhAM5NES99ZRhCHWeAoo8T03rdgs4QFPCVWPjvEAmKzCKhKnFmwBaybV8Bd4uOnHnaI
	fQoSy76sBYtzCnhI3Oo+BmYLAdW8+HSbfQIj7wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5
	uZsYIWH4dQfj0mNWhxgFOBiVeHg75ngHC7EmlhVX5h5ilOBgVhLh3ZbhFSzEm5JYWZValB9f
	VJqTWnyIkYmDU6qBkZXZc9mTtYe1XCqrwqs3/5bPWLnpFHOwXstxx1v3/n6sd4vdNs1Lc52y
	1vlIhSKxpR+KjMRjhD0nXJMR/Jvtw3EzLmLvS43mnVuv+Un/u7vqkJXVhLLUvzIL+HzvtV8t
	j9ecMdNg2/587qsnBa+yPsr2ve16ryOjnpuBZZb8pC8TlFcWH/34W4mlOCPRUIu5qDgRAPom
	RtshAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch prepares for adding support for MAX77836 device to existing
max14577 driver by adding MAX14577 prefix to defines of interrupts.

This is only a rename-like patch, new code is not added.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/mfd/max14577.c               | 24 ++++++++++++------------
 include/linux/mfd/max14577-private.h | 28 ++++++++++++++--------------
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/drivers/mfd/max14577.c b/drivers/mfd/max14577.c
index 0e07ed74ab41..6f39dec9dfdf 100644
--- a/drivers/mfd/max14577.c
+++ b/drivers/mfd/max14577.c
@@ -66,20 +66,20 @@ static const struct regmap_config max14577_muic_regmap_config = {
 
 static const struct regmap_irq max14577_irqs[] = {
 	/* INT1 interrupts */
-	{ .reg_offset = 0, .mask = INT1_ADC_MASK, },
-	{ .reg_offset = 0, .mask = INT1_ADCLOW_MASK, },
-	{ .reg_offset = 0, .mask = INT1_ADCERR_MASK, },
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADC_MASK, },
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCLOW_MASK, },
+	{ .reg_offset = 0, .mask = MAX14577_INT1_ADCERR_MASK, },
 	/* INT2 interrupts */
-	{ .reg_offset = 1, .mask = INT2_CHGTYP_MASK, },
-	{ .reg_offset = 1, .mask = INT2_CHGDETRUN_MASK, },
-	{ .reg_offset = 1, .mask = INT2_DCDTMR_MASK, },
-	{ .reg_offset = 1, .mask = INT2_DBCHG_MASK, },
-	{ .reg_offset = 1, .mask = INT2_VBVOLT_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGTYP_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_CHGDETRUN_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_DCDTMR_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_DBCHG_MASK, },
+	{ .reg_offset = 1, .mask = MAX14577_INT2_VBVOLT_MASK, },
 	/* INT3 interrupts */
-	{ .reg_offset = 2, .mask = INT3_EOC_MASK, },
-	{ .reg_offset = 2, .mask = INT3_CGMBC_MASK, },
-	{ .reg_offset = 2, .mask = INT3_OVP_MASK, },
-	{ .reg_offset = 2, .mask = INT3_MBCCHGERR_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_EOC_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_CGMBC_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_OVP_MASK, },
+	{ .reg_offset = 2, .mask = MAX14577_INT3_MBCCHGERR_MASK, },
 };
 
 static const struct regmap_irq_chip max14577_irq_chip = {
diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index 1ce6f2952cc9..989183d232cd 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -79,20 +79,20 @@ enum max14577_muic_charger_type {
 };
 
 /* MAX14577 interrupts */
-#define INT1_ADC_MASK			(0x1 << 0)
-#define INT1_ADCLOW_MASK		(0x1 << 1)
-#define INT1_ADCERR_MASK		(0x1 << 2)
-
-#define INT2_CHGTYP_MASK		(0x1 << 0)
-#define INT2_CHGDETRUN_MASK		(0x1 << 1)
-#define INT2_DCDTMR_MASK		(0x1 << 2)
-#define INT2_DBCHG_MASK			(0x1 << 3)
-#define INT2_VBVOLT_MASK		(0x1 << 4)
-
-#define INT3_EOC_MASK			(0x1 << 0)
-#define INT3_CGMBC_MASK			(0x1 << 1)
-#define INT3_OVP_MASK			(0x1 << 2)
-#define INT3_MBCCHGERR_MASK		(0x1 << 3)
+#define MAX14577_INT1_ADC_MASK		BIT(0)
+#define MAX14577_INT1_ADCLOW_MASK	BIT(1)
+#define MAX14577_INT1_ADCERR_MASK	BIT(2)
+
+#define MAX14577_INT2_CHGTYP_MASK	BIT(0)
+#define MAX14577_INT2_CHGDETRUN_MASK	BIT(1)
+#define MAX14577_INT2_DCDTMR_MASK	BIT(2)
+#define MAX14577_INT2_DBCHG_MASK	BIT(3)
+#define MAX14577_INT2_VBVOLT_MASK	BIT(4)
+
+#define MAX14577_INT3_EOC_MASK		BIT(0)
+#define MAX14577_INT3_CGMBC_MASK	BIT(1)
+#define MAX14577_INT3_OVP_MASK		BIT(2)
+#define MAX14577_INT3_MBCCHGERR_MASK	BIT(3)
 
 /* MAX14577 DEVICE ID register */
 #define DEVID_VENDORID_SHIFT		0
-- 
1.8.3.2

