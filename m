Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaBGKFd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 05:05:33 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:22511 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaBGKFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 05:05:20 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-e3-52f4afdbed09
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH v2 12/15] power: max17040: Add ID for max77836 Fuel Gauge block
Date: Fri, 07 Feb 2014 11:04:44 +0100
Message-id: <1391767487-10017-13-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
References: <1391767487-10017-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsVy+t/xq7q3138JMvgyy9ji4FZNi40z1rNa
	TH34hM3i+pfnrBaTnrxntpi4cjKzxesXhhZnm96wW9z/epTRYtPja6wWl3fNYbNYe+Quu8Xt
	xhVsFqe7WR34PCb0f2L02DnrLrvH5hVaHptWdbJ53Lm2h81j3slAj81L6j36tqxi9Pi8SS6A
	M4rLJiU1J7MstUjfLoEro/FWN3PBO/aK3Z1H2RoY77B1MXJySAiYSEyd1Q9li0lcuLceyObi
	EBJYyihx4/l/KKePSeLtpM+MIFVsAsYSm5cvAUuICLQwSbxfv58RxGEWOMYksfHOKbBZwgL+
	EmfmbWYHsVkEVCVmNb0B6+YV8JB4c/YGUA0H0D4FiTmTbEDCnEDhLQ/OsYLYQgLuEr+W9bBP
	YORdwMiwilE0tTS5oDgpPddIrzgxt7g0L10vOT93EyMkdL/uYFx6zOoQowAHoxIPr+KKz0FC
	rIllxZW5hxglOJiVRHg11n4JEuJNSaysSi3Kjy8qzUktPsTIxMEp1cBYceL73o/Olz3dA88d
	3sKXwnyPaaHHhqLa5Nh7bYm6+1iue/+uD78g/sdOy+CQlDiv78Y1Ky7IhN2UbvePkY9RU+Zb
	sH5BIptDBeO7y9++Mubl8TjVMfmfYM8VyeblZTROXJ9gX9qc0r3xjrq9aknlzqKN/3LnRrOw
	7zDkfGsRUnOJv2XTUiWW4oxEQy3mouJEAI2KvGg7AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX77836 has the same Fuel Gauge as MAX17040. The max17040 driver can be
safely re-used. The patch adds MAX77836 ID to array with i2c_device_id.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Anton Vorontsov <anton@enomsg.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>
---
 drivers/power/max17040_battery.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/power/max17040_battery.c b/drivers/power/max17040_battery.c
index 0fbac861080d..165ffe381803 100644
--- a/drivers/power/max17040_battery.c
+++ b/drivers/power/max17040_battery.c
@@ -278,6 +278,7 @@ static SIMPLE_DEV_PM_OPS(max17040_pm_ops, max17040_suspend, max17040_resume);
 
 static const struct i2c_device_id max17040_id[] = {
 	{ "max17040", 0 },
+	{ "max77836-battery", 0 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, max17040_id);
-- 
1.7.9.5

