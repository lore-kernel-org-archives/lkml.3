Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3K0Att (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:49:49 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:53734 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3K0Ato (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:49:44 -0500
X-AuditID: cbfee68f-b7f336d00000481b-bf-529541a1f44f
Date: Wed, 27 Nov 2013 00:49:37 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] avr32: Kill CONFIG_MTD_PARTITIONS
To: hskinnemoen@gmail.com, egtvedt@samfundet.no
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127004726035@eunb.song
Msgkey: 20131127004726035@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127004726035@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <6858332.78861385513376432.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplleLIzCtJLcpLzFFi42I5/e+Ztu5Cx6lBBndnq1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mlkf7mAq2RVb8/dXP3MDYE97FyMkhJKAi0fL/OyOILSFgIrHz
	5QwmCFtM4sK99WxdjFxANcsYJa4euwJXtOHdQXaIxHxGiSl328ESLAKqEptOTWQFsdkEtCV+
	HLjKDGILCxhJ9L/8BjSJg0NEwFpiwf5IkDCzgKPEo8t3mCGOkJeYfPoyO4jNKyAocXLmExaQ
	cgkBJYmd/90hwsoSs9csgTpBQmLW9AusEDavxIz2pywQtpzEtK9rmCFsaYnzszYwwvyy+Ptj
	qDi/xLHbO5ggxvNKPLkfDDNm9+YvbBC2gMTUMwehWtUlZp94BtXKJ7Fm4VsWmDG7Ti1nhum9
	v2UuE8RXihJTuh+yQ9haEl9+7GND9RWI7SDRtLiLeQKj8iwkqVlI2mchaUdWs4CRZRWjaGpB
	ckFxUnqRsV5xYm5xaV66XnJ+7iZGSFLo38F494D1IcZkYIRMZJYSTc4HJpW8knhDYzMjC1MT
	U2Mjc0sz0oSVxHnvP0wKEhJITyxJzU5NLUgtii8qzUktPsTIxMEp1cB45PAzdt386atn3pCN
	fajDw1elaa1h2VjR/ctAbdNm49MTX9dZfv9qNGdB1NXlbh0m/TUbvi16eSBPlM1nbqFDHc+R
	qpCQd9UXTBfxlWur/mpqva3+ImbRshD7b2cKgnmfJK3YLFeZM3dmK9OKcIcZz0QfnTT9nrFt
	7ePZKfUT0lclfZQVsRBWYinOSDTUYi4qTgQA/yufqCADAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgk+LIzCtJLcpLzFFi42I5/e/2DN2FjlODDF7PU7a4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GS2P9jEVbIus+Purn7mBsSe8i5GTQ0hARaLl/3dGEFtCwERiw7uD7BC2mMSFe+vZuhi5gGrm
	M0pMudsOVsQioCqx6dREVhCbTUBb4seBq8wgtrCAkUT/y29ADRwcIgLWEgv2R4KEmQUcJR5d
	vsMMsUteYvLpy2DzeQUEJU7OfMICUi4hoCSx8787RFhZYvaaJVDnSEjMmn6BFcLmlZjR/pQF
	wpaTmPZ1DTOELS1xftYGRpiTF39/DBXnlzh2ewcTxHheiSf3g2HG7N78hQ3CFpCYeuYgVKu6
	xOwTz6Ba+STWLHzLAjNm16nlzDC997fMZYL4SlFiSvdDdghbS+LLj31sqL4CsR0kmhZ3MU9g
	lJuFJDULSfssJO3IahYwsqxiFE0tSC4oTkqvMNQrTswtLs1L10vOz93ECE5PzxbuYPxy3voQ
	owAHoxIP74TLU4KEWBPLiitzDzFKcDArifC+cJgaJMSbklhZlVqUH19UmpNafIgxGRh9E5ml
	RJPzgakzryTe0NjA2NDQ0tzA1NDIgjRhJXHeuzeTgoQE0hNLUrNTUwtSi2C2MHFwSjUwlpuW
	xp2cVyfyraV6p9z7dyfUl0c71/h7BKazBMebMMfvPyH3+cqV9Q/lb8efXl7ip7E+w4qdMcyN
	6Zz8ITYTP4fX5y0f+aVt++w/r+RpmRKvjNvG9ddmH9tWrMwdkPjWL6bo9USvfZt/bXCLqv+0
	8+GbSdUHRFrXP8mo8W1o7eC7eH7Bq/etSizFGYmGWsxFxYkAdheUk5MDAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR0nufc015859


This patch removes CONFIG_MTD_PARTITIONS in config files for avr32.
 Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/avr32/configs/atngw100_defconfig              |    1 -
 arch/avr32/configs/atngw100_evklcd100_defconfig    |    1 -
 arch/avr32/configs/atngw100_evklcd101_defconfig    |    1 -
 arch/avr32/configs/atngw100_mrmt_defconfig         |    1 -
 arch/avr32/configs/atngw100mkii_defconfig          |    1 -
 .../avr32/configs/atngw100mkii_evklcd100_defconfig |    1 -
 .../avr32/configs/atngw100mkii_evklcd101_defconfig |    1 -
 arch/avr32/configs/atstk1002_defconfig             |    1 -
 arch/avr32/configs/atstk1003_defconfig             |    1 -
 arch/avr32/configs/atstk1004_defconfig             |    1 -
 arch/avr32/configs/atstk1006_defconfig             |    1 -
 arch/avr32/configs/favr-32_defconfig               |    1 -
 arch/avr32/configs/hammerhead_defconfig            |    1 -
 arch/avr32/configs/merisc_defconfig                |    1 -
 arch/avr32/configs/mimc200_defconfig               |    1 -
 15 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/arch/avr32/configs/atngw100_defconfig b/arch/avr32/configs/atngw100_defconfig
index d5aff36..4733e38 100644
--- a/arch/avr32/configs/atngw100_defconfig
+++ b/arch/avr32/configs/atngw100_defconfig
@@ -59,7 +59,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100_evklcd100_defconfig b/arch/avr32/configs/atngw100_evklcd100_defconfig
index 4abcf43..1be0ee3 100644
--- a/arch/avr32/configs/atngw100_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd100_defconfig
@@ -61,7 +61,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100_evklcd101_defconfig b/arch/avr32/configs/atngw100_evklcd101_defconfig
index 18f3fa0..796e536 100644
--- a/arch/avr32/configs/atngw100_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100_evklcd101_defconfig
@@ -60,7 +60,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100_mrmt_defconfig b/arch/avr32/configs/atngw100_mrmt_defconfig
index 06e389c..9a57da4 100644
--- a/arch/avr32/configs/atngw100_mrmt_defconfig
+++ b/arch/avr32/configs/atngw100_mrmt_defconfig
@@ -48,7 +48,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100mkii_defconfig b/arch/avr32/configs/atngw100mkii_defconfig
index 2518a13..97fe1b3 100644
--- a/arch/avr32/configs/atngw100mkii_defconfig
+++ b/arch/avr32/configs/atngw100mkii_defconfig
@@ -59,7 +59,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
index 245ef6b..a176d24 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd100_defconfig
@@ -62,7 +62,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
index fa6cbac..d1bf6dc 100644
--- a/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
+++ b/arch/avr32/configs/atngw100mkii_evklcd101_defconfig
@@ -61,7 +61,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index bbd5131..2813dd2 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -53,7 +53,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atstk1003_defconfig b/arch/avr32/configs/atstk1003_defconfig
index c1cd726..f8ff3a3 100644
--- a/arch/avr32/configs/atstk1003_defconfig
+++ b/arch/avr32/configs/atstk1003_defconfig
@@ -42,7 +42,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atstk1004_defconfig b/arch/avr32/configs/atstk1004_defconfig
index 754ae56..992228e 100644
--- a/arch/avr32/configs/atstk1004_defconfig
+++ b/arch/avr32/configs/atstk1004_defconfig
@@ -42,7 +42,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/atstk1006_defconfig b/arch/avr32/configs/atstk1006_defconfig
index 58589d8..b8e698b 100644
--- a/arch/avr32/configs/atstk1006_defconfig
+++ b/arch/avr32/configs/atstk1006_defconfig
@@ -54,7 +54,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/favr-32_defconfig b/arch/avr32/configs/favr-32_defconfig
index c90fbf6..07bed3f 100644
--- a/arch/avr32/configs/favr-32_defconfig
+++ b/arch/avr32/configs/favr-32_defconfig
@@ -58,7 +58,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/hammerhead_defconfig b/arch/avr32/configs/hammerhead_defconfig
index ba7c31e..18db853 100644
--- a/arch/avr32/configs/hammerhead_defconfig
+++ b/arch/avr32/configs/hammerhead_defconfig
@@ -58,7 +58,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/avr32/configs/merisc_defconfig b/arch/avr32/configs/merisc_defconfig
index 65de443..91df6b2 100644
--- a/arch/avr32/configs/merisc_defconfig
+++ b/arch/avr32/configs/merisc_defconfig
@@ -46,7 +46,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/avr32/configs/mimc200_defconfig b/arch/avr32/configs/mimc200_defconfig
index 0a8bfdc..d630e08 100644
--- a/arch/avr32/configs/mimc200_defconfig
+++ b/arch/avr32/configs/mimc200_defconfig
@@ -49,7 +49,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
