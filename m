Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757965AbaDXOus (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:50:48 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10651 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbaDXOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:50:43 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-58-535924c1bd86
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-i2c@vger.kernel.org
Cc: naveenkrishna.ch@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, sjg@chromium.org,
        grundler@chromium.org, linux-kernel@vger.kernel.org, wsa@the-dreams.de,
        cpgs@samsung.com, broonie@kernel.org
Subject: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C controller
 early
Date: Thu, 24 Apr 2014 20:18:36 +0530
Message-id: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWyRsSkWvegSmSwwZv1NhZTHz5hs3h5SNPi
	1ZEfTBabHl9jtej4+4XR4vKuOWwWM87vY7JYtO0/s8W3LdsYLVaemMXswOUxu+Eii8fOWXfZ
	PTat6mTz2Lyk3qNvyypGj5OnnrB4fN4kF8AexWWTkpqTWZZapG+XwJUx+VQXa8FM7or5T9ax
	NjDe4exi5OSQEDCROPjsChuELSZx4d56IJuLQ0hgKaPE5NXdLF2MHGBFqzsYQWqEBBYxSlw9
	nQBR088kcar7ARNIgk3ATOLgotXsILaIgKxE64M1zCBFzAJvGSXOT1nMBDJIWCBYYtn3TJAa
	FgFViTmXd7OA2LwCzhKPPu9ihNilIDFnkg3EPavYJXb8z4AoF5D4NvkQ1DmyEpsOMEOUSEoc
	XHGDZQKj4AJGhlWMoqkFyQXFSelFpnrFibnFpXnpesn5uZsYgeF9+t+ziTsY7x+wPsSYDDRu
	IrOUaHI+MD7ySuINjc2MLExNTI2NzC3NSBNWEudNf5QUJCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoHRYtEjnqnbts98FaDwdKbR+95bOs4RfO8UMhgK3t3R2cbMrDBBpTN7yQRm7Xj2PxPN
	73v5zyyot2QvuO/b/PvG4wsqv9Yu8GlOjW/Y8armWvhpfkM27tm6i49mtW+yMmx1X/1yjrPh
	okNmLw+ZxtaUOq0oYYw2uJx9T+7YZlXvlRZeKd/0JJqUWIozEg21mIuKEwHdbhtmhQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t9jAd2DKpHBBmvmGFtMffiEzeLlIU2L
	V0d+MFlsenyN1aLj7xdGi8u75rBZzDi/j8li0bb/zBbftmxjtFh5YhazA5fH7IaLLB47Z91l
	99i0qpPNY/OSeo++LasYPU6eesLi8XmTXAB7VAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7yp
	mYGhrqGlhbmSQl5ibqqtkotPgK5bZg7QeUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC
	4HqMDNBAwhrGjMmnulgLZnJXzH+yjrWB8Q5nFyMHh4SAicTqDsYuRk4gU0ziwr31bCC2kMAi
	RomrpxO6GLmA7H4miVPdD5hAEmwCZhIHF61mB7FFBGQlWh+sYQYpYhZ4yyhxfspiJpChwgLB
	Esu+Z4LUsAioSsy5vJsFxOYVcJZ49HkXI8ReBYk5k2wmMHIvYGRYxSiaWpBcUJyUnmukV5yY
	W1yal66XnJ+7iREcP8+kdzCuarA4xCjAwajEwztBNjJYiDWxrLgy9xCjBAezkgivrzxQiDcl
	sbIqtSg/vqg0J7X4EGMy0PKJzFKiyfnA2M4riTc0NjE3NTa1NLEwMbMkTVhJnPdgq3WgkEB6
	YklqdmpqQWoRzBYmDk6pBkaluUtm/C0yWqPJtetfW9LsqburQrz9npmstF0/42hPh38o63x7
	xcw7LIZvjn2Wm3276VkD60Rjv8roGMnbyhflbFbUflj9WTq24hZXLWf0+j3+yWffmb7S0W+3
	mfc0+e77aTsNN3P97TYOYGFPvsZ/UqLOuvDN3Uki2xz16n9v1tlwfRFXX68SS3FGoqEWc1Fx
	IgCYN5Ha4wIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves initialization code to subsys_initcall() to ensure
that the i2c bus is available early so the regulators can be quickly
probed and available for other devices on their probe() call.

Such solution has been proposed by Mark Brown to fix the problem of
the regulators not beeing available on the peripheral device probe():
http://lists.infradead.org/pipermail/linux-arm-kernel/2010-March/011971.html

Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
---
 drivers/i2c/busses/i2c-exynos5.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-exynos5.c b/drivers/i2c/busses/i2c-exynos5.c
index 00af0a0..20e3077 100644
--- a/drivers/i2c/busses/i2c-exynos5.c
+++ b/drivers/i2c/busses/i2c-exynos5.c
@@ -762,8 +762,18 @@ static struct platform_driver exynos5_i2c_driver = {
 	},
 };
 
-module_platform_driver(exynos5_i2c_driver);
+static int __init i2c_adap_exynos5_init(void)
+{
+	return platform_driver_register(&exynos5_i2c_driver);
+}
+subsys_initcall(i2c_adap_exynos5_init);
+
+static void __exit i2c_adap_exynos5_exit(void)
+{
+	platform_driver_unregister(&exynos5_i2c_driver);
+}
 
+module_exit(i2c_adap_exynos5_exit);
 MODULE_DESCRIPTION("Exynos5 HS-I2C Bus driver");
 MODULE_AUTHOR("Naveen Krishna Chatradhi, <ch.naveen@samsung.com>");
 MODULE_AUTHOR("Taekgyun Ko, <taeggyun.ko@samsung.com>");
-- 
1.7.9.5

