Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933050Ab3ECGfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:35:54 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22582 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932967Ab3ECGfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:35:51 -0400
X-AuditID: cbfee68d-b7f016d000007930-3b-51835aad10d0
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 29/42] rtc: rtc-pcap: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:35:25 +0900
Message-id: <002b01ce47c8$65026490$2f072db0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyGK3ouQQaLdmRdmHKzT0A8z8Bw==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zA921Uc2BBncXy1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGsVlk5Kak1mW
	WqRvl8CVsebAfbaC9TwVPbsvsDUwTuLqYuTkkBAwkfhy+AUbhC0mceHeejBbSGAZo8S2qwow
	NX3tT1i6GLmA4tMZJRqaGtkgnF+MEuf3f2EBqWITUJP48uUwexcjB4eIgL5EW4sGSA2zQDej
	xKPmucwgNcIC/hJfr3cygdgsAqoSDXfvgG3jFbCU+L1vOhOELSjxY/I9sJnMAloS63ceZ4Kw
	5SU2r3nLDHGRgsSOs68ZQWwRAT2JVZNa2SFqRCT2vXjHCLJYQuAYu8S/xplQywQkvk0+xAJy
	nISArMSmA1BzJCUOrrjBMoFRbBaS1bOQrJ6FZPUsJCsWMLKsYhRNLUguKE5KLzLUK07MLS7N
	S9dLzs/dxAiJvd4djLcPWB9iTAZaP5FZSjQ5Hxi7eSXxhsZmRhamJqbGRuaWZqQJK4nzqrVY
	BwoJpCeWpGanphakFsUXleakFh9iZOLglGpgDGh/eWrzrnjVrM9nrf3vf66S8Nicovz4c65A
	ytqEImFTq6bS+qDsk2umGwa5buflD7OesezxsbTZFSZhs24LbWY8rqRxVrR1//QHt2UMeM72
	3HqQvURh1v6IYOHWvYn3M/s3/0n3vvQ4IvmNzcx/e8Rn8E8R2i/Ww7woZQdHg5+2XamdfXiF
	EktxRqKhFnNRcSIAZOETAtMCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHKsWRmVeSWpSXmKPExsVy+t9jQd21Uc2BBveXS1ssuXiV3WLO+jVs
	FpcXXmK1uLxrDpvF/s4ORgdWjz0TT7J5nJjxm8Wjb8sqRo/p834yeXzeJBfAGtXAaJORmpiS
	WqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDtF1JoSwxpxQoFJBY
	XKykb4dpQmiIm64FTGOErm9IEFyPkQEaSFjHmLHmwH22gvU8FT27L7A1ME7i6mLk5JAQMJHo
	a3/CAmGLSVy4t56ti5GLQ0hgOqNEQ1MjlPOLUeL8/i9gVWwCahJfvhxm72Lk4BAR0Jdoa9EA
	qWEW6GaUeNQ8lxmkRljAX+Lr9U4mEJtFQFWi4e4dNhCbV8BS4ve+6UwQtqDEj8n3wGYyC2hJ
	rN95nAnClpfYvOYtM8RFChI7zr5mBLFFBPQkVk1qZYeoEZHY9+Id4wRGgVlIRs1CMmoWklGz
	kLQsYGRZxSiaWpBcUJyUnmukV5yYW1yal66XnJ+7iREc28+kdzCuarA4xCjAwajEw6vQ0hQo
	xJpYVlyZe4hRgoNZSYTX7QdQiDclsbIqtSg/vqg0J7X4EGMy0KcTmaVEk/OBaSevJN7Q2MTM
	yNLIzMLIxNycNGElcd6DrdaBQgLpiSWp2ampBalFMFuYODilGhhtv+8XMD9urvuXy+hLzV/b
	sGnWe/9nrXQ6+mYSj2H+32N6C4Ti9h/+XPO4eUOdns6d5kznBMGKi+sOmm/btTM07lFTjub+
	Pxy8anwnmJeXusqvULTYnFETavcyjLNDyOx2c7tbEce6ouRZe1/HTc86uFClpNlswmsNVfWF
	qsbVt9Mba3fGn1RiKc5INNRiLipOBAC8fd/FMQMAAA==
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
 drivers/rtc/rtc-pcap.c |   13 ++++---------
 1 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-pcap.c b/drivers/rtc/rtc-pcap.c
index 539a90b..40b5c63 100644
--- a/drivers/rtc/rtc-pcap.c
+++ b/drivers/rtc/rtc-pcap.c
@@ -156,10 +156,8 @@ static int __init pcap_rtc_probe(struct platform_device *pdev)
 
 	pcap_rtc->rtc = devm_rtc_device_register(&pdev->dev, "pcap",
 					&pcap_rtc_ops, THIS_MODULE);
-	if (IS_ERR(pcap_rtc->rtc)) {
-		err = PTR_ERR(pcap_rtc->rtc);
-		goto fail;
-	}
+	if (IS_ERR(pcap_rtc->rtc))
+		return PTR_ERR(pcap_rtc->rtc);
 
 	timer_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_1HZ);
 	alarm_irq = pcap_to_irq(pcap_rtc->pcap, PCAP_IRQ_TODA);
@@ -167,17 +165,14 @@ static int __init pcap_rtc_probe(struct platform_device *pdev)
 	err = devm_request_irq(&pdev->dev, timer_irq, pcap_rtc_irq, 0,
 				"RTC Timer", pcap_rtc);
 	if (err)
-		goto fail;
+		return err;
 
 	err = devm_request_irq(&pdev->dev, alarm_irq, pcap_rtc_irq, 0,
 				"RTC Alarm", pcap_rtc);
 	if (err)
-		goto fail;
+		return err;
 
 	return 0;
-fail:
-	platform_set_drvdata(pdev, NULL);
-	return err;
 }
 
 static int __exit pcap_rtc_remove(struct platform_device *pdev)
-- 
1.7.2.5


