Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaFBGas (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 02:30:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:43871 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752238AbaFBGar (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 02:30:47 -0400
X-AuditID: cbfee690-b7fb56d000003439-06-538c1a14fb22
From: Jingoo Han <jg1.han@samsung.com>
To: "'Mark Brown'" <broonie@kernel.org>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Balaji T K'" <balajitk@ti.com>
References: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
In-reply-to: <000101cf7e2b$b5c9f9c0$215ded40$%han@samsung.com>
Subject: [PATCH 3/3] regulator: pbias: remove unnecessary OOM messages
Date: Mon, 02 Jun 2014 15:30:44 +0900
Message-id: <000301cf7e2c$2ec50b80$8c4f2280$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9+K7WAMnl298jeROKabyh9CsMnMAAAF7Lw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKIsWRmVeSWpSXmKPExsVy+t8zfV0RqZ5gg/eb9CymTt7OZjH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8fxG9uZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2PrgE1NBG3vFo6/PmBoYP7B2MXJwSAiYSHy/a9DFyAlkiklcuLeeDcQWEljGKPH4
	dTBE3ETiyZu7QOVcQPHpjBJtq3tYIJzfjBLfJ35lBKliE1CT+PLlMDvIUBEBVYn/r9xBapgF
	ehklDi3byggx1VZi88Ir7CA2p4CdxMT7l5hAbGEBN4mZnYfB4ixAvRMfvmMBmcMLVD/5gDdI
	mFdAUOLH5HssIDazgJbE+p3HmSBseYnNa94yQ/yiLvHory5IWETASKK74QlUuYjEvhfvGEHO
	kRB4xC5xZttNFohVAhLfJh9igeiVldh0gBniX0mJgytusExglJiFZPMsJJtnIdk8C8mKBYws
	qxhFUwuSC4qT0otM9IoTc4tL89L1kvNzNzFConTCDsZ7B6wPMSYDrZ/ILCWanA+M8rySeENj
	MyMLUxNTYyNzSzPShJXEedUeJQUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYJx6y69MYcHt
	imuPF0kXRKnNnp67oKj1Y9/y25vqP2XvXWPE1LRSvVgkesMhtzd9XaoHfVY0nHz9tjdr3pu/
	FzRVdt7Ovrwv2vawv77OMb2Fd8/M7QjJaLLcvmj7zO/f7KTu/FKYbSi1rpf959rEfw4z+ngX
	zgvyjW7Off6c6cW5UusrPe5LX9opsRRnJBpqMRcVJwIANwbqxegCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQV0RqZ5ggz37tCymTt7OZjH14RM2
	i8sLL7FafLvSwWRxedccNgdWj52z7rJ7bFrVyebRt2UVo8fxG9uZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNj64BNTQRt7xaOvz5gaGD+wdjFyckgImEg8
	eXMXyhaTuHBvPVsXIxeHkMB0Rom21T0sEM5vRonvE78yglSxCahJfPlymL2LkYNDREBV4v8r
	d5AaZoFeRolDy7aC1QgJ2EpsXniFHcTmFLCTmHj/EhOILSzgJjGz8zBYnAWod+LDdywgc3iB
	6icf8AYJ8woISvyYfI8FxGYW0JJYv/M4E4QtL7F5zVtmkHIJAXWJR391QcIiAkYS3Q1PoMpF
	JPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGukVJ+YWl+al6yXn525iBKeB
	Z9I7GFc1WBxiFOBgVOLhvdDbFSzEmlhWXJl7iFGCg1lJhPfo2e5gId6UxMqq1KL8+KLSnNTi
	Q4zJQH9OZJYSTc4Hpqi8knhDYxMzI0sjMwsjE3Nz0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh
	4uCUamA0WjRrnerCPwp57w99y7Hf+MnlmHnQjGdtGss23tlXGG31/NGUb5+K+9guTGP7czPH
	dD3Pc8WIrDbN6gMyX2+az3G2E674L+l28XirwaUnbVd3fWkIuZ7weNm28zU/hEKkRTlsP/C8
	n1sqkK7EembpC6/cxurl2ueW/Zyh5rjm6s3LMu+iD3zqUmIpzkg01GIuKk4EAF+PKeNHAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The site-specific OOM messages are unnecessary, because they
duplicate the MM subsystem generic OOM message.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/regulator/pbias-regulator.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/pbias-regulator.c b/drivers/regulator/pbias-regulator.c
index 708ddbb..6d02d68 100644
--- a/drivers/regulator/pbias-regulator.c
+++ b/drivers/regulator/pbias-regulator.c
@@ -122,10 +122,8 @@ static int pbias_regulator_probe(struct platform_device *pdev)
 
 	drvdata = devm_kzalloc(&pdev->dev, sizeof(struct pbias_regulator_data)
 			       * count, GFP_KERNEL);
-	if (drvdata == NULL) {
-		dev_err(&pdev->dev, "Failed to allocate device data\n");
+	if (!drvdata)
 		return -ENOMEM;
-	}
 
 	syscon = syscon_regmap_lookup_by_phandle(np, "syscon");
 	if (IS_ERR(syscon))
-- 
1.7.10.4


