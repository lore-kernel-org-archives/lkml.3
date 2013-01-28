Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757333Ab3A1Lj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:39:57 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:58559 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754384Ab3A1Ljv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:39:51 -0500
X-AuditID: cbfee61a-b7f7d6d000000f4e-41-51066386cb06
From: Vivek Gautam <gautam.vivek@samsung.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com, sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Subject: [PATCH 3/4] usb: dwc3: exynos: Enable runtime power management
Date: Mon, 28 Jan 2013 17:12:27 +0530
Message-id: <1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
X-Mailer: git-send-email 1.7.6.5
In-reply-to: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42JZI2JSq9uWzBZosHyKhMXlXXPYLGYv6Wex
	mHF+H5PFomWtzA4sHp83yQUwRnHZpKTmZJalFunbJXBltLZIFJwXrph68wlTA+MqgS5GTg4J
	AROJJfuWskDYYhIX7q1n62Lk4hASWMoo8ah5GhtM0Z+fk1hBbCGBRYwSs7/WQBRNZpI4++4z
	WDebgK5E09tdjCC2iICsxOErv5lBipgFJjJJ9CxqYAJJCAu4S8x7fgtsKouAqsSyj4eAmjk4
	eAU8JC68lYZYpiDx5vYzZhCbU8BTYvKDM+wQiz0kZi6azwIyU0LgNZvEvDuLmCDmCEh8mwwx
	RwJo8aYDzBBzJCUOrrjBMoFReAEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2MwPA8/e+Z
	1A7GlQ0WhxgFOBiVeHh/pLEECrEmlhVX5h5ilOBgVhLhFYhhCxTiTUmsrEotyo8vKs1JLT7E
	mAy0fCKzlGhyPjB28kriDY1NzE2NTS2NjMxMTUkTVhLnZTz1JEBIID2xJDU7NbUgtQhmCxMH
	p1QDo/R+di+TTRMqGktWVGwomKlYd0b9f+SNJfPqpWbcYNN+v2xV/0Leho3Pvrql3QyZ8P2z
	vdJ/s5uml2oXf5388WZD7ga9W/Fl3Z5LxQOjD2tEXtaZ+i+ie7YyH/vaN5xTW3bUvp2/77Rs
	2MGNBW4mjrrzJBiOlclMyf5x5Olppf2/PzAv+1G8bbMSS3FGoqEWc1FxIgBvGtBskwIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t9jAd22ZLZAg+Un2C0u75rDZjF7ST+L
	xYzz+5gsFi1rZXZg8fi8SS6AMaqB0SYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJc
	SSEvMTfVVsnFJ0DXLTMHaImSQlliTilQKCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCG
	MaO1RaLgvHDF1JtPmBoYVwl0MXJySAiYSPz5OYkVwhaTuHBvPRuILSSwiFFi9teaLkYuIHsy
	k8TZd59ZQBJsAroSTW93MYLYIgKyEoev/GYGKWIWmMgk0bOogQkkISzgLjHv+S2wSSwCqhLL
	Ph4Caubg4BXwkLjwVhpimYLEm9vPmEFsTgFPickPzrBDLPaQmLloPssERt4FjAyrGEVTC5IL
	ipPScw31ihNzi0vz0vWS83M3MYKD/5nUDsaVDRaHGAU4GJV4eH+ksQQKsSaWFVfmHmKU4GBW
	EuEViGELFOJNSaysSi3Kjy8qzUktPsSYDHTURGYp0eR8YGTmlcQbGpuYmxqbWppYmJhZkias
	JM7LeOpJgJBAemJJanZqakFqEcwWJg5OqQbGczHrj9ka517zUfPSWtQ4pfqFxDLPy6c7+ZX0
	PzorZxVuieAQbd+mfqSiZt8e+fbjPrOT5ugkOV3mr/ox359RQ8iSi8NT8JrgbfEY53rT1utK
	UW9fhOc83OM2V0Dj7M41kx/s8azLVTVaeN065Z3OXMe0DfvC/GewVW6+z2/mJVTmWmXZ806J
	pTgj0VCLuag4EQBh80NvwgIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enabling runtime power management on dwc3-exynos to save
power and allow its PHY's power to be managed at runtime.

Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
---
 drivers/usb/dwc3/dwc3-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
index aae5328..c51e8c1 100644
--- a/drivers/usb/dwc3/dwc3-exynos.c
+++ b/drivers/usb/dwc3/dwc3-exynos.c
@@ -157,11 +157,15 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
 		goto err4;
 	}
 
+	pm_runtime_set_active(&pdev->dev);
+	pm_runtime_enable(&pdev->dev);
+
 	return 0;
 
 err4:
 	clk_disable(clk);
 	clk_put(clk);
+	pm_runtime_disable(&pdev->dev);
 err3:
 	platform_device_put(dwc3);
 err1:
@@ -174,6 +178,8 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 {
 	struct dwc3_exynos	*exynos = platform_get_drvdata(pdev);
 
+	pm_runtime_disable(&pdev->dev);
+
 	platform_device_unregister(exynos->dwc3);
 	platform_device_unregister(exynos->usb2_phy);
 	platform_device_unregister(exynos->usb3_phy);
@@ -186,6 +192,46 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static int dwc3_exynos_runtime_suspend(struct device *dev)
+{
+	struct dwc3_exynos	*exynos = dev_get_drvdata(dev);
+	struct platform_device	*pdev_dwc = exynos->dwc3;
+	struct dwc3		*dwc = NULL;
+
+	dwc = platform_get_drvdata(pdev_dwc);
+
+	if (!dwc)
+		return 0;
+
+	pm_runtime_put_sync(dwc->usb3_phy->dev);
+
+	clk_disable(exynos->clk);
+
+	return 0;
+}
+static int dwc3_exynos_runtime_resume(struct device *dev)
+{
+	struct dwc3_exynos	*exynos = dev_get_drvdata(dev);
+	struct platform_device	*pdev_dwc = exynos->dwc3;
+	struct dwc3		*dwc = NULL;
+
+	dwc = platform_get_drvdata(pdev_dwc);
+
+	clk_enable(exynos->clk);
+
+	if (!dwc)
+		return 0;
+
+	pm_runtime_get_sync(dwc->usb3_phy->dev);
+
+	return 0;
+}
+
+static const struct dev_pm_ops dwc3_exynos_pm_ops = {
+	SET_RUNTIME_PM_OPS(dwc3_exynos_runtime_suspend,
+				dwc3_exynos_runtime_resume, NULL)
+};
+
 #ifdef CONFIG_OF
 static const struct of_device_id exynos_dwc3_match[] = {
 	{ .compatible = "samsung,exynos-dwc3" },
@@ -200,6 +246,7 @@ static struct platform_driver dwc3_exynos_driver = {
 	.driver		= {
 		.name	= "exynos-dwc3",
 		.of_match_table = of_match_ptr(exynos_dwc3_match),
+		.pm	= &dwc3_exynos_pm_ops,
 	},
 };
 
-- 
1.7.6.5

