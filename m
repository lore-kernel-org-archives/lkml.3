Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3K0Amp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 19:42:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:42373 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919Ab3K0Amn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:42:43 -0500
X-AuditID: cbfee690-b7f126d00000418c-fc-529540015c9d
Date: Wed, 27 Nov 2013 00:42:41 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] powerpc: : Kill CONFIG_MTD_PARTITIONS
To: benh@kernel.crashing.org, paulus@samba.org
Cc: linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131127004016048@eunb.song
Msgkey: 20131127004016048@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131127004016048@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <10105084.78451385512960055.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zbV1Gh6lBBi8XmFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M+10vmQo2LGCqmLJ5OWMD448ZTF2MnBxCAioSLf+/M4LYEgIm
	ErsWPGGBsMUkLtxbz9bFyAVUs4xRYkL/Lriir913WCES8xklJn7rZQVJsAioSvxvn8IOYrMJ
	aEv8OHCVGcQWFjCTOLl1OZgtImAlcXnuY7AaZoF0ibsnp7JAXCEvMfn0ZbA4r4CgxMmZMFco
	SXRceMECEVeWmPNrGjtEXEJi1vQLrBA2r8SM9qdQ9XIS076uYYawpSXOz9rACPPN4u+PoeL8
	Esdu7wD6ngOs98n9YJgxuzd/YYOwBSSmnjkI1aou8advIdRaPok1C9+ywIzZdWo5M0zv/S1z
	mSDeUpSY0v0Q6kUtiS8/9rGhe4tXwFHieP9ixgmMyrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXF
	SelFJnrFibnFpXnpesn5uZsYIclhwg7GewesDzEmA6NkIrOUaHI+MLnklcQbGpsZWZiamBob
	mVuakSasJM6r9igpSEggPbEkNTs1tSC1KL6oNCe1+BAjEwenVAPjFNVnaT+KHM7MCy86OFfq
	nGAu94vfqpuktB4+Fw4T0uZxzBKo1vl4plPp9Itbyg1FQcKzbvvuYr6WeXqh2as0zpfKs9ZE
	Ls55eybivPQtjp2PcjV3+z/vOz159xp7ZtOJ9bOq3gtNKuR6v+bGwtm2E5ckXpG5mlP/Q3Pb
	vsjmdoaLDPuajdYbKrEUZyQaajEXFScCALmwQn0kAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e/2dF1Gh6lBBn3/9Swu75rD5sDo8XmT
	XABjVIZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGuoaWFuZJCXmJuqq2Si0+ArltmDtBQ
	JYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUrSRgbGekamJnpGxgZ6JQayVoYGBkSlQVUJG
	xv2ul0wFGxYwVUzZvJyxgfHHDKYuRk4OIQEViZb/3xlBbAkBE4mv3XdYIWwxiQv31rN1MXIB
	1cxnlJj4rRcswSKgKvG/fQo7iM0moC3x48BVZhBbWMBM4uTW5WC2iICVxOW5j8FqmAXSJe6e
	nMoCsUxeYvLpy2BxXgFBiZMzn7BALFOS6LjwggUiriwx59c0doi4hMSs6RegDuKVmNH+FKpe
	TmLa1zXMELa0xPlZGxhhjl78/TFUnF/i2O0dQE9ygPU+uR8MM2b35i9sELaAxNQzB6Fa1SX+
	9C2EWssnsWbhWxaYMbtOLWeG6b2/ZS4TxFuKElO6H0K9qCXx5cc+NnRv8Qo4ShzvX8w4gVFu
	FpLULCTts5C0I6tZwMiyilE0tSC5oDgpvcJIrzgxt7g0L10vOT93EyM4TT1btIPx33nrQ4wC
	HIxKPLwTLk8JEmJNLCuuzD3EKMHBrCTCa6owNUiINyWxsiq1KD++qDQntfgQYzIwAicyS4km
	5wNTaF5JvKGxgbGhoaW5gamhkQVpwkrivPK3koKEBNITS1KzU1MLUotgtjBxcEo1MF6zr9zX
	tz8pqULPNaqm+r+laPO2narup79oHWKwuFtprn7H0OG1idyO8FtHtpivrpmntUvpgAgHr9vl
	5ZGhm5ZUnGz+Kn1miofoq7fX8m7pqKX7Bsx3mfI7plH1jsirtdoucss2sB9/rXzNzeNhfebp
	N8sL2c2PMYncZ7ixl+sKa2vOtvs7HZRYijMSDbWYi4oTAX9Rw6SXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAR0grUe015780


