Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3HTHGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:06:19 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:50141 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3HTHGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:06:18 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-70-52131569d696
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 6/6] mfd: wl1273: use devm_*() functions
Date: Tue, 20 Aug 2013 16:06:17 +0900
Message-id: <005a01ce9d73$c3cd88f0$4b689ad0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dc8B9Hj9KvEzbR7K1ltrTsCApJA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrIIsWRmVeSWpSXmKPExsVy+t8zQ91MUeEggw0/ZS0uL7zEanH/61FG
	i8u75rBZnO5mdWDxuHNtD5vHvJOBHn1bVjF6fN4kF8ASxWWTkpqTWZZapG+XwJWx4eFiloJJ
	nBW7Dm1mamA8yN7FyMEhIWAi0fyspIuRE8gUk7hwbz1bFyMXh5DAMkaJ1hvzmCASJhLPd61l
	h0hMZ5To2v6XBSQhJPCLUWJlswCIzSagJvHly2GwoSICfhINK9hBwswCThI/t8wEKxcWsJD4
	sOwQmM0ioCrx7Nl1VpByXgFLiZk3OEDCvAKCEj8m32OBaNWSWL/zOBOELS+xec1bZohzFCR2
	nH3NCGKLCOhJ3N2xjA2iRkRi34t3jCBnSghsYpc4/ucbG8QuAYlvk0H2gvwrK7HpANQcSYmD
	K26wTGAUm4Vk9Swkq2chWT0LyYoFjCyrGEVTC5ILipPSiwz1ihNzi0vz0vWS83M3MUKiq3cH
	4+0D1ocYk4HWT2SWEk3OB0ZnXkm8obGZkYWpiamxkbmlGWnCSuK8ai3WgUIC6YklqdmpqQWp
	RfFFpTmpxYcYmTg4pRoYd76YvXp3KrOea9qCCSYuvseMQ7zvhkxdsb1ocWvmgia1owoTX+v5
	SgqJH7JZ8/TWCanjCnYOGaaFRV98plZ9kFh0f5uGYqaF/u/uiwur1ktLCs1t4jglsUqmn/nx
	wYbK0jlq+/jEM45zeO9YOSP3tLrf7KXJLoLzG+dI+s+w9ZkSKaJR9W+pEktxRqKhFnNRcSIA
	4eQvKMQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupnleLIzCtJLcpLzFFi42I5/e+xoG6mqHCQwfSLUhaXF15itbj/9Sij
	xeVdc9gsTnezOrB43Lm2h81j3slAj74tqxg9Pm+SC2CJamC0yUhNTEktUkjNS85PycxLt1Xy
	Do53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ0HXLzAHaqKRQlphTChQKSCwuVtK3wzQhNMRN1wKm
	MULXNyQIrsfIAA0krGPM2PBwMUvBJM6KXYc2MzUwHmTvYuTkkBAwkXi+ay2ULSZx4d56ti5G
	Lg4hgemMEl3b/7KAJIQEfjFKrGwWALHZBNQkvnw5DNTAwSEi4CfRsAKsl1nASeLnlplg5cIC
	FhIflh0Cs1kEVCWePbvOClLOK2ApMfMGB0iYV0BQ4sfkeywQrVoS63ceZ4Kw5SU2r3nLDHGO
	gsSOs68ZQWwRAT2JuzuWsUHUiEjse/GOcQKjwCwko2YhGTULyahZSFoWMLKsYhRNLUguKE5K
	zzXSK07MLS7NS9dLzs/dxAiO3mfSOxhXNVgcYhTgYFTi4e1QEgoSYk0sK67MPcQowcGsJMLr
	8h8oxJuSWFmVWpQfX1Sak1p8iDEZ6NGJzFKiyfnAxJJXEm9obGJmZGlkZmFkYm5OmrCSOO/B
	VutAIYH0xJLU7NTUgtQimC1MHJxSDYzz8juYpCbfsJlnon9G5mdI2uf/6f9t+70eXDmgnJP0
	6eqv36KhYllRzjdmV12+voZFeFGCwtX2HQardt8MTuB+8+WDS6Bbi5g0p6xNenPdlX+XxcLt
	Gsq/xx5g5y4/P+9swYKp/Vev1c//cu3pMomK19pBtw6+n3xRQHNuUarbd+G2X5pNqZuVWIoz
	Eg21mIuKEwFEcACBIgMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/wl1273-core.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/mfd/wl1273-core.c b/drivers/mfd/wl1273-core.c
index 1288e99..f7c52d9 100644
--- a/drivers/mfd/wl1273-core.c
+++ b/drivers/mfd/wl1273-core.c
@@ -172,12 +172,9 @@ static int wl1273_fm_set_volume(struct wl1273_core *core, unsigned int volume)
 
 static int wl1273_core_remove(struct i2c_client *client)
 {
-	struct wl1273_core *core = i2c_get_clientdata(client);
-
 	dev_dbg(&client->dev, "%s\n", __func__);
 
 	mfd_remove_devices(&client->dev);
-	kfree(core);
 
 	return 0;
 }
@@ -203,7 +200,7 @@ static int wl1273_core_probe(struct i2c_client *client,
 		return -EINVAL;
 	}
 
-	core = kzalloc(sizeof(*core), GFP_KERNEL);
+	core = devm_kzalloc(&client->dev, sizeof(*core), GFP_KERNEL);
 	if (!core)
 		return -ENOMEM;
 
@@ -249,7 +246,6 @@ static int wl1273_core_probe(struct i2c_client *client,
 
 err:
 	pdata->free_resources();
-	kfree(core);
 
 	dev_dbg(&client->dev, "%s\n", __func__);
 
-- 
1.7.10.4


