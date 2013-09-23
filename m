Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3IWJnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 05:43:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28869 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753716Ab3IWJnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 05:43:18 -0400
X-AuditID: cbfee61b-b7f776d0000016c8-36-52400d34799b
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        t.figa@samsung.com, m.szyprowski@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] Spi s3c64xx fix for s5pv210
Date: Mon, 23 Sep 2013 11:42:59 +0200
Message-id: <1379929379-27245-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsVy+t9jAV0TXocgg1nLjC2mPnzCZnG26Q27
	xeVdc9gsGj/eZLc4veYUs8XaI3fZLdbPeM3iwO6xaVUnm8fBd3uYPPq2rGL0+LxJLoAlissm
	JTUnsyy1SN8ugSujZ/cFtoKXrBXzJzxnamB8z9LFyMkhIWAicf3jRXYIW0ziwr31bCC2kMAi
	RolFb+W7GLmA7HYmibWvWhlBEmwC5hITn20CaxYBarg9p5MZpIhZ4CyjxLenS8C6hQV0JM58
	m80MYrMIqEos3/McLM4r4Cfx/sQbRohtChI/L59gm8DIvYCRYRWjaGpBckFxUnqukV5xYm5x
	aV66XnJ+7iZGcHA8k97BuKrB4hCjAAejEg9vZKJ9kBBrYllxZe4hRgkOZiURXj9WhyAh3pTE
	yqrUovz4otKc1OJDjNIcLErivAdbrQOFBNITS1KzU1MLUotgskwcnFINjB6GjdPuR72ZbB16
	RO6mS8WC1csyv/3jP3U0u+zYl2X8X3eoT7KplmoMvr/4qmX5xmu7bHbcXrpx0pRtN8OYQsxe
	umyIuxegfdzCLbfucMDVb3Pydc/2Tcs/2u6pll+h9zgg59izNHPXkEllc3x/PT7n/rXt0uEr
	r46t5vzrtUipY/+NSbe0/rxRYinOSDTUYi4qTgQAR04FxgoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 734eaa5..124d7fa 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -394,7 +394,7 @@ config SPI_S3C24XX_FIQ
 
 config SPI_S3C64XX
 	tristate "Samsung S3C64XX series type SPI"
-	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5P64X0 || ARCH_EXYNOS)
+	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5PV210 || ARCH_S5P64X0 || ARCH_EXYNOS)
 	select S3C64XX_DMA if ARCH_S3C64XX
 	help
 	  SPI driver for Samsung S3C64XX and newer SoCs.
-- 
1.8.1.2

