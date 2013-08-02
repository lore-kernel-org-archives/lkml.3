Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab3HBTln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 15:41:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44371 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751655Ab3HBTlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 15:41:42 -0400
Message-ID: <1375472500.2034.128.camel@joe-AO722>
Subject: [PATCH] MAINTAINERS: Append "/" to directory patterns
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Fri, 02 Aug 2013 12:41:40 -0700
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's clearer to have patterns marked as directories.

Change the directory patterns without terminating slashes.

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS | 46 +++++++++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a44965..11269e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1003,7 +1003,7 @@ F:	arch/arm/mach-orion5x/ts78xx-*
 ARM/MICREL KS8695 ARCHITECTURE
 M:	Greg Ungerer <gerg@uclinux.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
-F:	arch/arm/mach-ks8695
+F:	arch/arm/mach-ks8695/
 S:	Odd Fixes
 
 ARM/MIOA701 MACHINE SUPPORT
@@ -2005,10 +2005,10 @@ W:	http://ceph.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git
 S:	Supported
 F:	Documentation/filesystems/ceph.txt
-F:	fs/ceph
-F:	net/ceph
-F:	include/linux/ceph
-F:	include/linux/crush
+F:	fs/ceph/
+F:	net/ceph/
+F:	include/linux/ceph/
+F:	include/linux/crush/
 
 CERTIFIED WIRELESS USB (WUSB) SUBSYSTEM:
 L:	linux-usb@vger.kernel.org
@@ -2118,7 +2118,7 @@ M:	Daniel Lezcano <daniel.lezcano@linaro.org>
 M:	Thomas Gleixner <tglx@linutronix.de>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers/core
 S:	Supported
-F:	drivers/clocksource
+F:	drivers/clocksource/
 
 CISCO FCOE HBA DRIVER
 M:	Hiral Patel <hiralpat@cisco.com>
@@ -2295,7 +2295,7 @@ CPU POWER MONITORING SUBSYSTEM
 M:	Dominik Brodowski <linux@dominikbrodowski.net>
 M:	Thomas Renninger <trenn@suse.de>
 S:	Maintained
-F:	tools/power/cpupower
+F:	tools/power/cpupower/
 
 CPUSETS
 M:	Li Zefan <lizefan@huawei.com>
@@ -2733,7 +2733,7 @@ L:	intel-gfx@lists.freedesktop.org
 L:	dri-devel@lists.freedesktop.org
 T:	git git://people.freedesktop.org/~danvet/drm-intel
 S:	Supported
-F:	drivers/gpu/drm/i915
+F:	drivers/gpu/drm/i915/
 F:	include/drm/i915*
 F:	include/uapi/drm/i915*
 
@@ -2745,7 +2745,7 @@ M:	Kyungmin Park <kyungmin.park@samsung.com>
 L:	dri-devel@lists.freedesktop.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/daeinki/drm-exynos.git
 S:	Supported
-F:	drivers/gpu/drm/exynos
+F:	drivers/gpu/drm/exynos/
 F:	include/drm/exynos*
 F:	include/uapi/drm/exynos*
 
@@ -3604,8 +3604,8 @@ M:	Arnd Bergmann <arnd@arndb.de>
 L:	linux-arch@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/arnd/asm-generic.git
 S:	Maintained
-F:	include/asm-generic
-F:	include/uapi/asm-generic
+F:	include/asm-generic/
+F:	include/uapi/asm-generic/
 
 GENERIC UIO DRIVER FOR PCI DEVICES
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -3726,7 +3726,7 @@ L:	linux-media@vger.kernel.org
 T:	git git://linuxtv.org/media_tree.git
 W:	http://linuxtv.org
 S:	Odd Fixes
-F:	drivers/media/usb/hdpvr
+F:	drivers/media/usb/hdpvr/
 
 HWPOISON MEMORY FAILURE HANDLING
 M:	Andi Kleen <andi@firstfloor.org>
@@ -4527,7 +4527,7 @@ S:	Supported
 W:	http://www.openfabrics.org
 W:	www.open-iscsi.org
 Q:	http://patchwork.kernel.org/project/linux-rdma/list/
-F:	drivers/infiniband/ulp/iser
+F:	drivers/infiniband/ulp/iser/
 
 ISDN SUBSYSTEM
 M:	Karsten Keil <isdn@linux-pingi.de>
