Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762839Ab3ECGcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:32:32 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:63792 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762770Ab3ECGc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:32:29 -0400
X-AuditID: cbfee68d-b7f016d000007930-d6-518359fc5df3
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 24/42] rtc: rtc-max8998: remove unnecessary
 platform_set_drvdata()
Date: Fri, 03 May 2013 15:32:28 +0900
Message-id: <002601ce47c7$fb7a18b0$f26e4a10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5Hx/rNFEQqbqjpRKyhwrztmfkeTA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPIsWRmVeSWpSXmKPExsVy+t8zQ90/kc2BBu0bFC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKePrlMlvBNM6Ka+/vsTQwnmDvYuTkkBAwkbjd+5UFwhaTuHBvPVsXIxeHkMAyRoln
	TfvhijpuLmSGSExnlLi5fwoLhPOLUeLwzEmsIFVsAmoSX74cBurg4BAR0Jdoa9EAqWEW6GaU
	eNQ8lxmkRlggRGLhwoWMIDaLgKrE0ZnbGEHqeQUsJdafByvhFRCU+DH5HthFzAJaEut3HmeC
	sOUlNq95ywxxkILEjrOvwcaICOhJbNp8iRmiRkRi34t3jBA1x9gltm/NglglIPFt8iEWkFUS
	ArISmw5AjZGUOLjiBssERrFZSDbPQrJ5FpLNs5BsWMDIsopRNLUguaA4Kb3IUK84Mbe4NC9d
	Lzk/dxMjJPJ6dzDePmB9iDEZaP1EZinR5Hxg5OaVxBsamxlZmJqYGhuZW5qRJqwkzqvWYh0o
	JJCeWJKanZpakFoUX1Sak1p8iJGJg1OqgZHt0eHjKVeVSnrMQifHX0gXabFWOXbk7uvw4J7C
	nub/wnM0yidMULu++vjuu/cCFp1d/iwlZqJb7aWvf2NaYj/tvfP79cZAwYLXRqeOHDiRl/WK
	e9Me32V+jGL+0kq1rCmxi3mbl8afFDasjhBiC1p1x6ztmcOU3fF7XloFOCyRmzO/74Dy7Dol
	luKMREMt5qLiRADdzvV60gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQd0/kc2BBncuyFosuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPH0y2W2gmmcFdfe32NpYDzB3sXIySEhYCLR
	cXMhM4QtJnHh3nq2LkYuDiGB6YwSN/dPYYFwfjFKHJ45iRWkik1ATeLLl8NA3RwcIgL6Em0t
	GiA1zALdjBKPmueCTRIWCJFYuHAhI4jNIqAqcXTmNkaQel4BS4n158FKeAUEJX5MvscCYjML
	aEms33mcCcKWl9i85i3UQQoSO86+BhsjIqAnsWnzJWaIGhGJfS/eMU5gFJiFZNQsJKNmIRk1
	C0nLAkaWVYyiqQXJBcVJ6bmGesWJucWleel6yfm5mxjBkf1MagfjygaLQ4wCHIxKPLwKLU2B
	QqyJZcWVuYcYJTiYlUR43X4AhXhTEiurUovy44tKc1KLDzEmAz06kVlKNDkfmHTySuINjU3M
	jCyNzCyMTMzNSRNWEuc90GodKCSQnliSmp2aWpBaBLOFiYNTqoHxWGLURuWFL49uvG3PbDE9
	VmHp2ojfNf1bFq6absnLY7fhi14TX3STXdD2NbkS81kfnz3g+ub+vMQ7R4TdvN2del8vZVDq
	qA2rXm8SP8tiy5ZbHe+XSwRuWBuiHJw9jeveysj3TrP4Os9+s5yzJKpsGsP0O8xXLxYneSRt
	nSMrx/I57q7Gjvw1SizFGYmGWsxFxYkAsws5RzADAAA=
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
 drivers/rtc/rtc-max8998.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/rtc-max8998.c b/drivers/rtc/rtc-max8998.c
index 48b6612..b93842d 100644
--- a/drivers/rtc/rtc-max8998.c
+++ b/drivers/rtc/rtc-max8998.c
@@ -274,7 +274,7 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 	if (IS_ERR(info->rtc_dev)) {
 		ret = PTR_ERR(info->rtc_dev);
 		dev_err(&pdev->dev, "Failed to register RTC device: %d\n", ret);
-		goto out_rtc;
+		return ret;
 	}
 
 	ret = devm_request_threaded_irq(&pdev->dev, info->irq, NULL,
@@ -292,10 +292,6 @@ static int max8998_rtc_probe(struct platform_device *pdev)
 	}
 
 	return 0;
-
-out_rtc:
-	platform_set_drvdata(pdev, NULL);
-	return ret;
 }
 
 static int max8998_rtc_remove(struct platform_device *pdev)
-- 
1.7.2.5


