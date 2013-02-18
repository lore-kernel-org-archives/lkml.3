Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757565Ab3BRFNG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:13:06 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:56531 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016Ab3BRFNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:13:04 -0500
X-AuditID: cbfee691-b7f556d000001a24-1c-5121b85deac6
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 1/5 RESEND] video: s3c-fb: use ARCH_ dependancy
Date: Mon, 18 Feb 2013 14:13:01 +0900
Message-id: <000201ce0d96$9fa550b0$deeff210$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4Nlp93iQLgxtgRRimJ2C2xwhxUfA==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprDIsWRmVeSWpSXmKPExsVy+t8zfd3YHYqBBgcu61mc6PvAanF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKeTNjGVLCfraJn9wW2BsY1rF2MnBwSAiYSD3e1skDY
	YhIX7q1n62Lk4hASWMYocfXSSWaYoucvGlggEtMZJZb8XQTl/GKU+H6hiRGkik1ATeLLl8Ps
	XYwcHCIC+hJtLRogNcwCcxklLq05ArZCWMBeYt6x42CrWQRUJTqvv2cCqecVsJVYtswQJMwr
	ICjxY/I9sHJmAS2J9TuPM0HY8hKb17xlBimXEFCXePRXFyQsIqAn8WDTMagSEYl9L94xgqyV
	EJjOLtF+YjI7xCoBiW+TD7FA9MpKbDoA9ZekxMEVN1gmMIrNQrJ5FpLNs5BsnoVkxQJGllWM
	oqkFyQXFSelFpnrFibnFpXnpesn5uZsYITEzcQfj/QPWhxiTgdZPZJYSTc4HxlxeSbyhsbGJ
	mYmpibmlqbkpacJK4rzyl2QChQTSE0tSs1NTC1KL4otKc1KLDzEycXBKNTDOn9/T/mrV8SUS
	WQcMy9crbnKrk1zUkrjuaW+s3dL0p41CqYwbHew5nyhH3Z56scZTc9JrpbqpxQf6NmQsz/oe
	KrTX1FA1w6FTxPZh3seDQuFSfEri72K8jwVJtD97evXE2pzJk88KPS8+E3Goe70Mz8syF/WW
	r0+cbjvNLPhYcW3J5I2bfqUqsRRnJBpqMRcVJwIAIlfPwK8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJIsWRmVeSWpSXmKPExsVy+t9jQd3YHYqBBqdOaVmc6PvAanF51xw2
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgznkzYxlSwn62i
	Z/cFtgbGNaxdjJwcEgImEs9fNLBA2GISF+6tZ+ti5OIQEpjOKLHk7yIWCOcXo8T3C02MIFVs
	AmoSX74cZu9i5OAQEdCXaGvRAKlhFpjLKHFpzRGwScIC9hLzjh0H28AioCrRef09E0g9r4Ct
	xLJlhiBhXgFBiR+T74GVMwtoSazfeZwJwpaX2LzmLTNIuYSAusSjv7ogYREBPYkHm45BlYhI
	7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIjshn
	UjsYVzZYHGIU4GBU4uFlyFcMFGJNLCuuzD3EKMHBrCTCu0kEKMSbklhZlVqUH19UmpNafIgx
	GejPicxSosn5wGSRVxJvaGxiZmRpZGZhZGJuTpqwkjgv46knAUIC6YklqdmpqQWpRTBbmDg4
	pRoYN7092xNm7FK9umVVQP93lZAjTrvjBWV3z1m9Pe1QtrzjnOJ/YiuOyS2dvPLsoq7Sfff+
	dDLfaPBL/XiuaoIFq/7WnXrP/rz5zPHb/Fqt+5J1D/8fnMt306Vtxi6nkOsTS9NeXF68933P
	/AVOhsZux0RORG6RtpmiNzc75vRC/fmM15w2Xvw9tUWJpTgj0VCLuag4EQDGxPdsDAMAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch uses ARCH_ dependancy when using s3c-fb.
S3C_DEV_FB, S5P_DEV_FIMD0 cannot be enabled on EXYNOS5.
So, ARCH_ should be used as dependancy for s3c-fb.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/video/Kconfig b/drivers/video/Kconfig
index e7068c5..049fff1 100644
--- a/drivers/video/Kconfig
+++ b/drivers/video/Kconfig
@@ -2025,7 +2025,8 @@ config FB_TMIO_ACCELL
 
 config FB_S3C
 	tristate "Samsung S3C framebuffer support"
-	depends on FB && (S3C_DEV_FB || S5P_DEV_FIMD0)
+	depends on FB && (CPU_S3C2416 || ARCH_S3C64XX || ARCH_S5P64X0 || \
+		ARCH_S5PC100 || ARCH_S5PV210 || ARCH_EXYNOS)
 	select FB_CFB_FILLRECT
 	select FB_CFB_COPYAREA
 	select FB_CFB_IMAGEBLIT
-- 
1.7.2.5


