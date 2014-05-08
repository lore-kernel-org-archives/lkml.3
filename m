Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199AbaEHDt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:49:26 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:38103 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbaEHDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:49:04 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-cf-536afeaf13dc
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v4 3/4] ARM: S3C24XX: move S3C24XX clock Kconfig options to
 Samsung clock Kconfig file
Date: Thu, 08 May 2014 13:07:10 +0900
Message-id: <1399522031-3394-4-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrJLMWRmVeSWpSXmKPExsVy+t8zI931/7KCDQ5ulLCYtO4Ak0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7vF+hmvWRw4PFqae9g8/q56weyxeUm9R9+WVYwe
	nzfJBbBGcdmkpOZklqUW6dslcGXse/eKpeCkYMXSO2uZGxg38XUxcnJICJhIdM36xAZhi0lc
	uLceyObiEBJYxijR13GcBaao4WUDVGI6o8TtvQ9ZIZw2Jon5bSeZQarYBHQlnryfC2aLCGRL
	XGm8zwxSxCywiFHizo9pYDuEBTIkPh5YxwpiswioSvy93McIYvMKuEts6z4JVMMBtE5BYs4k
	GxCTU8BDYvJJa5AKIaCKd8c3gx0hIbCIXWL63wtMEGMEJL5NPsQC0SorsekAM8TRkhIHV9xg
	mcAovICRYRWjaGpBckFxUnqRqV5xYm5xaV66XnJ+7iZGSLBP3MF4/4D1IcZkoHETmaVEk/OB
	0ZJXEm9obGZkYWpiamxkbmlGmrCSOG/6o6QgIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYyz
	nx/PZj48TbXE2qozOdRx/7Eb7I96VormutuvNv5QIsEkLd/5OFYuJWGx9MSlPlJR5kf+yr1c
	l8OjWZ+tMlfcam+RtduGT5rrGA/2n49YdNgxrbnsqnbDSsYnG1QuxUZr/t1em9XQZMZ4pnqu
	+TFZ7p1zRfw7wsQUQguXVBoL3T10LM/onhJLcUaioRZzUXEiAAAIQM2MAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrGIsWRmVeSWpSXmKPExsVy+t9jQd31/7KCDRq+CFtMWneAyaJ3wVU2
	i02Pr7FaXN41h81ixvl9TBa3L/NaLNr6hd1i/YzXLA4cHi3NPWwef1e9YPbYvKTeo2/LKkaP
	z5vkAlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0y
	c4BOUVIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFm7Hv3iqXgpGDF0jtr
	mRsYN/F1MXJySAiYSDS8bGCDsMUkLtxbD2RzcQgJTGeUuL33ISuE08YkMb/tJDNIFZuArsST
	93PBbBGBbIkrjfeZQYqYBRYxStz5MQ1slLBAhsTHA+tYQWwWAVWJv5f7GEFsXgF3iW3dJ4Fq
	OIDWKUjMmWQDYnIKeEhMPmkNUiEEVPHu+Ga2CYy8CxgZVjGKphYkFxQnpeca6RUn5haX5qXr
	JefnbmIEx9Iz6R2MqxosDjEKcDAq8fBmOGcFC7EmlhVX5h5ilOBgVhLh9Z8MFOJNSaysSi3K
	jy8qzUktPsSYDHTTRGYp0eR8YJznlcQbGpuYGVkamVkYmZibkyasJM57sNU6UEggPbEkNTs1
	tSC1CGYLEwenVANj+nP239vDV3al7vCcxPR9UUKbAG/MDdFDG+QY9PovKH1T+2KebPRiyoJl
	XxdMVlObFmn6gCHw0SpHn+xzXvoGq41S1m39E8bhYGwopmZXu8XpxblvKxWul0Won73D90Sk
	eWrq5r83e5jt3uy9KRayaWXY8y//ri4Oyjy5r7pH5Y72U5viUw3qSizFGYmGWsxFxYkAIoxJ
	O+kCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves S3C24XX specific clock Kconfig options into
"clk/samsung/Kconfig" and also removes COMMON_CLK selection from
"mach-s3c24xx/Kconfig" as S3C24XX_COMMON_CLK is selecting it's dependency.

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-s3c24xx/Kconfig |   14 --------------
 drivers/clk/samsung/Kconfig   |    9 +++++++++
 2 files changed, 9 insertions(+), 14 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index fbafb9a..e645ece 100644
--- a/arch/arm/mach-s3c24xx/Kconfig
+++ b/arch/arm/mach-s3c24xx/Kconfig
@@ -39,7 +39,6 @@ config CPU_S3C2410
 
 config CPU_S3C2412
 	bool "SAMSUNG S3C2412"
-	select COMMON_CLK
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2412_COMMON_CLK
@@ -50,7 +49,6 @@ config CPU_S3C2412
 
 config CPU_S3C2416
 	bool "SAMSUNG S3C2416/S3C2450"
-	select COMMON_CLK
 	select CPU_ARM926T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2416_PM if PM
@@ -88,7 +86,6 @@ config CPU_S3C244X
 
 config CPU_S3C2443
 	bool "SAMSUNG S3C2443"
-	select COMMON_CLK
 	select CPU_ARM920T
 	select CPU_LLSERIAL_S3C2440
 	select S3C2443_COMMON_CLK
@@ -364,11 +361,6 @@ config S3C2412_PM_SLEEP
 
 if CPU_S3C2412
 
-config S3C2412_COMMON_CLK
-	bool
-	help
-	  Build the s3c2412 clock driver based on the common clock framework.
-
 config CPU_S3C2412_ONLY
 	bool
 	depends on !CPU_S3C2410 && !CPU_S3C2416 && !CPU_S3C2440 && \
@@ -651,12 +643,6 @@ endif	# CPU_S3C2442
 
 if CPU_S3C2443 || CPU_S3C2416
 
-config S3C2443_COMMON_CLK
-	bool
-	help
-	  Temporary symbol to build the clock driver based on the common clock
-	  framework.
-
 config S3C2443_DMA
 	bool
 	help
diff --git a/drivers/clk/samsung/Kconfig b/drivers/clk/samsung/Kconfig
index fc8696b..baf28cb 100644
--- a/drivers/clk/samsung/Kconfig
+++ b/drivers/clk/samsung/Kconfig
@@ -1,3 +1,12 @@
 config COMMON_CLK_SAMSUNG
 	bool
 	select COMMON_CLK
+
+config S3C2412_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
+
+config S3C2443_COMMON_CLK
+	bool
+	select COMMON_CLK_SAMSUNG
+
-- 
1.7.10.4

