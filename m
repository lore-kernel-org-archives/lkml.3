Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475AbaDPK1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:27:39 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:12501 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307AbaDPK1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:08 -0400
X-AuditID: cbfee690-b7f266d00000287c-23-534e5af87cae
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 4/8] extcon: max14577: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:26:59 +0900
Message-id: <1397644023-32516-5-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkWPdHlF+wwfydFhbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8bs85OYCxbzVfxoa2NsYPzN
	3cXIySEhYCKxZsosJghbTOLCvfVsXYxcHEICSxkl5nQvZoQp2jN9GjNEYhGjxLYv/9ghnDYm
	ifMb97KAVLEJ6Eo8OXCZGcQWEQiW6Dh5HGwss4CnxNzJXWwgtrCAq8TKnXeB4hwcLAKqEjM6
	rEHCvAIeEg1fbrOChCUEFCTmTLIBCXMCdW5+9Y0ZJCwEVHLvqxnIVgmB92wSV/+3sYLUsAgI
	SHybfIgFolVWYtMBZoiTJSUOrrjBMoFReAEjwypG0dSC5ILipPQiE73ixNzi0rx0veT83E2M
	wCA9/e/ZhB2M9w5YH2JMBho3kVlKNDkfGOR5JfGGxmZGFqYmpsZG5pZmpAkrifOqPUoKEhJI
	TyxJzU5NLUgtii8qzUktPsTIxMEp1cDY8agyVCD+56Uni1erFnhxldc9sCwyN/umY1bf+XCZ
	0oGldmucGCYHv5rJ4OivHFJWdj5PrVBS5Yhtcbz+XbE7k9Yu/PE5U+Ebu38XW8ktQbeIe5Xn
	LGOqXs11tH7U7u9a4DjnS2uG0pYwtnVC/w/csOBg0ldZPimuMPNW2tW4PSLnbITtO5RYijMS
	DbWYi4oTAUKg2qBoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t9jAd0fUX7BBoeaDS2uf3nOanF51xw2
	i9uNK9gsFuwpcWDx6NuyitHj8ya5AKaoBkabjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0Nd
	Q0sLcyWFvMTcVFslF58AXbfMHKBFSgpliTmlQKGAxOJiJX07TBNCQ9x0LWAaI3R9Q4LgeowM
	0EDCGsaM2ecnMRcs5qv40dbG2MD4m7uLkZNDQsBEYs/0acwQtpjEhXvr2boYuTiEBBYxSmz7
	8o8dwmljkji/cS8LSBWbgK7EkwOXwTpEBIIlOk4eZwKxmQU8JeZO7mIDsYUFXCVW7rwLFOfg
	YBFQlZjRYQ0S5hXwkGj4cpsVJCwhoCAxZ5INSJgTqHPzq2/MIGEhoJJ7X80mMPIuYGRYxSia
	WpBcUJyUnmukV5yYW1yal66XnJ+7iREcA8+kdzCuarA4xCjAwajEwzszxzdYiDWxrLgy9xCj
	BAezkghvY6RfsBBvSmJlVWpRfnxRaU5q8SHGZKCTJjJLiSbnA+MzryTe0NjEzMjSyNzQwsjY
	nDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYQ7R3az9JF9rlfL1kz6PXS62uCEw3qK3I
	lmS2Dm8q71h4+al6oMgd1VmfzGabK2z8xfNE2PHnAnv3BXqzjCvVvu34nW7z0/L6zPT7ruuL
	fPW0ovl2LXzaFBNZHbE/t+XD3amRccUG6Tfs6ran8PI5Pbo0ayrD9KutsXcYl/n/1FvJ33C6
	3M9HiaU4I9FQi7moOBEAt5qYYsUCAAA=
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
---
 drivers/extcon/extcon-max14577.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/extcon/extcon-max14577.c b/drivers/extcon/extcon-max14577.c
index 1fef08d..c6166e7 100644
--- a/drivers/extcon/extcon-max14577.c
+++ b/drivers/extcon/extcon-max14577.c
@@ -675,7 +675,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 	}
 	info->edev->name = DEV_NAME;
 	info->edev->supported_cable = max14577_extcon_cable;
-	ret = extcon_dev_register(info->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, info->edev);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to register extcon device\n");
 		return ret;
@@ -694,7 +694,7 @@ static int max14577_muic_probe(struct platform_device *pdev)
 			MAX14577_REG_DEVICEID, &id);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to read revision number\n");
-		goto err_extcon;
+		return ret;
 	}
 	dev_info(info->dev, "device ID : 0x%x\n", id);
 
@@ -714,10 +714,6 @@ static int max14577_muic_probe(struct platform_device *pdev)
 			delay_jiffies);
 
 	return ret;
-
-err_extcon:
-	extcon_dev_unregister(info->edev);
-	return ret;
 }
 
 static int max14577_muic_remove(struct platform_device *pdev)
@@ -725,7 +721,6 @@ static int max14577_muic_remove(struct platform_device *pdev)
 	struct max14577_muic_info *info = platform_get_drvdata(pdev);
 
 	cancel_work_sync(&info->irq_work);
-	extcon_dev_unregister(info->edev);
 
 	return 0;
 }
-- 
1.7.9.5

