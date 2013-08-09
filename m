Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030604Ab3HII3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 04:29:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45099 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030493Ab3HII3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 04:29:32 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-1b-5204a86a1d7d
From: Jingoo Han <jg1.han@samsung.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        "'Maciej Sosnowski'" <maciej.sosnowski@intel.com>,
        "'Dan Williams'" <dan.j.williams@intel.com>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH] dca: Staticize local symbol
Date: Fri, 09 Aug 2013 17:29:30 +0900
Message-id: <001101ce94da$918a62b0$b49f2810$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6U2mETG3sCoyAOTUuPzMXxwd6iZg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t8zY92sFSxBBl9mm1rMWb+GzWL61AuM
	FpcXXmK1uLxrDpvF8WM/mB1YPRbvecnkcWLGbxaPvi2rGD0+b5ILYInisklJzcksSy3St0vg
	ypj09S1zwTa2iv7PS1gbGJewdjFyckgImEhcX9UKZYtJXLi3nq2LkYtDSGAZo8TWbceZYIqe
	f1jEDpGYzihx8vh3RgjnF6PEhFNr2UGq2ATUJL58OQxmiwjoSqx6vosZpIhZYBGjxNP919hA
	EsICOhILN64Hs1kEVCUmr50CtptXwFLiwqEnLBC2oMSPyffAbGYBLYn1OyHOYBaQl9i85i0z
	xEkKEjvOvga6ggNomZ7EvyeaECUiEvtevAM7TkJgH7vE/hlX2CF2CUh8m3yIBaReQkBWYtMB
	qDGSEgdX3GCZwCg2C8nmWUg2z0KyeRaSFQsYWVYxiqYWJBcUJ6UXmegVJ+YWl+al6yXn525i
	hMTchB2M9w5YH2JMBlo/kVlKNDkfGLN5JfGGxmZGFqYmpsZG5pZmpAkrifOqt1gHCgmkJ5ak
	ZqemFqQWxReV5qQWH2Jk4uCUamBcOHd/m4COXtodi13Hj65M/PGjsvf1m5OLvhmFM+heX+rE
	cdCXZWJ6uOFXPgWOz9ttL1jvUuKUXHm2W2L2tlwR4SPuD7mqWRh4vu+c0jEvzMxo5sN3k6y/
	q2Tnfba9x/SB6922Z/9vLtm2n3mL0IPr8hen/A3TCpR9PkXe+NNn4X4pb3V3Ds4EJZbijERD
	Leai4kQAkPhUKc8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJKsWRmVeSWpSXmKPExsVy+t9jQd2sFSxBBn/PGlrMWb+GzWL61AuM
	FpcXXmK1uLxrDpvF8WM/mB1YPRbvecnkcWLGbxaPvi2rGD0+b5ILYIlqYLTJSE1MSS1SSM1L
	zk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMAVqspFCWmFMKFApILC5W0rfD
	NCE0xE3XAqYxQtc3JAiux8gADSSsY8yY9PUtc8E2tor+z0tYGxiXsHYxcnJICJhIPP+wiB3C
	FpO4cG89WxcjF4eQwHRGiZPHvzNCOL8YJSacWgtWxSagJvHly2EwW0RAV2LV813MIEXMAosY
	JZ7uv8YGkhAW0JFYuHE9mM0ioCoxee0UsHW8ApYSFw49YYGwBSV+TL4HZjMLaEms33mcCcKW
	l9i85i0zxEkKEjvOvga6ggNomZ7EvyeaECUiEvtevGOcwCgwC8mkWUgmzUIyaRaSlgWMLKsY
	RVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgiP6mfQOxlUNFocYBTgYlXh4FbczBwmxJpYVV+Ye
	YpTgYFYS4d0+gSVIiDclsbIqtSg/vqg0J7X4EGMy0KMTmaVEk/OBySavJN7Q2MTMyNLIzMLI
	xNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhibfYr+hbx7wjrzILcT9/MvG3fNLjvF
	k7x/+etFs729usNZAoM0dQ74Frn5PbXd23//+GHJgCtlVh/tvpY4HlaUEHW5+W0at0H8p006
	VtPiVE/UiJeX+W6MqbQ78FN2Y618wIuFtsvKuva9YA9QNzz1ppPlsO25uHCJK9InfpTOz12m
	kbOl4JgSS3FGoqEWc1FxIgA0yvI9LAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This local symbol is used only in this file.
Fix the following sparse warnings:

drivers/dca/dca-core.c:273:4: warning: symbol 'dca_common_get_tag' was not declared. Should it be static?

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/dca/dca-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dca/dca-core.c b/drivers/dca/dca-core.c
index 819dfda..9096e59 100644
--- a/drivers/dca/dca-core.c
+++ b/drivers/dca/dca-core.c
@@ -270,7 +270,7 @@ EXPORT_SYMBOL_GPL(dca_remove_requester);
  * @dev - the device that wants dca service
  * @cpu - the cpuid as returned by get_cpu()
  */
-u8 dca_common_get_tag(struct device *dev, int cpu)
+static u8 dca_common_get_tag(struct device *dev, int cpu)
 {
 	struct dca_provider *dca;
 	u8 tag;
-- 
1.7.10.4


