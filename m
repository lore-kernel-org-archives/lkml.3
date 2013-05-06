Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3EFENI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 00:13:08 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:43256 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab3EFENG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 00:13:06 -0400
X-AuditID: cbfee691-b7fe56d000004b96-ef-51872dd13f2d
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 7/8] mfd: tc6387xb: remove unnecessary platform_set_drvdata()
Date: Mon, 06 May 2013 13:13:05 +0900
Message-id: <003401ce4a10$01e107a0$05a316e0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5KD/I5YJrs2bYaQMua2GQFK6HcJA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t8zQ92Luu2BBk2zxSwuL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAcxSXTUpqTmZZapG+XQJXxvWrexkLzrNVHFo6haWB8Rhr
	FyMnh4SAiUT/xg/MELaYxIV769m6GLk4hASWMUpMW9wFVzTj0hRmiMR0RolPTfuhnF+MEmea
	loO1swmoSXz5cpgdxBYR0JLoPnaeDcRmFnCS+LllJguILSzgKzGpuxOshkVAVeLy03NgNq+A
	pcSi7ROYIGxBiR+T77FA9GpJrN95nAnClpfYvOYt1KkKEjvOvmaE2KUncenWXmaIGhGJfS/e
	MYIcJyEwj11i56fdTBDLBCS+TT4ENJQDKCErsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJ
	igWMLKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQiJq4g7G+wesDzEmA62fyCwlmpwPjMi8
	knhDYzMjC1MTU2Mjc0sz0oSVxHnVW6wDhQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDO+zO3
	8iBbxvfVN/5M28O7IjfowwoeWbXdZY/OVn+8GLa0+oHRocJrKUKsj434d72uMdTf9kzR7OLF
	mYIylicKprAdMHI5aqZs9sW8aUnv8ry/L1f4Lyt2/K21uOFLm80XBV23/NdKvJJaP7exhHWl
	h02apvG17/TRbdfu2B/dsuRTjo7s03ZXJZbijERDLeai4kQA4ZqHYL4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgleLIzCtJLcpLzFFi42I5/e+xoO5F3fZAg+urhCwuL7zEanF51xw2
	i9PdrA7MHvNOBnr0bVnF6PF5k1wAc1QDo01GamJKapFCal5yfkpmXrqtkndwvHO8qZmBoa6h
	pYW5kkJeYm6qrZKLT4CuW2YO0B4lhbLEnFKgUEBicbGSvh2mCaEhbroWMI0Rur4hQXA9RgZo
	IGEdY8b1q3sZC86zVRxaOoWlgfEYaxcjJ4eEgInEjEtTmCFsMYkL99azdTFycQgJTGeU+NS0
	nxnC+cUocaZpOVgVm4CaxJcvh9lBbBEBLYnuY+fZQGxmASeJn1tmsoDYwgK+EpO6O8FqWARU
	JS4/PQdm8wpYSizaPoEJwhaU+DH5HgtEr5bE+p3HmSBseYnNa95CXaQgsePsa0aIXXoSl27t
	ZYaoEZHY9+Id4wRGgVlIRs1CMmoWklGzkLQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7
	iREcr8+kdjCubLA4xCjAwajEw1vwpC1QiDWxrLgy9xCjBAezkgivz16gEG9KYmVValF+fFFp
	TmrxIcZkoE8nMkuJJucDU0leSbyhsYmZkaWRmYWRibk5acJK4rwHWq0DhQTSE0tSs1NTC1KL
	YLYwcXBKNTDu/n7VpT50VUXOBuf+jc7vp/9kmHTn06onKw7PrPg2M7iReUoyH/9xE7O93918
	X/BqbRPw25KzvfJd7+1pPT3Zy1wmS6lFO7ic3ZedJ6LazLlgvrHU11e3NMKnJ567cF1uEpMt
	29bEllK2vGXS/S8C4ttVL6V316fKLZLWOSZ6YcvRu3ddfmxQYinOSDTUYi4qTgQAdLFjBhsD	AAA=
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
 drivers/mfd/tc6387xb.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/tc6387xb.c b/drivers/mfd/tc6387xb.c
index 366f7b9..65c425a 100644
--- a/drivers/mfd/tc6387xb.c
+++ b/drivers/mfd/tc6387xb.c
@@ -217,7 +217,6 @@ static int tc6387xb_remove(struct platform_device *dev)
 	release_resource(&tc6387xb->rscr);
 	clk_disable(tc6387xb->clk32k);
 	clk_put(tc6387xb->clk32k);
-	platform_set_drvdata(dev, NULL);
 	kfree(tc6387xb);
 
 	return 0;
-- 
1.7.2.5


