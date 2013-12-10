Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab3LJUZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:25:00 -0500
Received: from mail1.windriver.com ([147.11.146.13]:44309 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3LJUY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:24:58 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-kernel@vger.kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] staging: delete non-required instances of include <linux/init.h>
Date: Tue, 10 Dec 2013 15:23:48 -0500
Message-ID: <1386707028-28165-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

None of these files are actually using any __init type directives
and hence don't need to include <linux/init.h>.  Most are just a
left over from __devinit and __cpuinit removal, or simply due to
code getting copied from one driver to the next.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[passes allyes/allmodconfig builds on x86_64, arm, ppc]

 drivers/staging/ced1401/ced_ioc.c                              | 1 -
 drivers/staging/ced1401/usb1401.c                              | 1 -
 drivers/staging/comedi/drivers/dt9812.c                        | 1 -
 drivers/staging/comedi/drivers/usbdux.c                        | 1 -
 drivers/staging/comedi/drivers/usbduxfast.c                    | 1 -
 drivers/staging/comedi/drivers/usbduxsigma.c                   | 1 -
 drivers/staging/crystalhd/crystalhd_lnx.h                      | 1 -
 drivers/staging/dgrp/dgrp_driver.c                             | 1 -
 drivers/staging/et131x/et131x.c                                | 1 -
 drivers/staging/frontier/alphatrack.c                          | 1 -
 drivers/staging/frontier/tranzport.c                           | 1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_download.c            | 1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c                  | 1 -
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c                 | 1 -
 drivers/staging/gdm724x/gdm_tty.c                              | 1 -
 drivers/staging/gdm72xx/sdio_boot.c                            | 1 -
 drivers/staging/goldfish/goldfish_nand.c                       | 1 -
 drivers/staging/imx-drm/ipu-v3/ipu-common.c                    | 1 -
 drivers/staging/keucr/usb.c                                    | 1 -
 drivers/staging/lustre/include/linux/libcfs/linux/kp30.h       | 1 -
 drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h | 1 -
 drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h            | 1 -
 drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h  | 1 -
 drivers/staging/lustre/lustre/lmv/lmv_fld.c                    | 1 -
 drivers/staging/lustre/lustre/lmv/lmv_intent.c                 | 1 -
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c                | 1 -
 drivers/staging/lustre/lustre/mdc/mdc_locks.c                  | 1 -
 drivers/staging/lustre/lustre/obdclass/capa.c                  | 1 -
 drivers/staging/lustre/lustre/obdclass/linux/linux-module.c    | 1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c            | 1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c   | 1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c     | 1 -
 drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c           | 1 -
 drivers/staging/media/as102/as102_drv.c                        | 1 -
 drivers/staging/media/cxd2099/cxd2099.c                        | 1 -
 drivers/staging/media/go7007/go7007-driver.c                   | 1 -
 drivers/staging/media/go7007/go7007-fw.c                       | 1 -
 drivers/staging/media/go7007/go7007-i2c.c                      | 1 -
 drivers/staging/media/go7007/go7007-loader.c                   | 1 -
 drivers/staging/media/go7007/go7007-usb.c                      | 1 -
 drivers/staging/media/go7007/go7007-v4l2.c                     | 1 -
 drivers/staging/media/go7007/s2250-board.c                     | 1 -
 drivers/staging/media/go7007/snd-go7007.c                      | 1 -
 drivers/staging/media/lirc/lirc_imon.c                         | 1 -
 drivers/staging/media/lirc/lirc_sasem.c                        | 1 -
 drivers/staging/octeon/ethernet-mdio.h                         | 1 -
 drivers/staging/octeon/ethernet-rx.c                           | 1 -
 drivers/staging/octeon/ethernet-tx.c                           | 1 -
 drivers/staging/octeon/ethernet.c                              | 1 -
 drivers/staging/ozwpan/ozeltbuf.c                              | 1 -
 drivers/staging/ozwpan/ozpd.c                                  | 1 -
 drivers/staging/ozwpan/ozproto.c                               | 1 -
 drivers/staging/ozwpan/ozusbsvc.c                              | 1 -
 drivers/staging/ozwpan/ozusbsvc1.c                             | 1 -
 drivers/staging/phison/phison.c                                | 1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c          | 1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c     | 1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c     | 1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c      | 1 -
 drivers/staging/rtl8187se/r8180.h                              | 1 -
 drivers/staging/rtl8188eu/include/osdep_service.h              | 1 -
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h                   | 1 -
 drivers/staging/rtl8192u/r8192U.h                              | 1 -
 drivers/staging/rtl8712/os_intfs.c                             | 1 -
 drivers/staging/rtl8712/rtl8712_cmd.c                          | 1 -
 drivers/staging/rtl8712/rtl871x_cmd.c                          | 1 -
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c                  | 1 -
 drivers/staging/rtl8712/rtl871x_security.c                     | 1 -
 drivers/staging/rts5139/rts51x.c                               | 1 -
 drivers/staging/rts5208/rtsx.h                                 | 1 -
 drivers/staging/sb105x/sb_pci_mp.h                             | 1 -
 drivers/staging/sep/sep_crypto.c                               | 1 -
 drivers/staging/sep/sep_main.c                                 | 1 -
 drivers/staging/serqt_usb2/serqt_usb2.c                        | 1 -
 drivers/staging/tidspbridge/rmgr/drv_interface.c               | 1 -
 drivers/staging/vt6655/device.h                                | 1 -
 drivers/staging/vt6656/device.h                                | 1 -
 drivers/staging/wlags49_h2/wl_pci.c                            | 1 -
 drivers/staging/wlan-ng/prism2sta.c                            | 1 -
 drivers/staging/zsmalloc/zsmalloc-main.c                       | 1 -
 80 files changed, 80 deletions(-)

