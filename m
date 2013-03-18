Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3CRJdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 05:33:00 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:48962 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3CRJc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 05:32:56 -0400
X-AuditID: cbfee690-b7f656d0000007e3-6f-5146df475562
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>
References: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
In-reply-to: <01b701ce23bb$1b79b2a0$526d17e0$%han@samsung.com>
Subject: [PATCH 10/10] rtc: rtc-tps80031: switch to using SIMPLE_DEV_PM_OPS
Date: Mon, 18 Mar 2013 18:32:55 +0900
Message-id: <01c001ce23bb$91d05850$b57108f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4juxtMJTZWEDnPSfOGR4wzonE6SAAAGfTQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrAIsWRmVeSWpSXmKPExsVy+t8zY133+26BBjfvyFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MC9MbGAs2s1Xs2/mXsYFxE2sXIyeHhICJxLZ1mxkhbDGJC/fW
	s3UxcnEICSxjlLh77T4jTNGOY8ehEosYJb7Of8kC4cxmkph0ZhkzSBWbgJrEly+H2bsYOThE
	BPQl2lo0QGqYBXoZJc707mYHqRESsJWYd20x2FROATuJrf2TwM4QFvCW+HfvPpjNIqAqse/6
	JbAaXqD6Jye+M0HYghI/Jt9jAbGZBbQk1u88zgRhy0tsXvOWGWSvhIC6xKO/uiBhEQEjicOf
	X7BDlIhI7HvxjhHkHgmBZewST/cshNolIPFt8iEWiF5ZiU0HmCEelpQ4uOIGywRGiVlINs9C
	snkWks2zkKxYwMiyilE0tSC5oDgpvchErzgxt7g0L10vOT93EyMktibsYLx3wPoQYzLQ+onM
	UqLJ+cDYzCuJNzQ2M7IwNTE1NjK3NCNNWEmcV73FOlBIID2xJDU7NbUgtSi+qDQntfgQIxMH
	p1QDo5+xq2CsUrf/wuxPBTsVl9xqMPwwxXBl5/Ig9+Uivy9o3FpkF8PXOoVBds7P3PCZG7i0
	NstMefXQrUGhUPnkhinS0794ehssYO50/Xuib279utXr27KXvp0e78r1i9+3OEBse+eFE/aR
	SQIldqIP/x5V4lpxf5vf+1eTe12PyE2tuurk4/qwWYmlOCPRUIu5qDgRAI9gsWPDAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+xgK77fbdAg4WbJC0u75rD5sDo8XmT
	XABjVAOjTUZqYkpqkUJqXnJ+SmZeuq2Sd3C8c7ypmYGhrqGlhbmSQl5ibqqtkotPgK5bZg7Q
	VCWFssScUqBQQGJxsZK+HaYJoSFuuhYwjRG6viFBcD1GBmggYR1jxoXpDYwFm9kq9u38y9jA
	uIm1i5GTQ0LARGLHseNsELaYxIV764FsLg4hgUWMEl/nv2SBcGYzSUw6s4wZpIpNQE3iy5fD
	7F2MHBwiAvoSbS0aIDXMAr2MEmd6d7OD1AgJ2ErMu7aYEcTmFLCT2No/CWybsIC3xL9798Fs
	FgFViX3XL4HV8ALVPznxnQnCFpT4MfkeC4jNLKAlsX7ncSYIW15i85q3zCB7JQTUJR791QUJ
	iwgYSRz+/IIdokREYt+Ld4wTGIVmIZk0C8mkWUgmzULSsoCRZRWjaGpBckFxUnquoV5xYm5x
	aV66XnJ+7iZGcOQ+k9rBuLLB4hCjAAejEg/vjvVugUKsiWXFlbmHGCU4mJVEeB1vA4V4UxIr
	q1KL8uOLSnNSiw8xJgM9OpFZSjQ5H5hU8kriDY1NzIwsjcwsjEzMzUkTVhLnPdBqHSgkkJ5Y
	kpqdmlqQWgSzhYmDU6qBcaXG8Ud9Os4uXGcW7yt+yLYiiXXiGRUOS8HquIq6Xdvfyy7rtFTc
	v+nVNCfHd4UPpGf73av5Y/Dqy/1d3gVvZ+1+eeLZajmRwxnmykt4X1SIPl+fkynAHLFl3pKe
	7vJpf855N5p1z2X6eylD3D0iku0H447a55fDTWd8/li7hmnqMW39t6ma9UosxRmJhlrMRcWJ
	AGhHYOcgAwAA
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
 drivers/rtc/rtc-tps80031.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-tps80031.c b/drivers/rtc/rtc-tps80031.c
index dc62d5f..72662ea 100644
--- a/drivers/rtc/rtc-tps80031.c
+++ b/drivers/rtc/rtc-tps80031.c
@@ -323,9 +323,8 @@ static int tps80031_rtc_resume(struct device *dev)
 };
 #endif
 
-static const struct dev_pm_ops tps80031_pm_ops = {
-	SET_SYSTEM_SLEEP_PM_OPS(tps80031_rtc_suspend, tps80031_rtc_resume)
-};
+static SIMPLE_DEV_PM_OPS(tps80031_pm_ops, tps80031_rtc_suspend,
+			tps80031_rtc_resume);
 
 static struct platform_driver tps80031_rtc_driver = {
 	.driver	= {
-- 
1.7.2.5


