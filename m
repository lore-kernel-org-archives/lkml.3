Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3IXQIE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:08:04 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:10912 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab3IXQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:08:01 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-27-5241b8de0c1a
From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
To: broonie@kernel.org
Cc: t.figa@samsung.com, s.nawrocki@samsung.com, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, b.zolnierkie@samsung.com,
        m.szyprowski@samsung.com, t.stanislaws@samsung.com,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH v2] Spi s3c64xx fix for s5pv210
Date: Tue, 24 Sep 2013 18:07:46 +0200
Message-id: <1380038866-1861-1-git-send-email-m.krawczuk@partner.samsung.com>
X-Mailer: git-send-email 1.8.1.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmplluLIzCtJLcpLzFFi42I5/e+xoO69HY5BBtP+qllsnLGe1WLqwyds
	Fmeb3rBbXN41h82i8eNNdovTa04xW6w9cpfd4vCbdlaL9TNes1jMa3/J6sDlsWlVJ5vHwXd7
	mDz6tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoEr4/WHRewFj1grNl7rYW5gfMbSxcjBISFgInFx
	mWAXIyeQKSZx4d56ti5GLg4hgemMEicvHIJy2pkk1r3bwQhSxSZgLjHx2SYWEFsEqOP2nE5m
	kCJmgdlMEoc27WEFSQgL6EvcmdbCBmKzCKhKTDj/ng1kG6+Ar8SGV7EQ2xQkfl4+wTaBkXsB
	I8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODAeSa1g3Flg8UhRgEORiUe3h3eDkFCrIll
	xZW5hxglOJiVRHjNNzgGCfGmJFZWpRblxxeV5qQWH2KU5mBREuc90GodKCSQnliSmp2aWpBa
	BJNl4uCUamCU7mwUkfme+POwX5bxm1+JdfphrFM/+8YwO2VwzDmv2be3aV4R/2SOBfHrVoer
	6LctTPRU/mxvKvPFdX3lHeFfJzaJnXERkVAr4gu8zfjy96N9f+a4Oyj6fWiYYVp2ty4k9VyX
	9/0vmTuEp6gYsuacmDr/TsxLyepio2rFM1Gz7XmONdx9kqrEUpyRaKjFXFScCAAC01DhGAIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace all symbols by simple dependency PLAT_SAMSUNG.

Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/spi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 734eaa5..eb1f1ef 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -394,7 +394,7 @@ config SPI_S3C24XX_FIQ
 
 config SPI_S3C64XX
 	tristate "Samsung S3C64XX series type SPI"
-	depends on (ARCH_S3C24XX || ARCH_S3C64XX || ARCH_S5P64X0 || ARCH_EXYNOS)
+	depends on PLAT_SAMSUNG
 	select S3C64XX_DMA if ARCH_S3C64XX
 	help
 	  SPI driver for Samsung S3C64XX and newer SoCs.
-- 
1.8.1.2