diff --git a/drivers/staging/ced1401/ced_ioc.c b/drivers/staging/ced1401/ced_ioc.c
index 043a93230e82..bf532b1bd345 100644
--- a/drivers/staging/ced1401/ced_ioc.c
+++ b/drivers/staging/ced1401/ced_ioc.c
@@ -19,7 +19,6 @@
 */
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/ced1401/usb1401.c b/drivers/staging/ced1401/usb1401.c
index 97c55f9e5151..efc310ca789e 100644
--- a/drivers/staging/ced1401/usb1401.c
+++ b/drivers/staging/ced1401/usb1401.c
@@ -89,7 +89,6 @@ synchronous non-Urb based transfers.
 #include <linux/mutex.h>
 #include <linux/mm.h>
 #include <linux/highmem.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/comedi/drivers/dt9812.c b/drivers/staging/comedi/drivers/dt9812.c
index 73af600c1725..b3aeb6fb2ad0 100644
--- a/drivers/staging/comedi/drivers/dt9812.c
+++ b/drivers/staging/comedi/drivers/dt9812.c
@@ -41,7 +41,6 @@ for my needs.
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index da1d501d9e4e..71db683098d6 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -80,7 +80,6 @@ sampling rate. If you sample two channels you get 4kHz and so on.
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/comedi/drivers/usbduxfast.c b/drivers/staging/comedi/drivers/usbduxfast.c
index 9707dd1239c4..4a19b94e7c45 100644
--- a/drivers/staging/comedi/drivers/usbduxfast.c
+++ b/drivers/staging/comedi/drivers/usbduxfast.c
@@ -37,7 +37,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index a5363ded3668..194c686c5a42 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -43,7 +43,6 @@
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/input.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index 33d7431de837..816e1cd5db62 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -37,7 +37,6 @@
 #include <linux/delay.h>
 #include <linux/fb.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
