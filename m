Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab3B1IqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:46:09 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52690 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab3B1IqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:46:07 -0500
X-AuditID: cbfee691-b7faa6d000005ae9-12-512f194c35cc
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
In-reply-to: <00a501ce158e$ef171610$cd454230$%han@samsung.com>
Subject: [PATCH 18/19] rtc: rtc-sh: remove erroneous __init/__exit annotations
Date: Thu, 28 Feb 2013 17:46:04 +0900
Message-id: <00b601ce1590$0af4eaa0$20debfe0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Vju7DHmrOxtsNRmyyH1DU6RVYuAAAQ2Lg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPIsWRmVeSWpSXmKPExsVy+t8zY10fSf1Ag2urNCwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAldG29uNTAWXuSqOrtvC3MD4jKOLkZNDQsBE4ui8w+wQtpjEhXvr
	2boYuTiEBJYxSqw9sIwVpujmlC52iMQiRomFvWeYIZzZTBI3b04Aq2ITUJP48gVkFAeHiIC+
	RFuLBkgNs0Avo8SZ3t1gK4QEbCWOtbWxgNicAnYSv58eBesVFvCT2LZ3GzOIzSKgKvG99QqY
	zQtUv3j/O3YIW1Dix+R7YL3MAloS63ceZ4Kw5SU2r3nLDLJXQkBd4tFfXYgTjCSWn6qFqBCR
	2PfiHSPIORICi9glPvUdYYNYJSDxbfIhFohWWYlNB5gh/pWUOLjiBssERolZSBbPQrJ4FpLF
	s5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJLIm7mC8f8D6EGMy0PqJzFKiyfnA
	yMwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsap
	O0x67+s1bE/c47I6JT+hP2PZjIZkMW/R1/VzlC60V9+4ef9q+aJ2EYXTLjNeKu/18l4ifGGq
	wAHN7Z+Pe5gkbZXSDdpRErI0QHR27TdVnVfbZ1il9Gzqb2Hh7uI+6xBsbLT3Rr5ict8u0w2s
	U5szPMyDZy6fFi7v8KD6z13uT3zBeq7/XiixFGckGmoxFxUnAgBl9V9KwgIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+xgK6PpH6gwfldShaXd81hc2D0+LxJ
	LoAxqoHRJiM1MSW1SCE1Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdo
	qpJCWWJOKVAoILG4WEnfDtOE0BA3XQuYxghd35AguB4jAzSQsI4xo+3tRqaCy1wVR9dtYW5g
	fMbRxcjJISFgInFzShc7hC0mceHeerYuRi4OIYFFjBILe88wQzizmSRu3pzAClLFJqAm8eXL
	YaAODg4RAX2JthYNkBpmgV5GiTO9u8EmCQnYShxra2MBsTkF7CR+Pz0K1iss4Cexbe82ZhCb
	RUBV4nvrFTCbF6h+8f537BC2oMSPyffAepkFtCTW7zzOBGHLS2xe85YZZK+EgLrEo7+6ECcY
	SSw/VQtRISKx78U7xgmMQrOQDJqFZNAsJINmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10v
	OT93EyM4bp9J72Bc1WBxiFGAg1GJh7fDRC9QiDWxrLgy9xCjBAezkgivC79+oBBvSmJlVWpR
	fnxRaU5q8SHGZKA/JzJLiSbnA1NKXkm8obGJmZGlkZmFkYm5OWnCSuK8jKeeBAgJpCeWpGan
	phakFsFsYeLglGpg7EpW33fQuHvpfCV/qfh3cgw7N9ofyzwr+lmqoEHrq+YRxp9ZT4q+cU81
	9H877Q+nZcGMPfHd1k1L1xw/0hd8vvyKJdeSX7xhy/ap7rBy/9guOqu67KnhQbnkqF0eyzLP
	+7+sDOXk/b1VeHf8Uud1ZccMOnVnLjr33alCe3lJ5PbtFr4Gu9ZnKbEUZyQaajEXFScCAADk
	uOgfAwAA
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
 drivers/rtc/rtc-sh.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-sh.c b/drivers/rtc/rtc-sh.c
index e55a763..b75eb5c 100644
--- a/drivers/rtc/rtc-sh.c
+++ b/drivers/rtc/rtc-sh.c
@@ -585,7 +585,7 @@ static struct rtc_class_ops sh_rtc_ops = {
 	.alarm_irq_enable = sh_rtc_alarm_irq_enable,
 };
 
-static int __init sh_rtc_probe(struct platform_device *pdev)
+static int sh_rtc_probe(struct platform_device *pdev)
 {
 	struct sh_rtc *rtc;
 	struct resource *res;
@@ -747,7 +747,7 @@ err_badres:
 	return ret;
 }
 
-static int __exit sh_rtc_remove(struct platform_device *pdev)
+static int sh_rtc_remove(struct platform_device *pdev)
 {
 	struct sh_rtc *rtc = platform_get_drvdata(pdev);
 
@@ -817,7 +817,7 @@ static struct platform_driver sh_rtc_platform_driver = {
 		.owner	= THIS_MODULE,
 		.pm	= &sh_rtc_dev_pm_ops,
 	},
-	.remove		= __exit_p(sh_rtc_remove),
+	.remove		= sh_rtc_remove,
 };
 
 static int __init sh_rtc_init(void)
-- 
1.7.2.5


