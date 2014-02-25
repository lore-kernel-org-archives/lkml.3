Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaBYWkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 17:40:04 -0500
Received: from smtprelay0191.hostedemail.com ([216.40.44.191]:40391 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752938AbaBYWkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 17:40:02 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:2:41:69:355:379:541:800:960:967:973:988:989:1260:1345:1431:1437:1535:1606:1730:1747:1777:1792:2393:2525:2568:2631:2682:2685:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3355:3867:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4117:4605:4659:5007:6119:6261:6642:7514:7809:8599:9010:9025:9038:9388:10004:10026:10049:10848:11026:11232:11257:11657:11658:11914:12043:12291:12517:12519:12555:12683:14106:14110:21060,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: print76_1724d818157
X-Filterd-Recvd-Size: 6142
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] MAINTAINERS: Use tab for separator
Date: Tue, 25 Feb 2014 14:39:59 -0800
Message-Id: <7b47ed779e3545c430912c4c4c96096b4ab3161b.1393367945.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert whitespace to single tab for separators.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 88 ++++++++++++++++++++++++++++++-------------------------------
 1 file changed, 44 insertions(+), 44 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 90baeb1..08c519d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1620,11 +1620,11 @@ S:	Maintained
 F:	drivers/net/wireless/atmel*
 
 ATTO EXPRESSSAS SAS/SATA RAID SCSI DRIVER
-M:      Bradley Grove <linuxdrivers@attotech.com>
-L:      linux-scsi@vger.kernel.org
-W:      http://www.attotech.com
-S:      Supported
-F:      drivers/scsi/esas2r
+M:	Bradley Grove <linuxdrivers@attotech.com>
+L:	linux-scsi@vger.kernel.org
+W:	http://www.attotech.com
+S:	Supported
+F:	drivers/scsi/esas2r
 
 AUDIT SUBSYSTEM
 M:	Eric Paris <eparis@redhat.com>
@@ -2194,9 +2194,9 @@ S:	Supported
 F:	drivers/net/ethernet/cisco/enic/
 
 CISCO VIC LOW LATENCY NIC DRIVER
-M:      Upinder Malhi <umalhi@cisco.com>
-S:      Supported
-F:      drivers/infiniband/hw/usnic
+M:	Upinder Malhi <umalhi@cisco.com>
+S:	Supported
+F:	drivers/infiniband/hw/usnic
 
 CIRRUS LOGIC EP93XX ETHERNET DRIVER
 M:	Hartley Sweeten <hsweeten@visionengravers.com>
@@ -2400,13 +2400,13 @@ F:	drivers/cpufreq/arm_big_little.c
 F:	drivers/cpufreq/arm_big_little_dt.c
 
 CPUIDLE DRIVER - ARM BIG LITTLE
-M:      Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
-M:      Daniel Lezcano <daniel.lezcano@linaro.org>
-L:      linux-pm@vger.kernel.org
-L:      linux-arm-kernel@lists.infradead.org
-T:      git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
-S:      Maintained
-F:      drivers/cpuidle/cpuidle-big_little.c
+M:	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
+M:	Daniel Lezcano <daniel.lezcano@linaro.org>
+L:	linux-pm@vger.kernel.org
+L:	linux-arm-kernel@lists.infradead.org
+T:	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
+S:	Maintained
+F:	drivers/cpuidle/cpuidle-big_little.c
 
 CPUIDLE DRIVERS
 M:	Rafael J. Wysocki <rjw@rjwysocki.net>
@@ -2480,9 +2480,9 @@ S:	Maintained
 F:	sound/pci/cs5535audio/
 
 CW1200 WLAN driver
-M:     Solomon Peachy <pizza@shaftnet.org>
-S:     Maintained
-F:     drivers/net/wireless/cw1200/
+M:	Solomon Peachy <pizza@shaftnet.org>
+S:	Maintained
+F:	drivers/net/wireless/cw1200/
 
 CX18 VIDEO4LINUX DRIVER
 M:	Andy Walls <awalls@md.metrocast.net>
