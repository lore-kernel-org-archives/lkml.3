Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891Ab3HTHCJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:02:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:49216 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3HTHCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:02:07 -0400
X-AuditID: cbfee68d-b7f096d0000043fc-4f-5213146ef328
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'David Brown'" <davidb@codeaurora.org>,
        "'Daniel Walker'" <dwalker@fifo99.com>,
        "'Bryan Huntsman'" <bryanh@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 2/3] mfd: pm8921: remove unnecessary platform_set_drvdata()
Date: Tue, 20 Aug 2013 16:02:05 +0900
Message-id: <005301ce9d73$2df47b40$89dd71c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dcypaXfXokrQESRyQgyJqm5AsmA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zI908EeEgg47jvBb/jk1hsni8/B+b
	xdRlbawWlxdeYrW4//Uoo8XlXXPYLE53szqwe1zu62XyOD15P4vHnWt72DzmnQz06NuyitHj
	8ya5ALYoLpuU1JzMstQifbsEroyFvTvZCj6zV2zc1MvWwHiErYuRk0NCwETizfwf7BC2mMSF
	e+uB4lwcQgLLGCXmP/nO2sXIAVY06VIeRHw6o8TRSb1MIHEhgV+MEj0lIL1sAmoSX74cZgcJ
	iwj4STSsYAcpZxbYyyhxqwWknJNDWMBbYmXrObBdLAKqEvOn7wQbwytgKbF8ri5ImFdAUOLH
	5HssIDazgJbE+p3HmSBseYnNa94yQ5ypILHj7GtGEFtEQE+i5+UVdogaEYl9L94xguyVELjF
	LtHxbCMrxC4BiW+TD7FAvCIrsekA1BxJiYMrbrBMYBSbhWT1LCSrZyFZPQvJigWMLKsYRVML
	kguKk9KLDPWKE3OLS/PS9ZLzczcxQuKxdwfj7QPWhxiTgdZPZJYSTc4HxnNeSbyhsZmRhamJ
	qbGRuaUZacJK4rxqLdaBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhg7uuK1NU6dV30obvkp
	8N+Mn2WBKmpB6doaP3byKVW1M363r3V0eLi5dnuTvv/Zq4U9dzXPJq8+NeWpM/vV9Y//f7Ly
	2XDI7nJurkH460ML3B0/GBzRYptwumnrdYUDBa17U3XnXLD5J5zo8C//hm8Do9sb+3vPYzsP
	nD27V3Z61deXOze/Md2lxFKckWioxVxUnAgAqlVzMd0CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOKsWRmVeSWpSXmKPExsVy+t9jQd08EeEgg2lHOC3+HZvCZPF4+T82
	i6nL2lgtLi+8xGpx/+tRRovLu+awWZzuZnVg97jc18vkcXryfhaPO9f2sHnMOxno0bdlFaPH
	501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgzFvbuZCv4zF6xcVMv
	WwPjEbYuRg4OCQETiUmX8roYOYFMMYkL99YDhbk4hASmM0ocndTLBFIjJPCLUaKnBKSGTUBN
	4suXw+wgYREBP4mGFewg5cwCexklbrWAlHNyCAt4S6xsPccOYrMIqErMn74TbAyvgKXE8rm6
	IGFeAUGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxxjoLEjrOvGUFsEQE9iZ6XV9ghakQk9r14
	xziBUWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/szqR2M
	KxssDjEKcDAq8fB2KgkFCbEmlhVX5h5ilOBgVhLhdfkPFOJNSaysSi3Kjy8qzUktPsSYDPTo
	RGYp0eR8YCLKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQZG
	8YTcDRIrdebb8HZl1RUv4biTtqOdl7V8X8CuWvlrsU91PZ7Py99crcp1T/mcoOiOfpWc+QWq
	rVOuW83ayNSXZyH35q7a8swnzEtSLXfYaG55eefa5F0WB/PyBV+wh6x4+H/dc0P/zMY7uou2
	MIYWXJt+MFbp7nl9hWZJ0bOqnscPXpD9rtisxFKckWioxVxUnAgAcNBzpToDAAA=
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
 drivers/mfd/pm8921-core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index bd4b37c..9a7c991 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -160,7 +160,6 @@ static int pm8921_probe(struct platform_device *pdev)
 
 err:
 	mfd_remove_devices(pmic->dev);
-	platform_set_drvdata(pdev, NULL);
 err_read_rev:
 	kfree(pmic);
 	return rc;
@@ -180,7 +179,6 @@ static int pm8921_remove(struct platform_device *pdev)
 		pm8xxx_irq_exit(pmic->irq_chip);
 		pmic->irq_chip = NULL;
 	}
-	platform_set_drvdata(pdev, NULL);
 	kfree(pmic);
 
 	return 0;
-- 
1.7.10.4


