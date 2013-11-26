Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758312Ab3KZXlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:41:31 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:29125 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756449Ab3KZXl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:41:28 -0500
X-AuditID: cbfee691-b7f666d0000048b0-00-5295319c3d6d
Date: Tue, 26 Nov 2013 23:41:16 +0000 (GMT)
From: Eunbong Song <eunb.song@samsung.com>
Subject: [PATCH] ARM: Kill CONFIG_MTD_PARTITIONS
To: tony@atomide.com, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, nsekhar@ti.com,
        davinci-linux-open-source@linux.davincidsp.com, dwmw2@infradead.org
Reply-to: eunb.song@samsung.com
MIME-version: 1.0
X-MTR: 20131126232826295@eunb.song
Msgkey: 20131126232826295@eunb.song
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20131126232826295@eunb.song
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <17954130.75631385509274999.JavaMail.weblogic@epml11>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprIKsWRmVeSWpSXmKPExsVy+t8zTd05hlODDC7P0be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZO8/2MxccucxYceLYP5YGxo5zjF2MnBxCAioSLf+/g9kSAiYS
	L14eY4WwxSQu3FvP1sXIBVSzjFFi4rUXzDBFj+fvg0rMZ5RYsHQxWIJFQFXi7eTlYDabgLbE
	jwNXwWxhAQOJNf/Pg00VEciUuPWomRmkmVmgn1HiSOsqJogz5CUmn77MDmLzCghKnJz5hAVi
	m5LE87MngOIcQHFlie2/ciHCEhKzpl+AupRXYkb7U6hyOYlpX9dAHSotcX7WBkaYbxZ/fwwV
	55c4dnsHE8hIkN4n94Nhxuze/IUNwhaQmHrmIFSrusT8Z33sEDafxJqFb1lgxuw6tZwZpvf+
	lrlgnzALKEpM6X7IDmFrSXz5sY8N3Ve8Ao4Shx/uYJvAqDwLSWoWkvZZSNqR1SxgZFnFKJpa
	kFxQnJReZKpXnJhbXJqXrpecn7uJEZIcJu5gvH/A+hBjMjBKJjJLiSbnA5NLXkm8obGZkYWp
	iamxkbmlGWnCSuK86Y+SgoQE0hNLUrNTUwtSi+KLSnNSiw8xMnFwSjUwKmvGW04z/NDwVcji
	2aEGwZKHHXFerfNLJ86P09+iPtFa7NnxHdOnR38J+GCgOFWWdVMy4/O0PbFbDnI/dcrblbB4
	5WW22KqFbWFL2idwhdYtFpjfuVpo2e18kzufOKvdJu1Yrjfh5gbxJ4faO5Nik18xn43UkWIz
	W6VjvExi7prtl0z25H28oMRSnJFoqMVcVJwIADkBs8EkAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42I5/e/2TN05hlODDGa0aFpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jJ1n+5kLjlxmrDhx7B9LA2PHOcYuRk4OIQEViZb/38FsCQETicfz97FB2GISF+6tB7K5gGrm
	M0osWLqYGSTBIqAq8XbycjCbTUBb4seBq2C2sICBxJr/51lBbBGBTIlbj5qZQZqZBfoZJY60
	rmKC2CYvMfn0ZXYQm1dAUOLkzCcsENuUJJ6fPQEU5wCKK0ts/5ULEZaQmDX9AiuEzSsxo/0p
	VLmcxLSva5ghbGmJ87M2MMIcvfj7Y6g4v8Sx2zuYQEaC9D65HwwzZvfmL1A/CkhMPXMQqlVd
	Yv6zPnYIm09izcK3LDBjdp1azgzTe3/LXLBPmAUUJaZ0P2SHsLUkvvyAhBuyr3gFHCUOP9zB
	NoFRbhaS1Cwk7bOQtCOrWcDIsopRNLUguaA4Kb3CUK84Mbe4NC9dLzk/dxMjOE09W7iD8ct5
	60OMAhyMSjy8Ey5PCRJiTSwrrsw9xCjBwawkwmuqMDVIiDclsbIqtSg/vqg0J7X4EGMyMAIn
	MkuJJucDU2heSbyhsYGxoaGluYGpoZEFacJK4rx3byYFCQmkJ5akZqemFqQWwWxh4uCUamCs
	Ym4Wb/0Z88vqS9k/0/7gH+Kzf26N31qo6hGk/O3lkqcXGLc82vhGL67oc+7m2Q839lYV//w7
	d9FER+1tOw9cEzlx5PlWn8qI5z/YD9Q8yNrKsOXGJP+s87OmcvuXbft1a68363fGmEsx4hld
	zfebeOsSPF99urAjzHvV+i2XFGMOfni40mROuxJLcUaioRZzUXEiAGx50guXAwAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAQNfcHk015469


