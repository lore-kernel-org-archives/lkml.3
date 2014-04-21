Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289AbaDUKM2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 06:12:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10471 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751824AbaDUKKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 06:10:21 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-d8-5354ee89bb81
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv4 6/8] extcon: max8997: Use devm_extcon_dev_register()
Date: Mon, 21 Apr 2014 19:10:13 +0900
Message-id: <1398075015-19211-7-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
References: <1398075015-19211-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkRLfzXUiwwdL3UhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4MpYuncba8E2
	rooD01tYGxi/cHQxcnJICJhIHJ9+jgnCFpO4cG89G4gtJLCUUaLzUyJMzZ1H74DiXEDxRYwS
	R7bcYYFw2pgkrq0/CdbBJqAr8eTAZWYQW0QgWKLj5HEmkCJmgSWMEv9O3gIq4uAQFnCTeDvV
	FaSGRUBV4tSk1YwgYV4BD4lnS2JBTAkBBYk5k2xAKjgFPCUWTV3ICHGPh8TpT/OZIe75zyYx
	6XM6xBQBiW+TD7FAtMpKbDoAVSIpcXDFDZYJjMILGBlWMYqmFiQXFCelF5nqFSfmFpfmpesl
	5+duYgQG7el/zybuYLx/wPoQYzLQuInMUqLJ+cCgzyuJNzQ2M7IwNTE1NjK3NCNNWEmcN/1R
	UpCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGxsgTwje1n8TWpx7lDC1+vN1Cd4u/eMfmVWYX
	HD1nq9vuTZ2ssrfekfWk18VcpWteqXc22YZsO9UsccIk9tjCIJbn62VmczkFGMvcTK7c8fZl
	lciusrVttmkmqav+Tzi+bdfpM5fkH/qwM7Hu7uWx+Cff12biXLbIhznW3/lnRK6175EpP74d
	VGIpzkg01GIuKk4EAA4Qe+JwAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsVy+t9jAd3OdyHBBrueCVtc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY+nebawF27gqDkxvYW1g/MLRxcjJISFgInHn0Ts2CFtM4sK99UA2
	F4eQwCJGiSNb7rBAOG1MEtfWnwSrYhPQlXhy4DIziC0iECzRcfI4E0gRs8ASRol/J28BFXFw
	CAu4Sbyd6gpSwyKgKnFq0mpGkDCvgIfEsyWxIKaEgILEnEk2IBWcAp4Si6YuZASxhYAqTn+a
	zzyBkXcBI8MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOC4eCa1g3Flg8UhRgEORiUe3hkl
	IcFCrIllxZW5hxglOJiVRHgj1gOFeFMSK6tSi/Lji0pzUosPMSYD3TSRWUo0OR8Ys3kl8YbG
	JmZGlkbmhhZGxuakCSuJ8x5otQ4UEkhPLEnNTk0tSC2C2cLEwSnVwHg4cJ34Yvn27+I6t7QY
	3/8onqcqy35Gyj9ym0jJPOUrT+3sXyr/E3jjeeP7u/x334023O3ujAqc6pV54tTWOMmTM3Xu
	CGxZzynOd4Dvd8yBr7Of1YQlr/j4Zrdh3hkn+W7+A+KTuPacXdqwmo+V+aWOBEPJl6L394xz
	N8iqLQlOW37Uf3bX7Z9KLMUZiYZazEXFiQC6R9Q7zwIAAA==
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

