Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759136Ab3K0BVl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:21:41 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:60996 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754201Ab3K0BVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 20:21:34 -0500
X-AuditID: cbfee68d-b7f1a6d0000055a7-90-5295491c570f
Date: Wed, 27 Nov 2013 01:21:32 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] blackfin: Kill CONFIG_MTD_PARTITIONS
To: vapier@gentoo.org, uclinux-dist-devel@blackfin.uclinux.org
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127011923528@eunb.song
Msgkey: 20131127011923528@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127011923528@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1389567.80471385515291622.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Zpq6M59Qgg5mrDS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGnufTGQtmOVf0Tv7B1MC4w7GLkZNDSEBFouX/d0YQW0LARKK7
	bQobhC0mceHeeiCbC6hmGaNEZ/MWFpiiU78fs0A0z2eUuDSFH8RmEVCVuL90PTOIzSagLfHj
	wFUwW1jAVOLB+zusILaIgJdEQ9dPsAXMAo4Sjy7fYYaYIy8x+fRldhCbV0BQ4uTMJ1C7lCT6
	Zl9mgYgrS5xv3MEKEZeQmDX9ApTNKzGj/SlUvZzEtK9rmCFsaYnzszYwwjyz+PtjqDi/xLHb
	O5i6GDnAep/cD4YZs3vzF6jfBSSmnjnICFGiLrH9vgVEmE9izcK3LDBTdp1azgzTen/LXCaI
	rxQlpnQ/ZIewtSS+/NjHhu4rXgEHiR2/tjFPYFSehSQ1C0n7LCTtyGoWMLKsYhRNLUguKE5K
	LzLUK07MLS7NS9dLzs/dxAhJCr07GG8fsD7EmAyMkYnMUqLJ+cCkklcSb2hsZmRhamJqbGRu
	aUaasJI4b9LDpCAhgfTEktTs1NSC1KL4otKc1OJDjEwcnFINjNWvv8XvPd3DIlh7g8d2ffSL
	PjlXu9pX3wPKtrfMWHMl4s7ZG7v4vtzNu/djh/mjWzctQubYB3pLMmp/+JWRU/98ztOpnhzb
	nGINV3+ZmtJW1BGX/63mBXd6x5Hn7zaV7xXxMbvKVpFzfJr3wVfmi147XZqou0H89eKs90Xa
	EfvkpnRtq+h0Z1FiKc5INNRiLipOBACb5D46IAMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2TF0Zz6lBBo2LdC0u75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xp7n0xkLZjlX9E7+wdTAuMOxi5GTQ0hARaLl/3dGEFtCwETi1O/HLBC2mMSFe+vZIGrmM0pc
	msIPYrMIqErcX7qeGcRmE9CW+HHgKpgtLGAq8eD9HVYQW0TAS6Kh6ydYL7OAo8Sjy3eYIebI
	S0w+fZkdxOYVEJQ4OfMJ1C4lib7Zl1kg4soS5xt3sELEJSRmTb8AZfNKzGh/ClUvJzHt6xpm
	CFta4vysDYwwNy/+/hgqzi9x7PYOpi5GDrDeJ/eDYcbs3vyFDcIWkJh65iAjRIm6xPb7FhBh
	Pok1C9+ywEzZdWo5M0zr/S1zmSC+UpSY0v2QHcLWkvjyYx8buq94BRwkdvzaxjyBUW4WktQs
	JO2zkLQjq1nAyLKKUTS1ILmgOCm9wlCvODG3uDQvXS85P3cTIzg9PVu4g/HLeetDjAIcjEo8
	vBMuTwkSYk0sK67MPcQowcGsJML7wmFqkBBvSmJlVWpRfnxRaU5q8SHGZGD8TWSWEk3OB6bO
	vJJ4Q2MDY0NDS3MDU0MjC9KElcR5795MChISSE8sSc1OTS1ILYLZwsTBKdXAuFNX+3jEmRnN
	L7J/XNUszYzYskepVpTlfMujXSazRMLMHnNozJhhsjLgsKVlQFd+6QNNnamXDy9/pSFnNy9Q
	izX50IErn1xXyRtPijlf1rWK6+wVEf932YcclBbPrdswVSFK6rH0lXjFV+v0X7/c0TMzZ+Gq
	pAvVnE84yo0ctjsvTz/tIZMvqsRSnJFoqMVcVJwIAD7GpJmTAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR1LkYH016648


This patch removes CONFIG_MTD_PARTITIONS in config files for blackfin.
 Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/blackfin/configs/BF538-EZKIT_defconfig   |    1 -
 arch/blackfin/configs/BF561-ACVILON_defconfig |    1 -
 arch/blackfin/configs/BlackStamp_defconfig    |    1 -
 arch/blackfin/configs/CM-BF533_defconfig      |    1 -
 arch/blackfin/configs/CM-BF548_defconfig      |    1 -
 arch/blackfin/configs/CM-BF561_defconfig      |    1 -
 arch/blackfin/configs/DNP5370_defconfig       |    1 -
 arch/blackfin/configs/H8606_defconfig         |    1 -
 arch/blackfin/configs/IP0X_defconfig          |    1 -
 arch/blackfin/configs/PNAV-10_defconfig       |    1 -
 arch/blackfin/configs/SRV1_defconfig          |    1 -
 arch/blackfin/configs/TCM-BF518_defconfig     |    1 -
 12 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/blackfin/configs/BF538-EZKIT_defconfig b/arch/blackfin/configs/BF538-EZKIT_defconfig
