Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab3IWJqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:46:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22842 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab3IWJqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:46:01 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-d6-52400dd85f13
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: broonie@kernel.org
Cc: kgene.kim@samsung.com, ben-linux@fluff.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] spi: s3c64xx: Add missing compatibles
Date: Mon, 23 Sep 2013 11:45:45 +0200
Message-id: <1379929545-27517-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e+xgO4NXocgg2fH5SwmrTvAZDH14RM2
	i/lHzrFa9C64ymZxtukNu8Wmx9dYLS7vmsNmMeP8PiaLxo832S1OrznF7MDl8XfVC2aPTas6
	2Tw2L6n3OPhuD5NH35ZVjB6fN8kFsEVx2aSk5mSWpRbp2yVwZfz5eYSt4DhHxYE7Vg2MM9m7
	GDk4JARMJD5Nruhi5AQyxSQu3FvP1sXIxSEksIhRYuL+E1BOO5PE58PvGEGq2ATMJSY+28QC
	YosAddye08kMUsQssIlJ4uuWmWAJYQEziZX/XrOD2CwCqhJLOi4xg9i8An4S22dfY4FYpyDx
	8/IJtgmM3AsYGVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBIfSM+kdjKsaLA4xCnAwKvHw
	RibaBwmxJpYVV+YeYpTgYFYS4fVjdQgS4k1JrKxKLcqPLyrNSS0+xCjNwaIkznuw1TpQSCA9
	sSQ1OzW1ILUIJsvEwSnVwMjxfpfrGXPpH65yO46YsfnylTHnTMh3quBI5W50Wnn+T1pInPP6
	7eFHDV+9m18mYiJ8LONat2NIdUPKZp35jFcFk15bvZ3qemRuJSPflPS7aS2V8ae6Yor0N+9J
	233b+FvL5+az205sa/RkCii25ym03CzEuPrD0gfJqawh4qIMFwyXSJYcVmIpzkg01GIuKk4E
	AG//A14hAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add compatibles for s3c6410, s5pc100 and s5pc110/s5pv210 boards.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/spi-s3c64xx.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/spi/spi-s3c64xx.c b/drivers/spi/spi-s3c64xx.c
index 8bed27a..84cc6ac 100644
--- a/drivers/spi/spi-s3c64xx.c
+++ b/drivers/spi/spi-s3c64xx.c
@@ -1612,6 +1612,18 @@ static struct platform_device_id s3c64xx_spi_driver_ids[] = {
 };
 
 static const struct of_device_id s3c64xx_spi_dt_match[] = {
+	{ .compatible = "samsung,s3c2443-spi",
+			.data = (void *)&s3c2443_spi_port_config,
+	},
+	{ .compatible = "samsung,s3c6410-spi",
+			.data = (void *)&s3c6410_spi_port_config,
+	},
+	{ .compatible = "samsung,s5pc100-spi",
+			.data = (void *)&s5pc100_spi_port_config,
+	},
+	{ .compatible = "samsung,s5pv210-spi",
+			.data = (void *)&s5pv210_spi_port_config,
+	},
 	{ .compatible = "samsung,exynos4210-spi",
 			.data = (void *)&exynos4_spi_port_config,
 	},
-- 
1.8.1.2