This patch removes CONFIG_MTD_PARTITIONS in config files for ARM.
Because CONFIG_MTD_PARTITIONS was removed by commit 6a8a98b22b10f1560d5f90aded4a54234b9b2724.

---
 arch/arm/configs/acs5k_defconfig        |    1 -
 arch/arm/configs/acs5k_tiny_defconfig   |    1 -
 arch/arm/configs/assabet_defconfig      |    1 -
 arch/arm/configs/at91x40_defconfig      |    1 -
 arch/arm/configs/badge4_defconfig       |    1 -
 arch/arm/configs/cerfcube_defconfig     |    1 -
 arch/arm/configs/cm_x300_defconfig      |    1 -
 arch/arm/configs/cns3420vb_defconfig    |    1 -
 arch/arm/configs/collie_defconfig       |    1 -
 arch/arm/configs/corgi_defconfig        |    1 -
 arch/arm/configs/davinci_all_defconfig  |    1 -
 arch/arm/configs/h5000_defconfig        |    1 -
 arch/arm/configs/iop13xx_defconfig      |    1 -
 arch/arm/configs/iop32x_defconfig       |    1 -
 arch/arm/configs/iop33x_defconfig       |    1 -
 arch/arm/configs/ixp4xx_defconfig       |    1 -
 arch/arm/configs/ks8695_defconfig       |    1 -
 arch/arm/configs/lart_defconfig         |    1 -
 arch/arm/configs/lpd270_defconfig       |    1 -
 arch/arm/configs/lubbock_defconfig      |    1 -
 arch/arm/configs/mackerel_defconfig     |    1 -
 arch/arm/configs/magician_defconfig     |    1 -
 arch/arm/configs/mainstone_defconfig    |    1 -
 arch/arm/configs/mini2440_defconfig     |    1 -
 arch/arm/configs/mv78xx0_defconfig      |    1 -
 arch/arm/configs/neponset_defconfig     |    1 -
 arch/arm/configs/netx_defconfig         |    1 -
 arch/arm/configs/nuc910_defconfig       |    1 -
 arch/arm/configs/nuc950_defconfig       |    1 -
 arch/arm/configs/nuc960_defconfig       |    1 -
 arch/arm/configs/omap1_defconfig        |    1 -
 arch/arm/configs/pcm027_defconfig       |    1 -
 arch/arm/configs/pleb_defconfig         |    1 -
 arch/arm/configs/pxa255-idp_defconfig   |    1 -
 arch/arm/configs/raumfeld_defconfig     |    1 -
 arch/arm/configs/realview-smp_defconfig |    1 -
 arch/arm/configs/realview_defconfig     |    1 -
 arch/arm/configs/shannon_defconfig      |    1 -
 arch/arm/configs/simpad_defconfig       |    1 -
 arch/arm/configs/spitz_defconfig        |    1 -
 arch/arm/configs/tct_hammer_defconfig   |    1 -
 arch/arm/configs/versatile_defconfig    |    1 -
 42 files changed, 0 insertions(+), 42 deletions(-)