diff --git a/drivers/staging/dgrp/dgrp_driver.c b/drivers/staging/dgrp/dgrp_driver.c
index 08eedf0867e6..b60a8da6350a 100644
--- a/drivers/staging/dgrp/dgrp_driver.c
+++ b/drivers/staging/dgrp/dgrp_driver.c
@@ -23,7 +23,6 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
-#include <linux/init.h>
 
 /*
  *  PortServer includes
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 5dd217062096..0ffe9c739b9d 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -54,7 +54,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
diff --git a/drivers/staging/frontier/alphatrack.c b/drivers/staging/frontier/alphatrack.c
index 817f837b240d..edd5cef300d0 100644
--- a/drivers/staging/frontier/alphatrack.c
+++ b/drivers/staging/frontier/alphatrack.c
@@ -35,7 +35,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kobject.h>
diff --git a/drivers/staging/frontier/tranzport.c b/drivers/staging/frontier/tranzport.c
index 074b0e5bcc68..0e499ce5f0d7 100644
--- a/drivers/staging/frontier/tranzport.c
+++ b/drivers/staging/frontier/tranzport.c
@@ -34,7 +34,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 782aa9ed4718..cab9cdf6273e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -4,7 +4,6 @@
 * This file is part of Express Card USB Driver
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 0d6c1d12170d..a433e33049b5 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -4,7 +4,6 @@
 * This file is part of Express Card USB Driver
 */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index da6cc370c535..e40763e60dbd 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -7,7 +7,6 @@
  * $Id:
  *====================================================
  */
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/usb.h>
diff --git a/drivers/staging/gdm724x/gdm_tty.c b/drivers/staging/gdm724x/gdm_tty.c
index c0f7cd75116b..fe47cd3eb2ed 100644
--- a/drivers/staging/gdm724x/gdm_tty.c
+++ b/drivers/staging/gdm724x/gdm_tty.c
@@ -15,7 +15,6 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
 #include <linux/tty_flip.h>
diff --git a/drivers/staging/gdm72xx/sdio_boot.c b/drivers/staging/gdm72xx/sdio_boot.c
index 4302fcbdfdc3..cbe5dcfc2ac9 100644
--- a/drivers/staging/gdm72xx/sdio_boot.c
+++ b/drivers/staging/gdm72xx/sdio_boot.c
@@ -13,7 +13,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/uaccess.h>
 #include <linux/fs.h>
diff --git a/drivers/staging/goldfish/goldfish_nand.c b/drivers/staging/goldfish/goldfish_nand.c
index 81e2ad4038fe..eca0873098cd 100644
--- a/drivers/staging/goldfish/goldfish_nand.c
+++ b/drivers/staging/goldfish/goldfish_nand.c
@@ -22,7 +22,6 @@
 #include <linux/slab.h>
 #include <linux/ioport.h>
 #include <linux/vmalloc.h>
-#include <linux/init.h>
 #include <linux/mtd/mtd.h>
 #include <linux/platform_device.h>
 
diff --git a/drivers/staging/imx-drm/ipu-v3/ipu-common.c b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
index 7a22ce619ed2..8f54cdc7e4a4 100644
--- a/drivers/staging/imx-drm/ipu-v3/ipu-common.c
+++ b/drivers/staging/imx-drm/ipu-v3/ipu-common.c
@@ -15,7 +15,6 @@
 #include <linux/module.h>
 #include <linux/export.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/reset.h>
 #include <linux/platform_device.h>
 #include <linux/err.h>
diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index a84ee6303368..3e3ca6365fbc 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -2,7 +2,6 @@
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
index 5cc7ba000485..a09fed3c6ea8 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/kp30.h
@@ -42,7 +42,6 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/stat.h>
-#include <linux/init.h>
 #include <linux/errno.h>
 #include <linux/unistd.h>
 #include <linux/kmod.h>
diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h
index 1ec4ca1a6e32..2aeff27b1641 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-prim.h
@@ -47,7 +47,6 @@
 
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/proc_fs.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index 3f83ce4871cf..ce05d558b223 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -50,7 +50,6 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/list.h>
diff --git a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
index 1cfc1b168bed..025cb65ddc70 100644
--- a/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
+++ b/drivers/staging/lustre/lnet/klnds/socklnd/socklnd_lib-linux.h
@@ -54,7 +54,6 @@
 #include <asm/uaccess.h>
 #include <asm/irq.h>
 
-#include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/file.h>
 #include <linux/list.h>
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_fld.c b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
index 0b2d38d1362b..fd6b5ec61d8a 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_fld.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_fld.c
@@ -37,7 +37,6 @@
 #define DEBUG_SUBSYSTEM S_LMV
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pagemap.h>
 #include <asm/div64.h>
 #include <linux/seq_file.h>
diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index 511b3b4b699b..56dedceaf0a0 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -37,7 +37,6 @@
 #define DEBUG_SUBSYSTEM S_LMV
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/pagemap.h>
 #include <asm/div64.h>
 #include <linux/seq_file.h>
diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index 09474e7553dd..428ffd8c37b7 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -47,7 +47,6 @@
 #include <linux/quotaops.h>
 #include <linux/libcfs/libcfs.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/lustre_compat25.h>
 #include <lvfs.h>
 
diff --git a/drivers/staging/lustre/lustre/mdc/mdc_locks.c b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
index cc5490c3a603..8aa7c80c2002 100644
--- a/drivers/staging/lustre/lustre/mdc/mdc_locks.c
+++ b/drivers/staging/lustre/lustre/mdc/mdc_locks.c
@@ -39,7 +39,6 @@
 # include <linux/module.h>
 # include <linux/pagemap.h>
 # include <linux/miscdevice.h>
-# include <linux/init.h>
 
 #include <lustre_acl.h>
 #include <obd_class.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/capa.c b/drivers/staging/lustre/lustre/obdclass/capa.c
index 68d797ba8ae4..86deee5e70d1 100644
--- a/drivers/staging/lustre/lustre/obdclass/capa.c
+++ b/drivers/staging/lustre/lustre/obdclass/capa.c
@@ -46,7 +46,6 @@
 #include <asm/unistd.h>
 #include <linux/slab.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/crypto.h>
 
 #include <obd_class.h>
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index a70ead1be6a9..121a856d5052 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -56,7 +56,6 @@
 #include <linux/proc_fs.h>
 #include <linux/fs.h>
 #include <linux/poll.h>
-#include <linux/init.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
 #include <asm/io.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
index b518d8a0aaba..7852bf30a3a0 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_bulk.c
@@ -37,7 +37,6 @@
  */
 
 #define DEBUG_SUBSYSTEM S_SEC
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
index 20b1638e7255..56c28286c9c1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_generic_token.c
@@ -42,7 +42,6 @@
  */
 
 #define DEBUG_SUBSYSTEM S_SEC
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c
index 8cdad800382d..99462e085da7 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/gss_mech_switch.c
@@ -44,7 +44,6 @@
  */
 
 #define DEBUG_SUBSYSTEM S_SEC
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c b/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
index de100a14ab52..a0a74e5542ed 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/gss/lproc_gss.c
@@ -35,7 +35,6 @@
  */
 
 #define DEBUG_SUBSYSTEM S_SEC
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/dcache.h>
diff --git a/drivers/staging/media/as102/as102_drv.c b/drivers/staging/media/as102/as102_drv.c
index ac92eaf6c74b..8b7bb9547079 100644
--- a/drivers/staging/media/as102/as102_drv.c
+++ b/drivers/staging/media/as102/as102_drv.c
@@ -19,7 +19,6 @@
  */
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/mm.h>
diff --git a/drivers/staging/media/cxd2099/cxd2099.c b/drivers/staging/media/cxd2099/cxd2099.c
index 822c487592a4..6cb74dacc69d 100644
--- a/drivers/staging/media/cxd2099/cxd2099.c
+++ b/drivers/staging/media/cxd2099/cxd2099.c
@@ -26,7 +26,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/i2c.h>
 #include <linux/wait.h>
 #include <linux/delay.h>
