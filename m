Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760959AbaEMK7Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:59:16 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59978 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760551AbaEMK7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:59:04 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-7e-5371faf7ed65
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 15/16] mfd: max77693: Make of_device_id array const
Date: Tue, 13 May 2014 12:58:52 +0200
Message-id: <1399978733-13662-15-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEJMWRmVeSWpSXmKPExsVy+t/xy7rffxUGG+ybxGtx/ctzVovXLwwt
	7n89ymhxedccNovT3awOrB53ru1h85h3MtCjb8sqRo/Pm+QCWKK4bFJSczLLUov07RK4Mhbt
	OM1ccIK1YtOtNpYGxgssXYycHBICJhL3Jj9khrDFJC7cW8/WxcjFISSwlFFi6oP1YAkhgT4m
	iTd9YDabgLHE5uVL2EBsEYEsiR/TVoMNYhaIlJi+6xpYjbCAs8S5PSsZuxg5OFgEVCX6NkWC
	hHkFPCTa7kxmgtglJ3Hy2GRWEJsTKP7i9llWiFXuEjdWTWKZwMi7gJFhFaNoamlyQXFSeq6R
	XnFibnFpXrpecn7uJkZIuHzdwbj0mNUhRgEORiUeXg/mgmAh1sSy4srcQ4wSHMxKIrzunwqD
	hXhTEiurUovy44tKc1KLDzEycXBKNTCmn/27/FT5fb7zxx71flLjKTyg2ZEj4zR9X8Ahg1fh
	HV+5Xlg+8NO/5/KlX10oaX/LwoVr9t7mMjityJfMuDht4i5HzTN7b2ybuPK7pParlFTrb4Lr
	akyKb9XV/7hh+vJqRNIE5Zs8T/T2dB4OS40+686/MiJXne/3zmbjn6Gce98+Pz67NMZfiaU4
	I9FQi7moOBEANTw6nPUBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Array of struct of_device_id may be be const as expected by
of_match_table field.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
---
 drivers/mfd/max77693.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/max77693.c b/drivers/mfd/max77693.c
index c5535f018466..7e05428c756d 100644
--- a/drivers/mfd/max77693.c
+++ b/drivers/mfd/max77693.c
@@ -243,7 +243,7 @@ static const struct dev_pm_ops max77693_pm = {
 };
 
 #ifdef CONFIG_OF
-static struct of_device_id max77693_dt_match[] = {
+static const struct of_device_id max77693_dt_match[] = {
 	{ .compatible = "maxim,max77693" },
 	{},
 };
-- 
1.9.1

