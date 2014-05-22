Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750936AbaEVEAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 00:00:21 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29034 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaEVEAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 00:00:20 -0400
X-AuditID: cbfee68f-b7fef6d000003970-f9-537d76525bf4
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kishon Vijay Abraham I'" <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, "'Vivek Gautam'" <gautam.vivek@samsung.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH] phy: exynos5-usbdrd: Make local functions static
Date: Thu, 22 May 2014 13:00:28 +0900
Message-id: <000101cf7572$5e52cd00$1af86700$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac91cl4FuDy+CCFKQD6WRh4pngY3mQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zI92gstpggx1HlSzarhxkt7i88BKr
	xYWnPWwWl3fNYXNg8ejbsorR4/iN7UwenzfJBTBHcdmkpOZklqUW6dslcGXMfPGfseAjV8X/
	7lNsDYwzOLsYOTkkBEwklrS8YYawxSQu3FvP1sXIxSEksIxRYteUo0wwRQd+f2OHSExnlNh8
	bg0rhPObUeL05MOsIFVsAmoSX74cZgexRQR0JBaeXg82llmgUOJYz2uwuLCAo8Tua01g9SwC
	qhIn5t9kA7F5BWwlTr1qZ4SwBSV+TL7HAtGrJbF+53EmCFteYvOat0AzOYAuUpd49FcXYpWe
	xMLe2VAlIhL7XrxjBLlNQmAVu8TKy8dYIHYJSHybfIgFoldWYtMBqI8lJQ6uuMEygVFsFpLN
	s5BsnoVk8ywkKxYwsqxiFE0tSC4oTkovMtYrTswtLs1L10vOz93ECImu/h2Mdw9YH2JMBlo/
	kVlKNDkfGJ15JfGGxmZGFqYmpsZG5pZmpAkrifPef5gUJCSQnliSmp2aWpBaFF9UmpNafIiR
	iYNTqoGRYffPU2YzDtz2y/sb++O/f1qHW5yJh17m0R0VpZWPLheInrELfLLA7cQfi9/yAgfX
	f5ruJ3aZ610tw77GG3GPnmaoTfYw+/VJ2r47dIFh3MeQCtWI7rdbP5W6mm7gfyQZ2le+7mNo
	74+H/o379QR3yk5+F7HUSTx1YvvLNbNelK58y8s0I8tLiaU4I9FQi7moOBEAeVmAEcQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+xoG5QWW2wwdsGeYu2KwfZLS4vvMRq
	ceFpD5vF5V1z2BxYPPq2rGL0OH5jO5PH501yAcxRDYw2GamJKalFCql5yfkpmXnptkrewfHO
	8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDrlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6
	hgTB9RgZoIGEdYwZM1/8Zyz4yFXxv/sUWwPjDM4uRk4OCQETiQO/v7FD2GISF+6tZ+ti5OIQ
	EpjOKLH53BpWCOc3o8TpyYdZQarYBNQkvnw5DNYhIqAjsfD0emYQm1mgUOJYz2uwuLCAo8Tu
	a01g9SwCqhIn5t9kA7F5BWwlTr1qZ4SwBSV+TL7HAtGrJbF+53EmCFteYvOat0AzOYAuUpd4
	9FcXYpWexMLe2VAlIhL7XrxjnMAoMAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPSc430ihNz
	i0vz0vWS83M3MYJj95n0DsZVDRaHGAU4GJV4eG+crwkWYk0sK67MPcQowcGsJMLboVwbLMSb
	klhZlVqUH19UmpNafIgxGejRicxSosn5wLSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbrQCGB
	9MSS1OzU1ILUIpgtTBycUg2M5feCTCYzb5q6t3tV1Ye5eX7eNlPvMxVa/Jsu59CyOyd/ufdV
	0XtPTG5OTHxaMsH2zhebXsvKaQw/Z97g1926MrX7DefVjOOSEee/dT1euV7bzGXiAdMUodrt
	5bfeFM9gOxQy7ZPvhFbL1ZFeMhpHZLZKcjMKqrPwaQvZfI1yVA2Ke7b3gvY9JZbijERDLeai
	4kQAs9+xvSEDAAA=
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


