Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161442AbaDQKKj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:39 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63751 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161171AbaDQKKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:16 -0400
X-AuditID: cbfee690-b7f266d00000287c-e7-534fa87a1b5c
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 6/8] extcon: max8997: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:10:01 +0900
Message-id: <1397729403-32045-7-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkWLdqhX+wwYRL5hbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MpYuncba8E2
	rooD01tYGxi/cHQxcnJICJhInPu8gBXCFpO4cG89WxcjF4eQwFJGiYPT5rPCFE1+3cMMkZjO
	KNFw9g6U08Yk8WftNGaQKjYBXYknBy6D2SICwRIdJ48zgRQxCyxhlPh38hYbSEJYwE1i7uKj
	LCA2i4CqxO49u5lAbF4BD4m9C64ydjFyAK1TkJgzyQYkzCngKbFn61lGEFsIqGTrshusIDMl
	BP6zSTzasRFqjoDEt8mHWCB6ZSU2HWCGuFpS4uCKGywTGIUXMDKsYhRNLUguKE5KLzLRK07M
	LS7NS9dLzs/dxAgM3tP/nk3YwXjvgPUhxmSgcROZpUST84HBn1cSb2hsZmRhamJqbGRuaUaa
	sJI4r9qjpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjIra9ZznT/xcePDYesmwPdsn2LJV
	J90tOlPpMvvefdGp94+2pvB3K7ZYKZ6aHjin+666rv+jDy8u/FK4kauju/S3TdPc9wE6u1i0
	AuUXv2c9Ktze8nv17iv+OsenMb2Rq8gS+72K76ji9RcWR0WWn+8u1/rKvCCntTIwkWvyc835
	D6oPWs2Q0VBiKc5INNRiLipOBAAJUoORdAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBnvfG1hc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY+nebawF27gqDkxvYW1g/MLRxcjJISFgIjH5dQ8zhC0mceHeerYu
	Ri4OIYHpjBINZ+8wQzhtTBJ/1k4Dq2IT0JV4cuAymC0iECzRcfI4E0gRs8ASRol/J2+xgSSE
	Bdwk5i4+ygJiswioSuzes5sJxOYV8JDYu+AqYxcjB9A6BYk5k2xAwpwCnhJ7tp5lBLGFgEq2
	LrvBOoGRdwEjwypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4Nh4JrWDcWWDxSFGAQ5GJR7e
	Cer+wUKsiWXFlbmHGCU4mJVEeJf0AoV4UxIrq1KL8uOLSnNSiw8xJgMdNZFZSjQ5Hxi3eSXx
	hsYmZkaWRuaGFkbG5qQJK4nzHmi1DhQSSE8sSc1OTS1ILYLZwsTBKdXAeEmS08rV82jQgzev
	gi4s16qbtmbGpaOB+hfj66VfOEs/Ppo+07Vm5g47q3hRT5OYf6cKPHxiDP/M8+P61bf0tX32
	Vq6F8Vu+nfm8KNegeP7b7WJn5I9fV+Wcf7rEr/GW38k3nLfYn/Nvmbt6ZZ78EscAC8/TjpsP
	XVy6i3uWhqDC40mskv99tJRYijMSDbWYi4oTAfC8ojPRAgAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the resource-managed extcon device register function (i.e.
devm_extcon_dev_register()) instead of extcon_dev_register(). If extcon device
is attached with this function, that extcon device is automatically unregistered
on driver detach. That reduces tiresome managing code.

Signed-off-by: Sangjung Woo <sangjung.woo@samsung.com>
Reviewed-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/extcon/extcon-max8997.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/extcon/extcon-max8997.c b/drivers/extcon/extcon-max8997.c
index 223e6b0..804a446 100644
--- a/drivers/extcon/extcon-max8997.c
+++ b/drivers/extcon/extcon-max8997.c
@@ -709,7 +709,7 @@ static int max8997_muic_probe(struct platform_device *pdev)
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max8997_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
@@ -790,8 +790,6 @@ static int max8997_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 
-	extcon_dev_unregister(info->edev);
-
 	return 0;
 }
 
-- 
1.7.9.5