This patch removes CONFIG_MTD_PARTITIONS in config files for powerpc.
 Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.


Signed-off-by: Eunbong Song <eunb.song@samsung.com>
---
 arch/powerpc/configs/40x/acadia_defconfig        |    1 -
 arch/powerpc/configs/40x/ep405_defconfig         |    1 -
 arch/powerpc/configs/40x/kilauea_defconfig       |    1 -
 arch/powerpc/configs/40x/makalu_defconfig        |    1 -
 arch/powerpc/configs/40x/walnut_defconfig        |    1 -
 arch/powerpc/configs/44x/arches_defconfig        |    1 -
 arch/powerpc/configs/44x/bluestone_defconfig     |    1 -
 arch/powerpc/configs/44x/canyonlands_defconfig   |    1 -
 arch/powerpc/configs/44x/ebony_defconfig         |    1 -
 arch/powerpc/configs/44x/eiger_defconfig         |    1 -
 arch/powerpc/configs/44x/icon_defconfig          |    1 -
 arch/powerpc/configs/44x/iss476-smp_defconfig    |    1 -
 arch/powerpc/configs/44x/katmai_defconfig        |    1 -
 arch/powerpc/configs/44x/rainier_defconfig       |    1 -
 arch/powerpc/configs/44x/redwood_defconfig       |    1 -
 arch/powerpc/configs/44x/sequoia_defconfig       |    1 -
 arch/powerpc/configs/44x/taishan_defconfig       |    1 -
 arch/powerpc/configs/44x/warp_defconfig          |    1 -
 arch/powerpc/configs/52xx/cm5200_defconfig       |    1 -
 arch/powerpc/configs/52xx/motionpro_defconfig    |    1 -
 arch/powerpc/configs/52xx/pcm030_defconfig       |    1 -
 arch/powerpc/configs/52xx/tqm5200_defconfig      |    1 -
 arch/powerpc/configs/83xx/asp8347_defconfig      |    1 -
 arch/powerpc/configs/83xx/mpc8313_rdb_defconfig  |    1 -
 arch/powerpc/configs/83xx/mpc8315_rdb_defconfig  |    1 -
 arch/powerpc/configs/83xx/mpc836x_mds_defconfig  |    1 -
 arch/powerpc/configs/83xx/mpc836x_rdk_defconfig  |    1 -
 arch/powerpc/configs/83xx/sbc834x_defconfig      |    1 -
 arch/powerpc/configs/85xx/ksi8560_defconfig      |    1 -
 arch/powerpc/configs/85xx/ppa8548_defconfig      |    1 -
 arch/powerpc/configs/85xx/socrates_defconfig     |    1 -
 arch/powerpc/configs/85xx/tqm8540_defconfig      |    1 -
 arch/powerpc/configs/85xx/tqm8541_defconfig      |    1 -
 arch/powerpc/configs/85xx/tqm8548_defconfig      |    1 -
 arch/powerpc/configs/85xx/tqm8555_defconfig      |    1 -
 arch/powerpc/configs/85xx/tqm8560_defconfig      |    1 -
 arch/powerpc/configs/85xx/xes_mpc85xx_defconfig  |    1 -
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig    |    1 -
 arch/powerpc/configs/86xx/gef_sbc310_defconfig   |    1 -
 arch/powerpc/configs/86xx/gef_sbc610_defconfig   |    1 -
 arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig |    1 -
 arch/powerpc/configs/86xx/sbc8641d_defconfig     |    1 -
 arch/powerpc/configs/c2k_defconfig               |    1 -
 arch/powerpc/configs/corenet64_smp_defconfig     |    1 -
 arch/powerpc/configs/linkstation_defconfig       |    1 -
 arch/powerpc/configs/mpc85xx_defconfig           |    1 -
 arch/powerpc/configs/mpc85xx_smp_defconfig       |    1 -
 arch/powerpc/configs/ppc40x_defconfig            |    1 -
 arch/powerpc/configs/ppc44x_defconfig            |    1 -
 arch/powerpc/configs/prpmc2800_defconfig         |    1 -
 arch/powerpc/configs/storcenter_defconfig        |    1 -
 arch/powerpc/configs/tqm8xx_defconfig            |    1 -
 52 files changed, 0 insertions(+), 52 deletions(-)