@@ -6086,7 +6086,7 @@ W:	http://openrisc.net
 L:	linux@lists.openrisc.net (moderated for non-subscribers)
 S:	Maintained
 T:	git git://openrisc.net/~jonas/linux
-F:	arch/openrisc
+F:	arch/openrisc/
 
 OPENVSWITCH
 M:	Jesse Gross <jesse@nicira.com>
@@ -6370,7 +6370,7 @@ M:	Jamie Iles <jamie@jamieiles.com>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 T:	git git://github.com/jamieiles/linux-2.6-ji.git
 S:	Supported
-F:	arch/arm/mach-picoxcell
+F:	arch/arm/mach-picoxcell/
 F:	drivers/*/picoxcell*
 F:	drivers/*/*/picoxcell*
 
@@ -6643,7 +6643,7 @@ F:	drivers/spi/spi-pxa2xx*
 F:	drivers/usb/gadget/pxa2*
 F:	include/sound/pxa2xx-lib.h
 F:	sound/arm/pxa*
-F:	sound/soc/pxa
+F:	sound/soc/pxa/
 
 MMP SUPPORT
 M:	Eric Miao <eric.y.miao@gmail.com>
@@ -7088,7 +7088,7 @@ SAMSUNG AUDIO (ASoC) DRIVERS
 M:	Sangbeom Kim <sbkim73@samsung.com>
 L:	alsa-devel@alsa-project.org (moderated for non-subscribers)
 S:	Supported
-F:	sound/soc/samsung
+F:	sound/soc/samsung/
 
 SAMSUNG FRAMEBUFFER DRIVER
 M:	Jingoo Han <jg1.han@samsung.com>
@@ -7134,7 +7134,7 @@ SERIAL DRIVERS
 M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 L:	linux-serial@vger.kernel.org
 S:	Maintained
-F:	drivers/tty/serial
+F:	drivers/tty/serial/
 
 SYNOPSYS DESIGNWARE DMAC DRIVER
 M:	Viresh Kumar <viresh.linux@gmail.com>
@@ -7169,7 +7169,7 @@ TLG2300 VIDEO4LINUX-2 DRIVER
 M:	Huang Shijie <shijie8@gmail.com>
 M:	Hans Verkuil <hverkuil@xs4all.nl>
 S:	Odd Fixes
-F:	drivers/media/usb/tlg2300
+F:	drivers/media/usb/tlg2300/
 
 SC1200 WDT DRIVER
 M:	Zwane Mwaikambo <zwane@arm.linux.org.uk>
@@ -7441,7 +7441,7 @@ S:	Odd fixes
 F:	drivers/media/common/siano/
 F:	drivers/media/usb/siano/
 F:	drivers/media/usb/siano/
-F:	drivers/media/mmc/siano
+F:	drivers/media/mmc/siano/
 
 SH_VEU V4L2 MEM2MEM DRIVER
 M:	Guennadi Liakhovetski <g.liakhovetski@gmx.de>
@@ -7490,7 +7490,7 @@ L:	davinci-linux-open-source@linux.davincidsp.com (moderated for non-subscribers
 T:	git git://gitorious.org/linux-davinci/linux-davinci.git
 Q:	http://patchwork.kernel.org/project/linux-davinci/list/
 S:	Supported
-F:	arch/arm/mach-davinci
+F:	arch/arm/mach-davinci/
 F:	drivers/i2c/busses/i2c-davinci.c
 
 TI DAVINCI SERIES MEDIA DRIVER
@@ -7567,7 +7567,7 @@ SMIA AND SMIA++ IMAGE SENSOR DRIVER
 M:	Sakari Ailus <sakari.ailus@iki.fi>
 L:	linux-media@vger.kernel.org
 S:	Maintained
-F:	drivers/media/i2c/smiapp
+F:	drivers/media/i2c/smiapp/
 F:	include/media/smiapp.h
 F:	drivers/media/i2c/smiapp-pll.c
 F:	drivers/media/i2c/smiapp-pll.h
@@ -9206,7 +9206,7 @@ M:	Matthew Garrett <matthew.garrett@nebula.com>
 L:	platform-driver-x86@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-drivers-x86.git
 S:	Maintained
-F:	drivers/platform/x86
+F:	drivers/platform/x86/
 
 X86 MCE INFRASTRUCTURE
 M:	Tony Luck <tony.luck@intel.com>


