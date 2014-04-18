Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480AbaDRAeu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 20:34:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43991 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaDRAck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 20:32:40 -0400
X-AuditID: cbfee690-b7f266d00000287c-98-535072a573b7
From: Sangjung Woo <sangjung.woo@samsung.com>
To: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, Sangjung Woo <sangjung.woo@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>
Subject: [PATCHv3 3/8] extcon: gpio: Use devm_extcon_dev_register()
Date: Fri, 18 Apr 2014 09:32:35 +0900
Message-id: <1397781160-744-4-git-send-email-sangjung.woo@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
References: <1397781160-744-1-git-send-email-sangjung.woo@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWyRsSkSHdpUUCwQedLI4vrX56zWrx+YWhx
	edccNovbjSvYLBbsKbGYMfklmwObR9+WVYwenzfJBTBFcdmkpOZklqUW6dslcGVsWzqJseAV
	X8X2xqgGxoU8XYwcHBICJhKvWoq7GDmBTDGJC/fWs3UxcnEICSxllGg+28MMkTCRWPxtMztE
	YhGjxNTvxxghnDYmif3PToNVsQnoSjw5cBnMFhEIlug4eZwJpIhZYAmjxL+Tt9hA1gkLOEv8
	X1kJUsMioCpx6+UOsDCvgJvEzNvGEAcpSMyZZANSwSngLjFr104mEFsIqOL5lqlgayUEfrNJ
	rL3/iQ1ijIDEt8mHWCB6ZSU2HYC6WVLi4IobLBMYhRcwMqxiFE0tSC4oTkovMtErTswtLs1L
	10vOz93ECAza0/+eTdjBeO+A9SHGZKBxE5mlRJPzgUGfVxJvaGxmZGFqYmpsZG5pRpqwkjiv
	2qOkICGB9MSS1OzU1ILUovii0pzU4kOMTBycUg2MKhkbxQ8Ja3iv7ne2DVrce73o7sKDqb/l
	507/Zr/mSYfl6pT2vV7XQ7v2HVjAM7W38o5NzLc0k83FBe+ebWGdf8wsrcAy71d98POfPf1C
	afLMR37UTK84+tHl+7+UzLUlIndjfknlfmYNLalrls6Mj/xWvmDS2el7l77vauO95pi3xFWI
	peyFEktxRqKhFnNRcSIAxtKCH3ACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNIsWRmVeSWpSXmKPExsVy+t9jAd2lRQHBBm++aFlc//Kc1eL1C0OL
	y7vmsFncblzBZrFgT4nFjMkv2RzYPPq2rGL0+LxJLoApqoHRJiM1MSW1SCE1Lzk/JTMv3VbJ
	OzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdoo5JCWWJOKVAoILG4WEnfDtOE0BA3XQuY
	xghd35AguB4jAzSQsIYxY9vSSYwFr/gqtjcCHbSQp4uRk0NCwERi8bfN7BC2mMSFe+vZuhi5
	OIQEFjFKTP1+jBHCaWOS2P/sNDNIFZuArsSTA5fBbBGBYImOk8eZQIqYBZYwSvw7eQuonYND
	WMBZ4v/KSpAaFgFViVsvd4CFeQXcJGbeNgYxJQQUJOZMsgGp4BRwl5i1aycTiC0EVPF8y1TG
	CYy8CxgZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER8UzqR2MKxssDjEKcDAq8fAK6AUE
	C7EmlhVX5h5ilOBgVhLhPZ8GFOJNSaysSi3Kjy8qzUktPsSYDHTTRGYp0eR8YMTmlcQbGpuY
	GVkamRtaGBmbkyasJM57oNU6UEggPbEkNTs1tSC1CGYLEwenVAOjg0ZgYMvey94mWhd2vfiu
	fjVos/z1C19vbpUOdjjQX2vbOU+a82xu0u45otHsbgX1+T80K25urIzbkLesZ+mTSxyHFAsV
	A/3W2q15sVWurW7fmc3rJBelL+O1WdQ549SSXjfVrD8d5S5C6dl/WWT/eR3s2R1VKCRpPyNT
	4d8XL1P1rsm/VdKVWIozEg21mIuKEwFAXTuazgIAAA==
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
 drivers/extcon/extcon-gpio.c |   16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/drivers/extcon/extcon-gpio.c b/drivers/extcon/extcon-gpio.c
index 13d5222..43af34c 100644
--- a/drivers/extcon/extcon-gpio.c
+++ b/drivers/extcon/extcon-gpio.c
@@ -121,34 +121,27 @@ static int gpio_extcon_probe(struct platform_device *pdev)
 				msecs_to_jiffies(pdata->debounce);
 	}
 
-	ret = extcon_dev_register(&extcon_data->edev);
+	ret = devm_extcon_dev_register(&pdev->dev, &extcon_data->edev);
 	if (ret < 0)
 		return ret;
 
 	INIT_DELAYED_WORK(&extcon_data->work, gpio_extcon_work);
 
 	extcon_data->irq = gpio_to_irq(extcon_data->gpio);
-	if (extcon_data->irq < 0) {
-		ret = extcon_data->irq;
-		goto err;
-	}
+	if (extcon_data->irq < 0)
+		return extcon_data->irq;
 
 	ret = request_any_context_irq(extcon_data->irq, gpio_irq_handler,
 				      pdata->irq_flags, pdev->name,
 				      extcon_data);
 	if (ret < 0)
-		goto err;
+		return ret;
 
 	platform_set_drvdata(pdev, extcon_data);
 	/* Perform initial detection */
 	gpio_extcon_work(&extcon_data->work.work);
 
 	return 0;
-
-err:
-	extcon_dev_unregister(&extcon_data->edev);
-
-	return ret;
 }
 
 static int gpio_extcon_remove(struct platform_device *pdev)
@@ -157,7 +150,6 @@ static int gpio_extcon_remove(struct platform_device *pdev)
 
 	cancel_delayed_work_sync(&extcon_data->work);
 	free_irq(extcon_data->irq, extcon_data);
-	extcon_dev_unregister(&extcon_data->edev);
 
 	return 0;
 }
-- 
1.7.9.5

