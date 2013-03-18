Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662Ab3CRJbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:31:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48508 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567Ab3CRJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:30:58 -0400
X-AuditID: cbfee690-b7f656d0000007e3-01-5146deb5fbab
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 03/10] rtc: rtc-pxa: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:30:28 +0900
Message-id: <01b901ce23bb$3aa9b4e0$affd1ea0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAABLoQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zY92t99wCDf6dFLBYcvEqu8Wc9WvY
	LC4vvMRqcXnXHDaL/Z0djA6sHnsmnmTzODHjN4tH35ZVjB7T5/1k8vi8SS6ANYrLJiU1J7Ms
	tUjfLoEro3nRZNaC/5wVre8amBoYZ3B0MXJySAiYSKw8sYMRwhaTuHBvPVsXIxeHkMAyRokJ
	D54xwRSd+v6UFSIxnVGiffZddgjnF6PEmvObWUCq2ATUJL58OQyU4OAQEdCXaGvRAKlhFuhl
	lDjTu5sdpEZIwFZi3rXFYOs4BewktvZPYgWxhQXcJP5suwxWwyKgKvFxzXSwOC9Q/a+7X9kh
	bEGJH5Pvge1iFtCSWL/zOBOELS+xec1bZpC9EgLqEo/+6oKERQSMJBp272SGKBGR2PfiHSPI
	PRIC99glrh55zgqxS0Di2+RDLBC9shKbDjBDPCwpcXDFDZYJjBKzkGyehWTzLCSbZyFZsYCR
	ZRWjaGpBckFxUnqRiV5xYm5xaV66XnJ+7iZGSKxO2MF474D1IcZkoPUTmaVEk/OBsZ5XEm9o
	bGZkYWpiamxkbmlGmrCSOK96i3WgkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBkZFQ11xqZJJ
	lVO4gmd1LWPv2THpWKLVo6Wsh1QdtAILHluvvnbtecW2X5tW5Xt8mX+F69LbWI3/r5hqGy2D
	o56FTKjWl3jGeOxvc32tm4elRuG60L9b45SV3zt1Sid9YK3r4JzBaGHi+8nZZGX216uSkan7
	ZiRE371i1tQRvUPB1djDP3zediWW4oxEQy3mouJEABlxRhDrAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKKsWRmVeSWpSXmKPExsVy+t9jQd2t99wCDVq28lgsuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmNG8aDJrwX/OitZ3DUwNjDM4uhg5OSQETCRO
	fX/KCmGLSVy4t56ti5GLQ0hgOqNE++y77BDOL0aJNec3s4BUsQmoSXz5chgowcEhIqAv0dai
	AVLDLNDLKHGmdzc7SI2QgK3EvGuLGUFsTgE7ia39k8A2CAu4SfzZdhmshkVAVeLjmulgcV6g
	+l93v7JD2IISPybfA9vFLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJiwgYSTTs3skMUSIi
	se/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjOBE8
	k9rBuLLB4hCjAAejEg/vjvVugUKsiWXFlbmHGCU4mJVEeB1vA4V4UxIrq1KL8uOLSnNSiw8x
	JgM9OpFZSjQ5H5ik8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5YkpqdmlqQWgSzhYmD
	U6qBcfL9f6//8nt23neu49Iv2fCERdRl5vuK/Y/WvhV7xlWvEa0Z854h0Utqz8vXMZXVzEzT
	qs+05nx+8Gd7c2Z/4dWSH+wu+9JnNwXfTfn9RGt236T/7yt/z/BXz3cw0njl+iJAJ1nYpaJ/
	b7O+3w6Tn6W8p2r/C15qnzqF+e+W/74Ge+9Nivr4UomlOCPRUIu5qDgRAFM47TRIAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to using SIMPLE_DEV_PM_OPS  macro to declare the driver's
pm_ops. It reduces code size.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-pxa.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/rtc/rtc-pxa.c b/drivers/rtc/rtc-pxa.c
index 72e13da..a2c75c1 100644
--- a/drivers/rtc/rtc-pxa.c
+++ b/drivers/rtc/rtc-pxa.c
@@ -466,7 +466,7 @@ static struct of_device_id pxa_rtc_dt_ids[] = {
 MODULE_DEVICE_TABLE(of, pxa_rtc_dt_ids);
 #endif
 
-#ifdef CONFIG_PM
+#ifdef CONFIG_PM_SLEEP
 static int pxa_rtc_suspend(struct device *dev)
 {
 	struct pxa_rtc *pxa_rtc = dev_get_drvdata(dev);
@@ -484,21 +484,16 @@ static int pxa_rtc_resume(struct device *dev)
 		disable_irq_wake(pxa_rtc->irq_Alrm);
 	return 0;
 }
-
-static const struct dev_pm_ops pxa_rtc_pm_ops = {
-	.suspend	= pxa_rtc_suspend,
-	.resume		= pxa_rtc_resume,
-};
 #endif
 
+static SIMPLE_DEV_PM_OPS(pxa_rtc_pm_ops, pxa_rtc_suspend, pxa_rtc_resume);
+
 static struct platform_driver pxa_rtc_driver = {
 	.remove		= __exit_p(pxa_rtc_remove),
 	.driver		= {
 		.name	= "pxa-rtc",
 		.of_match_table = of_match_ptr(pxa_rtc_dt_ids),
-#ifdef CONFIG_PM
 		.pm	= &pxa_rtc_pm_ops,
-#endif
 	},
 };
 
-- 
1.7.2.5