diff --git a/arch/arm/configs/acs5k_defconfig b/arch/arm/configs/acs5k_defconfig
index 92b0f90..27ca89d 100644
--- a/arch/arm/configs/acs5k_defconfig
+++ b/arch/arm/configs/acs5k_defconfig
@@ -35,7 +35,6 @@ CONFIG_IP_PNP_DHCP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/acs5k_tiny_defconfig b/arch/arm/configs/acs5k_tiny_defconfig
index 2a27a14..1f663ca 100644
--- a/arch/arm/configs/acs5k_tiny_defconfig
+++ b/arch/arm/configs/acs5k_tiny_defconfig
@@ -30,7 +30,6 @@ CONFIG_INET=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/assabet_defconfig b/arch/arm/configs/assabet_defconfig
index 558ecd8..bdf6f9c 100644
--- a/arch/arm/configs/assabet_defconfig
+++ b/arch/arm/configs/assabet_defconfig
@@ -22,7 +22,6 @@ CONFIG_IRDA=m
 CONFIG_IRLAN=m
 CONFIG_SA1100_FIR=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/at91x40_defconfig b/arch/arm/configs/at91x40_defconfig
index c55e921..5886aea 100644
--- a/arch/arm/configs/at91x40_defconfig
+++ b/arch/arm/configs/at91x40_defconfig
@@ -29,7 +29,6 @@ CONFIG_BINFMT_FLAT=y
 # CONFIG_SUSPEND is not set
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_RAM=y
diff --git a/arch/arm/configs/badge4_defconfig b/arch/arm/configs/badge4_defconfig
index 5b54abb..b21bd0a 100644
--- a/arch/arm/configs/badge4_defconfig
+++ b/arch/arm/configs/badge4_defconfig
@@ -30,7 +30,6 @@ CONFIG_BT_HCIVHCI=m
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/cerfcube_defconfig b/arch/arm/configs/cerfcube_defconfig
index dce912d..dcee643 100644
--- a/arch/arm/configs/cerfcube_defconfig
+++ b/arch/arm/configs/cerfcube_defconfig
@@ -29,7 +29,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_IP_PNP_RARP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=m
diff --git a/arch/arm/configs/cm_x300_defconfig b/arch/arm/configs/cm_x300_defconfig
index f4b7672..1bddbd9 100644
--- a/arch/arm/configs/cm_x300_defconfig
+++ b/arch/arm/configs/cm_x300_defconfig
@@ -51,7 +51,6 @@ CONFIG_BT_HCIBTUSB=m
 CONFIG_LIB80211=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_NAND=y
diff --git a/arch/arm/configs/cns3420vb_defconfig b/arch/arm/configs/cns3420vb_defconfig
index b1ff5cd..e5f02de 100644
--- a/arch/arm/configs/cns3420vb_defconfig
+++ b/arch/arm/configs/cns3420vb_defconfig
@@ -31,7 +31,6 @@ CONFIG_CMDLINE="console=ttyS0,38400 mem=128M root=/dev/mmcblk0p1 ro rootwait"
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/collie_defconfig b/arch/arm/configs/collie_defconfig
index 6c56ad0..4fff4ea 100644
--- a/arch/arm/configs/collie_defconfig
+++ b/arch/arm/configs/collie_defconfig
@@ -26,7 +26,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/corgi_defconfig b/arch/arm/configs/corgi_defconfig
index 1fd1d1d..442043d 100644
--- a/arch/arm/configs/corgi_defconfig
+++ b/arch/arm/configs/corgi_defconfig
@@ -90,7 +90,6 @@ CONFIG_BT_HCIBTUART=m
 CONFIG_BT_HCIVHCI=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/davinci_all_defconfig b/arch/arm/configs/davinci_all_defconfig