diff --git a/arch/powerpc/configs/40x/acadia_defconfig b/arch/powerpc/configs/40x/acadia_defconfig
index ed3bab7..69e06ee 100644
--- a/arch/powerpc/configs/40x/acadia_defconfig
+++ b/arch/powerpc/configs/40x/acadia_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/40x/ep405_defconfig b/arch/powerpc/configs/40x/ep405_defconfig
index 17582a3..cf06d42 100644
--- a/arch/powerpc/configs/40x/ep405_defconfig
+++ b/arch/powerpc/configs/40x/ep405_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/40x/kilauea_defconfig b/arch/powerpc/configs/40x/kilauea_defconfig
index f2d4be9..5ff338f 100644
--- a/arch/powerpc/configs/40x/kilauea_defconfig
+++ b/arch/powerpc/configs/40x/kilauea_defconfig
@@ -32,7 +32,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/40x/makalu_defconfig b/arch/powerpc/configs/40x/makalu_defconfig
index 42b9793..84505e3 100644
--- a/arch/powerpc/configs/40x/makalu_defconfig
+++ b/arch/powerpc/configs/40x/makalu_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/40x/walnut_defconfig b/arch/powerpc/configs/40x/walnut_defconfig
index aa1a4ca..0a19f43 100644
--- a/arch/powerpc/configs/40x/walnut_defconfig
+++ b/arch/powerpc/configs/40x/walnut_defconfig
@@ -27,7 +27,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/arches_defconfig b/arch/powerpc/configs/44x/arches_defconfig
index 329f9a3..44355c5 100644
--- a/arch/powerpc/configs/44x/arches_defconfig
+++ b/arch/powerpc/configs/44x/arches_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/bluestone_defconfig b/arch/powerpc/configs/44x/bluestone_defconfig
index 20c8d26..ca7f1f3 100644
--- a/arch/powerpc/configs/44x/bluestone_defconfig
+++ b/arch/powerpc/configs/44x/bluestone_defconfig
@@ -26,7 +26,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/canyonlands_defconfig b/arch/powerpc/configs/44x/canyonlands_defconfig
index d5be93e..7b8abd1 100644
--- a/arch/powerpc/configs/44x/canyonlands_defconfig
+++ b/arch/powerpc/configs/44x/canyonlands_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/ebony_defconfig b/arch/powerpc/configs/44x/ebony_defconfig
index f9269fc..31b58b0 100644
--- a/arch/powerpc/configs/44x/ebony_defconfig
+++ b/arch/powerpc/configs/44x/ebony_defconfig
@@ -28,7 +28,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/44x/eiger_defconfig b/arch/powerpc/configs/44x/eiger_defconfig
index 9be0890..faccaf6 100644
--- a/arch/powerpc/configs/44x/eiger_defconfig
+++ b/arch/powerpc/configs/44x/eiger_defconfig
@@ -34,7 +34,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/icon_defconfig b/arch/powerpc/configs/44x/icon_defconfig
index 82f7303..05782c1 100644
--- a/arch/powerpc/configs/44x/icon_defconfig
+++ b/arch/powerpc/configs/44x/icon_defconfig
@@ -33,7 +33,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/iss476-smp_defconfig b/arch/powerpc/configs/44x/iss476-smp_defconfig
index ca00cf7..49a1518 100644
--- a/arch/powerpc/configs/44x/iss476-smp_defconfig
+++ b/arch/powerpc/configs/44x/iss476-smp_defconfig
@@ -42,7 +42,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/44x/katmai_defconfig b/arch/powerpc/configs/44x/katmai_defconfig
index 109562c..f113797 100644
--- a/arch/powerpc/configs/44x/katmai_defconfig
+++ b/arch/powerpc/configs/44x/katmai_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/rainier_defconfig b/arch/powerpc/configs/44x/rainier_defconfig
index 21c33fa..4b91a44 100644
--- a/arch/powerpc/configs/44x/rainier_defconfig
+++ b/arch/powerpc/configs/44x/rainier_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/redwood_defconfig b/arch/powerpc/configs/44x/redwood_defconfig
index 4880281..b7113e1 100644
--- a/arch/powerpc/configs/44x/redwood_defconfig
+++ b/arch/powerpc/configs/44x/redwood_defconfig
@@ -34,7 +34,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/sequoia_defconfig b/arch/powerpc/configs/44x/sequoia_defconfig
index b7a653b..9642d99 100644
--- a/arch/powerpc/configs/44x/sequoia_defconfig
+++ b/arch/powerpc/configs/44x/sequoia_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/44x/taishan_defconfig b/arch/powerpc/configs/44x/taishan_defconfig
index 30de97f..09e3075 100644
--- a/arch/powerpc/configs/44x/taishan_defconfig
+++ b/arch/powerpc/configs/44x/taishan_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_CFI=y
diff --git a/arch/powerpc/configs/44x/warp_defconfig b/arch/powerpc/configs/44x/warp_defconfig
index 105bc56..551e50a 100644
--- a/arch/powerpc/configs/44x/warp_defconfig
+++ b/arch/powerpc/configs/44x/warp_defconfig
@@ -34,7 +34,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_STANDALONE is not set
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/52xx/cm5200_defconfig b/arch/powerpc/configs/52xx/cm5200_defconfig
index 69b57da..455c855 100644
--- a/arch/powerpc/configs/52xx/cm5200_defconfig
+++ b/arch/powerpc/configs/52xx/cm5200_defconfig
@@ -31,7 +31,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/52xx/motionpro_defconfig b/arch/powerpc/configs/52xx/motionpro_defconfig
index 0c7de96..b006f1b 100644
--- a/arch/powerpc/configs/52xx/motionpro_defconfig
+++ b/arch/powerpc/configs/52xx/motionpro_defconfig
@@ -32,7 +32,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/52xx/pcm030_defconfig b/arch/powerpc/configs/52xx/pcm030_defconfig
index 22e7195..dede9c8 100644
--- a/arch/powerpc/configs/52xx/pcm030_defconfig
+++ b/arch/powerpc/configs/52xx/pcm030_defconfig
@@ -45,7 +45,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/52xx/tqm5200_defconfig b/arch/powerpc/configs/52xx/tqm5200_defconfig
index 716a37b..47e5b25 100644
--- a/arch/powerpc/configs/52xx/tqm5200_defconfig
+++ b/arch/powerpc/configs/52xx/tqm5200_defconfig
@@ -36,7 +36,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/83xx/asp8347_defconfig b/arch/powerpc/configs/83xx/asp8347_defconfig
index d2762d9..985f95c 100644
--- a/arch/powerpc/configs/83xx/asp8347_defconfig
+++ b/arch/powerpc/configs/83xx/asp8347_defconfig
@@ -32,7 +32,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_OF_PARTS=y
diff --git a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
index e4ad2e2..0b73b7f 100644
--- a/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8313_rdb_defconfig
@@ -30,7 +30,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
index 34ff568..97ac3b9 100644
--- a/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
+++ b/arch/powerpc/configs/83xx/mpc8315_rdb_defconfig
@@ -30,7 +30,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
index 10b5c4c..05710bb 100644
--- a/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_mds_defconfig
@@ -31,7 +31,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
index 45925d7..0540d67 100644
--- a/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
+++ b/arch/powerpc/configs/83xx/mpc836x_rdk_defconfig
@@ -29,7 +29,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/83xx/sbc834x_defconfig b/arch/powerpc/configs/83xx/sbc834x_defconfig
index 6d6463f..a3bcda6 100644
--- a/arch/powerpc/configs/83xx/sbc834x_defconfig
+++ b/arch/powerpc/configs/83xx/sbc834x_defconfig
@@ -31,7 +31,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/85xx/ksi8560_defconfig b/arch/powerpc/configs/85xx/ksi8560_defconfig
index 8f7c106..aee0d17 100644
--- a/arch/powerpc/configs/85xx/ksi8560_defconfig
+++ b/arch/powerpc/configs/85xx/ksi8560_defconfig
@@ -28,7 +28,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/powerpc/configs/85xx/ppa8548_defconfig b/arch/powerpc/configs/85xx/ppa8548_defconfig
index a11337d..e80bb9b 100644
--- a/arch/powerpc/configs/85xx/ppa8548_defconfig
+++ b/arch/powerpc/configs/85xx/ppa8548_defconfig
@@ -44,7 +44,6 @@ CONFIG_MTD_CFI_INTELEXT=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_PHYSMAP_OF=y
 
 CONFIG_I2C=y
