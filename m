Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab3EFD11 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:27:27 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23850 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab3EFD10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:27:26 -0400
X-AuditID: cbfee68e-b7efa6d000004d12-0f-5187231cb275
From: Jingoo Han <jg1.han@samsung.com>
To: "'Grant Likely'" <grant.likely@secretlab.ca>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/7] gpio: langwell: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:27:24 +0900
Message-id: <001701ce4a09$a04af0b0$e0e0d210$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KCZ07urt0PbqhS6y9GGX8tv7etg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKIsWRmVeSWpSXmKPExsVy+t8zQ10Z5fZAgxUntS1endnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wASxSXTUpqTmZZapG+XQJXxuktp5kL
	7rBVnH7Yzt7AeJ61i5GTQ0LARGLdnyNQtpjEhXvr2boYuTiEBJYxShxb9Z25i5EDrGji32SI
	+CJGiQW7+5khnF+MEg82doF1swmoSXz5cpgdxBYR0JO4caGDEcRmFiiSeN41C6xGWMBPonHt
	cxYQm0VAVeLmjwawOK+ApcSz5nuMELagxI/J91ggerUk1u88zgRhy0tsXvOWGeJSBYkdZ18z
	wuxa83oe1C4RiX0v3jGCHCchsI5d4tTEfjaIZQIS3yYfYoH4RlZi0wGoOZISB1fcYJnAKDYL
	yepZSFbPQrJ6FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefnbmKERFnfDsabB6wPMSYD
	rZ/ILCWanA+M0rySeENjMyMLUxNTYyNzSzPShJXEedVarAOFBNITS1KzU1MLUovii0pzUosP
	MTJxcEo1MLb6FPilTPVMPHvx0rurcTf7Ln5dOPuQaWtFzSedx/mXj9qserqL+eY9Lu7UW8ZX
	koX5s9Rf7bU78VLlat6576UHRYryTeXynl7/5tRYFWAdyZrw8blOzfJtduwcfGfmrzvEOP2c
	pETsg+27Sn41PBeuzN6U+tPZpbg+O0f4shjr87+8Jf/ljimxFGckGmoxFxUnAgAbKtY3yAIA	AA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprEKsWRmVeSWpSXmKPExsVy+t9jAV0Z5fZAg2eP1S1endnIZnF54SVW
	iyl/ljNZXN41h82BxePOtT1sHn1bVjF6/Hyp4/F5k1wAS1QDo01GamJKapFCal5yfkpmXrqt
	kndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0EolhbLEnFKgUEBicbGSvh2mCaEhbroW
	MI0Rur4hQXA9RgZoIGEdY8bpLaeZC+6wVZx+2M7ewHietYuRg0NCwERi4t/kLkZOIFNM4sK9
	9WxdjFwcQgKLGCUW7O5nhnB+MUo82NjFClLFJqAm8eXLYXYQW0RAT+LGhQ5GEJtZoEjiedcs
	sBphAT+JxrXPWUBsFgFViZs/GsDivAKWEs+a7zFC2IISPybfY4Ho1ZJYv/M4E4QtL7F5zVtm
	iIsUJHacfc0Is2vN63lQu0Qk9r14xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca
	6RUn5haX5qXrJefnbmIEx/Az6R2MqxosDjEKcDAq8fAWPGkLFGJNLCuuzD3EKMHBrCTC67MX
	KMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wPSSVxJvaGxiZmRpZGZhZGJuTpqwkjjvwVbr
	QCGB9MSS1OzU1ILUIpgtTBycUg2MArf8H1keyt8z31ikiTncX3TOJI06B78FcyqOKTdLtU2/
	/FIu/PnbW52LYgN8tJKUg2abcmvlslmG61U9mab8NfFo740avbpDnn8fmPMtqxA899fjr8SO
	81d41j57YlpQ7jpvxuY98zrCVB1VM/K57O99ue0mO+me8JLapUvC95WvOvxx8uf/SizFGYmG
	WsxFxYkAjyjGCSUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver core clears the driver data to NULL after device_release
or on probe failure, since commit 0998d0631001288a5974afc0b2a5f568bcdecb4d
(device-core: Ensure drvdata = NULL when no driver is bound).
Thus, it is not needed to manually clear the device driver data to NULL.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/gpio/gpio-langwell.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
index 634c3d3..de08bc1 100644
--- a/drivers/gpio/gpio-langwell.c
+++ b/drivers/gpio/gpio-langwell.c
@@ -478,7 +478,6 @@ static int wp_gpio_remove(struct platform_device *pdev)
 		dev_err(&pdev->dev, "failed to remove gpio_chip.\n");
 	iounmap(lnw->reg_base);
 	kfree(lnw);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