index 972aa62..be03be6 100644
--- a/arch/blackfin/configs/BF538-EZKIT_defconfig
+++ b/arch/blackfin/configs/BF538-EZKIT_defconfig
@@ -59,7 +59,6 @@ CONFIG_BFIN_SIR=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/BF561-ACVILON_defconfig b/arch/blackfin/configs/BF561-ACVILON_defconfig
index 9198837..802f9c4 100644
--- a/arch/blackfin/configs/BF561-ACVILON_defconfig
+++ b/arch/blackfin/configs/BF561-ACVILON_defconfig
@@ -49,7 +49,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/BlackStamp_defconfig b/arch/blackfin/configs/BlackStamp_defconfig
index 7b982d0..3853c47 100644
--- a/arch/blackfin/configs/BlackStamp_defconfig
+++ b/arch/blackfin/configs/BlackStamp_defconfig
@@ -44,7 +44,6 @@ CONFIG_IP_PNP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/CM-BF533_defconfig b/arch/blackfin/configs/CM-BF533_defconfig
index c940a1e..5e0db82 100644
--- a/arch/blackfin/configs/CM-BF533_defconfig
+++ b/arch/blackfin/configs/CM-BF533_defconfig
@@ -36,7 +36,6 @@ CONFIG_UNIX=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/CM-BF548_defconfig b/arch/blackfin/configs/CM-BF548_defconfig
index e961483..b9af4fa 100644
--- a/arch/blackfin/configs/CM-BF548_defconfig
+++ b/arch/blackfin/configs/CM-BF548_defconfig
@@ -53,7 +53,6 @@ CONFIG_INET_XFRM_MODE_BEET=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/CM-BF561_defconfig b/arch/blackfin/configs/CM-BF561_defconfig
index 24936b9..d6dd98e 100644
--- a/arch/blackfin/configs/CM-BF561_defconfig
+++ b/arch/blackfin/configs/CM-BF561_defconfig
@@ -51,7 +51,6 @@ CONFIG_INET=y
 # CONFIG_WIRELESS is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/blackfin/configs/DNP5370_defconfig b/arch/blackfin/configs/DNP5370_defconfig
index 89162d0..2b58cb2 100644
--- a/arch/blackfin/configs/DNP5370_defconfig
+++ b/arch/blackfin/configs/DNP5370_defconfig
@@ -36,7 +36,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
 CONFIG_MTD_DEBUG_VERBOSE=1
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_NFTL=y
diff --git a/arch/blackfin/configs/H8606_defconfig b/arch/blackfin/configs/H8606_defconfig
index a26436b..f754e49 100644
--- a/arch/blackfin/configs/H8606_defconfig
+++ b/arch/blackfin/configs/H8606_defconfig
@@ -36,7 +36,6 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_WIRELESS is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/blackfin/configs/IP0X_defconfig b/arch/blackfin/configs/IP0X_defconfig
index 6479915..6295165 100644
--- a/arch/blackfin/configs/IP0X_defconfig
+++ b/arch/blackfin/configs/IP0X_defconfig
@@ -43,7 +43,6 @@ CONFIG_IP_NF_TARGET_REJECT=y
 CONFIG_IP_NF_MANGLE=y
 # CONFIG_WIRELESS is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/blackfin/configs/PNAV-10_defconfig b/arch/blackfin/configs/PNAV-10_defconfig
index 8fd9b44..a6a7298 100644
--- a/arch/blackfin/configs/PNAV-10_defconfig
+++ b/arch/blackfin/configs/PNAV-10_defconfig
@@ -46,7 +46,6 @@ CONFIG_IP_PNP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/blackfin/configs/SRV1_defconfig b/arch/blackfin/configs/SRV1_defconfig
index 0520c16..bc21664 100644
--- a/arch/blackfin/configs/SRV1_defconfig
+++ b/arch/blackfin/configs/SRV1_defconfig
@@ -38,7 +38,6 @@ CONFIG_IRTTY_SIR=m
 # CONFIG_WIRELESS is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_JEDECPROBE=m
diff --git a/arch/blackfin/configs/TCM-BF518_defconfig b/arch/blackfin/configs/TCM-BF518_defconfig
index e4ed865..ea88158 100644
--- a/arch/blackfin/configs/TCM-BF518_defconfig
+++ b/arch/blackfin/configs/TCM-BF518_defconfig
@@ -54,7 +54,6 @@ CONFIG_IP_PNP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