diff --git a/drivers/staging/media/go7007/go7007-driver.c b/drivers/staging/media/go7007/go7007-driver.c
index 3640df0aa0c1..6f1beca86b2b 100644
--- a/drivers/staging/media/go7007/go7007-driver.c
+++ b/drivers/staging/media/go7007/go7007-driver.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
diff --git a/drivers/staging/media/go7007/go7007-fw.c b/drivers/staging/media/go7007/go7007-fw.c
index 479953b2d983..814ce08bc44d 100644
--- a/drivers/staging/media/go7007/go7007-fw.c
+++ b/drivers/staging/media/go7007/go7007-fw.c
@@ -25,7 +25,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/time.h>
 #include <linux/mm.h>
 #include <linux/device.h>
diff --git a/drivers/staging/media/go7007/go7007-i2c.c b/drivers/staging/media/go7007/go7007-i2c.c
index 74f25e03c326..4cf4c0d65085 100644
--- a/drivers/staging/media/go7007/go7007-i2c.c
+++ b/drivers/staging/media/go7007/go7007-i2c.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/list.h>
diff --git a/drivers/staging/media/go7007/go7007-loader.c b/drivers/staging/media/go7007/go7007-loader.c
index f846ad5819dc..10bb41c2fb6d 100644
--- a/drivers/staging/media/go7007/go7007-loader.c
+++ b/drivers/staging/media/go7007/go7007-loader.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/usb.h>
 #include <linux/firmware.h>
diff --git a/drivers/staging/media/go7007/go7007-usb.c b/drivers/staging/media/go7007/go7007-usb.c
index b658c2316df3..2f62be905cd1 100644
--- a/drivers/staging/media/go7007/go7007-usb.c
+++ b/drivers/staging/media/go7007/go7007-usb.c
@@ -19,7 +19,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/list.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/media/go7007/go7007-v4l2.c b/drivers/staging/media/go7007/go7007-v4l2.c
index 50eb69a8ef07..edc52e2630a9 100644
--- a/drivers/staging/media/go7007/go7007-v4l2.c
+++ b/drivers/staging/media/go7007/go7007-v4l2.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/spinlock.h>
diff --git a/drivers/staging/media/go7007/s2250-board.c b/drivers/staging/media/go7007/s2250-board.c
index beaa98b9c85a..696a80756691 100644
--- a/drivers/staging/media/go7007/s2250-board.c
+++ b/drivers/staging/media/go7007/s2250-board.c
@@ -16,7 +16,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/usb.h>
 #include <linux/i2c.h>
 #include <linux/videodev2.h>
diff --git a/drivers/staging/media/go7007/snd-go7007.c b/drivers/staging/media/go7007/snd-go7007.c
index 4be0fa40a39a..16dd64920767 100644
--- a/drivers/staging/media/go7007/snd-go7007.c
+++ b/drivers/staging/media/go7007/snd-go7007.c
@@ -18,7 +18,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/spinlock.h>
 #include <linux/delay.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/media/lirc/lirc_imon.c b/drivers/staging/media/lirc/lirc_imon.c
