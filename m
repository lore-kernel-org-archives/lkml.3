Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021AbaCLERs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 00:17:48 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:29800 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752462AbaCLEQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 00:16:52 -0400
X-AuditID: cbfee691-b7efc6d0000039d3-42-531fdfb2f3bf
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Cc: Pankaj Dubey <pankaj.dubey@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v2 4/4] ARM: S3C24XX: remove S3C24XX specific clock Kconfig
 options
Date: Wed, 12 Mar 2014 13:33:01 +0900
Message-id: <1394598781-3848-5-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
References: <1394598781-3848-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t8zA91N9+WDDfYuYLOYtO4Ak0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7sDu0dLcw+bx99VL5g9Ni+p9+jbsorR4/MmuQDW
	KC6blNSczLLUIn27BK6Mb2vnMBY08lW0LnjO2MC4gbuLkZNDQsBEYv6l0+wQtpjEhXvr2UBs
	IYFljBJHzknA1Nx+shSohgsoPp1RYk1XC5TTxiSx+N5uFpAqNgFdiSfv5zKD2CIC2RKXZt1i
	ASliFpjJKLFo9RmwhLBAqMT6KbvAVrAIqEr0998AW80r4C7RPm8JkM0BtE5BYs4kG5Awp4CH
	xM6fpxghLnKX2HVoJ9Sl89glLkxighgjIPFt8iEWiFZZiU0HmCFKJCUOrrjBMoFReAEjwypG
	0dSC5ILipPQiU73ixNzi0rx0veT83E2MkACfuIPx/gHrQ4zJQOMmMkuJJucDIySvJN7Q2MzI
	wtTE1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgb8j9uuN1R/bL3
	heVKhh+W84trlgQoLDluya7ln9Jm9++KtfFEi9kicjJf+qc9nfDJ6+e3Du8E198zNvlPT5w7
	5Utt9DOdP4Hzj4fcav4VNMUsX80n58mB0kcdapZVVzK6xSJkS3P37nuws/+8ccf3fdNMlv9z
	vssYkZzJ43P8dVP1rZXFW+4psRRnJBpqMRcVJwIAhC1n94YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t9jQd1N9+WDDRZOYrKYtO4Ak0Xvgqts
	FpseX2O1uLxrDpvFjPP7mCxuX+a1WLT1C7sDu0dLcw+bx99VL5g9Ni+p9+jbsorR4/MmuQDW
	qAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zBygK5QU
	yhJzSoFCAYnFxUr6dpgmhIa46VrANEbo+oYEwfUYGaCBhHWMGd/WzmEsaOSraF3wnLGBcQN3
	FyMnh4SAicTtJ0vZIWwxiQv31rN1MXJxCAlMZ5RY09XCDuG0MUksvrebBaSKTUBX4sn7ucwg
	tohAtsSlWbdYQIqYBWYySixafQYsISwQKrF+yi42EJtFQFWiv/8G2ApeAXeJ9nlLgGwOoHUK
	EnMm2YCEOQU8JHb+PMUIYgsBlew6tJN9AiPvAkaGVYyiqQXJBcVJ6bmGesWJucWleel6yfm5
	mxjBMfRMagfjygaLQ4wCHIxKPLwLNOWDhVgTy4orcw8xSnAwK4nwfgQJ8aYkVlalFuXHF5Xm
	pBYfYkwGOmois5Rocj4wvvNK4g2NTcyMLI3MLIxMzM1JE1YS5z3Qah0oJJCeWJKanZpakFoE
	s4WJg1OqgXHZmRe7eJ3W6Imx65y7efihUVu27ymhp2smip7sfOea/d/60k3NLRK8fEvyYk5E
	eb8s/FJxRG1l/1STBKGfktc1zj9jmXS2siF+wwt7/3k8h57lTGB2O88QkHqfffltZd9f7XNK
	Ty307GOY39S2JkBjQW4Ft1NlnNbS7QVGr64IqRxvnWdzxUGJpTgj0VCLuag4EQB4aMEV5QIA	AA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes S3C24XX specific clock Kconfig options as
it has been moved into "drivers/clk/samsung/Kconfig" also removes
COMMON_CLK selection as COMMON_CLK_SAMSUNG is selecting it's dependency.

CC: Ben Dooks <ben-linux@fluff.org>
CC: Kukjin Kim <kgene.kim@samsung.com>
CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/mach-s3c24xx/Kconfig |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/arch/arm/mach-s3c24xx/Kconfig b/arch/arm/mach-s3c24xx/Kconfig
index 80373da..2d1232e 100644
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
-- 
1.7.9.5

