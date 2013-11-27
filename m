Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab3K0A3T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:29:19 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:28508 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab3K0A3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:29:18 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-a4-52953cdcf7ba
Date: Wed, 27 Nov 2013 00:29:16 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: Fwd: [PATCH] MIPS: Kill CONFIG_MTD_PARTITIONS
To: "ralf@linux-mips.org" <ralf@linux-mips.org>
Cc: "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127002831652@eunb.song
Msgkey: 20131127002831652@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127002449789@eunb.song
X-ParentMTR: 20131127002449789@eunb.song
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <18399894.77721385512155579.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuphleLIzCtJLcpLzFFi42I5/e+Ztu5dm6lBBjeqLS7vmsPmwOjxeZNc
	AGMUl01Kak5mWWqRvl0CV8aubXwFt+wqdr3tYmpg7LDtYuTkEBJQkWj5/52xi5GDQ0LAROLb
	WiaQsISAmMSFe+vZuhi5gEqWMUqcmvYeKmEi8fbQHqjEfEaJL/fuM4MkWARUJXYumsIIYrMJ
	aEv8OHAVLC4sYCYxfd5tsGYRAX2J/+fesoPYzAI1Et1/FzNCHCEvMfn0ZbA4r4CgxMmZT1gg
	lilJbDs1gwkirgxU84gZIi4hMWv6BVYIm1diRvtTqHo5iWlf10DVSEucn7WBEeabxd8fQ8X5
	JY7d3sEE8TCvxJP7wTBjdm/+wgZhC0hMPXMQqlVdYsG7iVCtmhI/1q6GG7Pr1HJmmN77W+Yy
	QbylKDGl+yHUi1oSX37sY0P3Fq+Ao8SFq7cZJzAqz0KSmoWkfRaSdmQ1CxhZVjGKphYkFxQn
	pRcZ6hUn5haX5qXrJefnbmKEpITeHYy3D1gfYkwGRslEZinR5HxgSskriTc0NjOyMDUxNTYy
	tzQjTVhJnDfpYVKQkEB6YklqdmpqQWpRfFFpTmrxIUYmDk6pBsaKc+8XnUiUrxdiXfFQ7aaI
	yLSjkwIe5O58HSB/YoPE2rfzT1wJ/ha7bnG+9LkjDvHzJO1e2j8XTmy1Ka28Hmhdvj3m3hFb
	5j/bI78pLyx2PK+2yeCX9htj98YIJd810xOTrFV/13q03fKd4GRyy9Ji3wbXUOszzK/nCOqm
	7yitE8kPlEz7/EmJpTgj0VCLuag4EQDxG0WNHwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkk+LIzCtJLcpLzFFi42I5/e/2dN07NlODDGatt7S4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	Gbu28RXcsqvY9baLqYGxw7aLkZNDSEBFouX/d0YQW0LAROLtoT1sELaYxIV764FsLqCa+YwS
	X+7dZwZJsAioSuxcNAWsgU1AW+LHgatgcWEBM4np824zgdgiAvoS/8+9ZQexmQVqJLr/LmaE
	WCYvMfn0ZbA4r4CgxMmZT1gglilJbDs1gwkirgxU84gZIi4hMWv6BVYIm1diRvtTqHo5iWlf
	10DVSEucn7WBEeboxd8fQ8X5JY7d3gE0kwOs98n9YJgxuzd/gfpRQGLqmYNQreoSC95NhGrV
	lPixdjXcmF2nljPD9N7fMpcJ4i1FiSndD6Fe1JL48mMfG7q3eAUcJS5cvc04gVFuFpLULCTt
	s5C0I6tZwMiyilE0tSC5oDgpvcJYrzgxt7g0L10vOT93EyM4QT1bvIPx/3nrQ4wCHIxKPLwT
	Lk8JEmJNLCuuzD3EKMHBrCTCa6owNUiINyWxsiq1KD++qDQntfgQYzIwAicyS4km5wOTZ15J
	vKGxgbGhoaW5gamhkQVpwkrivPG3koKEBNITS1KzU1MLUotgtjBxcEo1ME61+/13bpbvjb2P
	fu/l0xHKmh3ZYSrjzNd6//LpIK8w/SWNHFVVf9wfqSUrO+i9NnvBnfumXnRvxHmvn9ET/52f
	FDVp9bkyZ7u+0OOnHacob5joVSP7+u3b2YsCX/TJT6r1LuqMUYyX3RtRVrVDR6BxMXvn7JX7
	TtVIFjCKHsqwCBetNi12VmIpzkg01GIuKk4EAOpygUSUAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR0TTiL015721