index ab2f737..c5e0224 100644
--- a/arch/arm/configs/davinci_all_defconfig
+++ b/arch/arm/configs/davinci_all_defconfig
@@ -48,7 +48,6 @@ CONFIG_DEVTMPFS=y
 CONFIG_DEVTMPFS_MOUNT=y
 # CONFIG_FW_LOADER is not set
 CONFIG_MTD=m
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=m
 CONFIG_MTD_BLOCK=m
 CONFIG_MTD_CFI=m
diff --git a/arch/arm/configs/h5000_defconfig b/arch/arm/configs/h5000_defconfig
index 37903e3..68703a5 100644
--- a/arch/arm/configs/h5000_defconfig
+++ b/arch/arm/configs/h5000_defconfig
@@ -36,7 +36,6 @@ CONFIG_IP_PNP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
 CONFIG_MTD_CFI_ADV_OPTIONS=y
diff --git a/arch/arm/configs/iop13xx_defconfig b/arch/arm/configs/iop13xx_defconfig
index 4fa94a1..6de6017 100644
--- a/arch/arm/configs/iop13xx_defconfig
+++ b/arch/arm/configs/iop13xx_defconfig
@@ -38,7 +38,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/iop32x_defconfig b/arch/arm/configs/iop32x_defconfig
index 4f2ec3a..c18ee5b 100644
--- a/arch/arm/configs/iop32x_defconfig
+++ b/arch/arm/configs/iop32x_defconfig
@@ -34,7 +34,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/iop33x_defconfig b/arch/arm/configs/iop33x_defconfig
index aa36128..e2304e4 100644
--- a/arch/arm/configs/iop33x_defconfig
+++ b/arch/arm/configs/iop33x_defconfig
@@ -32,7 +32,6 @@ CONFIG_IPV6=y
 # CONFIG_IPV6_SIT is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_REDBOOT_PARTS_READONLY=y
diff --git a/arch/arm/configs/ixp4xx_defconfig b/arch/arm/configs/ixp4xx_defconfig
index 063e2ab..c4d3066 100644
--- a/arch/arm/configs/ixp4xx_defconfig
+++ b/arch/arm/configs/ixp4xx_defconfig
@@ -114,7 +114,6 @@ CONFIG_NET_ACT_POLICE=y
 CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/ks8695_defconfig b/arch/arm/configs/ks8695_defconfig
index 47c4883..c58fc9a 100644
--- a/arch/arm/configs/ks8695_defconfig
+++ b/arch/arm/configs/ks8695_defconfig
@@ -32,7 +32,6 @@ CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
diff --git a/arch/arm/configs/lart_defconfig b/arch/arm/configs/lart_defconfig
index faa2865..3ae0387 100644
--- a/arch/arm/configs/lart_defconfig
+++ b/arch/arm/configs/lart_defconfig
@@ -31,7 +31,6 @@ CONFIG_SA1100_FIR=m
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
 CONFIG_MTD_DEBUG_VERBOSE=1
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_LART=y
diff --git a/arch/arm/configs/lpd270_defconfig b/arch/arm/configs/lpd270_defconfig
index 1c8c9ee..2e1c520 100644
--- a/arch/arm/configs/lpd270_defconfig
+++ b/arch/arm/configs/lpd270_defconfig
@@ -21,7 +21,6 @@ CONFIG_IPV6=y
 # CONFIG_INET6_XFRM_MODE_BEET is not set
 # CONFIG_IPV6_SIT is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/lubbock_defconfig b/arch/arm/configs/lubbock_defconfig
