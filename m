Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab3HTHC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:02:29 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:58803 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3HTHC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:02:28 -0400
X-AuditID: cbfee690-b7f6f6d00000740c-40-521314833bf8
From: Jingoo Han <jg1.han@samsung.com>
To: "'Samuel Ortiz'" <sameo@linux.intel.com>,
        "'Lee Jones'" <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, "'David Brown'" <davidb@codeaurora.org>,
        "'Daniel Walker'" <dwalker@fifo99.com>,
        "'Bryan Huntsman'" <bryanh@codeaurora.org>,
        Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 3/3] mfd: pm8921: use devm_*() functions
Date: Tue, 20 Aug 2013 16:02:26 +0900
Message-id: <005401ce9d73$3a52fc40$aef8f4c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac6dczda6piE1rTiSNOTEiLvediVJQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zfd1mEeEgg9vNLBb/jk1hsni8/B+b
	xdRlbawWlxdeYrW4//Uoo8XlXXPYLE53szqwe1zu62XyOD15P4vHnWt72DzmnQz06NuyitHj
	8ya5ALYoLpuU1JzMstQifbsEroz1D9ezFvzmqXj7fwlzA+MWri5GDg4JAROJk5/Nuxg5gUwx
	iQv31rN1MXJxCAksY5S49O04M0TCRKL31jYWiMR0Rom9cz6zQzi/GCWWvnnLBlLFJqAm8eXL
	YXaQqSICfhINK8BqmAX2MkrcaullAqkRFrCQaD16F6yeRUBV4teWDewgNq+ApcS6v3vZIGxB
	iR+T77GA2MwCWhLrdx5ngrDlJTaveQt1kYLEjrOvGUFsEQE9icNLv0DViEjse/GOEaLmErvE
	pN2GELsEJL5NPsQC8bGsxKYDUGMkJQ6uuMEygVFsFpLNs5BsnoVk8ywkGxYwsqxiFE0tSC4o
	TkovMtErTswtLs1L10vOz93ECInJCTsY7x2wPsSYDLR+IrOUaHI+MKbzSuINjc2MLExNTI2N
	zC3NSBNWEudVb7EOFBJITyxJzU5NLUgtii8qzUktPsTIxMEp1cDIdIGhR+GlpGKmbWyVauLy
	4pYH897qT/Mqm7trytyjEct2VM3YHd5ufObiJcHZ7TfXO+mq7FDylQn7ptf7v0HIbKMLv1ew
	p13Agh/fnlolhBoL5Abn7co94Lj7wtTvMwyznaa9Uw8MbvW6sDF28YLe1DWMf/08nu0qO8jB
	pXAyNdnpVPmE5idKLMUZiYZazEXFiQCay8yK3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNKsWRmVeSWpSXmKPExsVy+t9jQd0mEeEggzNPbCz+HZvCZPF4+T82
	i6nL2lgtLi+8xGpx/+tRRovLu+awWZzuZnVg97jc18vkcXryfhaPO9f2sHnMOxno0bdlFaPH
	501yAWxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6Z
	OUCnKCmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz1j9cz1rwm6fi7f8l
	zA2MW7i6GDk5JARMJHpvbWOBsMUkLtxbz9bFyMUhJDCdUWLvnM/sEM4vRomlb96ygVSxCahJ
	fPlyGCjBwSEi4CfRsAKshllgL6PErZZeJpAaYQELidajd8HqWQRUJX5t2cAOYvMKWEqs+7uX
	DcIWlPgx+R7YZmYBLYn1O48zQdjyEpvXvGWGuEhBYsfZ14wgtoiAnsThpV+gakQk9r14xziB
	UWAWklGzkIyahWTULCQtCxhZVjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIER/0zqR2MKxss
	DjEKcDAq8fB2KgkFCbEmlhVX5h5ilOBgVhLhdfkPFOJNSaysSi3Kjy8qzUktPsSYDPTpRGYp
	0eR8YELKK4k3NDYxM7I0MrMwMjE3J01YSZz3QKt1oJBAemJJanZqakFqEcwWJg5OqQbGwFlJ
	8hPPd75ur5Q0XPcjNtAo2vhak4qyzI489e5pXH4vb+kHsbwULopzlVxcUxap1bhZKV7Gcp1b
	o+/smkyGVTkBZ1MvLf341SW6MulRuKn+z5+Xp0zxKC+b/DEn5M9y9XQmTeW+OdY6W7s6FfPf
	f5yeH87MpSlz4UQqs6KVfqz5Feer3UosxRmJhlrMRcWJABq1ACM+AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_*() functions to make cleanup paths simpler.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/mfd/pm8921-core.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/pm8921-core.c b/drivers/mfd/pm8921-core.c
index 9a7c991..a6841f7 100644
--- a/drivers/mfd/pm8921-core.c
+++ b/drivers/mfd/pm8921-core.c
@@ -118,7 +118,7 @@ static int pm8921_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
-	pmic = kzalloc(sizeof(struct pm8921), GFP_KERNEL);
+	pmic = devm_kzalloc(&pdev->dev, sizeof(struct pm8921), GFP_KERNEL);
 	if (!pmic) {
 		pr_err("Cannot alloc pm8921 struct\n");
 		return -ENOMEM;
@@ -128,7 +128,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	rc = ssbi_read(pdev->dev.parent, REG_HWREV, &val, sizeof(val));
 	if (rc) {
 		pr_err("Failed to read hw rev reg %d:rc=%d\n", REG_HWREV, rc);
-		goto err_read_rev;
+		return rc;
 	}
 	pr_info("PMIC revision 1: %02X\n", val);
 	rev = val;
@@ -138,7 +138,7 @@ static int pm8921_probe(struct platform_device *pdev)
 	if (rc) {
 		pr_err("Failed to read hw rev 2 reg %d:rc=%d\n",
 			REG_HWREV_2, rc);
-		goto err_read_rev;
+		return rc;
 	}
 	pr_info("PMIC revision 2: %02X\n", val);
 	rev |= val << BITS_PER_BYTE;
@@ -160,8 +160,6 @@ static int pm8921_probe(struct platform_device *pdev)
 
 err:
 	mfd_remove_devices(pmic->dev);
-err_read_rev:
-	kfree(pmic);
 	return rc;
 }
 
@@ -179,7 +177,6 @@ static int pm8921_remove(struct platform_device *pdev)
 		pm8xxx_irq_exit(pmic->irq_chip);
 		pmic->irq_chip = NULL;
 	}
-	kfree(pmic);
 
 	return 0;
 }
-- 
1.7.10.4


