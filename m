Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab3EFDn3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 23:43:29 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:26613 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab3EFDn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 23:43:27 -0400
X-AuditID: cbfee68d-b7f016d000007930-89-518726de6146
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        "'Barry Song '" <baohua.song@csr.com>
Subject: [PATCH 3/4] pinctrl: sirf: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 12:43:25 +0900
Message-id: <002001ce4a0b$dd76f720$9864e560$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KC7rXMUCyOgTCSoazJxiPl0yygg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t8zY917au2BBvc/C1m8nHmV1eLywkus
	FlP+LGeyuLxrDpsDi8eunXNYPe5c28Pm0bdlFaPH501yASxRXDYpqTmZZalF+nYJXBmf7pxj
	K5jNWdF95yJrA+M19i5GTg4JAROJtQe6WCFsMYkL99azdTFycQgJLGOUuPTuMxtMUWvzPFaI
	xCJGiR9dU1kgnF+MEg2b/4O1swmoSXz5chhsrIiAnsSbry1gNrNApsS0hxPBaoQFfCVWrXgA
	ZrMIqErs2jEHrIZXwFLi5M5jjBC2oMSPyfdYIHq1JNbvPM4EYctLbF7zlhniIgWJHWdfM8Ls
	mtHQxAxRIyKx78U7RpDjJARWsUtsnToHapmAxLfJh4CGcgAlZCU2HYCaIylxcMUNlgmMYrOQ
	rJ6FZPUsJKtnIVmxgJFlFaNoakFyQXFSepGhXnFibnFpXrpecn7uJkZIpPXuYLx9wPoQYzLQ
	+onMUqLJ+cBIzSuJNzQ2M7IwNTE1NjK3NCNNWEmcV63FOlBIID2xJDU7NbUgtSi+qDQntfgQ
	IxMHp1QDY+YjduaTmo9eRdk+Wc9+f//q2b+kV/P8ilA4aO5TPiG/dNWaRT6SMvdSXIylLlpZ
	1K9z2cq7NJnx3XT3nF15S2LPXk51neCc1+myUmbhKeHTocdW5F3T10uaa564k0Vo3hm3VUdK
	Z3S1yjpbctXdXv5M885UCZs8vkrjhc83fAy575+4ltdIWYmlOCPRUIu5qDgRAMmgzCjKAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCKsWRmVeSWpSXmKPExsVy+t9jAd17au2BBptm81m8nHmV1eLywkus
	FlP+LGeyuLxrDpsDi8eunXNYPe5c28Pm0bdlFaPH501yASxRDYw2GamJKalFCql5yfkpmXnp
	tkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUA7lRTKEnNKgUIBicXFSvp2mCaEhrjp
	WsA0Ruj6hgTB9RgZoIGEdYwZn+6cYyuYzVnRfeciawPjNfYuRk4OCQETidbmeawQtpjEhXvr
	2boYuTiEBBYxSvzomsoC4fxilGjY/B+sik1ATeLLl8Ng3SICehJvvraA2cwCmRLTHk4EqxEW
	8JVYteIBmM0ioCqxa8ccsBpeAUuJkzuPMULYghI/Jt9jgejVkli/8zgThC0vsXnNW2aIixQk
	dpx9zQiza0ZDEzNEjYjEvhfvGCcwCsxCMmoWklGzkIyahaRlASPLKkbR1ILkguKk9FwjveLE
	3OLSvHS95PzcTYzgOH4mvYNxVYPFIUYBDkYlHt6CJ22BQqyJZcWVuYcYJTiYlUR4ffYChXhT
	EiurUovy44tKc1KLDzEmA306kVlKNDkfmGLySuINjU3MjCyNzCyMTMzNSRNWEuc92GodKCSQ
	nliSmp2aWpBaBLOFiYNTqoGxXTvkjYle5qEth5rjfZrOna2T2mPNu1KDVcbnsCXDGdvTFfI5
	i7Rf6vC6/fmYdel2X6Dc3CCbrfxJzjyTjjKVX57Bpaq0lqXV5lOYriCP4soos8UsHFGnWJ4/
	9F1VcJzFKILX8jnvIgXHjUVuX9l0z5jOOdRXYSua1XClQnvPnin362qCnyqxFGckGmoxFxUn
	AgD441jlJwMAAA==
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
 drivers/pinctrl/pinctrl-sirf.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-sirf.c b/drivers/pinctrl/pinctrl-sirf.c
index bc9d1be..d704f3b 100644
--- a/drivers/pinctrl/pinctrl-sirf.c
+++ b/drivers/pinctrl/pinctrl-sirf.c
@@ -1280,9 +1280,8 @@ static int sirfsoc_pinmux_probe(struct platform_device *pdev)
 
 	spmx->gpio_virtbase = of_iomap(np, 0);
 	if (!spmx->gpio_virtbase) {
-		ret = -ENOMEM;
 		dev_err(&pdev->dev, "can't map gpio registers\n");
-		goto out_no_gpio_remap;
+		return -ENOMEM;
 	}
 
 	spmx->rsc_virtbase = sirfsoc_rsc_of_iomap();
@@ -1316,8 +1315,6 @@ out_no_pmx:
 	iounmap(spmx->rsc_virtbase);
 out_no_rsc_remap:
 	iounmap(spmx->gpio_virtbase);
-out_no_gpio_remap:
-	platform_set_drvdata(pdev, NULL);
 	return ret;
 }
 
-- 
1.7.2.5