This patch removes CONFIG_MTD_PARTITIONS in config files for MIPS.
 Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/mips/configs/ar7_defconfig            |    1 -
 arch/mips/configs/bcm47xx_defconfig        |    1 -
 arch/mips/configs/bcm63xx_defconfig        |    1 -
 arch/mips/configs/cobalt_defconfig         |    1 -
 arch/mips/configs/gpr_defconfig            |    1 -
 arch/mips/configs/jmr3927_defconfig        |    1 -
 arch/mips/configs/lasat_defconfig          |    1 -
 arch/mips/configs/markeins_defconfig       |    1 -
 arch/mips/configs/mtx1_defconfig           |    1 -
 arch/mips/configs/pnx8335_stb225_defconfig |    1 -
 arch/mips/configs/rb532_defconfig          |    1 -
 arch/mips/configs/rbtx49xx_defconfig       |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/mips/configs/ar7_defconfig b/arch/mips/configs/ar7_defconfig
index 80e012f..320772c 100644
--- a/arch/mips/configs/ar7_defconfig
+++ b/arch/mips/configs/ar7_defconfig
@@ -86,7 +86,6 @@ CONFIG_MAC80211_RC_DEFAULT_PID=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/bcm47xx_defconfig b/arch/mips/configs/bcm47xx_defconfig
index 4ca8e5c..f31d17b 100644
--- a/arch/mips/configs/bcm47xx_defconfig
+++ b/arch/mips/configs/bcm47xx_defconfig
@@ -272,7 +272,6 @@ CONFIG_FW_LOADER=m
 CONFIG_CONNECTOR=m
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/bcm63xx_defconfig b/arch/mips/configs/bcm63xx_defconfig
index 9190051..3fec264 100644
--- a/arch/mips/configs/bcm63xx_defconfig
+++ b/arch/mips/configs/bcm63xx_defconfig
@@ -44,7 +44,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CFI_AMDSTD=y
diff --git a/arch/mips/configs/cobalt_defconfig b/arch/mips/configs/cobalt_defconfig
index 5419adb..23b6693 100644
--- a/arch/mips/configs/cobalt_defconfig
+++ b/arch/mips/configs/cobalt_defconfig
@@ -19,7 +19,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_JEDECPROBE=y
diff --git a/arch/mips/configs/gpr_defconfig b/arch/mips/configs/gpr_defconfig
index fb64589..8f219da 100644
--- a/arch/mips/configs/gpr_defconfig
+++ b/arch/mips/configs/gpr_defconfig
@@ -165,7 +165,6 @@ CONFIG_YAM=m
 CONFIG_CFG80211=y
 CONFIG_MAC80211=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/jmr3927_defconfig b/arch/mips/configs/jmr3927_defconfig
index db5705e..9bc08f2 100644
--- a/arch/mips/configs/jmr3927_defconfig
+++ b/arch/mips/configs/jmr3927_defconfig
@@ -22,7 +22,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/lasat_defconfig b/arch/mips/configs/lasat_defconfig
index d9f3db2..0179c7f 100644
--- a/arch/mips/configs/lasat_defconfig
+++ b/arch/mips/configs/lasat_defconfig
@@ -31,7 +31,6 @@ CONFIG_INET=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/markeins_defconfig b/arch/mips/configs/markeins_defconfig
index 636f82b..4c2c0c4 100644
--- a/arch/mips/configs/markeins_defconfig
+++ b/arch/mips/configs/markeins_defconfig
@@ -124,7 +124,6 @@ CONFIG_IP6_NF_MANGLE=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_FW_LOADER=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/mips/configs/mtx1_defconfig b/arch/mips/configs/mtx1_defconfig
index 9fa8f16..593946a 100644
--- a/arch/mips/configs/mtx1_defconfig
+++ b/arch/mips/configs/mtx1_defconfig
@@ -246,7 +246,6 @@ CONFIG_BT_HCIBTUART=m
 CONFIG_BT_HCIVHCI=m
 CONFIG_CONNECTOR=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/mips/configs/pnx8335_stb225_defconfig b/arch/mips/configs/pnx8335_stb225_defconfig
index f292576..c887066 100644
--- a/arch/mips/configs/pnx8335_stb225_defconfig
+++ b/arch/mips/configs/pnx8335_stb225_defconfig
@@ -31,7 +31,6 @@ CONFIG_INET_AH=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/mips/configs/rb532_defconfig b/arch/mips/configs/rb532_defconfig
index b85b121..5d9d708 100644
--- a/arch/mips/configs/rb532_defconfig
+++ b/arch/mips/configs/rb532_defconfig
@@ -114,7 +114,6 @@ CONFIG_NET_CLS_IND=y
 CONFIG_HAMRADIO=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_BLOCK2MTD=y
diff --git a/arch/mips/configs/rbtx49xx_defconfig b/arch/mips/configs/rbtx49xx_defconfig
index 9cba856..f8bf9b4 100644
--- a/arch/mips/configs/rbtx49xx_defconfig
+++ b/arch/mips/configs/rbtx49xx_defconfig
@@ -35,7 +35,6 @@ CONFIG_IP_PNP=y
 # CONFIG_IPV6 is not set
 # CONFIG_WIRELESS is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=m
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
