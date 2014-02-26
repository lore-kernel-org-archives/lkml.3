Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971AbaBZBWJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:22:09 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:60506 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbaBZBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:22:07 -0500
X-AuditID: cbfee691-b7efc6d0000039d3-3c-530d41be62e9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Haojian Zhuang'" <haojian.zhuang@gmail.com>
References: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
In-reply-to: <002e01cf3290$ccda9430$668fbc90$%han@samsung.com>
Subject: [PATCH 3/3] regulator: 88pm8607: fix indent code style
Date: Wed, 26 Feb 2014 10:22:05 +0900
Message-id: <003001cf3291$293db3b0$7bb91b10$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: Ac8ykMzEt0AEx/NVROGPrQsXYu79GwAADcIQ
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsVy+t8zI919jrzBBss/illMffiEzeLCOnOL
	ywsvsVp8u9LBZHF51xw2B1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUVw2Kak5mWWpRfp2CVwZ
	b75cZi6Yz1/xZ8U85gbGc9xdjJwcEgImEpe2bmeCsMUkLtxbz9bFyMUhJLCMUaKv6T07TNG9
	449YIBKLGCX6m04yQTi/GSVuHTrBDFLFJqAm8eXLYaAODg4RAVWJ/6/cQWqYBWYxSjQs+ssC
	UiMkYCsx9dxRsBpOATuJKZ8VQMLCAvYSUw6uYQOxWYBav137ALaYF6j86LsprBC2oMSPyffA
	xjALaEms33mcCcKWl9i85i0zyEgJAXWJR391IcIiEvtevGMEsUUEjCR2v97NDHKOhMA1dolz
	e1+yQ+wSkPg2+RALRK+sxKYDzBD/SkocXHGDZQKjxCwkm2ch2TwLyeZZSNYtYGRZxSiaWpBc
	UJyUXmSqV5yYW1yal66XnJ+7iRESnRN3MN4/YH2IMRlo/URmKdHkfGB055XEGxqbGVmYmpga
	G5lbmpEmrCTOm/4oKUhIID2xJDU7NbUgtSi+qDQntfgQIxMHp1QDY1t3ec/0fVY/CxqX/U9e
	3np5rmYwr/RB9+NFuX33qk23vT7S+9Uu1Kd9pVfRkaZDnxd+r9ZcbX5pllunvux1zg0fWE6f
	4ezp/8l/PkSKecr31y/NevtOdceZr8y5ztvD58p0Z87UfcxuD+rO5FeGTt86fyVfucczLwZ1
	0eZFXVpGnxY5Hvv5QYmlOCPRUIu5qDgRAJzt6krkAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsVy+t9jAd19jrzBBu+WCltMffiEzeLCOnOL
	ywsvsVp8u9LBZHF51xw2B1aPnbPusntsWtXJ5tG3ZRWjx+dNcgEsUQ2MNhmpiSmpRQqpecn5
	KZl56bZK3sHxzvGmZgaGuoaWFuZKCnmJuam2Si4+AbpumTlAe5UUyhJzSoFCAYnFxUr6dpgm
	hIa46VrANEbo+oYEwfUYGaCBhHWMGW++XGYumM9f8WfFPOYGxnPcXYycHBICJhL3jj9igbDF
	JC7cW8/WxcjFISSwiFGiv+kkE4Tzm1Hi1qETzCBVbAJqEl++HGbvYuTgEBFQlfj/yh2khllg
	FqNEw6K/YJOEBGwlpp47ClbDKWAnMeWzAkhYWMBeYsrBNWwgNgtQ67drH9hBbF6g8qPvprBC
	2IISPybfAxvDLKAlsX7ncSYIW15i85q3zCAjJQTUJR791YUIi0jse/GOEcQWETCS2P16N/ME
	RqFZSCbNQjJpFpJJs5C0L2BkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRHPvPpHcwrmqw
	OMQowMGoxMMbwMIbLMSaWFZcmXuIUYKDWUmE1+IbT7AQb0piZVVqUX58UWlOavEhxmSgRycy
	S4km5wPTUl5JvKGxiZmRpZGZhZGJuTlpwkrivAdbrQOFBNITS1KzU1MLUotgtjBxcEo1MGb9
	NM3OZtL4me5+UcM6JvbalKo53a1H7H6yJCY2B0xhcu1T3tZvm1qger7wJtv28BjZnWkPeTK3
	e03Kr1F5ceiDoZN+fvnsW8ViMm+rRJrXKgq8879w72Hwn8ia4lu2xVJ/lf8ksnIo9V6r26It
	mRNYE9iocUyKvW71rfiSpEfRP/4ZtSQrsRRnJBpqMRcVJwIAaUdxGEEDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix indent code style in order to fix the following checkpatch
issues.

  ERROR: code indent should use tabs where possible
  WARNING: please, no space before tabs
  WARNING: please, no spaces at the start of a line

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/88pm8607.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index fa99bfc..337634a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -2,7 +2,7 @@
  * Regulators driver for Marvell 88PM8607
  *
  * Copyright (C) 2009 Marvell International Ltd.
- * 	Haojian Zhuang <haojian.zhuang@marvell.com>
+ *	Haojian Zhuang <haojian.zhuang@marvell.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -78,7 +78,7 @@ static const unsigned int BUCK2_suspend_table[] = {
 };
 
 static const unsigned int BUCK3_table[] = {
-              0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
+	      0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
 	 200000,  225000,  250000,  275000,  300000,  325000,  350000,  375000,
 	 400000,  425000,  450000,  475000,  500000,  525000,  550000,  575000,
 	 600000,  625000,  650000,  675000,  700000,  725000,  750000,  775000,
@@ -89,7 +89,7 @@ static const unsigned int BUCK3_table[] = {
 };
 
 static const unsigned int BUCK3_suspend_table[] = {
-              0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
+	      0,   25000,   50000,   75000,  100000,  125000,  150000,  175000,
 	 200000,  225000,  250000,  275000,  300000,  325000,  350000,  375000,
 	 400000,  425000,  450000,  475000,  500000,  525000,  550000,  575000,
 	 600000,  625000,  650000,  675000,  700000,  725000,  750000,  775000,
-- 
1.7.10.4