diff --git a/arch/powerpc/configs/85xx/socrates_defconfig b/arch/powerpc/configs/85xx/socrates_defconfig
index 77506b5..e514748 100644
--- a/arch/powerpc/configs/85xx/socrates_defconfig
+++ b/arch/powerpc/configs/85xx/socrates_defconfig
@@ -32,7 +32,6 @@ CONFIG_CAN_RAW=y
 CONFIG_CAN_BCM=y
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/85xx/tqm8540_defconfig b/arch/powerpc/configs/85xx/tqm8540_defconfig
index ddcb9f3..5a800e6 100644
--- a/arch/powerpc/configs/85xx/tqm8540_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8540_defconfig
@@ -26,7 +26,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/85xx/tqm8541_defconfig b/arch/powerpc/configs/85xx/tqm8541_defconfig
index 981abd6..2d93669 100644
--- a/arch/powerpc/configs/85xx/tqm8541_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8541_defconfig
@@ -26,7 +26,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/85xx/tqm8548_defconfig b/arch/powerpc/configs/85xx/tqm8548_defconfig
index 37b3d72..ce8a67e 100644
--- a/arch/powerpc/configs/85xx/tqm8548_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8548_defconfig
@@ -34,7 +34,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLKDEVS=y
diff --git a/arch/powerpc/configs/85xx/tqm8555_defconfig b/arch/powerpc/configs/85xx/tqm8555_defconfig
index 3593b32..a4e1297 100644
--- a/arch/powerpc/configs/85xx/tqm8555_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8555_defconfig
@@ -26,7 +26,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/85xx/tqm8560_defconfig b/arch/powerpc/configs/85xx/tqm8560_defconfig
index de413ac..341abe1 100644
--- a/arch/powerpc/configs/85xx/tqm8560_defconfig
+++ b/arch/powerpc/configs/85xx/tqm8560_defconfig
@@ -26,7 +26,6 @@ CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
index 1cd6fcb..07bb81d 100644
--- a/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
+++ b/arch/powerpc/configs/85xx/xes_mpc85xx_defconfig
@@ -65,7 +65,6 @@ CONFIG_ARPD=y
 CONFIG_IPV6=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
