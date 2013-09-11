Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730Ab3IKC1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 22:27:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:38417 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3IKC1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 22:27:48 -0400
X-AuditID: cbfee691-b7f4a6d0000074fc-05-522fd51e2fe0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Chanwoo Choi'" <cw00.choi@samsung.com>
Cc: "'MyungJoo Ham'" <myungjoo.ham@samsung.com>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>,
        "'Graeme Gregory'" <gg@slimlogic.co.uk>
References: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
In-reply-to: <003e01ceae95$9a708ab0$cf51a010$%han@samsung.com>
Subject: [PATCH 3/3] extcon: palmas: use dev_get_platdata()
Date: Wed, 11 Sep 2013 11:27:41 +0900
Message-id: <004101ceae96$7ddb6220$79922660$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac6ulZa6uUhwZIzATbuZxRtBD2SFVwAAKvlw
Content-language: ko
x-cr-hashedpuzzle: BOLG E9za MfCW TLV+ UFgg WZX0 jPE/ m7sG tOHi vaVA zGzM zbof
 14MC 2YB7 4FGr
 4NOq;6;YwB3ADAAMAAuAGMAaABvAGkAQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBnAGcAQABzAGwAaQBtAGwAbwBnAGkAYwAuAGMAbwAuAHUAawA7AGoAZwAxAC4AaABhAG4AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0AOwBsAGQAZQB3AGEAbgBnAGEAbgBAAG4AdgBpAGQAaQBhAC4AYwBvAG0AOwBsAGkAbgB1AHgALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG8AcgBnADsAbQB5AHUAbgBnAGoAbwBvAC4AaABhAG0AQABzAGEAbQBzAHUAbgBnAC4AYwBvAG0A;Sosha1_v1;7;{4FB37670-E739-48C8-B9FA-4676BBFEB845};agBnADEALgBoAGEAbgBAAHMAYQBtAHMAdQBuAGcALgBjAG8AbQA=;Wed,
 11 Sep 2013 02:27:33
 GMT;WwBQAEEAVABDAEgAIAAzAC8AMwBdACAAZQB4AHQAYwBvAG4AOgAgAHAAYQBsAG0AYQBzADoAIAB1AHMAZQAgAGQAZQB2AF8AZwBlAHQAXwBwAGwAYQB0AGQAYQB0AGEAKAApAA==
x-cr-puzzleid: {4FB37670-E739-48C8-B9FA-4676BBFEB845}
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHIsWRmVeSWpSXmKPExsVy+t8zI125q/pBBlun8Ftc//Kc1aJ/i4vF
	5YWXWC2W7lvNYnF51xw2i9uNK9gc2Dx6m9+xefRtWcXoMXXKX0aPz5vkAliiuGxSUnMyy1KL
	9O0SuDJW/mpgLnjIXjFj4i6WBsYLbF2MnBwSAiYS736fYYewxSQu3FsPFOfiEBJYxiixa88y
	Rpiiz/2TGCES0xkltve8ZIVwfjFKNPT8BGtnE1CT+PLlMJgtIqAlMbFzJhOIzSxwhFFi4QtP
	EFtIwFaiZd8H5i5GDg5OATuJ5tsmIGFhAWuJyQePsYDYLAKqEmcX/2UFKeEFKt89VRQkzCsg
	KPFj8j0WiIlaEut3HoeaLi+xec1bsIkSAuoSj/7qQhxgJHHq9wKoEhGJfS/egZ0vIfCEVaLt
	8X0WiL9MJVr/PYRKfGWX2LHkHxPEDQIS3yYfYoEYKiux6QAzRL2kxMEVN1gmMErNQnLSLCQn
	zUJy0iwkuxcwsqxiFE0tSC4oTkovMtUrTswtLs1L10vOz93ECInriTsY7x+wPsSYDLR+IrOU
	aHI+MC3klcQbGpsZWZiamBobmVuakSasJM6r3mIdKCSQnliSmp2aWpBaFF9UmpNafIiRiYNT
	qoExu5N/Vblum+Aebq6mq/cbOr4ktb+qZJ6Vx/ypV0bx/mSnhD2cc1PPnz+36dtJk1urjvhu
	OfzSj22rxeYL28pd2OyOO4ic+Z7v/2NVY/5Z21sJUccSRR7vWKFxUHpe6ZHXTa81nM04vXew
	WwkeMNV9mN/pEn1cWu1Zdrv8toMRlmGvz6tt9itXYinOSDTUYi4qTgQALIAbDgEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNKsWRmVeSWpSXmKPExsVy+t9jQV25q/pBBg0TuC2uf3nOatG/xcXi
	8sJLrBZL961msbi8aw6bxe3GFWwObB69ze/YPPq2rGL0mDrlL6PH501yASxRDYw2GamJKalF
	Cql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUDLlRTKEnNKgUIBicXF
	Svp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZK381MBc8ZK+YMXEXSwPjBbYuRk4OCQETic/9
	kxghbDGJC/fWA8W5OIQEpjNKbO95yQrh/GKUaOj5yQ5SxSagJvHly2EwW0RAS2Ji50wmEJtZ
	4AijxMIXniC2kICtRMu+D8xdjBwcnAJ2Es23TUDCwgLWEpMPHmMBsVkEVCXOLv7LClLCC1S+
	e6ooSJhXQFDix+R7LBATtSTW7zwONV1eYvOat2ATJQTUJR791YU4wEji1O8FUCUiEvtevGME
	uVhC4AmrRNvj+ywQf5lKtP57yDiBUWQWkhWzkKyYhWTFLCSzFjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQIThrPpHYwrmywOMQowMGoxMN7Q04/SIg1say4MvcQowQHs5II71QnoBBv
	SmJlVWpRfnxRaU5q8SHGZGAATGSWEk3OBya0vJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7RaBwoJ
	pCeWpGanphakFsFsYeLglGpgNNZxcNgXpf+/+tPnrUe1xBc/fxsYq5YldvBdwKwcm4T7//7f
	YooL9+H80vVUQWhPysQdF0qWH+b34p5uJWanZsnC3RQn7RMuyjg575Eva8eSF0e8pmU5Clqm
	u9xZF9T572Rr18T/Jz4VsD3eo6GvHPnupaD4R+9dCe9YY+cVer6VM2f5//GCEktxRqKhFnNR
	cSIAcCieJ14DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the wrapper function for retrieving the platform data instead of
accessing dev->platform_data directly. This is a cosmetic change
to make the code simpler and enhance the readability.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/extcon/extcon-palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/extcon/extcon-palmas.c b/drivers/extcon/extcon-palmas.c
index 89fdd05..0c2fb68 100644
--- a/drivers/extcon/extcon-palmas.c
+++ b/drivers/extcon/extcon-palmas.c
@@ -135,7 +135,7 @@ static void palmas_enable_irq(struct palmas_usb *palmas_usb)
 static int palmas_usb_probe(struct platform_device *pdev)
 {
 	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
-	struct palmas_usb_platform_data	*pdata = pdev->dev.platform_data;
+	struct palmas_usb_platform_data	*pdata = dev_get_platdata(&pdev->dev);
 	struct device_node *node = pdev->dev.of_node;
 	struct palmas_usb *palmas_usb;
 	int status;
-- 
1.7.10.4


