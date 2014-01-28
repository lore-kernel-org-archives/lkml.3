Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196AbaA1MTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 07:19:10 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:20311 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147AbaA1MTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 07:19:01 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-c8-52e7a0342393
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 02/18] mfd: max14577: Remove unused enum max14577_irq_source
Date: Tue, 28 Jan 2014 13:18:26 +0100
Message-id: <1390911522-28209-3-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4NV2TBc+DDH6v4LeY+vAJm8X1L89Z
	LV6/MLQ42/SG3eL+16OMFt+udDBZbHp8jdXi8q45bBZrj9xlt7jduILN4nQ3qwO3x85Zd9k9
	Nq3qZPO4c20Pm8e8k4Eem5fUe/RtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG58lLWQta2Cvu
	X5JrYGxg62Lk5JAQMJF4fGYzO4QtJnHh3nqwuJDAUkaJg4f4uxi5gOw+Jon9D/YygSTYBIwl
	Ni9fwgaSEBFYzSSxZsFUFpAEs0Avo8TN3R4gtrCAj8SXzi9gcRYBVYlDZyE28Aq4S8xqWwtk
	cwBtU5CYM8kGJMwp4CHx6mojE8Rid4lTx9+xTGDkXcDIsIpRNLU0uaA4KT3XSK84Mbe4NC9d
	Lzk/dxMjJAy/7mBceszqEKMAB6MSD++D7mdBQqyJZcWVuYcYJTiYlUR4E2c/DxLiTUmsrEot
	yo8vKs1JLT7EyMTBKdXAaNP/ZOpyT8HaCK7tYvlayz2uf9KZfWyJ8Y2OdR6tU8J+XW+9Zxp3
	rdTQrHGxvOM27fRJW3zO+uvZXVpk2LP/2drknFeTTqVcbCvd4FKflN37ZtE7e46/6XPFv/EE
	bFrfUmZ/3WSrhbqqR3SSzddT9zsyTdZ5/3obz9gc6JJ1V/DdL9G6yTnpSizFGYmGWsxFxYkA
	AT6HIiECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unused symbol: enum max14577_irq_source.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
---
 include/linux/mfd/max14577-private.h |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/include/linux/mfd/max14577-private.h b/include/linux/mfd/max14577-private.h
index a3d0185196d3..c9b332fb0d5d 100644
--- a/include/linux/mfd/max14577-private.h
+++ b/include/linux/mfd/max14577-private.h
@@ -248,14 +248,6 @@ enum max14577_charger_reg {
 /* MAX14577 regulator SFOUT LDO voltage, fixed, uV */
 #define MAX14577_REGULATOR_SAFEOUT_VOLTAGE		4900000
 
-enum max14577_irq_source {
-	MAX14577_IRQ_INT1 = 0,
-	MAX14577_IRQ_INT2,
-	MAX14577_IRQ_INT3,
-
-	MAX14577_IRQ_REGS_NUM,
-};
-
 enum max14577_irq {
 	/* INT1 */
 	MAX14577_IRQ_INT1_ADC,
-- 
1.7.9.5

