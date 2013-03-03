Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab3CCBzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 20:55:02 -0500
Received: from smtp-01.mandic.com.br ([200.225.81.132]:40647 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab3CCByS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 20:54:18 -0500
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Cesar Eduardo Barros <cesarb@cesarb.net>,
        David Howells <dhowells@redhat.com>
Subject: =?UTF-8?q?=5BPATCH=2012/14=5D=20MAINTAINERS=3A=20adjust=20for=20UAPI=20=28part=202=29?=
Date: Sat,  2 Mar 2013 22:53:50 -0300
Message-Id: <1362275632-20242-13-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

More headers were moved or split to uapi/ since the last patch was
created.

Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 MAINTAINERS | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b73c00d..772da4f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -474,6 +474,7 @@ L:	linux-aio@kvack.org
 S:	Supported
 F:	fs/aio.c
 F:	include/linux/*aio*.h
+F:	include/uapi/linux/*aio*.h
 
 ALCATEL SPEEDTOUCH USB DRIVER
 M:	Duncan Sands <duncan.sands@free.fr>
@@ -2178,6 +2179,7 @@ L:	cgroups@vger.kernel.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 S:	Maintained
 F:	include/linux/cgroup*
+F:	include/uapi/linux/cgroup*
 F:	kernel/cgroup*
 F:	mm/*cgroup*
 
@@ -2493,6 +2495,7 @@ F:	drivers/md/dm*
 F:	drivers/md/persistent-data/
 F:	include/linux/device-mapper.h
 F:	include/linux/dm-*.h
+F:	include/uapi/linux/dm-*.h
 
 DIOLAN U2C-12 I2C DRIVER
 M:	Guenter Roeck <linux@roeck-us.net>
@@ -3064,6 +3067,7 @@ L:	netdev@vger.kernel.org
 W:	http://www.linuxfoundation.org/en/Net:Bridge
 S:	Maintained
 F:	include/linux/netfilter_bridge/
+F:	include/uapi/linux/netfilter_bridge/
 F:	net/bridge/
 
 EXT2 FILE SYSTEM
@@ -4557,6 +4561,7 @@ S:	Supported
 F:	Documentation/*/kvm.txt
 F:	arch/*/kvm/
 F:	arch/*/include/asm/kvm*
+F:	arch/*/include/uapi/asm/kvm*
 F:	include/linux/kvm*
 F:	include/uapi/linux/kvm*
 F:	virt/kvm/
@@ -4567,6 +4572,7 @@ L:	kvm@vger.kernel.org
 W:	http://kvm.qumranet.com
 S:	Maintained
 F:	arch/x86/include/asm/svm.h
+F:	arch/x86/include/uapi/asm/svm.h
 F:	arch/x86/kvm/svm.c
 
 KERNEL VIRTUAL MACHINE (KVM) FOR POWERPC
@@ -4576,6 +4582,7 @@ W:	http://kvm.qumranet.com
 T:	git git://github.com/agraf/linux-2.6.git
 S:	Supported
 F:	arch/powerpc/include/asm/kvm*
+F:	arch/powerpc/include/uapi/asm/kvm*
 F:	arch/powerpc/kvm/
 
 KERNEL VIRTUAL MACHINE For Itanium (KVM/IA64)
@@ -4585,6 +4592,7 @@ W:	http://kvm.qumranet.com
 S:	Supported
 F:	Documentation/ia64/kvm.txt
 F:	arch/ia64/include/asm/kvm*
+F:	arch/ia64/include/uapi/asm/kvm*
 F:	arch/ia64/kvm/
 
 KERNEL VIRTUAL MACHINE for s390 (KVM/s390)
@@ -4596,6 +4604,7 @@ W:	http://www.ibm.com/developerworks/linux/linux390/
 S:	Supported
 F:	Documentation/s390/kvm.txt
 F:	arch/s390/include/asm/kvm*
+F:	arch/s390/include/uapi/asm/kvm*
 F:	arch/s390/kvm/
 F:	drivers/s390/kvm/
 
@@ -5122,6 +5131,7 @@ F:	Documentation/DocBook/media/
 F:	drivers/media/
 F:	drivers/staging/media/
 F:	include/media/
+F:	include/linux/videodev2.h
 F:	include/uapi/linux/dvb/
 F:	include/uapi/linux/videodev2.h
 F:	include/uapi/linux/media.h
@@ -5223,6 +5233,7 @@ MODULE SUPPORT
 M:	Rusty Russell <rusty@rustcorp.com.au>
 S:	Maintained
 F:	include/linux/module.h
+F:	include/uapi/linux/module.h
 F:	kernel/module.c
 
 MOTION EYE VAIO PICTUREBOOK CAMERA DRIVER
@@ -5907,6 +5918,7 @@ L:	linux-parport@lists.infradead.org (subscribers-only)
 S:	Orphan
 F:	drivers/parport/
 F:	include/linux/parport*.h
+F:	include/uapi/linux/parport*.h
 F:	drivers/char/ppdev.c
 F:	include/uapi/linux/ppdev.h
 
@@ -5992,6 +6004,7 @@ S:	Supported
 F:	Documentation/PCI/
 F:	drivers/pci/
 F:	include/linux/pci*
+F:	include/uapi/linux/pci*
 
 PCMCIA SUBSYSTEM
 P:	Linux PCMCIA Team
@@ -6208,6 +6221,7 @@ S:	Maintained
 F:	Documentation/pps/
 F:	drivers/pps/
 F:	include/linux/pps*.h
+F:	include/uapi/linux/pps*.h
 
 PPTP DRIVER
 M:	Dmitry Kozlov <xeb@mail.ru>
@@ -6252,6 +6266,7 @@ S:	Maintained
 F:	arch/powerpc/boot/ps3*
 F:	arch/powerpc/include/asm/lv1call.h
 F:	arch/powerpc/include/asm/ps3*.h
+F:	arch/powerpc/include/uapi/asm/ps3*.h
 F:	arch/powerpc/platforms/ps3/
 F:	drivers/*/ps3*
 F:	drivers/ps3/
@@ -6287,6 +6302,7 @@ F:	drivers/net/ethernet/freescale/gianfar_ptp.c
 F:	drivers/net/phy/dp83640*
 F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
+F:	include/uapi/linux/ptp_cl*
 
 PTRACE SUPPORT
 M:	Roland McGrath <roland@redhat.com>
@@ -6894,6 +6910,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-pending-2.6.git
 S:	Maintained
 F:	drivers/scsi/
 F:	include/scsi/
+F:	include/uapi/scsi/
 
 SCSI TAPE DRIVER
 M:	Kai Mäkisara <Kai.Makisara@kolumbus.fi>
@@ -6990,6 +7007,7 @@ W:	http://selinuxproject.org
 T:	git git://git.infradead.org/users/eparis/selinux.git
 S:	Supported
 F:	include/linux/selinux*
+F:	include/uapi/linux/selinux*
 F:	security/selinux/
 F:	scripts/selinux/
 
@@ -7693,6 +7711,7 @@ M:	Balbir Singh <bsingharora@gmail.com>
 S:	Maintained
 F:	Documentation/accounting/taskstats*
 F:	include/linux/taskstats*
+F:	include/uapi/linux/taskstats*
 F:	kernel/taskstats.c
 
 TC CLASSIFIER
@@ -8258,6 +8277,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git
 S:	Maintained
 F:	drivers/usb/gadget/
 F:	include/linux/usb/gadget*
+F:	include/uapi/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 M:	Jiri Kosina <jkosina@suse.cz>
@@ -8432,6 +8452,7 @@ F:	drivers/net/usb/
 F:	drivers/usb/
 F:	include/linux/usb.h
 F:	include/linux/usb/
+F:	include/uapi/linux/usb/
 
 USB UHCI DRIVER
 M:	Alan Stern <stern@rowland.harvard.edu>
@@ -8521,6 +8542,7 @@ S:	Maintained
 F:	Documentation/DocBook/uio-howto.tmpl
 F:	drivers/uio/
 F:	include/linux/uio*.h
+F:	include/uapi/linux/uio*.h
 
 UTIL-LINUX PACKAGE
 M:	Karel Zak <kzak@redhat.com>
@@ -8578,6 +8600,7 @@ F:	drivers/virtio/
 F:	drivers/net/virtio_net.c
 F:	drivers/block/virtio_blk.c
 F:	include/linux/virtio_*.h
+F:	include/uapi/linux/virtio_*.h
 
 VIRTIO HOST (VHOST)
 M:	"Michael S. Tsirkin" <mst@redhat.com>
@@ -8628,6 +8651,7 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/macvlan.c
 F:	include/linux/if_*vlan.h
+F:	include/uapi/linux/if_*vlan.h
 F:	net/8021q/
 
 VLYNQ BUS
-- 
1.7.11.7

