Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760316Ab3K0BtH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:49:07 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:9734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758941Ab3K0Bs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:48:59 -0500
X-AuditID: cbfee68f-b7f336d00000481b-8b-52954f87acef
Date: Wed, 27 Nov 2013 01:48:55 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] m68k : Kill CONFIG_MTD_PARTITIONS
To: geert@linux-m68k.org
Cc: linux-m68k@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127014800482@eunb.song
Msgkey: 20131127014800482@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127014800482@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11558848.81811385516934809.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zlm6H/9Qgg+c6Fpd3zWFzYPT4vEku
	gDGKyyYlNSezLLVI3y6BK2PCtwusBd/kK9bsbGZsYOyQ72Lk5BASUJFo+f+dEcSWEDCR2NO7
	gQnCFpO4cG89WxcjF1DNMkaJKcvmscMUNW14xwrRPJ9RoukwM4jNIqAqMfHbNBYQm01AW+LH
	gatgcWEBI4ndW1+CxUUEZCX6z20Cm8MskCkx9f4WRog58hKTT18Gi/MKCEqcnPmEBWKXkkTz
	ojdQcWWJu7efs0LEJSRmTb8AZfNKzGh/ClUvJzHt6xpmCFta4vysDYwwzyz+/hgqzi9x7PYO
	oCc5wHqf3A+GGbN78xc2CFtAYuqZg1Ct6hKXzqyCauWTWLPwLQvMmF2nljPD9N7fMpcJ4i1F
	iSndD6Fe1JL48mMfG7q3eAUcJaZsnM80gVF5FpLULCTts5C0I6tZwMiyilE0tSC5oDgpvchY
	rzgxt7g0L10vOT93EyMkKfTvYLx7wPoQYzIwSiYyS4km5wOTSl5JvKGxmZGFqYmpsZG5pRlp
	wkrivPcfJgUJCaQnlqRmp6YWpBbFF5XmpBYfYmTi4JRqYGRyFN+jvpC7r0s2I/Xt5CN9qgdn
	n3/0KWP3g8XRJaon3efsf5rn9D1r90JNow+3eia0PSvqZuF+98LsivvNzoN/rJivxJlKs9vM
	l5ymdFWaZaayz686B/MvtzeYf/1pe1+uUNKi9e3GrvVXDGX/9zzt1Hm2r+SwRHnHztRrSXE5
	R59xuaTd61JiKc5INNRiLipOBADvRdVgIAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2DN12/6lBBq++WFpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jAnfLrAWfJOvWLOzmbGBsUO+i5GTQ0hARaLl/3dGEFtCwESiacM7VghbTOLCvfVsEDXzGSWa
	DjOD2CwCqhITv01jAbHZBLQlfhy4ChYXFjCS2L31JVhcREBWov/cJnYQm1kgU2Lq/S2MEHPk
	JSafvgwW5xUQlDg58wkLxC4lieZFb6DiyhJ3bz+HukFCYtb0C1A2r8SM9qdQ9XIS076uYYaw
	pSXOz9rACHPz4u+PoeL8Esdu72DqYuQA631yPxhmzO7NX9ggbAGJqWcOQrWqS1w6swqqlU9i
	zcK3LDBjdp1azgzTe3/LXCaItxQlpnQ/hHpRS+LLj31s6N7iFXCUmLJxPtMERrlZSFKzkLTP
	QtKOrGYBI8sqRtHUguSC4qT0CiO94sTc4tK8dL3k/NxNjOAE9WzRDsZ/560PMQpwMCrx8E64
	PCVIiDWxrLgy9xCjBAezkgjvC4epQUK8KYmVValF+fFFpTmpxYcYk4EROJFZSjQ5H5g880ri
	DY0NjA0NLc0NTA2NLEgTVhLnlb+VFCQkkJ5YkpqdmlqQWgSzhYmDU6qBkUVvxWejBmuB/k29
	CqrPbwrbJC1382/uXV0d6/elL1VazlPdccHP6S5/93Z/KMx/faH3yJLgX5db9I+npUpN3XAg
	dJf/scpJ1zeXlZqHXbuprPC0LlpfgvWuSt3DStZPapsq1867uOHQhEsq7ceZ2X/nSlhk7tC4
	xftTv5HDfsf7bQfvTDO4qsRSnJFoqMVcVJwIAH/9FsWUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR1nG8H017528


This patch removes CONFIG_MTD_PARTITIONS in config files for m68k.
Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/m68k/configs/m5208evb_defconfig |    1 -
 arch/m68k/configs/m5249evb_defconfig |    1 -
 arch/m68k/configs/m5272c3_defconfig  |    1 -
 arch/m68k/configs/m5275evb_defconfig |    1 -
 arch/m68k/configs/m5307c3_defconfig  |    1 -
 arch/m68k/configs/m5407c3_defconfig  |    1 -
 6 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/arch/m68k/configs/m5208evb_defconfig b/arch/m68k/configs/m5208evb_defconfig
index c161682..e7292f4 100644
--- a/arch/m68k/configs/m5208evb_defconfig
+++ b/arch/m68k/configs/m5208evb_defconfig
@@ -40,7 +40,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/m68k/configs/m5249evb_defconfig b/arch/m68k/configs/m5249evb_defconfig
index a6599e4..0cd4b39 100644
--- a/arch/m68k/configs/m5249evb_defconfig
+++ b/arch/m68k/configs/m5249evb_defconfig
@@ -38,7 +38,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/m68k/configs/m5272c3_defconfig b/arch/m68k/configs/m5272c3_defconfig
index 3fa60a5..a60cb35 100644
--- a/arch/m68k/configs/m5272c3_defconfig
+++ b/arch/m68k/configs/m5272c3_defconfig
@@ -36,7 +36,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/m68k/configs/m5275evb_defconfig b/arch/m68k/configs/m5275evb_defconfig
index a1230e8..e6502ab 100644
--- a/arch/m68k/configs/m5275evb_defconfig
+++ b/arch/m68k/configs/m5275evb_defconfig
@@ -39,7 +39,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/m68k/configs/m5307c3_defconfig b/arch/m68k/configs/m5307c3_defconfig
index 43795f4..023812a 100644
--- a/arch/m68k/configs/m5307c3_defconfig
+++ b/arch/m68k/configs/m5307c3_defconfig
@@ -38,7 +38,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/m68k/configs/m5407c3_defconfig b/arch/m68k/configs/m5407c3_defconfig
index 72746c5..557b39f 100644
--- a/arch/m68k/configs/m5407c3_defconfig
+++ b/arch/m68k/configs/m5407c3_defconfig
@@ -38,7 +38,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
