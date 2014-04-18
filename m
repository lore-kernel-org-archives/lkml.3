Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaDRAeL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:34:11 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbaDRAcl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:41 -0400
X-AuditID: cbfee68e-b7f566d000002344-41-535072a547d4
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 5/8] extcon: max77693: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:37 +0900
Message-id: <1397781160-744-6-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWyRsSkUHdpUUCwwd/7lhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mo4fl6v4ANf
	RdOvH+wNjCd4uhg5OSQETCQ63q9kgrDFJC7cW8/WxcjFISSwlFHiwNat7DBFbW83QCUWMUpc
	WL8Iymljktj/7DQzSBWbgK7EkwOXwWwRgWCJjpPHmUCKmAWWMEr8O3mLDSQhLOAuMbHzApjN
	IqAqMeneXLAGXgE3if0nZzN2MXIArVOQmDPJBiTMCVQ+a9dOsPOEgEqeb5nKCDJTQuA3m8TX
	PefZIeYISHybfIgFoldWYtMBZoirJSUOrrjBMoFReAEjwypG0dSC5ILipPQiI73ixNzi0rx0
	veT83E2MwNA9/e9Z3w7GmwesDzEmA42byCwlmpwPDP28knhDYzMjC1MTU2Mjc0sz0oSVxHkX
	PUwKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cBobJHUbvOu7PKihOgGge3POV/NXpnnKCxq
	29XnWZOkVbKWL0suotXt6GSTH5e0Xfh/pF5UVf7uXsZcc1F57sVMGYeHx7g2My7O5xQ72iPL
	Ffr1YxK3ct8aHaXjdT2tPyviWPpq1Jj3lkutdytzaPCefW9rsEKK6RvDhf9YTm3vzmRa8nsa
	jxJLcUaioRZzUXEiAGdrZ5BzAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBj9nGVlc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4/h5vYIPfBVNv36wNzCe4Oli5OSQEDCRaHu7gQ3CFpO4cG89kM3F
	ISSwiFHiwvpFUE4bk8T+Z6eZQarYBHQlnhy4DGaLCARLdJw8zgRSxCywhFHi38lbYKOEBdwl
	JnZeALNZBFQlJt2bC9bAK+Amsf/kbMYuRg6gdQoScybZgIQ5gcpn7drJBGILAZU83zKVcQIj
	7wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwZHxTHoH46oGi0OMAhyMSjy8F776Bwux
	JpYVV+YeYpTgYFYS4T2fFhAsxJuSWFmVWpQfX1Sak1p8iDEZ6KiJzFKiyfnAqM0riTc0NjEz
	sjQyN7QwMjYnTVhJnPdgq3WgkEB6YklqdmpqQWoRzBYmDk6pBsYe45jaqplBOffmslzVunTA
	TfZVwuI9urlRPC2sdU6+pQ9N1tZubp/3VTP1y9x9Qdonr198U5oyISUts0WWzV5dNYfh1zaW
	XZ+LFDnCBHjdX1xd6Z32xY9j6clpjx5NZfyZkW2dIsDEYL7ecbugz5tI56tBHbusW3a9WdFR
	+XrfZ4WWQ1+SryixFGckGmoxFxUnAgB/7whj0AIAAA==
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
 drivers/extcon/extcon-max77693.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/extcon/extcon-max77693.c b/drivers/extcon/extcon-max77693.c
index 39cd095..f0f18e2 100644
--- a/drivers/extcon/extcon-max77693.c
+++ b/drivers/extcon/extcon-max77693.c
@@ -1185,7 +1185,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 	info->edev->name = DEV_NAME;
 	info->edev->dev.parent = &pdev->dev;
 	info->edev->supported_cable = max77693_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		goto err_irq;
@@ -1267,7 +1267,7 @@ static int max77693_muic_probe(struct platform_device *pdev)
 			MAX77693_MUIC_REG_ID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		goto err_irq;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -1288,8 +1288,6 @@ static int max77693_muic_probe(struct platform_device *pdev)
 
 	return ret;
 
-err_extcon:
-	extcon_dev_unregister(info->edev);
 err_irq:
 	while (--i >= 0)
 		free_irq(muic_irqs[i].virq, info);
@@ -1305,7 +1303,6 @@ static int max77693_muic_remove(struct platform_device *pdev)
 		free_irq(muic_irqs[i].virq, info);
 	cancel_work_sync(&info->irq_work);
 	input_unregister_device(info->dock);
-	extcon_dev_unregister(info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

