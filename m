Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaKHNXt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 08:23:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:61674 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaKHNWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:22:44 -0500
X-AuditID: cbfee68d-f79296d000004278-99-545e19229505
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        s.nawrocki@samsung.com, lee.jones@linaro.org,
        Amit Daniel Kachhap <amit.daniel@samsung.com>
Subject: [PATCH v2 3/6] drivers: soc: samsung: Fix a spelling mistake
Date: Sat, 08 Nov 2014 18:46:38 +0530
Message-id: <1415452601-13078-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
References: <1415452601-13078-1-git-send-email-amit.daniel@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCLMWRmVeSWpSXmKPExsWyRsSkTldJMi7EYPdaEYuGqyEWvQuuslnc
	/3qU0WLT42usFpd3zWGzmHF+H5PF4TftrA7sHneu7WHz2Lyk3qNvyypGj8+b5AJYorhsUlJz
	MstSi/TtErgy5j7vYyn4wVWx7/1sxgbGZZxdjJwcEgImEr+mv2CEsMUkLtxbz9bFyMUhJLCU
	UWLOxk4mmKJDE74yQiSmM0qc3vuJCcKZwCTx9sFjsCo2AWOJnzv3s3cxcnCICHhLLL+mCFLD
	LDCDUaKnuxVshbCAq8Shs+1gNouAqsSJ+auZQWxeAXeJZZ93MoP0SggoSMyZZAMS5hTwkFiw
	t5sFxBYCKtn08B/YERICk9kl9qy6wwYxR0Di2+RDLBC9shKbDjBDHC0pcXDFDZYJjMILGBlW
	MYqmFiQXFCelFxnqFSfmFpfmpesl5+duYgQG9ul/z3p3MN4+YH2IUYCDUYmH90ZLbIgQa2JZ
	cWXuIUZToA0TmaVEk/OB8ZNXEm9obGZkYWpiamxkbmmmJM6rKPUzWEggPbEkNTs1tSC1KL6o
	NCe1+BAjEwenVAPjXfZr3Tyf/zWtPrTBTFVTU1LcM1bcY9fXNUuPa7vy21/x/H5WcUdkDtP0
	W/eYjhyaxckwP2kR0+y0lgQZP+4tO14omXLtDgvg35q1/cWzlepq++RDWU8+tXtx0MGxWm7b
	4mnNUVvXVD9rPsPZ/CHG8Pcjwa6rMx0u3KmZMs+Z7f9toVrLljNWSizFGYmGWsxFxYkAuaOQ
	SmcCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHIsWRmVeSWpSXmKPExsVy+t9jQV0lybgQg/sXuS0aroZY9C64ymZx
	/+tRRotNj6+xWlzeNYfNYsb5fUwWh9+0szqwe9y5tofNY/OSeo++LasYPT5vkgtgiWpgtMlI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjDmDH3eR9LwQ+uin3vZzM2MC7j7GLk5JAQ
	MJE4NOErI4QtJnHh3nq2LkYuDiGB6YwSp/d+YoJwJjBJvH3wmAmkik3AWOLnzv3sXYwcHCIC
	3hLLrymC1DALzGCU6OluBZskLOAqcehsO5jNIqAqcWL+amYQm1fAXWLZ553MIL0SAgoScybZ
	gIQ5BTwkFuztZgGxhYBKNj38xziBkXcBI8MqRtHUguSC4qT0XCO94sTc4tK8dL3k/NxNjOC4
	eSa9g3FVg8UhRgEORiUe3hstsSFCrIllxZW5hxglOJiVRHh7zwOFeFMSK6tSi/Lji0pzUosP
	MZoCHTWRWUo0OR8Y03kl8YbGJuamxqaWJhYmZpZK4rwHW60DhQTSE0tSs1NTC1KLYPqYODil
	GhjrPEQM9HWuliRN+XluRVvkgSWb33zafPXmzpTq+ue9p6xfV1WbreCPZPu15HpjxeUTRv4J
	RUEhGnmaWhPjmK779kzk2/evpNb27f/l0i7OljLfzQWePX8ov8Hpu6aimWVik+6K6Ff+p58G
	xvz9n8lwd/kzzvCIj1939jNfT7f490ZfhzdGboMSS3FGoqEWc1FxIgDGQxGPsQIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches changes the name of exynos5_list_diable_wfi_wfe to
exynos5_list_disable_wfi_wfe.

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 drivers/soc/samsung/exynos-pmu.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/soc/samsung/exynos-pmu.c b/drivers/soc/samsung/exynos-pmu.c
index 35774e8..3832cda 100644
--- a/drivers/soc/samsung/exynos-pmu.c
+++ b/drivers/soc/samsung/exynos-pmu.c
@@ -361,7 +361,7 @@ static unsigned int const exynos5_list_both_cnt_feed[] = {
 	EXYNOS5_TOP_PWR_SYSMEM_OPTION,
 };
 
-static unsigned int const exynos5_list_diable_wfi_wfe[] = {
+static unsigned int const exynos5_list_disable_wfi_wfe[] = {
 	EXYNOS5_ARM_CORE1_OPTION,
 	EXYNOS5_FSYS_ARM_OPTION,
 	EXYNOS5_ISP_ARM_OPTION,
@@ -392,11 +392,11 @@ static void exynos5_powerdown_conf(enum sys_powerdown mode)
 	/*
 	 * Disable WFI/WFE on XXX_OPTION
 	 */
-	for (i = 0; i < ARRAY_SIZE(exynos5_list_diable_wfi_wfe); i++) {
-		tmp = pmu_raw_readl(exynos5_list_diable_wfi_wfe[i]);
+	for (i = 0; i < ARRAY_SIZE(exynos5_list_disable_wfi_wfe); i++) {
+		tmp = pmu_raw_readl(exynos5_list_disable_wfi_wfe[i]);
 		tmp &= ~(EXYNOS5_OPTION_USE_STANDBYWFE |
 			 EXYNOS5_OPTION_USE_STANDBYWFI);
-		pmu_raw_writel(tmp, exynos5_list_diable_wfi_wfe[i]);
+		pmu_raw_writel(tmp, exynos5_list_disable_wfi_wfe[i]);
 	}
 }
 
-- 
1.7.9.5

