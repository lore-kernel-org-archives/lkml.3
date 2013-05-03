Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194Ab3ECGhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 02:37:36 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:61951 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933166Ab3ECGh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 02:37:29 -0400
X-AuditID: cbfee691-b7fe56d000004b96-2b-51835b2705a9
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, Jingoo Han <jg1.han@samsung.com>
Subject: [PATCH 36/42] rtc: rtc-twl: remove unnecessary platform_set_drvdata()
Date: Fri, 03 May 2013 15:37:27 +0900
Message-id: <003201ce47c8$adf66340$09e329c0$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac5HyK0fndltNsWRSr65OWgc+0TLaQ==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrAIsWRmVeSWpSXmKPExsVy+t8zI1316OZAg+3vrS2WXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjeKySUnNySxL
	LdK3S+DK2Lb8AntBH1vFnNZlLA2MbaxdjJwcEgImEm9272aDsMUkLtxbD2RzcQgJLGOU6J91
	CsjhACua91wZIj6dUeL46RmsEM4vRomlm76DdbMJqEl8+XKYHaRBREBfoq1FA6SGWaCbUeJR
	81xmkBphAT+J+z3HWUBsFgFVieNPVoLFeQUsJRqW32KBsAUlfky+B2YzC2hJrN95nAnClpfY
	vOYtM8SlChI7zr5mBLFFBPQkFnztYoeoEZHY9+IdI8hiCYFT7BK3n9xig1gmIPFt8iEWiG9k
	JTYdgJojKXFwxQ2WCYxis5CsnoVk9Swkq2chWbGAkWUVo2hqQXJBcVJ6kalecWJucWleul5y
	fu4mRkjsTdzBeP+A9SHGZKD1E5mlRJPzgbGbVxJvaGxmZGFqYmpsZG5pRpqwkjiveot1oJBA
	emJJanZqakFqUXxRaU5q8SFGJg5OqQbGrY5vYy+Gipv1si4qmHH+TNpq37uC1xv5TAT/T55+
	4B0n0+2HvJejl17uq1zf1R47MUwtxeSv0ZKvu5U2XXz0ZN3bCV/ZVHtdrs42XVnox627KFdl
	Gsv5vxdC3pzjic49W2lZdfpkCMPldM/dbEed1XRY1hfeY4sQmB26/MprOcnVm07Y/HrCp8RS
	nJFoqMVcVJwIABg66ATTAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLKsWRmVeSWpSXmKPExsVy+t9jQV316OZAgxWHLCyWXLzKbjFn/Ro2
	i8sLL7FaXN41h81if2cHowOrx56JJ9k8Tsz4zeLRt2UVo8f0eT+ZPD5vkgtgjWpgtMlITUxJ
	LVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wB2q6kUJaYUwoUCkgs
	LlbSt8M0ITTETdcCpjFC1zckCK7HyAANJKxjzNi2/AJ7QR9bxZzWZSwNjG2sXYwcHBICJhLz
	nit3MXICmWISF+6tZ+ti5OIQEpjOKHH89AxWCOcXo8TSTd/ZQKrYBNQkvnw5zA7SLCKgL9HW
	ogFSwyzQzSjxqHkuM0iNsICfxP2e4ywgNouAqsTxJyvB4rwClhINy2+xQNiCEj8m3wOzmQW0
	JNbvPM4EYctLbF7zlhniIgWJHWdfM4LYIgJ6Egu+drFD1IhI7HvxjnECo8AsJKNmIRk1C8mo
	WUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjuxnUjsYVzZYHGIU4GBU4uFVaGkK
	FGJNLCuuzD3EKMHBrCTC6/YDKMSbklhZlVqUH19UmpNafIgxGejTicxSosn5wKSTVxJvaGxi
	ZmRpZGZhZGJuTpqwkjjvgVbrQCGB9MSS1OzU1ILUIpgtTBycUg2Mygfamp+vfa76tGX3pKNN
	h0PefAz7cq8zMujYmi4T/k2nzX9OZimSlTblWZAgcMPpxjrFtVe/WJku71yxhTXzWsGR5SYm
	QZ09e+eEBHZlLHt/WsBy3dHDz6cJ/r8ePTt265wvZa4eF27ONWg98Zp3nfnKZL1Dc9ufqUZ2
	lixzbZt4fHLhlz17nimxFGckGmoxFxUnAgCLmlltMAMAAA==
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
 drivers/rtc/rtc-twl.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-twl.c b/drivers/rtc/rtc-twl.c
index 8751a52..103fea2 100644
--- a/drivers/rtc/rtc-twl.c
+++ b/drivers/rtc/rtc-twl.c
@@ -555,7 +555,6 @@ static int twl_rtc_remove(struct platform_device *pdev)
 	free_irq(irq, rtc);
 
 	rtc_device_unregister(rtc);
-	platform_set_drvdata(pdev, NULL);
 	return 0;
 }
 
-- 
1.7.2.5


