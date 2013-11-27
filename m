Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760209Ab3K0BpB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:45:01 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:57072 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760193Ab3K0Boz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:44:55 -0500
X-AuditID: cbfee68e-b7f7e6d00000477d-ec-52954e93f90c
Date: Wed, 27 Nov 2013 01:44:51 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] m32r : Kill CONFIG_MTD_PARTITIONS
To: takata@linux-m32r.org
Cc: linux-m32r-ja@ml.linux-m32r.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127014320960@eunb.song
Msgkey: 20131127014320960@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127014320960@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11124106.81601385516690121.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zju5kv6lBBvdOKlhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MI5ePMhf8U6iYvWEBewNjj0IXIyeHkICKRMv/74wgtoSAicTl
	xafZIGwxiQv31gPZXEA1yxgl1n05xgxTdHHuLyaIxHxGiUfLVzKBJFgEVCW6Hp1kBbHZBLQl
	fhy4CtTAwSEsYCTx91gmSFhEQE7i85GFYGFmgUyJmbOdIW6Ql5h8+jI7iM0rIChxcuYTFohV
	ShL/Dx5igYgrS7RO3cIEEZeQmDX9AiuEzSsxo/0pVL2cxLSva6DOlJY4P2sDI8wvi78/horz
	Sxy7vYMJ5ASQ3if3g2HG7N78Bep1AYmpZw5CtapLrFo8BSrOJ7Fm4VsWmDG7Ti1nhum9v2Uu
	2GnMAooSU7ofskPYWhJffuxjQ/cWr4CjxPapn1kmMCrPQpKahaR9FpJ2ZDULGFlWMYqmFiQX
	FCelFxnpFSfmFpfmpesl5+duYoQkhb4djDcPWB9iTAZGyERmKdHkfGBSySuJNzQ2M7IwNTE1
	NjK3NCNNWEmcd9HDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjBKLqhlWqdexf3yYEWrp
	unff5mSWHXMN4znU+Qpy1eeKtKx6FvjY4ZBuX/nRg8yKE19xrkibMkOXW5Nt3nod5X3ZszJm
	2UTVvXa6whKz7kCp55fC1rVnNpks/xvnsnj+rHt6XtuniHQ9+9j5kG//FmFFaRHZaXXH9imX
	BxS86iyTOxjx1D7SQImlOCPRUIu5qDgRAEvO2f8gAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2dN3JflODDF5/krG4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GUcuH2Uu+KdQMXvDAvYGxh6FLkZODiEBFYmW/98ZQWwJAROJi3N/MUHYYhIX7q1n62LkAqqZ
	zyjxaPlKsASLgKpE16OTrCA2m4C2xI8DV5m7GDk4hAWMJP4eywQJiwjISXw+shAszCyQKTFz
	tjPEKnmJyacvs4PYvAKCEidnPmGBWKUk8f/gIRaIuLJE69QtUCdISMyafoEVwuaVmNH+FKpe
	TmLa1zXMELa0xPlZGxhhTl78/TFUnF/i2O0dTCAngPQ+uR8MM2b35i9sELaAxNQzB6Fa1SVW
	LZ4CFeeTWLPwLQvMmF2nljPD9N7fMhfsNGYBRYkp3Q/ZIWwtiS8/9rGhe4tXwFFi+9TPLBMY
	5WYhSc1C0j4LSTuymgWMLKsYRVMLkguKk9IrDPWKE3OLS/PS9ZLzczcxgtPTs4U7GL+ctz7E
	KMDBqMTDO+HylCAh1sSy4srcQ4wSHMxKIrwvHKYGCfGmJFZWpRblxxeV5qQWH2JMBkbfRGYp
	0eR8YOrMK4k3NDYwNjS0NDcwNTSyIE1YSZz37s2kICGB9MSS1OzU1ILUIpgtTBycUg2MMr83
	dO9JqPQ0/13OaxqodWDfl4nn61QFLEoqYj4dsV99nzHt0nuOZ09EJNb6ap69usk7Jeuk8pbv
	W85FHWMS0GE0fSthquf2TDg/4q3thuqvn7Y+iUze1ZJuUHHQzN/iWa3JqioR8YUKnR9Xb8tl
	VE1dZyMUtG1OksCJ1MqlDzv5RGu9VsopsRRnJBpqMRcVJwIAjPbLjpMDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR1jDiS017410


This patch removes CONFIG_MTD_PARTITIONS in config files for m32r.
Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/m32r/configs/m32700ut.smp_defconfig |    1 -
 arch/m32r/configs/m32700ut.up_defconfig  |    1 -
 arch/m32r/configs/mappi.smp_defconfig    |    1 -
 arch/m32r/configs/mappi.up_defconfig     |    1 -
 arch/m32r/configs/mappi3.smp_defconfig   |    1 -
 arch/m32r/configs/usrv_defconfig         |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/m32r/configs/m32700ut.smp_defconfig b/arch/m32r/configs/m32700ut.smp_defconfig
index a3d727e..fe09039 100644
--- a/arch/m32r/configs/m32700ut.smp_defconfig
+++ b/arch/m32r/configs/m32700ut.smp_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
diff --git a/arch/m32r/configs/m32700ut.up_defconfig b/arch/m32r/configs/m32700ut.up_defconfig
index b833416..18091bf 100644
--- a/arch/m32r/configs/m32700ut.up_defconfig
+++ b/arch/m32r/configs/m32700ut.up_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=m
diff --git a/arch/m32r/configs/mappi.smp_defconfig b/arch/m32r/configs/mappi.smp_defconfig
index 367d07c..109409b 100644
--- a/arch/m32r/configs/mappi.smp_defconfig
+++ b/arch/m32r/configs/mappi.smp_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/mappi.up_defconfig b/arch/m32r/configs/mappi.up_defconfig
index cb11384..74d5a23 100644
--- a/arch/m32r/configs/mappi.up_defconfig
+++ b/arch/m32r/configs/mappi.up_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 # CONFIG_STANDALONE is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/mappi3.smp_defconfig b/arch/m32r/configs/mappi3.smp_defconfig
index 27cefd4..f030ddd 100644
--- a/arch/m32r/configs/mappi3.smp_defconfig
+++ b/arch/m32r/configs/mappi3.smp_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/m32r/configs/usrv_defconfig b/arch/m32r/configs/usrv_defconfig
index a3cfaae..34d9458 100644
--- a/arch/m32r/configs/usrv_defconfig
+++ b/arch/m32r/configs/usrv_defconfig
@@ -35,7 +35,6 @@ CONFIG_INET_IPCOMP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
