Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbaCMB57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 21:57:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:39361 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098AbaCMB55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 21:57:57 -0400
X-AuditID: cbfee68f-b7f156d00000276c-78-532110a466d4
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: lee.jones@linaro.org, sameo@linux.intel.com, sbkim73@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [PATCH v3] drivers: mfd: silence compiler warning in sec-core.c
Date: Thu, 13 Mar 2014 11:14:07 +0900
Message-id: <1394676847-3392-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394017159-4851-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t8zQ90lAorBBhc2aVrc/3qU0eLyrjls
	Fou2fmG3ON3NanFxxRcmB1aPO9f2sHnMOxno0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBk3
	23czF/zlrri/ahJzA+M3zi5GTg4JAROJK1PnsEHYYhIX7q0Hsrk4hASWMUrsPPSGCabo8NQ/
	7BCJ6YwS7TM+QFW1MUl83tjFCFLFJqAr8eT9XGYQW0RAQWJz7zNWEJtZIF/iwq9pYDXCAh4S
	q3/+BKthEVCV2PjjEjuIzSvgLjFp6wOgoRxA2xQk5kyyATE5gcrXLtcGqRACqlj5eS4TyFoJ
	gf9sElNbvkCNEZD4NvkQC0SrrMSmA8wQN0tKHFxxg2UCo/ACRoZVjKKpBckFxUnpRcZ6xYm5
	xaV56XrJ+bmbGCEh3L+D8e4B60OMyUDjJjJLiSbnA2MgryTe0NjMyMLUxNTYyNzSjDRhJXHe
	+w+TgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwhrDPfx8YYW2bzfJeZc63ZXlSX6+66Txm
	/5/8a6FIvp1X9OJdsU7rGfYnfFxzXGjaWrM4jhCev56Tv4v+8g35kXelfgdXS6DtHG7/2zlT
	RW6yrbFgyT5/R3Aee4DHKVF7oce/rPUvLr36uH1l4Vst9z8ORz4y6kh5/HDK+HJt/QSG7ZNf
	2ci2K7EUZyQaajEXFScCAFwlw/53AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t9jQd0lAorBBl9Xqlrc/3qU0eLyrjls
	Fou2fmG3ON3NanFxxRcmB1aPO9f2sHnMOxno0bdlFaPH501yASxRDYw2GamJKalFCql5yfkp
	mXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBrlRTKEnNKgUIBicXFSvp2mCaE
	hrjpWsA0Ruj6hgTB9RgZoIGEdYwZN9t3Mxf85a64v2oScwPjN84uRk4OCQETicNT/7BD2GIS
	F+6tZ+ti5OIQEpjOKNE+4wOU08Yk8XljFyNIFZuArsST93OZQWwRAQWJzb3PWEFsZoF8iQu/
	poHVCAt4SKz++ROshkVAVWLjj0tgG3gF3CUmbX0ANJQDaJuCxJxJNiAmJ1D52uXaIBVCQBUr
	P89lmsDIu4CRYRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGcIQ8k9rBuLLB4hCjAAejEg/v
	iuUKwUKsiWXFlbmHGCU4mJVEeLvWAIV4UxIrq1KL8uOLSnNSiw8xJgPdNJFZSjQ5Hxi9eSXx
	hsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAKPGJdw6D/ZOrZVul
	9ScvXmtqtd5voUSY99PYFzYn/l19sePTFCf+pUd0/ietKykqv53Q9biX6VVDaGXmDP/JlRvy
	z27eEx9/j9F46ZPJuZEf858pTUqJY/E4Ussyi7GpT1AyKZJHZuLEnSnn9q8+d740csPEXyee
	OEQ2ffp7JznSTHzVhuTlU5RYijMSDbWYi4oTAbC+Fw3UAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When used 64bit compiler GCC warns as
drivers/mfd/sec-core.c:199:10: warning:
cast from pointer to integer of different size [-Wpointer-to-int-cast]

Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 drivers/mfd/sec-core.c           |    6 +++---
 include/linux/mfd/samsung/core.h |    2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mfd/sec-core.c b/drivers/mfd/sec-core.c
index ce32538..c6088c5 100644
--- a/drivers/mfd/sec-core.c
+++ b/drivers/mfd/sec-core.c
@@ -189,17 +189,17 @@ static struct sec_platform_data *sec_pmic_i2c_parse_dt_pdata(
 }
 #endif
 
-static inline int sec_i2c_get_driver_data(struct i2c_client *i2c,
+static inline unsigned long sec_i2c_get_driver_data(struct i2c_client *i2c,
 						const struct i2c_device_id *id)
 {
 #ifdef CONFIG_OF
 	if (i2c->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(sec_dt_match, i2c->dev.of_node);
-		return (int)match->data;
+		return (unsigned long)match->data;
 	}
 #endif
-	return (int)id->driver_data;
+	return id->driver_data;
 }
 
 static int sec_pmic_probe(struct i2c_client *i2c,
diff --git a/include/linux/mfd/samsung/core.h b/include/linux/mfd/samsung/core.h
index a30b53c..05d584b 100644
--- a/include/linux/mfd/samsung/core.h
+++ b/include/linux/mfd/samsung/core.h
@@ -51,7 +51,7 @@ struct sec_pmic_dev {
 	struct regmap_irq_chip_data *irq_data;
 
 	int ono;
-	int type;
+	unsigned long type;
 	bool wakeup;
 	bool wtsr_smpl;
 };
-- 
1.7.10.4

