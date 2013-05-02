Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3EBHjT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 03:39:19 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:31992 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab3EBHjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 03:39:16 -0400
X-AuditID: cbfee691-b7fe56d000004b96-d0-51821822a189
Date: Thu, 02 May 2013 07:39:14 +0000 (GMT)
From: EUNBONG SONG <eunb.song@samsung.com>
Subject: [PATCH] MIPS: remove USB_EHCI_BIG_ENDIAN_{DESC,MMIO} depends on
 architecture symbol
To: "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Cc: florian@openwrt.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20130502073528604@eunb.song
Msgkey: 20130502073528604@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20130502073528604@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <26714880.190151367480353110.JavaMail.weblogic@epv6ml12>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjleLIzCtJLcpLzFFi42I5/e+Znq6SRFOgQdNaU4vLu+awOTB6fN4k
	F8AYxWWTkpqTWZZapG+XwJXx6uNM9oIN/BWdR96xNzD+4Oti5OQQElCRaPn/nbGLkYNDQsBE
	oneuNkhYQkBM4sK99WxdjFxAJcsYJdb+e8UGkTCR+LBmPQtEYj6jxIuzk1lAEixAgy5d/8sK
	YrMJaEu8/fIAzBYWiJE4u6iHHcQWEciS2LtlETOIzSwQK3H0cwcTxBHyEpNPXwar4RUQlDg5
	8wkLxDIlid9XjrJAxJUlWjf8YIeIS0jMmn6BFcLmlZjR/hSqXk5i2tc1zBC2tMT5WRsYYb5Z
	/P0xVJxf4tjtHUwQD/NKPLkfDDNm9+YvUD8KSEw9cxCqVV3i09yHUDafxJqFb1lgxuw6tZwZ
	pvf+lrlMEG8pSkzpfsgOYWtJfPmxjw3dW7wCLhLNp9azTmBUnoUkNQtJ+ywk7chqFjCyrGIU
	TS1ILihOSi8y1StOzC0uzUvXS87P3cQISQsTdzDeP2B9iDEZGCUTmaVEk/OBaSWvJN7Q2MzI
	wtTE1NjI3NKMNGElcV71FutAIYH0xJLU7NTUgtSi+KLSnNTiQ4xMHJxSDYwbz3+X/vrC9oO/
	u9YfhndfJhyyjHst31VvJNVvJ94WulVNprSt/EXTDNkXaRunpFkbN6wQCexOlFjw9Gj0T7Yl
	E5Qu+Vrfq+qRz/MLmr0rRnWyxT2xOVYXm1OChZwW1V/dw/3/xHeRdYt6pn6+epJ7vv33rnm6
	iczrfQSdCw1YVaR+8zc8llZiKc5INNRiLipOBAD3Wb/DIQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42I5/e/2TF0liaZAg1XPjSwu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xquPM9kLNvBXdB55x97A+IOvi5GTQ0hARaLl/3dGEFtCwETiw5r1LBC2mMSFe+vZuhi5gGrm
	M0q8ODsZLMEC1HDp+l9WEJtNQFvi7ZcHYLawQIzE2UU97CC2iECWxN4ti5hBbGaBWImjnzuY
	IJbJS0w+fRmshldAUOLkzCdQy5Qkfl85ygIRV5Zo3fCDHSIuITFr+gVWCJtXYkb7U6h6OYlp
	X9cwQ9jSEudnbWCEOXrx98dQcX6JY7d3AO3lAOt9cj8YZszuzV/YIGwBialnDkK1qkt8mvsQ
	yuaTWLPwLQvMmF2nljPD9N7fMpcJ4i1FiSndD9khbC2JLz/2saF7i1fARaL51HrWCYxys5Ck
	ZiFpn4WkHVnNAkaWVYyiqQXJBcVJ6RUmesWJucWleel6yfm5mxjBKerZkh2MDResDzEKcDAq
	8fB+0G0MFGJNLCuuzD3EKMHBrCTCu+A1UIg3JbGyKrUoP76oNCe1+BBjMjACJzJLiSbnA9Nn
	Xkm8obGBsaGhpbmBqaGRBWnCSuK8z1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwrk5ukQ5UFWWo
	fKFwef3E9xc1WyNYd8hN2/LPKqBXjrkxWYCjr3hD4Ipbi3kn9Cs/c/gbfPLg7WnH8l+4sU5l
	l5r2z/pnzLarc1IeugspnNIKMpnW4Pg3ZdcDi8Xta85e7riZx/ptzv+fz0PSjPXuSbBJL7cT
	dqsrWnu5IUdfcP6LvoDt7/aWKrEUZyQaajEXFScCAIXvBxWVAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r427dOS3002455


This patch removes the architecture specific symbols which prevent these
configuration symbols from being selected by platforms/architectures requiring it.
I reference commit 9296d94d83649e1c2f25c87dc4ead9c2ab073305.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/Kconfig |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index e5f3794..7dd3b65 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -355,8 +355,6 @@ config MIPS_SEAD3
 	select SYS_SUPPORTS_LITTLE_ENDIAN
 	select SYS_SUPPORTS_SMARTMIPS
 	select USB_ARCH_HAS_EHCI
-	select USB_EHCI_BIG_ENDIAN_DESC
-	select USB_EHCI_BIG_ENDIAN_MMIO
 	select USE_OF
 	help
 	  This enables support for the MIPS Technologies SEAD3 evaluation
@@ -404,8 +402,6 @@ config PMC_MSP
 	select IRQ_CPU
 	select SERIAL_8250
 	select SERIAL_8250_CONSOLE
-	select USB_EHCI_BIG_ENDIAN_MMIO
-	select USB_EHCI_BIG_ENDIAN_DESC
 	help
 	  This adds support for the PMC-Sierra family of Multi-Service
 	  Processor System-On-A-Chips.  These parts include a number
@@ -1435,7 +1431,6 @@ config CPU_CAVIUM_OCTEON
 	select CPU_SUPPORTS_HUGEPAGES
 	select LIBFDT
 	select USE_OF
-	select USB_EHCI_BIG_ENDIAN_MMIO
 	help
 	  The Cavium Octeon processor is a highly integrated chip containing
 	  many ethernet hardware widgets for networking tasks. The processor
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
