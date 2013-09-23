Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3IWBfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:35:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:13891 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753192Ab3IWBfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:35:07 -0400
X-AuditID: cbfee68f-b7f1e6d000004e8d-b3-523f9aca2c80
From: Jingoo Han <jg1.han@samsung.com>
To: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>, "'Alex Dubov'" <oakad@yahoo.com>
Subject: [PATCH 1/4] misc: tifm: remove unnecessary pci_set_drvdata()
Date: Mon, 23 Sep 2013 10:35:06 +0900
Message-id: <003101ceb7fd$21e97540$65bc5fc0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac63/SHKB4kHrvrSQPCGprHejMhtRA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zY91Ts+yDDKZ8VLL4O+kYu0Xz4vVs
	FpcXXmK1uLxrDpvFw2OrmR1YPX7/msTosX/uGnaPvi2rGD0+b5LzmDXrMFMAaxSXTUpqTmZZ
	apG+XQJXxtdHz9kLtrFXHF/XwdTAOImti5GTQ0LARGL+1qdQtpjEhXvrgWwuDiGBZYwSNw/t
	YYYperbrJDtEYhGjxO0nx5ghnF+MEptvfmQBqWITUJP48uUwO4gtImAqsfH9FEaQImaBdkaJ
	TdM2gBUJC7hKLNl9hxXEZhFQlfi/Yz3YCl4BW4n//z+wQdiCEj8m3wOrZxbQkli/8zgThC0v
	sXnNW6B6DqCT1CUe/dWF2KUnseXZEagSEYl9L96B7ZUQOMQu8fjKVEaIXQIS3yYfYoHolZXY
	dADqM0mJgytusExgFJuFZPMsJJtnIdk8C8mKBYwsqxhFUwuSC4qT0ouM9YoTc4tL89L1kvNz
	NzFCoq9/B+PdA9aHGJOB1k9klhJNzgdGb15JvKGxmZGFqYmpsZG5pRlpwkrivGot1oFCAumJ
	JanZqakFqUXxRaU5qcWHGJk4OKUaGBvqfIODztyb9NTtPq8Cq3j879mdd9K3801Y4m3xrGJt
	xl3LzeznPb7Grd3vH5Qp8YBbIChB7IrR/RkBSZsTCh5s+si4p7Qy0MarTT3lqd0ZdsH/AedU
	9ilYKMtVNvNNCvjLdzJq9utFW9yuGM3J/C73s8nDdDX7TbW4SL266bHx05vzHjzbqcRSnJFo
	qMVcVJwIABs06/XUAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd1Ts+yDDB7Mkbf4O+kYu0Xz4vVs
	FpcXXmK1uLxrDpvFw2OrmR1YPX7/msTosX/uGnaPvi2rGD0+b5LzmDXrMFMAa1QDo01GamJK
	apFCal5yfkpmXrqtkndwvHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0HYlhbLEnFKgUEBi
	cbGSvh2mCaEhbroWMI0Rur4hQXA9RgZoIGEdY8bXR8/ZC7axVxxf18HUwDiJrYuRk0NCwETi
	2a6T7BC2mMSFe+uB4lwcQgKLGCVuPznGDOH8YpTYfPMjC0gVm4CaxJcvh8E6RARMJTa+n8II
	UsQs0M4osWnaBrAiYQFXiSW777CC2CwCqhL/d6xnBrF5BWwl/v//wAZhC0r8mHwPrJ5ZQEti
	/c7jTBC2vMTmNW+B6jmATlKXePRXF2KXnsSWZ0egSkQk9r14xziBUWAWkkmzkEyahWTSLCQt
	CxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmIEx/Yz6R2MqxosDjEKcDAq8fBGJtoHCbEm
	lhVX5h5ilOBgVhLhbeoECvGmJFZWpRblxxeV5qQWH2JMBnp0IrOUaHI+MO3klcQbGpuYGVka
	mVkYmZibkyasJM57sNU6UEggPbEkNTs1tSC1CGYLEwenVANjJoebmGTs5n31UVbRSdwutuFN
	t/YwvZzS4/IyOu6blv+JZOmkbp8w6QtKlrtsxNrfPr1WsfTQ/d+iUzY8urvZ6Pmbug0n/kg/
	/nhXarm426mdvQckRSwc0sM0fueuYtA/8Z7P8vS09hPX9/MYbH1bbvVC4Ij7yvnnDrUbPzwd
	erRK9ElNecFsJZbijERDLeai4kQAbWQj8zEDAAA=
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
 drivers/misc/tifm_7xx1.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index f8d66543..ae282a1 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -378,7 +378,6 @@ err_out_irq:
 err_out_unmap:
 	iounmap(fm->addr);
 err_out_free:
-	pci_set_drvdata(dev, NULL);
 	tifm_free_adapter(fm);
 err_out_int:
 	pci_intx(dev, 0);
@@ -405,8 +404,6 @@ static void tifm_7xx1_remove(struct pci_dev *dev)
 	for (cnt = 0; cnt < fm->num_sockets; cnt++)
 		tifm_7xx1_sock_power_off(tifm_7xx1_sock_addr(fm->addr, cnt));
 
-	pci_set_drvdata(dev, NULL);
-
 	iounmap(fm->addr);
 	pci_intx(dev, 0);
 	pci_release_regions(dev);
-- 
1.7.10.4


