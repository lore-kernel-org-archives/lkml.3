Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab3B1IoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:44:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:48540 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3B1IoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:44:00 -0500
X-AuditID: cbfee68f-b7f6a6d000004969-44-512f18ced743
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 13/19] rtc: rtc-at91rm9200: remove erroneous __init/__exit
 annotations
Date: Thu, 28 Feb 2013 17:43:58 +0900
Message-id: <00b101ce158f$c00baba0$402302e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAMJ2w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t8zY91zEvqBBvOazC2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DKWN7+jb3gLXfFnfbvLA2Mrzi7GDk5JARMJObNXsoMYYtJXLi3ng3EFhJYxigxq0MF
	pmb1wj+sXYxcQPHpjBJrWr+yQxT9YpT4csYBxGYTUJP48uUwUJyDQ0RAX6KtRQOknlmgl1Hi
	TO9uqHpbiWNtbSwgNqeAncTvp0dZQWxhgQiJnp63TCA2i4CqxMsb98HivED1R+Zfh7IFJX5M
	vgfWyyygJbF+53EmCFteYvOat8wgeyUE1CUe/dUFCYsIGEl0NPcxQpSISOx78Y4R5B4JgXvs
	EieOTmGF2CUg8W3yIRaIXlmJTQeg4SApcXDFDZYJwBBAsnkWks2zkGyehWTFAkaWVYyiqQXJ
	BcVJ6UXGesWJucWleel6yfm5mxghcdq/g/HuAetDjMlA6ycyS4km5wPjPK8k3tDY2MTMxNTE
	3NLU3JQ0YSVxXvlLMoFCAumJJanZqakFqUXxRaU5qcWHGJk4OKUaGDOS/vHt+GMVpsDVtXBB
	hOFZoXSf/wfOe/JuPODWoxHR0rOaUX1NtKp5SfekTw8YXD4tP8W28GBPPW/+armHU+cknVNw
	W9Vb9ThgWtn7+1m31NKZZySxWBjuuPzMONroj1ePcdWdkA2eU05N28Dfn7Yqsu34mk8SJmvz
	Lh2eW+7Ps98yncnUXYmlOCPRUIu5qDgRABpyoXHpAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCKsWRmVeSWpSXmKPExsVy+t9jQd1zEvqBBmdeGFksuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLG8/Rt7wVvuijvt31kaGF9xdjFyckgImEis
	XviHFcIWk7hwbz1bFyMXh5DAdEaJNa1f2UESQgK/GCW+nHEAsdkE1CS+fDkMFOfgEBHQl2hr
	0QCpZxboZZQ407sbqt5W4lhbGwuIzSlgJ/H76VGwBcICERI9PW+ZQGwWAVWJlzfug8V5geqP
	zL8OZQtK/Jh8D6yXWUBLYv3O40wQtrzE5jVvmUH2SgioSzz6qwsSFhEwkuho7mOEKBGR2Pfi
	HeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5rpFecmFtcmpeul5yfu4kRnAaeSe9g
	XNVgcYhRgINRiYe3w0QvUIg1say4MvcQowQHs5IIrwu/fqAQb0piZVVqUX58UWlOavEhxmSg
	RycyS4km5wNTVF5JvKGxiZmRpZGZhZGJuTlpwkrivIynngQICaQnlqRmp6YWpBbBbGHi4JRq
	YBQ6ej/+u/zGfQrrt8Z9st9clFjeuyFzbalo8PIG/utLl1tfkdhiuFXIe/MtnsXiyk9Sj7RN
	5hIwKPbdaT3nZcxFtRltPO3Bu7ZZ/F2bq/Tj/707B1YddUjvn3nzkDP3ti0PglZ/PMswq7Zh
	uYrEg7Oc13quJ+1S5MtbIZAx2bNp5dxeJvtun1YlluKMREMt5qLiRAARN/XtRwMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__init/__exit annotations for probe()/remove() are supposed to be
__devinit/__devexit, because __init/__exit for probe()/remove()
are not correct. However, __devinit/__devexit are not used,
because CONFIG_HOTPLUG was removed. Thus, these annotations
should be removed.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-at91rm9200.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-at91rm9200.c b/drivers/rtc/rtc-at91rm9200.c
index 434ebc3..055dafa 100644
--- a/drivers/rtc/rtc-at91rm9200.c
+++ b/drivers/rtc/rtc-at91rm9200.c
@@ -260,7 +260,7 @@ static const struct rtc_class_ops at91_rtc_ops = {
 /*
  * Initialize and install RTC driver
  */
-static int __init at91_rtc_probe(struct platform_device *pdev)
+static int at91_rtc_probe(struct platform_device *pdev)
 {
 	struct rtc_device *rtc;
 	struct resource *regs;
@@ -321,7 +321,7 @@ static int __init at91_rtc_probe(struct platform_device *pdev)
 /*
  * Disable and remove the RTC driver
  */
-static int __exit at91_rtc_remove(struct platform_device *pdev)
+static int at91_rtc_remove(struct platform_device *pdev)
 {
 	struct rtc_device *rtc = platform_get_drvdata(pdev);
 
@@ -382,7 +382,7 @@ static const struct dev_pm_ops at91_rtc_pm = {
 #endif
 
 static struct platform_driver at91_rtc_driver = {
-	.remove		= __exit_p(at91_rtc_remove),
+	.remove		= at91_rtc_remove,
 	.driver		= {
 		.name	= "at91_rtc",
 		.owner	= THIS_MODULE,
-- 
1.7.2.5


