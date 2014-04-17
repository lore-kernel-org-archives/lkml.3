Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161305AbaDQKKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 06:10:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28855 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161171AbaDQKKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 06:10:07 -0400
X-AuditID: cbfee690-b7f266d00000287c-e6-534fa87af677
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv2 5/8] extcon: max77693: Use devm_extcon_dev_register()
Date: Thu, 17 Apr 2014 19:10:00 +0900
Message-id: <1397729403-32045-6-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
References: <1397729403-32045-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWyRsSkSLdqhX+wwf5V5hbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mo4fl6v4ANf
	RdOvH+wNjCd4uhg5OSQETCR2XZ/LDmGLSVy4t56ti5GLQ0hgKaNE07VDbDBFZ7cdASsSEpjO
	KDHrYgREURuTxJ+105hBEmwCuhJPDlwGs0UEgiU6Th5nAiliFljCKPHv5C2wScIC7hJHe7+w
	gtgsAqoS3ctfsXQxcnDwCnhIXNldDGJKCChIzJlkA1LBKeApsWfrWUaIvR4SW5fdYAUZKSHw
	m03i3NLH7BBjBCS+TT7EAtErK7HpADPEzZISB1fcYJnAKLyAkWEVo2hqQXJBcVJ6kYlecWJu
	cWleul5yfu4mRmDYnv73bMIOxnsHrA8xJgONm8gsJZqcDwz7vJJ4Q2MzIwtTE1NjI3NLM9KE
	lcR51R4lBQkJpCeWpGanphakFsUXleakFh9iZOLglGpg7PBd+c4usK5x2iqBFgejmJS3oo8C
	vFe80kp6t+tt5WWrGYsP7n5YsuDS580+xh/vlPzKrNj2MNuA4fc8482i5Qrar47l7VrExjbp
	5ernhtkv92Xdlz/Flyy9bqtMmqee2/yED6x/BHVXKm2adurze+dV2RbZt2dLPt5zTI85KVS2
	6xx3wuLmUiWW4oxEQy3mouJEALxHJRRxAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jQd2qFf7BBhMu6Ftc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx4/h5vYIPfBVNv36wNzCe4Oli5OSQEDCROLvtCDuELSZx4d56NhBb
	SGA6o8SsixFdjFxAdhuTxJ+105hBEmwCuhJPDlwGs0UEgiU6Th5nAiliFljCKPHv5C2wbmEB
	d4mjvV9YQWwWAVWJ7uWvWLoYOTh4BTwkruwuBjElBBQk5kyyAangFPCU2LP1LCPEXg+Jrctu
	sE5g5F3AyLCKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzgqnknvYFzVYHGIUYCDUYmHl/O3
	X7AQa2JZcWXuIUYJDmYlEV4JYEwJ8aYkVlalFuXHF5XmpBYfYkwGumkis5Rocj4wYvNK4g2N
	TcyMLI3MDS2MjM1JE1YS5z3Yah0oJJCeWJKanZpakFoEs4WJg1OqgbG1L5h3ZtkFu1dye199
	vxy4ZXLfk/zwCr11CkmKTMk3pcz3ts0y3PKl5qdT+x71j248cix995YpWczMW+x7YI9Wkgy/
	7j6NaIm75b6/lT5Is/FfFXSvmyOlribL6Pc3d85zi7qZfn18BaffmE7aLSGXGVpT8TB4Z/PU
	qxF7r4blXgrjO7DfQ4mlOCPRUIu5qDgRAJw1vZLOAgAA
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

