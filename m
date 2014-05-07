Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755675AbaEGIho (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 04:37:44 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:15589 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaEGIhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 04:37:42 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-ca-5369f0d4986a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "'Alessandro Zummo'" <a.zummo@towertech.it>,
        rtc-linux@googlegroups.com, "'Jingoo Han'" <jg1.han@samsung.com>,
        "'Laxman Dewangan'" <ldewangan@nvidia.com>
References: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
In-reply-to: <020f01cf69ce$bf617b50$3e2471f0$%han@samsung.com>
Subject: [PATCH 5/5] rtc: rtc-palmas: Make of_device_id array const
Date: Wed, 07 May 2014 17:37:40 +0900
Message-id: <021601cf69cf$9b96ece0$d2c4c6a0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9pzr9CTHGzqjsGTXmFpMFJp7KU/wAAL7eg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAIsWRmVeSWpSXmKPExsVy+t8zI90rHzKDDbruW1gsuXiV3WLO+jVs
	FpcXXmK1WLpvNYvF5V1z2Cz2d3YwOrB57Jl4ks3jxIzfLB69ze/YPPq2rGL0mD7vJ5PH501y
	AWxRXDYpqTmZZalF+nYJXBm9u1axFexhrZhzt5mpgfEoSxcjJ4eEgInEvje/mCBsMYkL99az
	gdhCAssYJe60JcLUzP16nLWLkQsoPp1RYtqy/1DOb0aJPategnWzCahJfPlymL2LkYNDREBf
	oq1FA6SGWWAno8TartnMEFNtJdY2fwXbwClgJzH5yFR2EFtYwFmib/NNsItYBFQlbu+ZzgIy
	hxeofs3zCJAwr4CgxI/J98BKmAW0JNbvPM4EYctLbF7zlhmkXEJAXeLRX12QsIiAkUTX/2Y2
	iBIRiX0v3jGCnCMh8JVd4sbZNmaIVQIS3yYfYoHolZXYdIAZ4l9JiYMrbrBMYJSYhWTzLCSb
	ZyHZPAvJigWMLKsYRVMLkguKk9KLTPWKE3OLS/PS9ZLzczcxQmJ34g7G+wesDzEmA62fyCwl
	mpwPjP28knhDYzMjC1MTU2Mjc0sz0oSVxHnTHyUFCQmkJ5akZqemFqQWxReV5qQWH2Jk4uCU
	amDsZX21aI/Tp9/hNjzur9NcLqdf9l6/Yq+M5a7Ku5/2eqXY3c16G+CvmXKlZLVl7KEF6UbS
	/KazxGbL2JQqmT9yO/x7fqZYn+BMI/WJEdrPJ+3bU9qh7Hp0vud+ATYLBQPrXDG/yQK3jXKt
	lQvuL30sZfD5zZ2Df1/kWH0T+uGx9ZtcbCJvwEMlluKMREMt5qLiRAAL0R988wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHKsWRmVeSWpSXmKPExsVy+t9jQd0rHzKDDRY/N7FYcvEqu8Wc9WvY
	LC4vvMRqsXTfahaLy7vmsFns7+xgdGDz2DPxJJvHiRm/WTx6m9+xefRtWcXoMX3eTyaPz5vk
	AtiiGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm9O5axVawh7Vizt1mpgbG
	oyxdjJwcEgImEnO/HmeFsMUkLtxbz9bFyMUhJDCdUWLasv+sEM5vRok9q14ygVSxCahJfPly
	mL2LkYNDREBfoq1FA6SGWWAno8TartnMIDVCArYSa5u/soHYnAJ2EpOPTGUHsYUFnCX6Nt8E
	28wioCpxe890FpA5vED1a55HgIR5BQQlfky+B1bCLKAlsX7ncSYIW15i85q3zCDlEgLqEo/+
	6oKERQSMJLr+N7NBlIhI7HvxjnECo9AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtO
	zC0uzUvXS87P3cQITg3PpHYwrmywOMQowMGoxMNr8TYjWIg1say4MvcQowQHs5II766LmcFC
	vCmJlVWpRfnxRaU5qcWHGJOB/pzILCWanA9MW3kl8YbGJmZGlkZmFkYm5uakCSuJ8x5otQ4U
	EkhPLEnNTk0tSC2C2cLEwSnVwJhgXjBb9cx+C332j5pVOz7O8HZebNbUdMyi3PZDeLSPnoFk
	hNm8yLhMDxutC4c2F/K9W6kq9z3kzCrXuYoH+wS+3PzcdSLfyF82Nv7/gpUSz0xr1VQ2npF4
	r3K7uO75ZL2DHIwcvWs85+3Ja+Ayv9LBZPy94O88vQ3d4s6XHrncszCMOspsq8RSnJFoqMVc
	VJwIADhMgepRAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make of_device_id array const, because all OF functions
handle it as const.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/rtc/rtc-palmas.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-palmas.c b/drivers/rtc/rtc-palmas.c
index c360d62..4dfe2d7 100644
--- a/drivers/rtc/rtc-palmas.c
+++ b/drivers/rtc/rtc-palmas.c
@@ -352,7 +352,7 @@ static SIMPLE_DEV_PM_OPS(palmas_rtc_pm_ops, palmas_rtc_suspend,
 			 palmas_rtc_resume);
 
 #ifdef CONFIG_OF
-static struct of_device_id of_palmas_rtc_match[] = {
+static const struct of_device_id of_palmas_rtc_match[] = {
 	{ .compatible = "ti,palmas-rtc"},
 	{ },
 };
-- 
1.7.10.4


