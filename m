Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbaDKCAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 22:00:52 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:9159 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaDKCAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 22:00:49 -0400
X-AuditID: cbfee68e-b7f566d000002344-d5-53474ccfa690
From: Chanwoo Choi <cw00.choi@samsung.com>
To: jic23@kernel.org, ch.naveen@samsung.com, kgene.kim@samsung.com
Cc: linux-iio@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] iio: adc: exynos_adc: Control special clock of ADC to support
 Exynos3250 ADC
Date: Fri, 11 Apr 2014 11:00:40 +0900
Message-id: <1397181640-18513-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.8.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsWyRsSkWPe8j3uwwcRrBhZ3nx9mtLj+5Tmr
	xYOmVUwWvQuuslmcbXrDbrHp8TVWi3lH3rFYXN41h81ixvl9TA6cHptWdbJ5bF5S79G3ZRWj
	x+dNcgEsUVw2Kak5mWWpRfp2CVwZ3xYvYS64JV6x98kGlgbG58JdjJwcEgImEj1H+pkhbDGJ
	C/fWs3UxcnEICSxllHi+7jojTNG32WfYQWwhgemMEqvXK0AUNTFJzPy8EqyITUBLYv+LG2wg
	toiAk8TPb/fAbGaBm4wSXzriQGxhgXiJdafXMoHYLAKqEhM7l7OA2LwCrhIXp5xlglgmJ/Fh
	zyN2kAUSAu3sElevv2eBaBCQ+Db5EJDNAZSQldh0AOpqSYmDK26wTGAUXMDIsIpRNLUguaA4
	Kb3ISK84Mbe4NC9dLzk/dxMjMHxP/3vWt4Px5gHrQ4zJQOMmMkuJJucDwz+vJN7Q2MzIwtTE
	1NjI3NKMNGElcd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDq/eFND7ZOluWa8+vY
	9tSD/fMubKyYfDPO6knzaseLRhXskY98HrYuzVfRK8yY2rK8f2+RZaruyvsxaqKTRXjvr08o
	3mFvnsKVc6rG/Rvn0Zigs7OfSLxmYua2eMi1Jb1y6qvPN3fLt2Rm3OhvWTv1K9v0L3fS/SZc
	/nLp68aypXaMufM4tKyUWIozEg21mIuKEwGgjc6SdQIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t9jQd3zPu7BBtN3aVjcfX6Y0eL6l+es
	Fg+aVjFZ9C64ymZxtukNu8Wmx9dYLeYdecdicXnXHDaLGef3MTlwemxa1cnmsXlJvUffllWM
	Hp83yQWwRDUw2mSkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6
	ZeYA3aKkUJaYUwoUCkgsLlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxhzPi2eAlzwS3xir1P
	NrA0MD4X7mLk5JAQMJH4NvsMO4QtJnHh3no2EFtIYDqjxOr1Cl2MXEB2E5PEzM8rGUESbAJa
	Evtf3AArEhFwkvj57R6YzSxwk1HiS0cciC0sEC+x7vRaJhCbRUBVYmLnchYQm1fAVeLilLNM
	EMvkJD7secQ+gZF7ASPDKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzg6HgmtYNxZYPFIUYB
	DkYlHt6MC27BQqyJZcWVuYcYJTiYlUR4e34AhXhTEiurUovy44tKc1KLDzEmA22fyCwlmpwP
	jNy8knhDYxMzI0sjc0MLI2Nz0oSVxHkPtFoHCgmkJ5akZqemFqQWwWxh4uCUamDk3JtVcH8J
	wyL3MMFtHH+Phr2ffqNi88+0g1d43t/Ytq9fKinESO/G4145pgmiv5YJvknx6mQ5/+gk18Xj
	jiH+VoKfcpuSpI/k8EsqHNr6l2GrcmJO6mrX5XMqzs75euFfiJxvh+6bXCEnN5GQK38cyw8t
	LPjKEC/teZQ9dImlG7Pj3kdPj+9UYinOSDTUYi4qTgQANMY2tNICAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch control special clock for ADC in Exynos series's FSYS block.
If special clock of ADC is registerd on clock list of common clk framework,
Exynos ADC drvier have to control this clock.

Exynos3250/Exynos4/Exynos5 has 'adc' clock as following:
- 'adc' clock: bus clock for ADC

Exynos3250 has additional 'sclk_tsadc' clock as following:
- 'sclk_tsadc' clock: special clock for ADC which provide clock to internal ADC

Exynos 4210/4212/4412 and Exynos5250/5420 has not included 'sclk_tsadc' clock
in FSYS_BLK. But, Exynos3250 based on Cortex-A7 has only included 'sclk_tsadc'
clock in FSYS_BLK.

Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-iio@vger.kernel.org
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/adc/exynos_adc.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/iio/adc/exynos_adc.c b/drivers/iio/adc/exynos_adc.c
index d25b262..4cd1975 100644
--- a/drivers/iio/adc/exynos_adc.c
+++ b/drivers/iio/adc/exynos_adc.c
@@ -88,6 +88,7 @@ struct exynos_adc {
 	void __iomem		*regs;
 	void __iomem		*enable_reg;
 	struct clk		*clk;
+	struct clk		*sclk;
 	unsigned int		irq;
 	struct regulator	*vdd;
 
@@ -308,6 +309,13 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_irq;
 	}
 
+	info->sclk = devm_clk_get(&pdev->dev, "sclk_tsadc");
+	if (IS_ERR(info->sclk)) {
+		dev_warn(&pdev->dev, "failed getting sclk clock, err = %ld\n",
+							PTR_ERR(info->sclk));
+		info->sclk = NULL;
+	}
+
 	info->vdd = devm_regulator_get(&pdev->dev, "vdd");
 	if (IS_ERR(info->vdd)) {
 		dev_err(&pdev->dev, "failed getting regulator, err = %ld\n",
@@ -341,6 +349,7 @@ static int exynos_adc_probe(struct platform_device *pdev)
 		goto err_iio_dev;
 
 	clk_prepare_enable(info->clk);
+	clk_prepare_enable(info->sclk);
 
 	exynos_adc_hw_init(info);
 
@@ -357,6 +366,7 @@ err_of_populate:
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
+	clk_disable_unprepare(info->sclk);
 err_iio_dev:
 	iio_device_unregister(indio_dev);
 err_irq:
@@ -373,6 +383,7 @@ static int exynos_adc_remove(struct platform_device *pdev)
 				exynos_adc_remove_devices);
 	regulator_disable(info->vdd);
 	clk_disable_unprepare(info->clk);
+	clk_disable_unprepare(info->sclk);
 	writel(0, info->enable_reg);
 	iio_device_unregister(indio_dev);
 	free_irq(info->irq, info);
@@ -398,6 +409,7 @@ static int exynos_adc_suspend(struct device *dev)
 	}
 
 	clk_disable_unprepare(info->clk);
+	clk_disable_unprepare(info->sclk);
 	writel(0, info->enable_reg);
 	regulator_disable(info->vdd);
 
@@ -416,6 +428,7 @@ static int exynos_adc_resume(struct device *dev)
 
 	writel(1, info->enable_reg);
 	clk_prepare_enable(info->clk);
+	clk_prepare_enable(info->sclk);
 
 	exynos_adc_hw_init(info);
 
-- 
1.8.0

