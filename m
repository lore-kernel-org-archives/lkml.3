Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351AbaDRAeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:34:17 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30892 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389AbaDRAck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:40 -0400
X-AuditID: cbfee68e-b7f566d000002344-40-535072a5c153
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 4/8] extcon: max14577: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:36 +0900
Message-id: <1397781160-744-5-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrILMWRmVeSWpSXmKPExsWyRsSkQHdpUUCwwd8FRhbXvzxntXj9wtDi
	8q45bBa3G1ewWSzYU2IxY/JLNgc2j74tqxg9Pm+SC2CK4rJJSc3JLEst0rdL4Mo41D+BreA+
	X8W8w8fZGxg38XQxcnJICJhInOj6zAhhi0lcuLeerYuRi0NIYCmjxOmGaUwwRTdX7GGHSCxi
	lOjuugzltDFJ7H92mhmkik1AV+LJgctgtohAsETHyeNMIEXMAksYJf6dvMUGkhAWcJeY2LmA
	HcRmEVCVaL7wGqyBV8BN4trRp6xdjBxA6xQk5kyyAQlzApXP2rUT7AohoJLnW6YygsyUEPjP
	JvF+7xcmiDkCEt8mH2KB6JWV2HSAGeJqSYmDK26wTGAUXsDIsIpRNLUguaA4Kb3ISK84Mbe4
	NC9dLzk/dxMjMHhP/3vWt4Px5gHrQ4zJQOMmMkuJJucDgz+vJN7Q2MzIwtTE1NjI3NKMNGEl
	cd5FD5OChATSE0tSs1NTC1KL4otKc1KLDzEycXBKNTB2L5VYl7755fTG6ogFLA+e/Tvx72eZ
	1PKHva5zlwkye9sLVVozVb95d+mMye41D34xrw57Iif+Q97WvPss47l5LP9vqH+aqCV1xfjg
	0iXbmi9vf7/i/ZvYlCA/zXN+9a+sl06/EcQ6zfbYgr4LIjo1VTKqhz6wye5rqzVu+2cv0CHf
	uPK9k2W4EktxRqKhFnNRcSIAGo3n0HQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBmfeaVlc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYx41D/BLaC+3wV8w4fZ29g3MTTxcjJISFgInFzxR52CFtM4sK99Wxd
	jFwcQgKLGCW6uy6zQzhtTBL7n51mBqliE9CVeHLgMpgtIhAs0XHyOBNIEbPAEkaJfydvsYEk
	hAXcJSZ2LgAbyyKgKtF84TVYA6+Am8S1o09Zuxg5gNYpSMyZZAMS5gQqn7VrJxOILQRU8nzL
	VMYJjLwLGBlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgTHxjPpHYyrGiwOMQpwMCrx8F74
	6h8sxJpYVlyZe4hRgoNZSYT3fFpAsBBvSmJlVWpRfnxRaU5q8SHGZKCjJjJLiSbnA+M2ryTe
	0NjEzMjSyNzQwsjYnDRhJXHeg63WgUIC6YklqdmpqQWpRTBbmDg4pRoYowTE+PgXuty2EOcv
	cClnjjv3ZVt0URQz/9aHG0/5nr/TMrfPffGZX0eC0qSm/VY+v9fgISfTu4oJBTsfVmbeeurF
	cFFC/pbanGlcmZKFs84cVdae7KAmxbXsWkiM1sQ92fzrH3bOntnszxN39kHeug+SB8S4J1y7
	w98paWnYECBTvn7q06kSSizFGYmGWsxFxYkAh+kGCdECAAA=
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