index c4ba274..198d7c3 100644
--- a/arch/arm/configs/lubbock_defconfig
+++ b/arch/arm/configs/lubbock_defconfig
@@ -20,7 +20,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mackerel_defconfig b/arch/arm/configs/mackerel_defconfig
index 9fb1189..77128cc 100644
--- a/arch/arm/configs/mackerel_defconfig
+++ b/arch/arm/configs/mackerel_defconfig
@@ -45,7 +45,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/magician_defconfig b/arch/arm/configs/magician_defconfig
index 557dd29..59f7e6a 100644
--- a/arch/arm/configs/magician_defconfig
+++ b/arch/arm/configs/magician_defconfig
@@ -60,7 +60,6 @@ CONFIG_BT_HCIBTUSB=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mainstone_defconfig b/arch/arm/configs/mainstone_defconfig
index 04efa1b..289d20a 100644
--- a/arch/arm/configs/mainstone_defconfig
+++ b/arch/arm/configs/mainstone_defconfig
@@ -18,7 +18,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_BOOTP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mini2440_defconfig b/arch/arm/configs/mini2440_defconfig
index a07948a..1d65757 100644
--- a/arch/arm/configs/mini2440_defconfig
+++ b/arch/arm/configs/mini2440_defconfig
@@ -86,7 +86,6 @@ CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_CONNECTOR=m
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/mv78xx0_defconfig b/arch/arm/configs/mv78xx0_defconfig
index 1f08219..ce28274 100644
--- a/arch/arm/configs/mv78xx0_defconfig
+++ b/arch/arm/configs/mv78xx0_defconfig
@@ -37,7 +37,6 @@ CONFIG_NET_PKTGEN=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_FIRMWARE_IN_KERNEL is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/neponset_defconfig b/arch/arm/configs/neponset_defconfig
index d7dc992..143e71b 100644
--- a/arch/arm/configs/neponset_defconfig
+++ b/arch/arm/configs/neponset_defconfig
@@ -26,7 +26,6 @@ CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/netx_defconfig b/arch/arm/configs/netx_defconfig
index 9c0ad79..81b6225 100644
--- a/arch/arm/configs/netx_defconfig
+++ b/arch/arm/configs/netx_defconfig
@@ -37,7 +37,6 @@ CONFIG_NETFILTER=y
 CONFIG_IP_NF_QUEUE=m
 CONFIG_NET_PKTGEN=m
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/nuc910_defconfig b/arch/arm/configs/nuc910_defconfig
index 10180cf..4af6de9 100644
--- a/arch/arm/configs/nuc910_defconfig
+++ b/arch/arm/configs/nuc910_defconfig
@@ -17,7 +17,6 @@ CONFIG_FPE_NWFPE=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/nuc950_defconfig b/arch/arm/configs/nuc950_defconfig
index 27aa873..e90cc26 100644
--- a/arch/arm/configs/nuc950_defconfig
+++ b/arch/arm/configs/nuc950_defconfig
@@ -23,7 +23,6 @@ CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/nuc960_defconfig b/arch/arm/configs/nuc960_defconfig
index 56fd7ad..b342b6e 100644
--- a/arch/arm/configs/nuc960_defconfig
+++ b/arch/arm/configs/nuc960_defconfig
@@ -23,7 +23,6 @@ CONFIG_BINFMT_MISC=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/omap1_defconfig b/arch/arm/configs/omap1_defconfig
index d74edba..468e754 100644
--- a/arch/arm/configs/omap1_defconfig
+++ b/arch/arm/configs/omap1_defconfig
@@ -97,7 +97,6 @@ CONFIG_CONNECTOR=y
 CONFIG_MTD=y
 CONFIG_MTD_DEBUG=y
 CONFIG_MTD_DEBUG_VERBOSE=3
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/pcm027_defconfig b/arch/arm/configs/pcm027_defconfig
index 2f136c3..60c4fd8 100644
--- a/arch/arm/configs/pcm027_defconfig
+++ b/arch/arm/configs/pcm027_defconfig
@@ -39,7 +39,6 @@ CONFIG_IP_PNP=y
 # CONFIG_IPV6 is not set
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/pleb_defconfig b/arch/arm/configs/pleb_defconfig
index cb08cc5..7ad5c8e 100644
--- a/arch/arm/configs/pleb_defconfig
+++ b/arch/arm/configs/pleb_defconfig
@@ -24,7 +24,6 @@ CONFIG_INET=y
 CONFIG_SYN_COOKIES=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_REDBOOT_PARTS=y
 CONFIG_MTD_REDBOOT_PARTS_UNALLOCATED=y
 CONFIG_MTD_CMDLINE_PARTS=y
