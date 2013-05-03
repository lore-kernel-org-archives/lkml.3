Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab3ECGgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:36:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22645 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:36:01 -0400
X-AuditID: cbfee68f-b7f066d000003683-07-51835acff27e
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 31/42] rtc: rtc-s3c: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:35:59 +0900
Message-id: <002d01ce47c8$798ae4a0$6ca0ade0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyHjWtsTIwtj7SOW/jCcWYMcKFw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrIIsWRmVeSWpSXmKPExsVy+t8zA93zUc2BBj+abCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2NjSy1rwnrvi/ZVjjA2MFzi7GDk5JARMJP6v2MAIYYtJXLi3nq2LkYtDSGAZo8T0
	tztZYIo+XGtmhEgsYpSY/f8wC4Tzi1HiXONNsCo2ATWJL18Os3cxcnCICOhLtLVogNQwC3Qz
	SjxqnssMUiMs4Cfx5es0sHUsAqoSd9YtBuvlFbCUmP1zCiOELSjxY/I9sDizgJbE+p3HmSBs
	eYnNa94yQ1ykILHj7GuwehEBPYk9Dy5C1YhI7HvxDuxSCYFj7BLHZu9gglgmIPFt8iEWkOMk
	BGQlNh2AmiMpcXDFDZYJjGKzkKyehWT1LCSrZyFZsYCRZRWjaGpBckFxUnqRsV5xYm5xaV66
	XnJ+7iZGSPT172C8e8D6EGMy0PqJzFKiyfnA6M0riTc0NjOyMDUxNTYytzQjTVhJnFetxTpQ
	SCA9sSQ1OzW1ILUovqg0J7X4ECMTB6dUA2Obl2phd0R0bFW3Tqgdi/Y7o4iPk94/Psp2hin+
	Ypj6pSCV6+EPEw2uiZb0N+rOPj9VPfjfDKeyex+tsv9VXje6qMN4Us332bF/3x9eO+nJ2eTb
	spkr4NG7thkXlj7fUyFYO/2w/LyjFzmurVThVr38rWSPv9z+bZNeTplzy+P5mnMdvtOuVE9R
	YinOSDTUYi4qTgQA/+98c9QCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jAd3zUc2BBmdaLSyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNjY0sta8J674v2VY4wNjBc4uxg5OSQETCQ+
	XGtmhLDFJC7cW8/WxcjFISSwiFFi9v/DLBDOL0aJc403WUCq2ATUJL58OczexcjBISKgL9HW
	ogFSwyzQzSjxqHkuM0iNsICfxJev08CmsgioStxZtxisl1fAUmL2zymMELagxI/J98DizAJa
	Eut3HmeCsOUlNq95ywxxkYLEjrOvwepFBPQk9jy4CFUjIrHvxTvGCYwCs5CMmoVk1Cwko2Yh
	aVnAyLKKUTS1ILmgOCk911CvODG3uDQvXS85P3cTIzi2n0ntYFzZYHGIUYCDUYmHV6GlKVCI
	NbGsuDL3EKMEB7OSCK/bD6AQb0piZVVqUX58UWlOavEhxmSgTycyS4km5wPTTl5JvKGxiZmR
	pZGZhZGJuTlpwkrivAdarQOFBNITS1KzU1MLUotgtjBxcEo1MOod4Xu/4b9Z7bSY+DM/8g57
	rgjpPql2J7asZZ+G5KXm+LMGJQ9/z7fXOuLI5VfzWY93wvSrtqL7LbRPOD9kVVjcJSXLtc0y
	wrs2ZnvNgiOdE94XLHIRz1kkdWLSJ/VXb05tcFRIk0n9K/rI8Zr4jx3HdHbonbz/qvDtzSgJ
	savvVBdVLQo/I6DEUpyRaKjFXFScCABTlI6DMQMAAA==
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
 drivers/rtc/rtc-s3c.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 14040b2..4d38c6b 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -421,8 +421,6 @@ static void s3c_rtc_enable(struct platform_device *pdev, int en)
 
 static int s3c_rtc_remove(struct platform_device *dev)
 {
-	platform_set_drvdata(dev, NULL);
-
 	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_unprepare(rtc_clk);
@@ -554,23 +552,20 @@ static int s3c_rtc_probe(struct platform_device *pdev)
 			  0,  "s3c2410-rtc alarm", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_alarmno, ret);
-		goto err_alarm_irq;
+		goto err_nortc;
 	}
 
 	ret = devm_request_irq(&pdev->dev, s3c_rtc_tickno, s3c_rtc_tickirq,
 			  0,  "s3c2410-rtc tick", rtc);
 	if (ret) {
 		dev_err(&pdev->dev, "IRQ%d error %d\n", s3c_rtc_tickno, ret);
-		goto err_alarm_irq;
+		goto err_nortc;
 	}
 
 	clk_disable(rtc_clk);
 
 	return 0;
 
- err_alarm_irq:
-	platform_set_drvdata(pdev, NULL);
-
  err_nortc:
 	s3c_rtc_enable(pdev, 0);
 	clk_disable_unprepare(rtc_clk);
-- 
1.7.2.5