index c7d6667e7d14..f2d396cc4a4c 100644
--- a/drivers/staging/media/lirc/lirc_imon.c
+++ b/drivers/staging/media/lirc/lirc_imon.c
@@ -23,7 +23,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/media/lirc/lirc_sasem.c b/drivers/staging/media/lirc/lirc_sasem.c
index 68acca74ddb1..d2445fdd9015 100644
--- a/drivers/staging/media/lirc/lirc_sasem.c
+++ b/drivers/staging/media/lirc/lirc_sasem.c
@@ -37,7 +37,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/slab.h>
diff --git a/drivers/staging/octeon/ethernet-mdio.h b/drivers/staging/octeon/ethernet-mdio.h
index a417d4fce12c..eccfcc54cea8 100644
--- a/drivers/staging/octeon/ethernet-mdio.h
+++ b/drivers/staging/octeon/ethernet-mdio.h
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-#include <linux/init.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/string.h>
diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 0315f60497b7..a0f4868cfa13 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -29,7 +29,6 @@
 #include <linux/cache.h>
 #include <linux/cpumask.h>
 #include <linux/netdevice.h>
-#include <linux/init.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/string.h>
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index 9b4d0b546b89..47541e1608f3 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -27,7 +27,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-#include <linux/init.h>
 #include <linux/etherdevice.h>
 #include <linux/ip.h>
 #include <linux/ratelimit.h>
diff --git a/drivers/staging/octeon/ethernet.c b/drivers/staging/octeon/ethernet.c
index bd6ca7164049..089dc4b9efd4 100644
--- a/drivers/staging/octeon/ethernet.c
+++ b/drivers/staging/octeon/ethernet.c
@@ -26,7 +26,6 @@
 **********************************************************************/
 #include <linux/platform_device.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
diff --git a/drivers/staging/ozwpan/ozeltbuf.c b/drivers/staging/ozwpan/ozeltbuf.c
index 02d541247819..bd560c67fc8c 100644
--- a/drivers/staging/ozwpan/ozeltbuf.c
+++ b/drivers/staging/ozwpan/ozeltbuf.c
@@ -3,7 +3,6 @@
  * Released under the GNU General Public License Version 2 (GPLv2).
  * -----------------------------------------------------------------------------
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include "ozdbg.h"
diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index ab85a724a0e2..743695077346 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -4,7 +4,6 @@
  * -----------------------------------------------------------------------------
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/ozwpan/ozproto.c b/drivers/staging/ozwpan/ozproto.c
index 9f2dffe6e131..64d94f77f8a7 100644
--- a/drivers/staging/ozwpan/ozproto.c
+++ b/drivers/staging/ozwpan/ozproto.c
@@ -4,7 +4,6 @@
  * -----------------------------------------------------------------------------
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/ozwpan/ozusbsvc.c b/drivers/staging/ozwpan/ozusbsvc.c
index cf263791cb30..edd44c457a4b 100644
--- a/drivers/staging/ozwpan/ozusbsvc.c
+++ b/drivers/staging/ozwpan/ozusbsvc.c
@@ -11,7 +11,6 @@
  * -----------------------------------------------------------------------------
  */
 
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/ozwpan/ozusbsvc1.c b/drivers/staging/ozwpan/ozusbsvc1.c
index 228bffaa69c9..617f51cdaea7 100644
--- a/drivers/staging/ozwpan/ozusbsvc1.c
+++ b/drivers/staging/ozwpan/ozusbsvc1.c
@@ -5,7 +5,6 @@
  * This file implements the protocol specific parts of the USB service for a PD.
  * -----------------------------------------------------------------------------
  */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/timer.h>
 #include <linux/sched.h>
diff --git a/drivers/staging/phison/phison.c b/drivers/staging/phison/phison.c
index 57fc27958797..3826561e7742 100644
--- a/drivers/staging/phison/phison.c
+++ b/drivers/staging/phison/phison.c
@@ -12,7 +12,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/delay.h>
 #include <linux/device.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
index a0340ee9d8b7..101f0c0cdb0a 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -15,7 +15,6 @@
 
 //#include <linux/config.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/errno.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
index 0e8392acdeac..c8013d373a77 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -12,7 +12,6 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/skbuff.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
index 34a10d1868b4..c5907968e1a7 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -10,7 +10,6 @@
  */
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/skbuff.h>
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
index bba77141d9a3..f114f9a33e17 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -13,7 +13,6 @@
 
 //#include <linux/config.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/random.h>
 #include <linux/skbuff.h>
