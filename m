Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbaEHDtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 23:49:23 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:46337 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbaEHDtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 23:49:04 -0400
X-AuditID: cbfee691-b7f3e6d000002ce8-ce-536afeaf2499
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Cc: kgene.kim@samsung.com, t.figa@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: [PATCH v4 2/4] ARM: select COMMON_CLK_SAMSUNG for ARCH_EXYNOS and
 ARCH_S3C64XX
Date: Thu, 08 May 2014 13:07:09 +0900
Message-id: <1399522031-3394-3-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
References: <1399522031-3394-1-git-send-email-pankaj.dubey@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t8zfd31/7KCDfbM47ToXXCVzWLT42us
	Fpd3zWGzmHF+H5PF7cu8Fou2fmG3WD/jNYsDu0dLcw+bx+Yl9R59W1YxenzeJBfAEsVlk5Ka
	k1mWWqRvl8CVcXT3JOaCo+wVax7NYm1gnMvWxcjJISFgIvFx+nNmCFtM4sK99UBxLg4hgWWM
	Eps/3mKEKXq47wIjRGI6o8SWiXtYIJw2JomP16ayglSxCehKPHk/F2yUiEC2xJXG+2A2s0C9
	xOazq8DWCQtESiz73csCYrMIqEocv/seLM4r4C5xuv06excjB9A2BYk5k2xATE4BD4nJJ61B
	KoSAKt4d3wx2nITAZHaJjokr2CDGCEh8m3yIBaJVVmLTAahnJCUOrrjBMoFReAEjwypG0dSC
	5ILipPQiU73ixNzi0rx0veT83E2MkLCeuIPx/gHrQ4zJQOMmMkuJJucD4yKvJN7Q2MzIwtTE
	1NjI3NKMNGElcd70R0lBQgLpiSWp2ampBalF8UWlOanFhxiZODilGhgntXDNWfXZ6juvIZ9U
	+DXDLpVzyl5Sr9MTZvlfOXL95BVDUY2z516fPbtU3H3mU3exf9u6RHSP2E9bq9Ef8MRPkOFJ
	msEVhpMrHE7O/8PGV3V2X98u8wj9e2HT61U2+XHNWNJXHpYy8cq6mZ6Kp+daWIvOqUp4+4oz
	sU1KgLFX+8yz57qPTuYosRRnJBpqMRcVJwIA/v4jUIECAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t9jQd31/7KCDQ4tYbXoXXCVzWLT42us
	Fpd3zWGzmHF+H5PF7cu8Fou2fmG3WD/jNYsDu0dLcw+bx+Yl9R59W1YxenzeJBfAEtXAaJOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ3w7ThNAQN10LmMYIXd+QILgeIwM0kLCOMePo7knMBUfZK9Y8msXawDiXrYuRk0NC
	wETi4b4LjBC2mMSFe+uB4lwcQgLTGSW2TNzDAuG0MUl8vDaVFaSKTUBX4sn7ucwgtohAtsSV
	xvtgNrNAvcTms6vApgoLREos+93LAmKzCKhKHL/7HizOK+Aucbr9OnsXIwfQNgWJOZNsQExO
	AQ+JySetQSqEgCreHd/MNoGRdwEjwypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4Kh5Jr2D
	cVWDxSFGAQ5GJR7eDOesYCHWxLLiytxDjBIczEoivP6TgUK8KYmVValF+fFFpTmpxYcYk4Fu
	msgsJZqcD4zovJJ4Q2MTMyNLIzMLIxNzc9KElcR5D7ZaBwoJpCeWpGanphakFsFsYeLglGpg
	zLPe+sI1vanz+N3XYp+N3vi63Of+FnyQyXm+whHJs7lfd6uf3Lps57wbqySuaDMLS9TyZzgk
	CP7a5svhMo9XZJPwlLjr2v82bgs9JP7u9KurYcu/JOcU3r5/0Hxmc07U7exzzxKfvl06dU7k
	qe3XHjmze3DsWmk656/A+Z6lt547OrMlCZ37oa/EUpyRaKjFXFScCADy4/SL3gIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch selects COMMON_CLK_SAMSUNG for EXYNOS and S3C64XX SoC
and removes COMMON_CLK selection as COMMON_CLK_SAMSUNG selects it's dependency.

CC: Russell King <linux@arm.linux.org.uk>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---
 arch/arm/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb..0edb868 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -754,7 +754,7 @@ config ARCH_S3C64XX
 	select ATAGS
 	select CLKDEV_LOOKUP
 	select CLKSRC_SAMSUNG_PWM
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V6K
 	select GENERIC_CLOCKEVENTS
 	select GPIO_SAMSUNG
@@ -835,7 +835,7 @@ config ARCH_EXYNOS
 	select ARCH_REQUIRE_GPIOLIB
 	select ARCH_SPARSEMEM_ENABLE
 	select ARM_GIC
-	select COMMON_CLK
+	select COMMON_CLK_SAMSUNG
 	select CPU_V7
 	select GENERIC_CLOCKEVENTS
 	select HAVE_S3C2410_I2C if I2C
-- 
1.7.10.4

