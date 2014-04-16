Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755539AbaDPKau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:30:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:10656 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755304AbaDPK1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:27:07 -0400
X-AuditID: cbfee68e-b7f566d000002344-a8-534e5afae9bf
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>
Subject: [PATCH 5/8] extcon: max77693: Use devm_extcon_dev_register()
Date: Wed, 16 Apr 2014 19:27:00 +0900
Message-id: <1397644023-32516-6-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
References: <1397644023-32516-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrKLMWRmVeSWpSXmKPExsWyRsSkSPdXlF+wwZcpehbXvzxntbi8aw6b
	xe3GFWwWC/aUOLB49G1ZxejxeZNcAFMUl01Kak5mWWqRvl0CV8blhU8YC7bwVXRdX83ewDiR
	p4uRk0NCwETi5qQPLBC2mMSFe+vZQGwhgaWMEsc3JcHUrJxzlqmLkQsovohRYvXVhWwQThuT
	xPoVPYwgVWwCuhJPDlxmBrFFBIIlOk4eZwKxmQU8JeZO7gKbKizgKvFg5392EJtFQFVi44E3
	YJt5BTwk1jdvBYpzAG1TkJgzyQYkzAnUuvnVN2aQsBBQyb2vZiBrJQTes0ncXvyFBWKMgMS3
	yYdYIFplJTYdYIa4WVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtIrTswtLs1L10vOz93ECAzS
	0/+e9e1gvHnA+hBjMtC4icxSosn5wCDPK4k3NDYzsjA1MTU2Mrc0I01YSZx30cOkICGB9MSS
	1OzU1ILUovii0pzU4kOMTBycUg2MxjwTWest+JcaV83WZRAqDEowKD68hP0Vy22Bj5y/z+5J
	s/v6+8eVE+5tUXNFfs2f/eH3nrYy3d/blBZueXk2XOyvRZvDElnWXwvYt7friGZxqInVb1bb
	ce7s1YUH1aIjts08s9FTcwnjtGlLxL02bz0TP9Wt5OPGTievd5tWXizLtOc/ad7yUYmlOCPR
	UIu5qDgRADU5CPpoAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsVy+t9jAd1fUX7BBlcuqllc//Kc1eLyrjls
	FrcbV7BZLNhT4sDi0bdlFaPH501yAUxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6
	hpYW5koKeYm5qbZKLj4Bum6ZOUCLlBTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZ
	oIGENYwZlxc+YSzYwlfRdX01ewPjRJ4uRk4OCQETiZVzzjJB2GISF+6tZ+ti5OIQEljEKLH6
	6kIop41JYv2KHkaQKjYBXYknBy4zg9giAsESHSePg3UzC3hKzJ3cxQZiCwu4SjzY+Z8dxGYR
	UJXYeOANC4jNK+Ahsb55K1CcA2ibgsScSTYgYU6g1s2vvjGDhIWASu59NZvAyLuAkWEVo2hq
	QXJBcVJ6rpFecWJucWleul5yfu4mRnAUPJPewbiqweIQowAHoxIP78wc32Ah1sSy4srcQ4wS
	HMxKIryNkX7BQrwpiZVVqUX58UWlOanFhxiTgW6ayCwlmpwPjNC8knhDYxMzI0sjc0MLI2Nz
	0oSVxHkPtloHCgmkJ5akZqemFqQWwWxh4uCUamDUTXktcOFJVEirsuYmF6Mgbc69AQ+Xya6+
	ckT3wNul5r9/s9x7nNt8u8jIollBd7WGkUXLccd7lh3rXr0qfWpjt3Tqtq4l7ZJc74p8txzo
	n3Kb3+jzKqc/VhsVZtSmV+q7+zI8Vk+p3Da5ZPGrTZ6zOf7FLXRdnLN+0yzfOy0hPz841Z79
	on9QiaU4I9FQi7moOBEAEk16gcYCAAA=
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

