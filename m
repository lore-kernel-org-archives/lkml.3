Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaGHL7r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 07:59:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18967 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaGHL7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 07:59:44 -0400
X-AuditID: cbfee690-b7fb56d000003439-79-53bbdd2e34ba
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH RESEND] phy: exynos5-usbdrd: Make local functions static
Date: Tue, 08 Jul 2014 20:59:42 +0900
Message-id: <000c01cf9aa4$1a499e20$4edcda60$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac+apBozXlCJ9eywRuu55TqSpf0eeQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHIsWRmVeSWpSXmKPExsVy+t8zY129u7uDDbo/G1i0XTnIbnF54SVW
	iwtPe9gsLu+aw+bA4tG3ZRWjx/Eb25k8Pm+SC2CO4rJJSc3JLEst0rdL4MqY+eI/Y8FHror/
	3afYGhhncHYxcnBICJhIrP+X0sXICWSKSVy4t56ti5GLQ0hgGaNE69fZTDA1kw7GQcQXMUo8
	v3uDFcL5zSgxu/MRO0g3m4CaxJcvh8FsEQEdiYWn1zOD2MwChRLHel6zgwwSFvCQOLzQDSTM
	IqAq8W/NBlYQm1fAVmLi1JssELagxI/J91ggWrUk1u88zgRhy0tsXvOWGeIedYlHf3UhNulJ
	3JncxgpRIiKx78U7RpDTJARWsUss2/KDEWKXgMS3yYdYIHplJTYdYIb4V1Li4IobLBMYxWYh
	2TwLyeZZSDbPQrJiASPLKkbR1ILkguKk9CITveLE3OLSvHS95PzcTYyQuJqwg/HeAetDjMlA
	6ycyS4km5wPjMq8k3tDYzMjC1MTU2Mjc0ow0YSVxXrVHSUFCAumJJanZqakFqUXxRaU5qcWH
	GJk4OKUaGCe4xewuPWvyTXf5Mybu+Em658K7/0VcSq6ttnm2S9xN80qlunSQ1z+2B9t8Nmkn
	RCQfTlvhs/qG3MtzxyuKTQoSpl12z6vLq3ilJfDsyDHV35KJAftiFqZvCHQwbdr1fv+lX42d
	4VznPkwNmfLa/EgXW/0h6wdsZ2YtmMDg/UtUaPELO9Pa80osxRmJhlrMRcWJAHiUQtzBAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHIsWRmVeSWpSXmKPExsVy+t9jAV29u7uDDU7s17Fou3KQ3eLywkus
	Fhee9rBZXN41h82BxaNvyypGj+M3tjN5fN4kF8Ac1cBok5GamJJapJCal5yfkpmXbqvkHRzv
	HG9qZmCoa2hpYa6kkJeYm2qr5OIToOuWmQO0TkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Su
	b0gQXI+RARpIWMeYMfPFf8aCj1wV/7tPsTUwzuDsYuTgkBAwkZh0MK6LkRPIFJO4cG89Wxcj
	F4eQwCJGied3b7BCOL8ZJWZ3PmIHqWITUJP48uUwmC0ioCOx8PR6ZhCbWaBQ4ljPa3aQocIC
	HhKHF7qBhFkEVCX+rdnACmLzCthKTJx6kwXCFpT4MfkeC0SrlsT6nceZIGx5ic1r3jJD3KYu
	8eivLsQmPYk7k9tYIUpEJPa9eMc4gVFgFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBMftM6kdjCsbLA4xCnAwKvHwrji4K1iINbGsuDL3EKMEB7OSCO+XU7uD
	hXhTEiurUovy44tKc1KLDzGaAj06kVlKNDkfmFLySuINjU3MjCyNzCyMTMzNlcR5D7RaBwoJ
	pCeWpGanphakFsH0MXFwSjUw8k+QUS645LZxyWYRdx9r0+eXH7o/6+Mvj7vkt0/O6u/6JoYm
	S1aTGeaNF/7e0kiakBHXOOuc3IfikmjhEPUVf724mdx/STM2NTtP476pM1dYuVetd7H8xu9z
	/oSGr82/XKr65sT6n85BEw4f/TF7R3r7v5L3e0ydVi6WiNp71+3pE66LibKvlViKMxINtZiL
	ihMB5xw7bPECAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make local functions static, because these are used only in this
file.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/phy/phy-exynos5-usbdrd.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-exynos5-usbdrd.c
index 76d862b..205159d 100644
--- a/drivers/phy/phy-exynos5-usbdrd.c
+++ b/drivers/phy/phy-exynos5-usbdrd.c
@@ -506,7 +506,7 @@ static struct phy_ops exynos5_usbdrd_phy_ops = {
 	.owner		= THIS_MODULE,
 };
 
-const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
+static const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 	{
 		.id		= EXYNOS5_DRDPHY_UTMI,
 		.phy_isol	= exynos5_usbdrd_phy_isol,
@@ -521,13 +521,13 @@ const struct exynos5_usbdrd_phy_config phy_cfg_exynos5[] = {
 	},
 };
 
-const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
+static const struct exynos5_usbdrd_phy_drvdata exynos5420_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 	.pmu_offset_usbdrd1_phy	= EXYNOS5420_USBDRD1_PHY_CONTROL,
 };
 
-const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
+static const struct exynos5_usbdrd_phy_drvdata exynos5250_usbdrd_phy = {
 	.phy_cfg		= phy_cfg_exynos5,
 	.pmu_offset_usbdrd0_phy	= EXYNOS5_USBDRD_PHY_CONTROL,
 };
-- 
1.7.10.4