diff --git a/arch/arm/configs/pxa255-idp_defconfig b/arch/arm/configs/pxa255-idp_defconfig
index 917a070..eb35347 100644
--- a/arch/arm/configs/pxa255-idp_defconfig
+++ b/arch/arm/configs/pxa255-idp_defconfig
@@ -18,7 +18,6 @@ CONFIG_IP_PNP=y
 CONFIG_IP_PNP_DHCP=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/raumfeld_defconfig b/arch/arm/configs/raumfeld_defconfig
index f7caa90..8605aad 100644
--- a/arch/arm/configs/raumfeld_defconfig
+++ b/arch/arm/configs/raumfeld_defconfig
@@ -32,7 +32,6 @@ CONFIG_MAC80211=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_NFTL=y
diff --git a/arch/arm/configs/realview-smp_defconfig b/arch/arm/configs/realview-smp_defconfig
index abe61bf..0c347c5 100644
--- a/arch/arm/configs/realview-smp_defconfig
+++ b/arch/arm/configs/realview-smp_defconfig
@@ -31,7 +31,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/realview_defconfig b/arch/arm/configs/realview_defconfig
index 7079cbe..47e2d75 100644
--- a/arch/arm/configs/realview_defconfig
+++ b/arch/arm/configs/realview_defconfig
@@ -30,7 +30,6 @@ CONFIG_IP_PNP_BOOTP=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/shannon_defconfig b/arch/arm/configs/shannon_defconfig
index b0b9694..aa8ffd6 100644
--- a/arch/arm/configs/shannon_defconfig
+++ b/arch/arm/configs/shannon_defconfig
@@ -17,7 +17,6 @@ CONFIG_UNIX=y
 CONFIG_INET=y
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/simpad_defconfig b/arch/arm/configs/simpad_defconfig
index d335815..ae3666f 100644
--- a/arch/arm/configs/simpad_defconfig
+++ b/arch/arm/configs/simpad_defconfig
@@ -42,7 +42,6 @@ CONFIG_BT_BNEP_MC_FILTER=y
 CONFIG_BT_BNEP_PROTO_FILTER=y
 CONFIG_MTD=y
 CONFIG_MTD_CONCAT=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/spitz_defconfig b/arch/arm/configs/spitz_defconfig
index 2e0419d..5d12495 100644
--- a/arch/arm/configs/spitz_defconfig
+++ b/arch/arm/configs/spitz_defconfig
@@ -87,7 +87,6 @@ CONFIG_BT_HCIBTUART=m
 CONFIG_BT_HCIVHCI=m
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
diff --git a/arch/arm/configs/tct_hammer_defconfig b/arch/arm/configs/tct_hammer_defconfig
index 71277a1..18d52c5 100644
--- a/arch/arm/configs/tct_hammer_defconfig
+++ b/arch/arm/configs/tct_hammer_defconfig
@@ -26,7 +26,6 @@ CONFIG_UNIX=y
 CONFIG_UEVENT_HELPER_PATH="/sbin/hotplug"
 # CONFIG_PREVENT_FIRMWARE_BUILD is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
 CONFIG_MTD_CFI=y
diff --git a/arch/arm/configs/versatile_defconfig b/arch/arm/configs/versatile_defconfig
index 2ba9e63..b2b40b8 100644
--- a/arch/arm/configs/versatile_defconfig
+++ b/arch/arm/configs/versatile_defconfig
@@ -26,7 +26,6 @@ CONFIG_IP_PNP_BOOTP=y
 # CONFIG_INET_DIAG is not set
 # CONFIG_IPV6 is not set
 CONFIG_MTD=y
-CONFIG_MTD_PARTITIONS=y
 CONFIG_MTD_CMDLINE_PARTS=y
 CONFIG_MTD_CHAR=y
 CONFIG_MTD_BLOCK=y
-- 
1.7.0.4
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
