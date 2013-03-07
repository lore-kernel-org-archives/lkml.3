Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758735Ab3CGDLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 22:11:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10466 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713Ab3CGDLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 22:11:18 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-f1-513805549a8d
From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
To: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        dianders@chromium.org, gregkh@linuxfoundation.org,
        naveenkrishna.ch@gmail.com, lars@metafoo.de
Subject: [PATCH v2] iio: adc: exynos5_adc: fix compilation warnings
Date: Thu, 07 Mar 2013 08:39:03 +0530
Message-id: <1362625743-10401-1-git-send-email-ch.naveen@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGLMWRmVeSWpSXmKPExsWyRsSkRjeE1SLQ4OprIYt5R96xWFzeNYfN
	Ysb5fUwOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZdxeMoGpYK1ExfrF/UwNjG+Euxg5OSQETCQ6
	W36yQNhiEhfurWfrYuTiEBJYyigx4f5aRpii+a/uMUIkFjFKPD41kQXC6WGSWHLnJBtIFZuA
	mcTBRavZuxg5OEQEZCVmduuB1DALLGeUWHLtAztIjbCAs8T+O9fB6lkEVCVOT2wCi/MKuEr0
	zr/KBNIrIaAgMWeSDUivhMAZNond87czQ9QLSHybfIgFokZWYtMBZojjJCUOrrjBMoFRcAEj
	wypG0dSC5ILipPQiU73ixNzi0rx0veT83E2MwDA7/e/ZxB2M9w9YH2JMBho3kVlKNDkfGKZ5
	JfGGxibmpsamZkaWlpampAkrifPKX5IJFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cAomyWa
	fLzFOL9zyd3eNbJv1LrPTuNIPDHjbcOnMD/GFBOjnu3WzAFPFmVdXaEcduaogdyttoTpts0T
	lrpJzJd6t5NF4e3NzlfXJp75axDlGGjifunAlevZc16LiW7ermHHP++3hNq/ZzvcQlQfvZS/
	WLrzQMv0lIrFy1qLFyws/3fuXbf2ik1lSizFGYmGWsxFxYkAYn+g/EkCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMIsWRmVeSWpSXmKPExsVy+t9jAd0QVotAgxcX2CzmHXnHYnF51xw2
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5hxe8kE
	poK1EhXrF/czNTC+Ee5i5OSQEDCRmP/qHiOELSZx4d56ti5GLg4hgUWMEo9PTWSBcHqYJJbc
	OckGUsUmYCZxcNFq9i5GDg4RAVmJmd16IDXMAssZJZZc+8AOUiMs4Cyx/851sHoWAVWJ0xOb
	wOK8Aq4SvfOvMoH0SggoSMyZZDOBkXsBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOAg
	fia9g3FVg8UhRgEORiUe3o055oFCrIllxZW5hxglOJiVRHjvLgEK8aYkVlalFuXHF5XmpBYf
	YkwGWj6RWUo0OR8YYXkl8YbGJuamxqaWJhYmZpakCSuJ8zKeehIgJJCeWJKanZpakFoEs4WJ
	g1OqgTGFddEFmbCpKQ9eZPns+ubdr3DB/Q6fk9qEWv/C77tbNsf+mCtgdSBusUam+KskPxsN
	rRc1pXf8edW+3p+oFrttqqUKRydr/pyvK+2v7/ObIndh0c3fHN93nL+yaYLuYovHzCK+PcwP
	Lba8+uTLPUHvTdL1oj+ZqwSV/p524E3oXXkzK+hFZbwSS3FGoqEWc1FxIgAYbf9UpgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes the compilation warnings and potential NULL pointer
dereferencing pointed out by "Dan Carpenter".

Signed-off-by: Naveen Krishna Ch <ch.naveen@samsung.com>
Cc: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Series-to: linux-iio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <dan.carpenter@oracle.com>
---
Changes since v1:
	Made the exynos_adc driver depends on CONFIG_OF.

 drivers/iio/adc/Kconfig      |    1 +
 drivers/iio/adc/exynos_adc.c |   21 ++++++++++++++-------
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/adc/Kconfig b/drivers/iio/adc/Kconfig
index a40d3c2..9c45c0f 100644
--- a/drivers/iio/adc/Kconfig
+++ b/drivers/iio/adc/Kconfig
@@ -105,6 +105,7 @@ config AT91_ADC
 
 config EXYNOS_ADC
 	bool "Exynos ADC driver support"
+	depends on OF
 	help
 	  Core support for the ADC block found in the Samsung EXYNOS series
 	  of SoCs for drivers such as the touchscreen and hwmon to use to share
diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index ed6fdd7..4fd5e3a 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -92,7 +92,7 @@ struct exynos_adc {
 	struct completion	completion;
 
 	u32			value;
-	unsigned int            version;
+	unsigned int		version;
 };
 
 static const struct of_device_id exynos_adc_match[] = {
@@ -102,12 +102,12 @@ static const struct of_device_id exynos_adc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, exynos_adc_match);
 
-static inline unsigned int exynos_adc_get_version(struct platform_device *pdev)
+static inline int exynos_adc_get_version(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
 
 	match = of_match_node(exynos_adc_match, pdev->dev.of_node);
-	return (unsigned int)match->data;
+	return (int)match->data;
 }
 
 static int exynos_read_raw(struct iio_dev *indio_dev,
@@ -117,7 +117,7 @@ static int exynos_read_raw(struct iio_dev *indio_dev,
 				long mask)
 {
 	struct exynos_adc *info = iio_priv(indio_dev);
-	unsigned long timeout;
+	int timeout;
 	u32 con1, con2;
 
 	if (mask != IIO_CHAN_INFO_RAW)
@@ -255,7 +255,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 	struct iio_dev *indio_dev = NULL;
 	struct resource	*mem;
 	int ret = -ENODEV;
-	int irq;
+	int irq, version;
 
 	if (!np)
 		return ret;
@@ -268,6 +268,15 @@ static int exynos_adc_probe(struct platform_device *pdev)
 
 	info = iio_priv(indio_dev);
 
+	version = exynos_adc_get_version(pdev);
+	if (version < 0) {
+		dev_err(&pdev->dev, "no matching of_node, err = %d\n", version);
+		ret = version;
+		goto err_iio;
+	}
+
+	info->version = version;
+
 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	info->regs = devm_request_and_ioremap(&pdev->dev, mem);
@@ -311,8 +320,6 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
-	info->version = exynos_adc_get_version(pdev);
-
 	platform_set_drvdata(pdev, indio_dev);
 
 	indio_dev->name = dev_name(&pdev->dev);
-- 
1.7.9.5

