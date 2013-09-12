Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab3ILGj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:39:58 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:60283 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757714Ab3ILGj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:39:56 -0400
X-AuditID: cbfee68d-b7fe86d0000077a5-92-523161bbd6a6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "'Hans J. Koch'" <hjk@hansjkoch.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
In-reply-to: <001001ceaf82$978a36f0$c69ea4d0$%han@samsung.com>
Subject: [PATCH 5/5] uio: uio_sercos3: remove unnecessary pci_set_drvdata()
Date: Thu, 12 Sep 2013 15:39:55 +0900
Message-id: <001401ceaf82$e4b26970$ae173c50$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6vgpOjT534nRYfSDiuPQlOOHeZTQAADxmA
Content-language: ko
x-cr-hashedpuzzle: BpIF CfFn K6yQ NnXd PsRW TBSJ TKPA X8FP Zzf+ bbPA feDk lt6o
 mIGw osAI qnzy
 uVBR;4;ZwByAGUAZwBrAGgAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnADsAaABqAGsAQABoAGEAbgBzAGoAawBvAGMAaAAuAGQAZQA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnAA==;Sosha1_v1;7;{6E757F82-C2E4-4099-AD5D-9FB83E0964A7};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Thu,
 12 Sep 2013 06:39:48
 GMT;WwBQAEEAVABDAEgAIAA1AC8ANQBdACAAdQBpAG8AOgAgAHUAaQBvAF8AcwBlAHIAYwBvAHMAMwA6ACAAcgBlAG0AbwB2AGUAIAB1AG4AbgBlAGMAZQBzAHMAYQByAHkAIABwAGMAaQBfAHMAZQB0AF8AZAByAHYAZABhAHQAYQAoACkA
x-cr-puzzleid: {6E757F82-C2E4-4099-AD5D-9FB83E0964A7}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCIsWRmVeSWpSXmKPExsVy+t8zI93diYZBBifbtCyaF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJYrLJiU1J7MstUjfLoErY97yD0wF
	HWwVc46/YW5gbGbtYuTkkBAwkeh41soEYYtJXLi3nq2LkYtDSGAZo8Si+beBijjAit7sC4OI
	L2KU6J77kRXC+cUo8fzSd0aQbjYBNYkvXw6zg9giAqYSG99PAYszC2RLHPv+lwXEFhKwlXj/
	dQnYNk4BO4kpq04wg9jCAt4Sl/tWs4AsYxFQlTi8VRwkzAtUfmz1HhYIW1Dix+R7LBAjtSTW
	7zzOBGHLS2xe85YZ4k51iUd/dSEuMJLYdX4PVLmIxL4X7xhBTpYQmMMqcen3CmaIh00ljq/e
	xA6ReMkusW3Je7CbWQQEJL5NPsQCMVRWYtMBqHpJiYMrbrBMYJSaheSkWUhOmoXkpFlIdi9g
	ZFnFKJpakFxQnJReZKhXnJhbXJqXrpecn7uJERLDvTsYbx+wPsSYDLR+IrOUaHI+MAXklcQb
	GpsZWZiamBobmVuakSasJM6r1mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNTqoFxwbufjpe3
	ZjJ/T3x2RMBwjfed6qbqpakHzqzI2haSZhbmvvycSFp93D9mi/5ZURH7vmxzWSktHKWt/vRd
	dg9nsEzO6Zti7q2ZszUz5p+1eL6UQd3wfFrIgRmGf9ZvuJZ62OXkbOdjK2fvvvFt848lspM+
	Blw53cr+4dqLJx+u3NMoqjrZvjB8oxJLcUaioRZzUXEiAHGrRwH3AgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIKsWRmVeSWpSXmKPExsVy+t9jAd3diYZBBt1r1SyaF69nszh6djq7
	xeWFl1gtLu+aw+bA4jH/oZfH/rlr2D36tqxi9Pi8SS6AJaqB0SYjNTEltUghNS85PyUzL91W
	yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWPe8g9MBR1sFXOOv2FuYGxm7WLk4JAQMJF4sy+si5ETyBSTuHBv
	PVsXIxeHkMAiRonuuR9ZIZxfjBLPL31nBKliE1CT+PLlMDuILSJgKrHx/RSwOLNAtsSx739Z
	QGwhAVuJ91+XMIHYnAJ2ElNWnWAGsYUFvCUu961mAVnMIqAqcXirOEiYF6j82Oo9LBC2oMSP
	yfdYIEZqSazfeZwJwpaX2LzmLTPEzeoSj/7qQlxgJLHr/B6ochGJfS/eMYKcLCEwh1Xi0u8V
	zBCPmUocX72JfQKjyCwkK2YhWTELyYpZSGYtYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iRGcIJ5J7WBc2WBxiFGAg1GJh7djlkGQEGtiWXFl7iFGCQ5mJRHeeHPDICHelMTKqtSi/Pii
	0pzU4kOMycAAmMgsJZqcD0xeeSXxhsYmZkaWRmYWRibm5qQJK4nzHmi1DhQSSE8sSc1OTS1I
	LYLZwsTBKdXAaHbpzeu0J8Fng04c5uRJLLp8r2/PtT57V8kljrpL0wqa0+f+4/b7XSgdUZDN
	tfSosFv1w/VbHW6diesuTjz6WHex2rtNPa9j9jwS6zZRYinNPWevlrZE3CR5R9S0F28EYpwc
	ntdIKtds0Xbu/xtlLnFiweUrZX/fv7swMSlK3sQopG7KRIFMJZbijERDLeai4kQAOe/4hlQD	AAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure. Thus, it is not needed to manually clear the
device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/uio/uio_sercos3.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/uio/uio_sercos3.c b/drivers/uio/uio_sercos3.c
index 5419832..9cfdfca 100644
--- a/drivers/uio/uio_sercos3.c
+++ b/drivers/uio/uio_sercos3.c
@@ -188,7 +188,6 @@ static void sercos3_pci_remove(struct pci_dev *dev)
 	uio_unregister_device(info);
 	pci_release_regions(dev);
 	pci_disable_device(dev);
-	pci_set_drvdata(dev, NULL);
 	for (i = 0; i < 5; i++) {
 		if (info->mem[i].internal_addr)
 			iounmap(info->mem[i].internal_addr);
-- 
1.7.10.4