diff --git a/drivers/staging/rtl8187se/r8180.h b/drivers/staging/rtl8187se/r8180.h
index e9602f67cac8..f14fca326798 100644
--- a/drivers/staging/rtl8187se/r8180.h
+++ b/drivers/staging/rtl8187se/r8180.h
@@ -28,7 +28,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 //#include <linux/config.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/types.h>
diff --git a/drivers/staging/rtl8188eu/include/osdep_service.h b/drivers/staging/rtl8188eu/include/osdep_service.h
index 36523edf6a71..d11e794c4d4a 100644
--- a/drivers/staging/rtl8188eu/include/osdep_service.h
+++ b/drivers/staging/rtl8188eu/include/osdep_service.h
@@ -30,7 +30,6 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index ce239be8f2f6..35fc1164effd 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -28,7 +28,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/types.h>
diff --git a/drivers/staging/rtl8192u/r8192U.h b/drivers/staging/rtl8192u/r8192U.h
index ad3bc567d35a..c9d8c102cca3 100644
--- a/drivers/staging/rtl8192u/r8192U.h
+++ b/drivers/staging/rtl8192u/r8192U.h
@@ -20,7 +20,6 @@
 
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/ioport.h>
 #include <linux/sched.h>
 #include <linux/types.h>
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 82a77b45fb50..37fe33005c02 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -29,7 +29,6 @@
 #define _OS_INTFS_C_
 
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/kthread.h>
 #include <linux/firmware.h>
 #include "osdep_service.h"
diff --git a/drivers/staging/rtl8712/rtl8712_cmd.c b/drivers/staging/rtl8712/rtl8712_cmd.c
index 5b6a96e3bd7b..1a4b7a651f92 100644
--- a/drivers/staging/rtl8712/rtl8712_cmd.c
+++ b/drivers/staging/rtl8712/rtl8712_cmd.c
@@ -31,7 +31,6 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index 7e324315e6ad..c71c7e55bb36 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -31,7 +31,6 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index 9fec6eda8731..23d539dba7ef 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -42,7 +42,6 @@
 #include <linux/wireless.h>
 #include <linux/module.h>
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/io.h>
 #include <linux/semaphore.h>
 #include <net/iw_handler.h>
diff --git a/drivers/staging/rtl8712/rtl871x_security.c b/drivers/staging/rtl8712/rtl871x_security.c
index 5349669707c0..aae5125a2e7e 100644
--- a/drivers/staging/rtl8712/rtl871x_security.c
+++ b/drivers/staging/rtl8712/rtl871x_security.c
@@ -31,7 +31,6 @@
 #include <linux/compiler.h>
 #include <linux/kernel.h>
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/kref.h>
diff --git a/drivers/staging/rts5139/rts51x.c b/drivers/staging/rts5139/rts51x.c
index 04213463123e..a8d2d046b44f 100644
--- a/drivers/staging/rts5139/rts51x.c
+++ b/drivers/staging/rts5139/rts51x.c
@@ -30,7 +30,6 @@
 #include <linux/errno.h>
 #include <linux/freezer.h>
 #include <linux/module.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/utsname.h>
diff --git a/drivers/staging/rts5208/rtsx.h b/drivers/staging/rts5208/rtsx.h
index 3f048e061231..37eab56ee02e 100644
--- a/drivers/staging/rts5208/rtsx.h
+++ b/drivers/staging/rts5208/rtsx.h
@@ -31,7 +31,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/moduleparam.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/mutex.h>
diff --git a/drivers/staging/sb105x/sb_pci_mp.h b/drivers/staging/sb105x/sb_pci_mp.h
index 11d92992e925..80ae4ab04603 100644
--- a/drivers/staging/sb105x/sb_pci_mp.h
+++ b/drivers/staging/sb105x/sb_pci_mp.h
@@ -9,7 +9,6 @@
 #include <linux/sched.h>
 
 #include <linux/kernel.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/wait.h>
 #include <linux/tty_driver.h>
