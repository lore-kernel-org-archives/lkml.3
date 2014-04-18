Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaDRAdr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:33:47 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751504AbaDRAcm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:42 -0400
X-AuditID: cbfee690-b7f266d00000287c-99-535072a54c58
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 6/8] extcon: max8997: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:38 +0900
Message-id: <1397781160-744-7-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrPLMWRmVeSWpSXmKPExsWyRsSkRHdpUUCwwap7lhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MpYuncba8E2
	rooD01tYGxi/cHQxcnJICJhILLo0hxHCFpO4cG89WxcjF4eQwFJGiVlTZ7PBFLVvO8MCYgsJ
	LGKUuHwrGqKojUli/7PTzCAJNgFdiScHLoPZIgLBEh0njzOBFDELLGGU+HfyFtgkYQE3ial7
	JrN3MXJwsAioSvxYqwYS5gUKr578jgUkLCGgIDFnkg1ImFPAXWLWrp1MEHvdJJ5vmcoIMlJC
	4DebxIrbE8B2sQgISHybfAiqV1Zi0wFmiJslJQ6uuMEygVF4ASPDKkbR1ILkguKk9CITveLE
	3OLSvHS95PzcTYzAwD3979mEHYz3DlgfYkwGGjeRWUo0OR8Y+Hkl8YbGZkYWpiamxkbmlmak
	CSuJ86o9SgoSEkhPLEnNTk0tSC2KLyrNSS0+xMjEwSnVwGjQld9kePHJ/ovOPzQ6X3U/U0kU
	nep2scdroeucSzWzpnsc2rqXtUT7lZp5ftskg83FXvtXhLx8rrVK16byZjf79ie3QnjE9rA8
	+cd76PWJLZp33FVfKdvlxW39+9A8dsIBYb9OFqGary9DlkVo3c4//XYyk4O9yw3d9BVc3KEJ
	+i5mqk/W71FiKc5INNRiLipOBAAa1fWycgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBptmG1lc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY+nebawF27gqDkxvYW1g/MLRxcjJISFgItG+7QwLhC0mceHeejYQ
	W0hgEaPE5VvRXYxcQHYbk8T+Z6eZQRJsAroSTw5cBrNFBIIlOk4eZwIpYhZYwijx7+QtsG5h
	ATeJqXsms3cxcnCwCKhK/FirBhLmBQqvnvyOBSQsIaAgMWeSDUiYU8BdYtaunUwQe90knm+Z
	yjiBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4eCa1g3Flg8UhRgEORiUeXgG9
	gGAh1sSy4srcQ4wSHMxKIrzn04BCvCmJlVWpRfnxRaU5qcWHGJOBbprILCWanA+M2bySeENj
	EzMjSyNzQwsjY3PShJXEeQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYOy8HlmcK/0xuf3y+Rvc
	F6W/Fn+aumVj7qzjcrpTzZZwlt+4kL5+7r9TBeGCOyqXOcfKBgrO35jUWPls3petlUd7txYb
	fYxs09IQD2CLmDSntND7n43Sa6eYc+6c0w3PLsr2t/rzhOPwBR+2sKCP58sY3iU/aXOYw522
	plvPwOZXH5uvpve6tUosxRmJhlrMRcWJAPiAgoDPAgAA
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

