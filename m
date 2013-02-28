Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3B1KlZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 05:41:25 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:14851 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab3B1KjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 05:39:21 -0500
X-AuditID: cbfee68e-b7fa46d00000627e-91-512f33d8c69f
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <000901ce159f$94e48270$bead8750$%han@samsung.com>
In-reply-to: <000901ce159f$94e48270$bead8750$%han@samsung.com>
Subject: [PATCH 5/7] rtc: rtc-nuc900: add __init/__exit annotation
Date: Thu, 28 Feb 2013 19:39:20 +0900
Message-id: <000d01ce159f$ddcd3680$9967a380$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vn5THVyS/kU1xRpiO8bTmT1G2WgAADuzg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zQ90bxvqBBv3XDCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKeLv9HXvBBa6K3+9XMjYwvuboYuTkkBAwkWhaeYERwhaTuHBvPVsXIxeHkMAyRomV
	j/+ywhT1L1jLDJGYzijxZN0ddgjnF6PEni3XwKrYBNQkvnw5DJTg4BAR0Jdoa9EAqWEW6GWU
	ONO7mx2kRkjAVmJVdytYPaeAncSe+ZPAbGEBJ4np53pZQGwWAVWJe1uWg9m8QPVLn79ghLAF
	JX5MvgcWZxbQkti8rYkVwpaX2LzmLTPIXgkBdYlHf3VBwiICRhJfrr2FKhGR2PfiHSPIPRIC
	99gllvauYoTYJSDxbfIhFoheWYlNB5ghHpaUOLjiBssERolZSDbPQrJ5FpLNs5CsWMDIsopR
	NLUguaA4Kb3ISK84Mbe4NC9dLzk/dxMjJFb7djDePGB9iDEZaP1EZinR5HxgrOeVxBsaG5uY
	mZiamFuampuSJqwkzit/SSZQSCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Nr5uS5EmtsYu0d
	wiZvk7hW13vMXGJdGUNO+mb/amXeX8ufzakKLqy8xd0+Odrie8bxJ7v+HHJIFxX/u62pN7dr
	rojtnEl19os+Xk4Nlt2Xpqe9WHy34cVY38jAScb9CQXucq6nqjY4389PK9jBPLXOa+7sU53C
	V2Y8eJPKd4opO0VjsX3vHCWW4oxEQy3mouJEAOQNqkXrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd0bxvqBBsu36VgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmPF2+zv2ggtcFb/fr2RsYHzN0cXIySEhYCLR
	v2AtM4QtJnHh3nq2LkYuDiGB6YwST9bdYYdwfjFK7NlyjRWkik1ATeLLl8NACQ4OEQF9ibYW
	DZAaZoFeRokzvbvZQWqEBGwlVnW3gtVzCthJ7Jk/CcwWFnCSmH6ulwXEZhFQlbi3ZTmYzQtU
	v/T5C0YIW1Dix+R7YHFmAS2JzduaWCFseYnNa94yg+yVEFCXePRXFyQsImAk8eXaW6gSEYl9
	L94xTmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGJ4Jn0
	DsZVDRaHGAU4GJV4eDtM9AKFWBPLiitzDzFKcDArifC68OsHCvGmJFZWpRblxxeV5qQWH2JM
	Bnp0IrOUaHI+MEnllcQbGpuYGVkamVkYmZibkyasJM7LeOpJgJBAemJJanZqakFqEcwWJg5O
	qQbG6cvWLfJ/9iF59/Stiqw/hOODG+K0Alae33Nr4/kGyRCNy0kVTSHGK54u6J8k2LxadFu6
	9eldqpf3/Jl6efl0F74Dh3jdIis7+JqXfc7ZoTVd0Xn33d2/K0/f37UgX/jpUxOp81tjrJnl
	e+QE9uSeCdxw08HfLGmb5rfVTX+TGa6Vbrp/13x3sBJLcUaioRZzUXEiABWKdNRIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When platform_driver_probe() is used, bind/unbind via sysfs is
disabled. Thus, __init/__exit annotations can be added to
probe()/remove().

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-nuc900.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-nuc900.c b/drivers/rtc/rtc-nuc900.c
index a636808..06b98fb 100644
--- a/drivers/rtc/rtc-nuc900.c
+++ b/drivers/rtc/rtc-nuc900.c
@@ -222,7 +222,7 @@ static struct rtc_class_ops nuc900_rtc_ops = {
 	.alarm_irq_enable = nuc900_alarm_irq_enable,
 };
 
-static int nuc900_rtc_probe(struct platform_device *pdev)
+static int __init nuc900_rtc_probe(struct platform_device *pdev)
 {
 	struct resource *res;
 	struct nuc900_rtc *nuc900_rtc;
@@ -284,7 +284,7 @@ fail1:	kfree(nuc900_rtc);
 	return err;
 }
 
-static int nuc900_rtc_remove(struct platform_device *pdev)
+static int __exit nuc900_rtc_remove(struct platform_device *pdev)
 {
 	struct nuc900_rtc *nuc900_rtc = platform_get_drvdata(pdev);
 	struct resource *res;
@@ -304,7 +304,7 @@ static int nuc900_rtc_remove(struct platform_device *pdev)
 }
 
 static struct platform_driver nuc900_rtc_driver = {
-	.remove		= nuc900_rtc_remove,
+	.remove		= __exit_p(nuc900_rtc_remove),
 	.driver		= {
 		.name	= "nuc900-rtc",
 		.owner	= THIS_MODULE,
-- 
1.7.2.5