diff --git a/drivers/staging/sep/sep_crypto.c b/drivers/staging/sep/sep_crypto.c
index b9262a78dd6e..cb3e63b7c319 100644
--- a/drivers/staging/sep/sep_crypto.c
+++ b/drivers/staging/sep/sep_crypto.c
@@ -32,7 +32,6 @@
  */
 
 /* #define DEBUG */
-#include <linux/init.h>
 #include <linux/module.h>
 #include <linux/miscdevice.h>
 #include <linux/fs.h>
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index dca838d043e5..122614c4092b 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -39,7 +39,6 @@
 /* #define DEBUG */
 /* #define SEP_PERF_DEBUG */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/miscdevice.h>
diff --git a/drivers/staging/serqt_usb2/serqt_usb2.c b/drivers/staging/serqt_usb2/serqt_usb2.c
index 73fc3cc19e33..4293c9064951 100644
--- a/drivers/staging/serqt_usb2/serqt_usb2.c
+++ b/drivers/staging/serqt_usb2/serqt_usb2.c
@@ -5,7 +5,6 @@
  */
 
 #include <linux/errno.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/tty.h>
 #include <linux/tty_driver.h>
diff --git a/drivers/staging/tidspbridge/rmgr/drv_interface.c b/drivers/staging/tidspbridge/rmgr/drv_interface.c
index 1aa4a3fd0f1b..6945e7b80024 100644
--- a/drivers/staging/tidspbridge/rmgr/drv_interface.c
+++ b/drivers/staging/tidspbridge/rmgr/drv_interface.c
@@ -23,7 +23,6 @@
 #include <linux/pm.h>
 #include <linux/module.h>
 #include <linux/device.h>
-#include <linux/init.h>
 #include <linux/moduleparam.h>
 #include <linux/cdev.h>
 
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index ca1b8578cf79..062c3a374b99 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -31,7 +31,6 @@
 
 #include <linux/module.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/mm.h>
 #include <linux/errno.h>
 #include <linux/ioport.h>
diff --git a/drivers/staging/vt6656/device.h b/drivers/staging/vt6656/device.h
index 82e1e6d695d1..9496bacf8611 100644
--- a/drivers/staging/vt6656/device.h
+++ b/drivers/staging/vt6656/device.h
@@ -32,7 +32,6 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
-#include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
diff --git a/drivers/staging/wlags49_h2/wl_pci.c b/drivers/staging/wlags49_h2/wl_pci.c
index 6226e5eebf3a..841ffac7f6a4 100644
--- a/drivers/staging/wlags49_h2/wl_pci.c
+++ b/drivers/staging/wlags49_h2/wl_pci.c
@@ -68,7 +68,6 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/pci.h>
-#include <linux/init.h>
 #include <linux/sched.h>
 #include <linux/ptrace.h>
 #include <linux/ctype.h>
diff --git a/drivers/staging/wlan-ng/prism2sta.c b/drivers/staging/wlan-ng/prism2sta.c
index 46f9491d10d3..2199f5afbf90 100644
--- a/drivers/staging/wlan-ng/prism2sta.c
+++ b/drivers/staging/wlan-ng/prism2sta.c
@@ -55,7 +55,6 @@
 #include <linux/kernel.h>
 #include <linux/sched.h>
 #include <linux/types.h>
-#include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/wireless.h>
 #include <linux/netdevice.h>
diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index 3b950e5a918f..7a04bba3a20e 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -67,7 +67,6 @@
 #include <linux/bitops.h>
 #include <linux/errno.h>
 #include <linux/highmem.h>
-#include <linux/init.h>
 #include <linux/string.h>
 #include <linux/slab.h>
 #include <asm/tlbflush.h>
-- 
1.8.5.1