diff --git a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
index f2f6734..e5a6481 100644
--- a/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
+++ b/arch/powerpc/configs/86xx/gef_ppc9a_defconfig
@@ -70,7 +70,6 @@ CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc310_defconfig b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
index be73219..8317b60 100644
--- a/arch/powerpc/configs/86xx/gef_sbc310_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc310_defconfig
@@ -70,7 +70,6 @@ CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/86xx/gef_sbc610_defconfig b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
index b3e2b10..124d66f 100644
--- a/arch/powerpc/configs/86xx/gef_sbc610_defconfig
+++ b/arch/powerpc/configs/86xx/gef_sbc610_defconfig
@@ -123,7 +123,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
index c09598b..bcbe747 100644
--- a/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
+++ b/arch/powerpc/configs/86xx/mpc8610_hpcd_defconfig
@@ -41,7 +41,6 @@ CONFIG_IP_PNP_RARP=y
 CONFIG_IPV6=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/86xx/sbc8641d_defconfig b/arch/powerpc/configs/86xx/sbc8641d_defconfig
index 1a62baf..1e15159 100644
--- a/arch/powerpc/configs/86xx/sbc8641d_defconfig
+++ b/arch/powerpc/configs/86xx/sbc8641d_defconfig
@@ -120,7 +120,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/powerpc/configs/c2k_defconfig b/arch/powerpc/configs/c2k_defconfig
index 671a8f9..c69f616 100644
--- a/arch/powerpc/configs/c2k_defconfig
+++ b/arch/powerpc/configs/c2k_defconfig
@@ -149,7 +149,6 @@ CONFIG_BT_HCIVHCI=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=m
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/corenet64_smp_defconfig b/arch/powerpc/configs/corenet64_smp_defconfig
index 63508dd..e6c8d20 100644
--- a/arch/powerpc/configs/corenet64_smp_defconfig
+++ b/arch/powerpc/configs/corenet64_smp_defconfig
@@ -60,7 +60,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/linkstation_defconfig b/arch/powerpc/configs/linkstation_defconfig
index 8a874b9..3534352 100644
--- a/arch/powerpc/configs/linkstation_defconfig
+++ b/arch/powerpc/configs/linkstation_defconfig
@@ -59,7 +59,6 @@ CONFIG_IP_NF_ARP_MANGLE=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/mpc85xx_defconfig b/arch/powerpc/configs/mpc85xx_defconfig
index d2e0fab..6c13a85 100644
--- a/arch/powerpc/configs/mpc85xx_defconfig
+++ b/arch/powerpc/configs/mpc85xx_defconfig
@@ -81,7 +81,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/mpc85xx_smp_defconfig b/arch/powerpc/configs/mpc85xx_smp_defconfig
index 4cb7b59..08558ff 100644
--- a/arch/powerpc/configs/mpc85xx_smp_defconfig
+++ b/arch/powerpc/configs/mpc85xx_smp_defconfig
@@ -84,7 +84,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/ppc40x_defconfig b/arch/powerpc/configs/ppc40x_defconfig
index 1eb19ac..52908c7 100644
--- a/arch/powerpc/configs/ppc40x_defconfig
+++ b/arch/powerpc/configs/ppc40x_defconfig
@@ -33,7 +33,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/ppc44x_defconfig b/arch/powerpc/configs/ppc44x_defconfig
index 3b98d73..ccf66b9 100644
--- a/arch/powerpc/configs/ppc44x_defconfig
+++ b/arch/powerpc/configs/ppc44x_defconfig
@@ -44,7 +44,6 @@ CONFIG_BRIDGE=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=y
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/powerpc/configs/prpmc2800_defconfig b/arch/powerpc/configs/prpmc2800_defconfig
index cd80fb6..f84ea21 100644
--- a/arch/powerpc/configs/prpmc2800_defconfig
+++ b/arch/powerpc/configs/prpmc2800_defconfig
@@ -32,7 +32,6 @@ CONFIG_SYN_COOKIES=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/powerpc/configs/storcenter_defconfig b/arch/powerpc/configs/storcenter_defconfig
index ebb2a66..ba39c78 100644
--- a/arch/powerpc/configs/storcenter_defconfig
+++ b/arch/powerpc/configs/storcenter_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/powerpc/configs/tqm8xx_defconfig b/arch/powerpc/configs/tqm8xx_defconfig
index 8616fde..62c3e73 100644
--- a/arch/powerpc/configs/tqm8xx_defconfig
+++ b/arch/powerpc/configs/tqm8xx_defconfig
@@ -41,7 +41,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_OF_PARTS=y
 CONFIG_MTD_CHAR=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