@@ -5487,11 +5487,11 @@ S:	Maintained
 F:	drivers/media/tuners/m88ts2022*
 
 MA901 MASTERKIT USB FM RADIO DRIVER
-M:      Alexey Klimov <klimov.linux@gmail.com>
-L:      linux-media@vger.kernel.org
-T:      git git://linuxtv.org/media_tree.git
-S:      Maintained
-F:      drivers/media/radio/radio-ma901.c
+M:	Alexey Klimov <klimov.linux@gmail.com>
+L:	linux-media@vger.kernel.org
+T:	git git://linuxtv.org/media_tree.git
+S:	Maintained
+F:	drivers/media/radio/radio-ma901.c
 
 MAC80211
 M:	Johannes Berg <johannes@sipsolutions.net>
@@ -5647,7 +5647,7 @@ F:	drivers/scsi/megaraid/
 
 MELLANOX ETHERNET DRIVER (mlx4_en)
 M:	Amir Vadai <amirv@mellanox.com>
-L: 	netdev@vger.kernel.org
+L:	netdev@vger.kernel.org
 S:	Supported
 W:	http://www.mellanox.com
 Q:	http://patchwork.ozlabs.org/project/netdev/list/
@@ -5688,7 +5688,7 @@ F:	include/linux/mtd/
 F:	include/uapi/mtd/
 
 MEN A21 WATCHDOG DRIVER
-M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
 L:	linux-watchdog@vger.kernel.org
 S:	Supported
 F:	drivers/watchdog/mena21_wdt.c
@@ -5750,14 +5750,14 @@ F:	drivers/net/ethernet/mellanox/mlx5/core/
 F:	include/linux/mlx5/
 
 Mellanox MLX5 IB driver
-M:      Eli Cohen <eli@mellanox.com>
-L:      linux-rdma@vger.kernel.org
-W:      http://www.mellanox.com
-Q:      http://patchwork.kernel.org/project/linux-rdma/list/
-T:      git://openfabrics.org/~eli/connect-ib.git
-S:      Supported
-F:      include/linux/mlx5/
-F:      drivers/infiniband/hw/mlx5/
+M:	Eli Cohen <eli@mellanox.com>
+L:	linux-rdma@vger.kernel.org
+W:	http://www.mellanox.com
+Q:	http://patchwork.kernel.org/project/linux-rdma/list/
+T:	git://openfabrics.org/~eli/connect-ib.git
+S:	Supported
+F:	include/linux/mlx5/
+F:	drivers/infiniband/hw/mlx5/
 
 MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
@@ -8741,17 +8741,17 @@ S:	Maintained
 F:	drivers/media/radio/radio-raremono.c
 
 THERMAL
-M:      Zhang Rui <rui.zhang@intel.com>
-M:      Eduardo Valentin <eduardo.valentin@ti.com>
-L:      linux-pm@vger.kernel.org
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
-T:      git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
-Q:      https://patchwork.kernel.org/project/linux-pm/list/
-S:      Supported
-F:      drivers/thermal/
-F:      include/linux/thermal.h
-F:      include/linux/cpu_cooling.h
-F:      Documentation/devicetree/bindings/thermal/
+M:	Zhang Rui <rui.zhang@intel.com>
+M:	Eduardo Valentin <eduardo.valentin@ti.com>
+L:	linux-pm@vger.kernel.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/evalenti/linux-soc-thermal.git
+Q:	https://patchwork.kernel.org/project/linux-pm/list/
+S:	Supported
+F:	drivers/thermal/
+F:	include/linux/thermal.h
+F:	include/linux/cpu_cooling.h
+F:	Documentation/devicetree/bindings/thermal/
 
 THINGM BLINK(1) USB RGB LED DRIVER
 M:	Vivien Didelot <vivien.didelot@savoirfairelinux.com>
-- 
1.8.1.2.459.gbcd45b4.dirty

