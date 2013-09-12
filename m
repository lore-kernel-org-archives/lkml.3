Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3ILTxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:53:49 -0400
Received: from top.free-electrons.com ([176.31.233.9]:41809 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753608Ab3ILTxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:53:41 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [TRIVIAL] treewide: fix occurrences of "the the "
Date: Thu, 12 Sep 2013 21:53:17 +0200
Message-Id: <1379015597-5462-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all occurrences of "the the " in the source code,
comments and documentation.

The replacement couldn't be automated because sometimes
the first "the" was meant to be another word.

Example: "according the the"
meaning: "according to the"

Note that I sometimes took the opportunity to fix
other spelling issues or typos in the same sentences.
I also fixed a few checkpatch errors in the same
lines.

If this is not the best time to get this patch merged,
I'll be happy to rebase and post it again when needed.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 Documentation/ABI/testing/sysfs-devices-memory                 | 2 +-
 Documentation/DocBook/media/v4l/controls.xml                   | 2 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml              | 2 +-
 Documentation/RCU/checklist.txt                                | 2 +-
 Documentation/devicetree/bindings/arm/msm/timer.txt            | 2 +-
 Documentation/devicetree/bindings/ata/cavium-compact-flash.txt | 2 +-
 Documentation/devicetree/bindings/mtd/fsmc-nand.txt            | 2 +-
 Documentation/email-clients.txt                                | 2 +-
 Documentation/filesystems/autofs4-mount-control.txt            | 6 +++---
 Documentation/futex-requeue-pi.txt                             | 2 +-
 Documentation/input/multi-touch-protocol.txt                   | 2 +-
 Documentation/io-mapping.txt                                   | 2 +-
 Documentation/kmemcheck.txt                                    | 2 +-
 Documentation/networking/spider_net.txt                        | 2 +-
 Documentation/power/devices.txt                                | 2 +-
 Documentation/security/Smack.txt                               | 2 +-
 Documentation/static-keys.txt                                  | 2 +-
 Documentation/trace/ring-buffer-design.txt                     | 2 +-
 Documentation/usb/WUSB-Design-overview.txt                     | 2 +-
 Documentation/virtual/kvm/api.txt                              | 2 +-
 Documentation/vm/unevictable-lru.txt                           | 2 +-
 arch/arm/Kconfig                                               | 2 +-
 arch/arm/include/asm/unwind.h                                  | 2 +-
 arch/arm/mach-omap2/omap_hwmod.c                               | 6 +++---
 arch/arm/mach-pxa/stargate2.c                                  | 2 +-
 arch/blackfin/mach-common/entry.S                              | 2 +-
 arch/c6x/platforms/cache.c                                     | 2 +-
 arch/ia64/include/asm/spinlock.h                               | 2 +-
 arch/ia64/include/asm/uv/uv_hub.h                              | 2 +-
 arch/m68k/platform/coldfire/intc-2.c                           | 2 +-
 arch/metag/kernel/process.c                                    | 2 +-
 arch/microblaze/kernel/entry.S                                 | 2 +-
 arch/mips/alchemy/devboards/pm.c                               | 2 +-
 arch/mips/include/asm/octeon/cvmx-pip.h                        | 2 +-
 arch/mips/include/asm/spinlock.h                               | 2 +-
 arch/mips/kernel/smtc.c                                        | 2 +-
 arch/mips/kvm/kvm_mips.c                                       | 2 +-
 arch/mips/mm/c-octeon.c                                        | 4 ++--
 arch/mips/netlogic/xlr/fmn.c                                   | 2 +-
 arch/powerpc/include/asm/epapr_hcalls.h                        | 2 +-
 arch/powerpc/include/asm/hw_breakpoint.h                       | 2 +-
 arch/powerpc/kernel/head_64.S                                  | 2 +-
 arch/powerpc/mm/gup.c                                          | 2 +-
 arch/powerpc/mm/hugetlbpage.c                                  | 2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c                      | 2 +-
 arch/powerpc/platforms/chrp/setup.c                            | 2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c                      | 2 +-
 arch/s390/mm/gup.c                                             | 2 +-
 arch/sparc/kernel/pci.c                                        | 2 +-
 arch/sparc/mm/gup.c                                            | 2 +-
 arch/tile/include/asm/irqflags.h                               | 2 +-
 arch/tile/include/gxio/trio.h                                  | 2 +-
 arch/tile/kernel/single_step.c                                 | 2 +-
 arch/x86/include/asm/spinlock.h                                | 2 +-
 arch/x86/include/asm/uv/uv_hub.h                               | 2 +-
 arch/x86/kvm/x86.c                                             | 2 +-
 arch/x86/mm/gup.c                                              | 4 ++--
 arch/x86/xen/setup.c                                           | 2 +-
 arch/xtensa/include/asm/initialize_mmu.h                       | 2 +-
 drivers/acpi/acpica/accommon.h                                 | 2 +-
 drivers/block/drbd/drbd_main.c                                 | 2 +-
 drivers/char/apm-emulation.c                                   | 2 +-
 drivers/char/xilinx_hwicap/fifo_icap.c                         | 2 +-
 drivers/cpuidle/driver.c                                       | 4 ++--
 drivers/crypto/picoxcell_crypto.c                              | 2 +-
 drivers/crypto/ux500/hash/hash_core.c                          | 2 +-
 drivers/gpio/gpio-ich.c                                        | 2 +-
 drivers/gpu/drm/i915/i915_gem.c                                | 2 +-
 drivers/gpu/drm/i915/intel_display.c                           | 4 ++--
 drivers/gpu/drm/radeon/atombios.h                              | 4 ++--
 drivers/gpu/drm/radeon/r300_reg.h                              | 2 +-
 drivers/gpu/drm/radeon/radeon_device.c                         | 2 +-
 drivers/gpu/drm/radeon/radeon_fence.c                          | 2 +-
 drivers/gpu/drm/radeon/radeon_gart.c                           | 2 +-
 drivers/hv/channel.c                                           | 4 ++--
 drivers/hv/vmbus_drv.c                                         | 2 +-
 drivers/hwmon/pmbus/ucd9200.c                                  | 2 +-
 drivers/infiniband/hw/ipath/ipath_common.h                     | 2 +-
 drivers/infiniband/hw/qib/qib.h                                | 2 +-
 drivers/input/mouse/gpio_mouse.c                               | 2 +-
 drivers/input/touchscreen/atmel_mxt_ts.c                       | 2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c                          | 2 +-
 drivers/lguest/core.c                                          | 2 +-
 drivers/media/dvb-frontends/tda1002x.h                         | 2 +-
 drivers/media/dvb-frontends/tda10048.c                         | 2 +-
 drivers/media/pci/cx88/cx88-dsp.c                              | 2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                              | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c                       | 2 +-
 drivers/media/platform/davinci/vpbe.c                          | 2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c               | 2 +-
 drivers/media/platform/omap3isp/isp.c                          | 2 +-
 drivers/media/rc/iguanair.c                                    | 2 +-
 drivers/media/usb/dvb-usb/friio-fe.c                           | 2 +-
 drivers/media/usb/dvb-usb/friio.c                              | 2 +-
 drivers/media/usb/dvb-usb/friio.h                              | 2 +-
 drivers/media/usb/gspca/finepix.c                              | 2 +-
 drivers/media/usb/tm6000/tm6000-cards.c                        | 2 +-
 drivers/media/usb/uvc/uvc_video.c                              | 2 +-
 drivers/memory/emif.c                                          | 2 +-
 drivers/message/fusion/mptspi.c                                | 2 +-
 drivers/mfd/db8500-prcmu.c                                     | 2 +-
 drivers/misc/sgi-gru/grukservices.c                            | 2 +-
 drivers/misc/sgi-xp/xpc_uv.c                                   | 2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c                         | 2 +-
 drivers/mtd/ubi/ubi.h                                          | 4 ++--
 drivers/mtd/ubi/wl.c                                           | 2 +-
 drivers/net/ethernet/calxeda/xgmac.c                           | 2 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     | 2 +-
 drivers/net/ethernet/emulex/benet/be_main.c                    | 2 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c                    | 2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                    | 2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                   | 2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  | 2 +-
 drivers/net/ethernet/neterion/s2io.c                           | 2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c              | 2 +-
 drivers/net/wimax/i2400m/i2400m.h                              | 4 ++--
 drivers/net/wimax/i2400m/rx.c                                  | 2 +-
 drivers/net/wimax/i2400m/tx.c                                  | 2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h                      | 2 +-
 drivers/net/wireless/ath/ath6kl/hif.h                          | 2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                         | 2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                    | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                    | 2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c                 | 2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                   | 4 ++--
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                    | 4 ++--
 drivers/of/base.c                                              | 2 +-
 drivers/pci/hotplug/acpiphp_glue.c                             | 2 +-
 drivers/pcmcia/pxa2xx_hx4700.c                                 | 2 +-
 drivers/power/power_supply_sysfs.c                             | 5 +++--
 drivers/rtc/rtc-rs5c372.c                                      | 2 +-
 drivers/s390/net/qeth_core_main.c                              | 2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                               | 2 +-
 drivers/scsi/fcoe/fcoe.c                                       | 6 +++---
 drivers/scsi/fcoe/fcoe_ctlr.c                                  | 4 ++--
 drivers/scsi/isci/host.h                                       | 2 +-
 drivers/scsi/isci/remote_device.h                              | 2 +-
 drivers/scsi/isci/remote_node_context.h                        | 2 +-
 drivers/scsi/isci/task.c                                       | 2 +-
 drivers/scsi/lpfc/lpfc_attr.c                                  | 8 ++++----
 drivers/scsi/lpfc/lpfc_els.c                                   | 2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                               | 4 ++--
 drivers/scsi/lpfc/lpfc_init.c                                  | 2 +-
 drivers/scsi/lpfc/lpfc_mbox.c                                  | 2 +-
 drivers/scsi/lpfc/lpfc_sli.c                                   | 2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                               | 2 +-
 drivers/spi/spi-ppc4xx.c                                       | 2 +-
 drivers/staging/android/binder.h                               | 2 +-
 drivers/staging/et131x/et131x.c                                | 2 +-
 drivers/staging/lustre/lustre/llite/file.c                     | 2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c                  | 2 +-
 drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c             | 4 ++--
 drivers/staging/rtl8188eu/core/rtw_cmd.c                       | 2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c              | 2 +-
 drivers/staging/rtl8712/rtl871x_cmd.c                          | 2 +-
 drivers/staging/sep/sep_main.c                                 | 6 +++---
 drivers/staging/tidspbridge/include/dspbridge/drv.h            | 4 ++--
 drivers/staging/tidspbridge/pmgr/dev.c                         | 2 +-
 drivers/staging/wlags49_h2/README.wlags49                      | 2 +-
 drivers/target/target_core_alua.c                              | 2 +-
 drivers/usb/serial/cypress_m8.c                                | 2 +-
 drivers/usb/serial/mos7720.c                                   | 4 ++--
 drivers/usb/wusbcore/devconnect.c                              | 2 +-
 drivers/uwb/drp-ie.c                                           | 2 +-
 drivers/video/omap/sossi.c                                     | 2 +-
 drivers/video/sis/sis_accel.c                                  | 2 +-
 fs/autofs4/dev-ioctl.c                                         | 2 +-
 fs/btrfs/dev-replace.c                                         | 2 +-
 fs/btrfs/send.c                                                | 2 +-
 fs/btrfs/tree-log.c                                            | 2 +-
 fs/dcache.c                                                    | 4 ++--
 fs/ecryptfs/keystore.c                                         | 2 +-
 fs/ext2/ext2.h                                                 | 2 +-
 fs/ext4/inline.c                                               | 4 ++--
 fs/f2fs/segment.h                                              | 2 +-
 fs/ocfs2/localalloc.c                                          | 2 +-
 fs/xfs/xfs_export.c                                            | 2 +-
 include/drm/drm_rect.h                                         | 2 +-
 include/linux/mm.h                                             | 2 +-
 include/linux/moduleparam.h                                    | 2 +-
 include/linux/skbuff.h                                         | 2 +-
 include/net/caif/caif_layer.h                                  | 2 +-
 include/net/ip6_fib.h                                          | 2 +-
 include/net/wimax.h                                            | 2 +-
 init/main.c                                                    | 2 +-
 kernel/jump_label.c                                            | 2 +-
 kernel/printk/printk.c                                         | 2 +-
 kernel/smp.c                                                   | 2 +-
 kernel/trace/ring_buffer.c                                     | 2 +-
 lib/bitmap.c                                                   | 2 +-
 lib/dynamic_queue_limits.c                                     | 2 +-
 lib/earlycpio.c                                                | 2 +-
 lib/syscall.c                                                  | 2 +-
 mm/hugetlb.c                                                   | 2 +-
 mm/page_alloc.c                                                | 2 +-
 net/bluetooth/hci_conn.c                                       | 2 +-
 net/bluetooth/hci_core.c                                       | 2 +-
 net/sctp/chunk.c                                               | 2 +-
 net/sunrpc/auth_generic.c                                      | 2 +-
 net/tipc/link.c                                                | 2 +-
 net/wimax/op-rfkill.c                                          | 2 +-
 scripts/tracing/draw_functrace.py                              | 2 +-
 security/apparmor/context.c                                    | 2 +-
 security/keys/keyctl.c                                         | 2 +-
 sound/pci/hda/hda_codec.c                                      | 2 +-
 sound/pci/hda/patch_sigmatel.c                                 | 2 +-
 sound/pci/ice1712/prodigy192.c                                 | 2 +-
 sound/soc/codecs/wm9713.c                                      | 2 +-
 sound/soc/fsl/fsl_dma.c                                        | 2 +-
 sound/soc/fsl/fsl_ssi.c                                        | 2 +-
 sound/sparc/dbri.c                                             | 2 +-
 tools/perf/Documentation/perf-diff.txt                         | 2 +-
 tools/power/x86/turbostat/turbostat.8                          | 4 ++--
 213 files changed, 244 insertions(+), 243 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index 7405de2..4b3c020 100644
--- a/Documentation/ABI/testing/sysfs-devices-memory
+++ b/Documentation/ABI/testing/sysfs-devices-memory
@@ -45,7 +45,7 @@ Description:
 		The file /sys/devices/system/memory/memoryX/state
 		is read-write.  When read, its contents show the
 		online/offline state of the memory section.  When written,
-		root can toggle the the online/offline state of a removable
+		root can toggle the online/offline state of a removable
 		memory section (see removable file description above)
 		using the following commands.
 		# echo online > /sys/devices/system/memory/memoryX/state
diff --git a/Documentation/DocBook/media/v4l/controls.xml b/Documentation/DocBook/media/v4l/controls.xml
index 7a3b49b..7cfc7c2 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3303,7 +3303,7 @@ giving priority to the center of the metered area.</entry>
 		<row>
 		  <entry><constant>V4L2_EXPOSURE_METERING_MATRIX</constant>&nbsp;</entry>
 		  <entry>A multi-zone metering. The light intensity is measured
-in several points of the frame and the the results are combined. The
+in several points of the frame and the results are combined. The
 algorithm of the zones selection and their significance in calculating the
 final value is device dependent.</entry>
 		</row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index f4e28e7..7217287 100644
--- a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
+++ b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
@@ -267,7 +267,7 @@ is intended for still imaging applications. The idea is to get the
 best possible image quality that the hardware can deliver. It is not
 defined how the driver writer may achieve that; it will depend on the
 hardware and the ingenuity of the driver writer. High quality mode is
-a different mode from the the regular motion video capture modes. In
+a different mode from the regular motion video capture modes. In
 high quality mode:<itemizedlist>
 		  <listitem>
 		    <para>The driver may be able to capture higher
diff --git a/Documentation/RCU/checklist.txt b/Documentation/RCU/checklist.txt
index 7703ec7..ad6cba4 100644
--- a/Documentation/RCU/checklist.txt
+++ b/Documentation/RCU/checklist.txt
@@ -203,7 +203,7 @@ over a rather long period of time, but improvements are always welcome!
 	the corresponding readers must disable preemption, possibly
 	by calling rcu_read_lock_sched() and rcu_read_unlock_sched().
 	If the updater uses synchronize_srcu() or call_srcu(),
-	the the corresponding readers must use srcu_read_lock() and
+	the corresponding readers must use srcu_read_lock() and
 	srcu_read_unlock(), and with the same srcu_struct.  The rules for
 	the expedited primitives are the same as for their non-expedited
 	counterparts.  Mixing things up will result in confusion and
diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt
index c6ef8f1..74607b6 100644
--- a/Documentation/devicetree/bindings/arm/msm/timer.txt
+++ b/Documentation/devicetree/bindings/arm/msm/timer.txt
@@ -8,7 +8,7 @@ Properties:
                "qcom,kpss-timer" - krait subsystem
                "qcom,scss-timer" - scorpion subsystem
 
-- interrupts : Interrupts for the the debug timer, the first general purpose
+- interrupts : Interrupts for the debug timer, the first general purpose
                timer, and optionally a second general purpose timer in that
                order.
 
diff --git a/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt b/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
index 93986a5..3bacc8e 100644
--- a/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
+++ b/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
@@ -9,7 +9,7 @@ Properties:
 
   Compatibility with many Cavium evaluation boards.
 
-- reg: The base address of the the CF chip select banks.  Depending on
+- reg: The base address of the CF chip select banks.  Depending on
   the device configuration, there may be one or two banks.
 
 - cavium,bus-width: The width of the connection to the CF devices.  Valid
diff --git a/Documentation/devicetree/bindings/mtd/fsmc-nand.txt b/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
index ec42935..5235cbc 100644
--- a/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
+++ b/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
@@ -9,7 +9,7 @@ Required properties:
 Optional properties:
 - bank-width : Width (in bytes) of the device.  If not present, the width
   defaults to 1 byte
-- nand-skip-bbtscan: Indicates the the BBT scanning should be skipped
+- nand-skip-bbtscan: Indicates the BBT scanning should be skipped
 - timings: array of 6 bytes for NAND timings. The meanings of these bytes
   are:
   byte 0 TCLR  : CLE to RE delay in number of AHB clock cycles, only 4 bits
diff --git a/Documentation/email-clients.txt b/Documentation/email-clients.txt
index 860c29a..e9f5dac 100644
--- a/Documentation/email-clients.txt
+++ b/Documentation/email-clients.txt
@@ -104,7 +104,7 @@ Then from the "Message" menu item, select insert file and choose your patch.
 As an added bonus you can customise the message creation toolbar menu
 and put the "insert file" icon there.
 
-Make the the composer window wide enough so that no lines wrap. As of
+Make the composer window wide enough so that no lines wrap. As of
 KMail 1.13.5 (KDE 4.5.4), KMail will apply word wrapping when sending
 the email if the lines wrap in the composer window. Having word wrapping
 disabled in the Options menu isn't enough. Thus, if your patch has very
diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index 4c95935..e548964 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
@@ -255,7 +255,7 @@ AUTOFS_DEV_IOCTL_OPENMOUNT and AUTOFS_DEV_IOCTL_CLOSEMOUNT
 
 Obtain and release a file descriptor for an autofs managed mount point
 path. The open call requires an initialized struct autofs_dev_ioctl with
-the the path field set and the size field adjusted appropriately as well
+the path field set and the size field adjusted appropriately as well
 as the arg1 field set to the device number of the autofs mount. The
 device number can be obtained from the mount options shown in
 /proc/mounts. The close call requires an initialized struct
@@ -373,7 +373,7 @@ variation uses the path and optionally arg1 set to an autofs mount type.
 The call returns 1 if this is a mount point and sets arg1 to the device
 number of the mount and field arg2 to the relevant super block magic
 number (described below) or 0 if it isn't a mountpoint. In both cases
-the the device number (as returned by new_encode_dev()) is returned
+the device number (as returned by new_encode_dev()) is returned
 in field arg1.
 
 If supplied with a file descriptor we're looking for a specific mount,
@@ -387,7 +387,7 @@ is one or 0 if it isn't a mountpoint.
 If a path is supplied (and the ioctlfd field is set to -1) then the path
 is looked up and is checked to see if it is the root of a mount. If a
 type is also given we are looking for a particular autofs mount and if
-a match isn't found a fail is returned. If the the located path is the
+a match isn't found a fail is returned. If the located path is the
 root of a mount 1 is returned along with the super magic of the mount
 or 0 otherwise.
 
diff --git a/Documentation/futex-requeue-pi.txt b/Documentation/futex-requeue-pi.txt
index 9dc1ff4..31b1661 100644
--- a/Documentation/futex-requeue-pi.txt
+++ b/Documentation/futex-requeue-pi.txt
@@ -67,7 +67,7 @@ pthread_cond_wait_pi(cond, mutex)
 	   lock(cond->__data.__lock);
 	} while(...)
 	unlock(cond->__data.__lock);
-        /* the kernel acquired the the mutex for us */
+        /* the kernel acquired the mutex for us */
 }
 
 pthread_cond_broadcast_pi(cond)
diff --git a/Documentation/input/multi-touch-protocol.txt b/Documentation/input/multi-touch-protocol.txt
index de139b1..7b4f59c 100644
--- a/Documentation/input/multi-touch-protocol.txt
+++ b/Documentation/input/multi-touch-protocol.txt
@@ -372,7 +372,7 @@ simple scheme, which is compatible with earlier usage, is:
 
 Rationale: We have no information about the orientation of the touching
 ellipse, so approximate it with an inscribed circle instead. The tool
-ellipse should align with the the vector (T - C), so the diameter must
+ellipse should align with the vector (T - C), so the diameter must
 increase with distance(T, C). Finally, assume that the touch diameter is
 equal to the tool thickness, and we arrive at the formulas above.
 
diff --git a/Documentation/io-mapping.txt b/Documentation/io-mapping.txt
index 473e43b..5ca7842 100644
--- a/Documentation/io-mapping.txt
+++ b/Documentation/io-mapping.txt
@@ -38,7 +38,7 @@ maps are more efficient:
 
 	void io_mapping_unmap_atomic(void *vaddr)
 
-		'vaddr' must be the the value returned by the last
+		'vaddr' must be the value returned by the last
 		io_mapping_map_atomic_wc call. This unmaps the specified
 		page and allows the task to sleep once again.
 
diff --git a/Documentation/kmemcheck.txt b/Documentation/kmemcheck.txt
index 9398a50..a41bdeb 100644
--- a/Documentation/kmemcheck.txt
+++ b/Documentation/kmemcheck.txt
@@ -541,7 +541,7 @@ initialized. This is the beginning of the struct:
 92         } _sifields;
 93 } siginfo_t;
 
-On 64-bit, the int is 4 bytes long, so it must the the union member that has
+On 64-bit, the int is 4 bytes long, so it must the union member that has
 not been initialized. We can verify this using gdb:
 
 	$ gdb vmlinux
diff --git a/Documentation/networking/spider_net.txt b/Documentation/networking/spider_net.txt
index 4b4adb8..b0b75f8 100644
--- a/Documentation/networking/spider_net.txt
+++ b/Documentation/networking/spider_net.txt
@@ -73,7 +73,7 @@ Thus, in an idle system, the GDACTDPA, tail and head pointers will
 all be pointing at the same descr, which should be "empty". All of the
 other descrs in the ring should be "empty" as well.
 
-The show_rx_chain() routine will print out the the locations of the
+The show_rx_chain() routine will print out the locations of the
 GDACTDPA, tail and head pointers. It will also summarize the contents
 of the ring, starting at the tail pointer, and listing the status
 of the descrs that follow.
diff --git a/Documentation/power/devices.txt b/Documentation/power/devices.txt
index a66c982..47d46df 100644
--- a/Documentation/power/devices.txt
+++ b/Documentation/power/devices.txt
@@ -391,7 +391,7 @@ When resuming from freeze, standby or memory sleep, the phases are:
 	the resume methods.  This generally involves undoing the actions of the
 	preceding suspend_late phase.
 
-    3	The resume methods should bring the the device back to its operating
+    3	The resume methods should bring the device back to its operating
 	state, so that it can perform normal I/O.  This generally involves
 	undoing the actions of the suspend phase.
 
diff --git a/Documentation/security/Smack.txt b/Documentation/security/Smack.txt
index 7a2d30c..5ea996f 100644
--- a/Documentation/security/Smack.txt
+++ b/Documentation/security/Smack.txt
@@ -3,7 +3,7 @@
     "Good for you, you've decided to clean the elevator!"
     - The Elevator, from Dark Star
 
-Smack is the the Simplified Mandatory Access Control Kernel.
+Smack is the Simplified Mandatory Access Control Kernel.
 Smack is a kernel based implementation of mandatory access
 control that includes simplicity in its primary design goals.
 
diff --git a/Documentation/static-keys.txt b/Documentation/static-keys.txt
index 9f5263d..e5f46e7 100644
--- a/Documentation/static-keys.txt
+++ b/Documentation/static-keys.txt
@@ -116,7 +116,7 @@ The branch(es) can then be switched via:
 	static_key_slow_dec(&key);
 
 Thus, 'static_key_slow_inc()' means 'make the branch true', and
-'static_key_slow_dec()' means 'make the the branch false' with appropriate
+'static_key_slow_dec()' means 'make the branch false' with appropriate
 reference counting. For example, if the key is initialized true, a
 static_key_slow_dec(), will switch the branch to false. And a subsequent
 static_key_slow_inc(), will change the branch back to true. Likewise, if the
diff --git a/Documentation/trace/ring-buffer-design.txt b/Documentation/trace/ring-buffer-design.txt
index 7d350b4..ff747b6 100644
--- a/Documentation/trace/ring-buffer-design.txt
+++ b/Documentation/trace/ring-buffer-design.txt
@@ -683,7 +683,7 @@ against nested writers.
   cmpxchg(tail_page, temp_page, next_page)
 
 The above will update the tail page if it is still pointing to the expected
-page. If this fails, a nested write pushed it forward, the the current write
+page. If this fails, a nested write pushed it forward, the current write
 does not need to push it.
 
 
diff --git a/Documentation/usb/WUSB-Design-overview.txt b/Documentation/usb/WUSB-Design-overview.txt
index 4c5e379..1cd07c0 100644
--- a/Documentation/usb/WUSB-Design-overview.txt
+++ b/Documentation/usb/WUSB-Design-overview.txt
@@ -25,7 +25,7 @@ updated content.
     * Design-overview.txt-1.8
 
 This code implements a Ultra Wide Band stack for Linux, as well as
-drivers for the the USB based UWB radio controllers defined in the
+drivers for the USB based UWB radio controllers defined in the
 Wireless USB 1.0 specification (including Wireless USB host controller
 and an Intel WiNET controller).
 
diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index 858aecf..cb54d29 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -1462,7 +1462,7 @@ struct kvm_lapic_state {
 	char regs[KVM_APIC_REG_SIZE];
 };
 
-Copies the input argument into the the Local APIC registers.  The data format
+Copies the input argument into the Local APIC registers.  The data format
 and layout are the same as documented in the architecture manual.
 
 
diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index a68db769..441dd22 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -453,7 +453,7 @@ putback_lru_page() function to add migrated pages back to the LRU.
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
 
-In addition the the mlock()/mlockall() system calls, an application can request
+In addition to the mlock()/mlockall() system calls, an application can request
 that a region of memory be mlocked supplying the MAP_LOCKED flag to the mmap()
 call.  Furthermore, any mmap() call or brk() call that expands the heap by a
 task that has previously called mlockall() with the MCL_FUTURE flag will result
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c8a916f..6bd7582 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -2021,7 +2021,7 @@ config ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND
 	bool "Extend with bootloader kernel arguments"
 	help
 	  The command-line arguments provided by the boot loader will be
-	  appended to the the device tree bootargs property.
+	  appended to the device tree bootargs property.
 
 endchoice
 
diff --git a/arch/arm/include/asm/unwind.h b/arch/arm/include/asm/unwind.h
index d1c3f3a..4f697ed 100644
--- a/arch/arm/include/asm/unwind.h
+++ b/arch/arm/include/asm/unwind.h
@@ -22,7 +22,7 @@
 
 #ifndef __ASSEMBLY__
 
-/* Unwind reason code according the the ARM EABI documents */
+/* Unwind reason code according to the ARM EABI documents */
 enum unwind_reason_code {
 	URC_OK = 0,			/* operation completed successfully */
 	URC_CONTINUE_UNWIND = 8,
diff --git a/arch/arm/mach-omap2/omap_hwmod.c b/arch/arm/mach-omap2/omap_hwmod.c
index d9ee0ff..5232252 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -721,7 +721,7 @@ static int _del_initiator_dep(struct omap_hwmod *oh, struct omap_hwmod *init_oh)
 }
 
 /**
- * _init_main_clk - get a struct clk * for the the hwmod's main functional clk
+ * _init_main_clk - get a struct clk * for the hwmod's main functional clk
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh _clk (main
@@ -759,7 +759,7 @@ static int _init_main_clk(struct omap_hwmod *oh)
 }
 
 /**
- * _init_interface_clks - get a struct clk * for the the hwmod's interface clks
+ * _init_interface_clks - get a struct clk * for the hwmod's interface clks
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh OCP slave interface
@@ -802,7 +802,7 @@ static int _init_interface_clks(struct omap_hwmod *oh)
 }
 
 /**
- * _init_opt_clk - get a struct clk * for the the hwmod's optional clocks
+ * _init_opt_clk - get a struct clk * for the hwmod's optional clocks
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh omap_hwmod_opt_clk
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 62aea3e..cd2a206 100644
--- a/arch/arm/mach-pxa/stargate2.c
+++ b/arch/arm/mach-pxa/stargate2.c
@@ -423,7 +423,7 @@ static void __init imote2_stargate2_init(void)
 }
 
 #ifdef CONFIG_MACH_INTELMOTE2
-/* As the the imote2 doesn't currently have a conventional SD slot
+/* As the imote2 doesn't currently have a conventional SD slot
  * there is no option to hotplug cards, making all this rather simple
  */
 static int imote2_mci_get_ro(struct device *dev)
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 86b5a09..9c86123 100644
--- a/arch/blackfin/mach-common/entry.S
+++ b/arch/blackfin/mach-common/entry.S
@@ -480,7 +480,7 @@ ENTRY(_trap) /* Exception: 4th entry into system event table(supervisor mode)*/
 #ifdef CONFIG_EXACT_HWERR
 	/* Make sure all pending read/writes complete. This will ensure any
 	 * accesses which could cause hardware errors completes, and signal
-	 * the the hardware before we do something silly, like crash the
+	 * the hardware before we do something silly, like crash the
 	 * kernel. We don't need to work around anomaly 05000312, since
 	 * we are already atomic
 	 */
diff --git a/arch/c6x/platforms/cache.c b/arch/c6x/platforms/cache.c
index 86318a1..dc21f94 100644
--- a/arch/c6x/platforms/cache.c
+++ b/arch/c6x/platforms/cache.c
@@ -437,7 +437,7 @@ void __init c6x_cache_init(void)
 	if (!cache_base)
 		return;
 
-	/* Set L2 caches on the the whole L2 SRAM memory */
+	/* Set L2 caches on the whole L2 SRAM memory */
 	L2_cache_set_mode(L2MODE_SIZE);
 
 	/* Enable L1 */
diff --git a/arch/ia64/include/asm/spinlock.h b/arch/ia64/include/asm/spinlock.h
index 45698cd..bd6ea40 100644
--- a/arch/ia64/include/asm/spinlock.h
+++ b/arch/ia64/include/asm/spinlock.h
@@ -23,7 +23,7 @@
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  * The pad bits in the middle are used to prevent the next_ticket number
  * overflowing into the now_serving number.
  *
diff --git a/arch/ia64/include/asm/uv/uv_hub.h b/arch/ia64/include/asm/uv/uv_hub.h
index 53e9dfa..3ea4168 100644
--- a/arch/ia64/include/asm/uv/uv_hub.h
+++ b/arch/ia64/include/asm/uv/uv_hub.h
@@ -257,7 +257,7 @@ static inline int uv_numa_blade_id(void)
 	return 0;
 }
 
-/* Convert a cpu number to the the UV blade number */
+/* Convert a cpu number to the UV blade number */
 static inline int uv_cpu_to_blade_id(int cpu)
 {
 	return 0;
diff --git a/arch/m68k/platform/coldfire/intc-2.c b/arch/m68k/platform/coldfire/intc-2.c
index 9950933..f74f0e47 100644
--- a/arch/m68k/platform/coldfire/intc-2.c
+++ b/arch/m68k/platform/coldfire/intc-2.c
@@ -7,7 +7,7 @@
  * family, the 5270, 5271, 5274, 5275, and the 528x family which have two such
  * controllers, and the 547x and 548x families which have only one of them.
  *
- * The external 7 fixed interrupts are part the the Edge Port unit of these
+ * The external 7 fixed interrupts are part of the Edge Port unit of these
  * ColdFire parts. They can be configured as level or edge triggered.
  *
  * (C) Copyright 2009-2011, Greg Ungerer <gerg@snapgear.com>
diff --git a/arch/metag/kernel/process.c b/arch/metag/kernel/process.c
index 483dff9..30052da 100644
--- a/arch/metag/kernel/process.c
+++ b/arch/metag/kernel/process.c
@@ -211,7 +211,7 @@ int copy_thread(unsigned long clone_flags, unsigned long usp,
 	/*
 	 * Get a pointer to where the new child's register block should have
 	 * been pushed.
-	 * The Meta's stack grows upwards, and the context is the the first
+	 * The Meta's stack grows upwards, and the context is the first
 	 * thing to be pushed by TBX (phew)
 	 */
 	*childregs = *current_pt_regs();
diff --git a/arch/microblaze/kernel/entry.S b/arch/microblaze/kernel/entry.S
index 0536bc0..b417be0 100644
--- a/arch/microblaze/kernel/entry.S
+++ b/arch/microblaze/kernel/entry.S
@@ -445,7 +445,7 @@ TRAP_return:		/* Make global symbol for debugging */
 
 
 /* This the initial entry point for a new child thread, with an appropriate
-   stack in place that makes it look the the child is in the middle of an
+   stack in place that makes it look like the child is in the middle of an
    syscall.  This function is actually `returned to' from switch_thread
    (copy_thread makes ret_from_fork the return address in each new thread's
    saved context).  */
diff --git a/arch/mips/alchemy/devboards/pm.c b/arch/mips/alchemy/devboards/pm.c
index b86bff3..6363d3c 100644
--- a/arch/mips/alchemy/devboards/pm.c
+++ b/arch/mips/alchemy/devboards/pm.c
@@ -16,7 +16,7 @@
  * Generic suspend userspace interface for Alchemy development boards.
  * This code exports a few sysfs nodes under /sys/power/db1x/ which
  * can be used by userspace to en/disable all au1x-provided wakeup
- * sources and configure the timeout after which the the TOYMATCH2 irq
+ * sources and configure the timeout after which the TOYMATCH2 irq
  * is to trigger a wakeup.
  */
 
diff --git a/arch/mips/include/asm/octeon/cvmx-pip.h b/arch/mips/include/asm/octeon/cvmx-pip.h
index a76fe5a..a6e8835 100644
--- a/arch/mips/include/asm/octeon/cvmx-pip.h
+++ b/arch/mips/include/asm/octeon/cvmx-pip.h
@@ -503,7 +503,7 @@ static inline void cvmx_pip_tag_mask_clear(uint64_t mask_index)
  *	    offsetof() to determine the offsets into packet headers.
  *	    For example, offsetof(ethhdr, protocol) returns the offset
  *	    of the ethernet protocol field.  The bitmask selects which
- *	    bytes to include the the tag, with bit offset X selecting
+ *	    bytes to include in the tag, with bit offset X selecting
  *	    byte at offset X from the beginning of the packet data.
  * @len:    Number of bytes to include. Usually this is the sizeof()
  *	    the field.
diff --git a/arch/mips/include/asm/spinlock.h b/arch/mips/include/asm/spinlock.h
index 78d201f..b6f41f6 100644
--- a/arch/mips/include/asm/spinlock.h
+++ b/arch/mips/include/asm/spinlock.h
@@ -31,7 +31,7 @@
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  */
 
 static inline int arch_spin_is_locked(arch_spinlock_t *lock)
diff --git a/arch/mips/kernel/smtc.c b/arch/mips/kernel/smtc.c
index dfc1b91..cfde409 100644
--- a/arch/mips/kernel/smtc.c
+++ b/arch/mips/kernel/smtc.c
@@ -908,7 +908,7 @@ void smtc_send_ipi(int cpu, int type, unsigned int action)
 
 		if ((tcstatus & TCSTATUS_IXMT) != 0) {
 			/*
-			 * If we're in the the irq-off version of the wait
+			 * If we're in the irq-off version of the wait
 			 * loop, we need to force exit from the wait and
 			 * do a direct post of the IPI.
 			 */
diff --git a/arch/mips/kvm/kvm_mips.c b/arch/mips/kvm/kvm_mips.c
index a7b0445..4074bc8 100644
--- a/arch/mips/kvm/kvm_mips.c
+++ b/arch/mips/kvm/kvm_mips.c
@@ -1197,7 +1197,7 @@ int __init kvm_mips_init(void)
 	/* On MIPS, kernel modules are executed from "mapped space", which requires TLBs.
 	 * The TLB handling code is statically linked with the rest of the kernel (kvm_tlb.c)
 	 * to avoid the possibility of double faulting. The issue is that the TLB code
-	 * references routines that are part of the the KVM module,
+	 * references routines that are part of the KVM module,
 	 * which are only available once the module is loaded.
 	 */
 	kvm_mips_gfn_to_pfn = gfn_to_pfn;
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index a0bcdbb..a3051b2 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -333,7 +333,7 @@ static void co_cache_error_call_notifiers(unsigned long val)
 }
 
 /*
- * Called when the the exception is recoverable
+ * Called when the exception is recoverable
  */
 
 asmlinkage void cache_parity_error_octeon_recoverable(void)
@@ -342,7 +342,7 @@ asmlinkage void cache_parity_error_octeon_recoverable(void)
 }
 
 /**
- * Called when the the exception is not recoverable
+ * Called when the exception is not recoverable
  */
 
 asmlinkage void cache_parity_error_octeon_non_recoverable(void)
diff --git a/arch/mips/netlogic/xlr/fmn.c b/arch/mips/netlogic/xlr/fmn.c
index d428e84..1d1eb1e 100644
--- a/arch/mips/netlogic/xlr/fmn.c
+++ b/arch/mips/netlogic/xlr/fmn.c
@@ -144,7 +144,7 @@ void xlr_percpu_fmn_init(void)
 	 * For sending FMN messages, we need credits on the destination
 	 * bucket. Program the credits this core has on the 128 possible
 	 * destination buckets.
-	 * We cannot use a loop here, because the the first argument has
+	 * We cannot use a loop here, because the first argument has
 	 * to be a constant integer value.
 	 */
 	COP2_CC_INIT_CPU_DEST(0, cpu_fmn_info->credit_config);
diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include/asm/epapr_hcalls.h
index 86b0ac7..51dd1f6 100644
--- a/arch/powerpc/include/asm/epapr_hcalls.h
+++ b/arch/powerpc/include/asm/epapr_hcalls.h
@@ -246,7 +246,7 @@ static inline unsigned int ev_int_get_mask(unsigned int interrupt,
  * ev_int_eoi - signal the end of interrupt processing
  * @interrupt: the interrupt number
  *
- * This function signals the end of processing for the the specified
+ * This function signals the end of processing for the specified
  * interrupt, which must be the interrupt currently in service. By
  * definition, this is also the highest-priority interrupt.
  *
diff --git a/arch/powerpc/include/asm/hw_breakpoint.h b/arch/powerpc/include/asm/hw_breakpoint.h
index eb0f4ac..0917910 100644
--- a/arch/powerpc/include/asm/hw_breakpoint.h
+++ b/arch/powerpc/include/asm/hw_breakpoint.h
@@ -30,7 +30,7 @@ struct arch_hw_breakpoint {
 	u16		len; /* length of the target data symbol */
 };
 
-/* Note: Don't change the the first 6 bits below as they are in the same order
+/* Note: Don't change the first 6 bits below as they are in the same order
  * as the dabr and dabrx.
  */
 #define HW_BRK_TYPE_READ		0x01
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index 3d11d80..534c33e 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -92,7 +92,7 @@ __secondary_hold_acknowledge:
 #ifdef CONFIG_RELOCATABLE
 	/* This flag is set to 1 by a loader if the kernel should run
 	 * at the loaded address instead of the linked address.  This
-	 * is used by kexec-tools to keep the the kdump kernel in the
+	 * is used by kexec-tools to keep the kdump kernel in the
 	 * crash_kernel region.  The loader is responsible for
 	 * observing the alignment requirement.
 	 */
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index 6936547..5dc8868 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -154,7 +154,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * the pagetables from being freed on powerpc.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index d67db4b..5c993db 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -943,7 +943,7 @@ void flush_dcache_icache_hugepage(struct page *page)
  * (4) hugepd pointer, bottom two bits == 00, next 4 bits indicate size of table
  *
  * So long as we atomically load page table pointers we are safe against teardown,
- * we can follow the address down to the the page and take a ref on it.
+ * we can follow the address down to the page and take a ref on it.
  */
 
 pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea, unsigned *shift)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 6929982..a2ce008 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -9,7 +9,7 @@
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
  *
- * This file is a driver for the the General Purpose Timer (gpt) devices
+ * This file is a driver for the General Purpose Timer (gpt) devices
  * found on the MPC5200 SoC.  Each timer has an IO pin which can be used
  * for GPIO or can be used to raise interrupts.  The timer function can
  * be used independently from the IO pin, or it can be used to control
diff --git a/arch/powerpc/platforms/chrp/setup.c b/arch/powerpc/platforms/chrp/setup.c
index c665d7d..baeb4df 100644
--- a/arch/powerpc/platforms/chrp/setup.c
+++ b/arch/powerpc/platforms/chrp/setup.c
@@ -251,7 +251,7 @@ static void briq_restart(char *cmd)
  * Per default, input/output-device points to the keyboard/screen
  * If no card is installed, the built-in serial port is used as a fallback.
  * But unfortunately, the firmware does not connect /chosen/{stdin,stdout}
- * the the built-in serial node. Instead, a /failsafe node is created.
+ * to the built-in serial node. Instead, a /failsafe node is created.
  */
 static void chrp_init_early(void)
 {
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 74a5a57..f4a1db8 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -889,7 +889,7 @@ static void pnv_pci_init_ioda_msis(struct pnv_phb *phb) { }
 
 /*
  * This function is supposed to be called on basis of PE from top
- * to bottom style. So the the I/O or MMIO segment assigned to
+ * to bottom style. So the I/O or MMIO segment assigned to
  * parent PE could be overrided by its child PEs if necessary.
  */
 static void pnv_ioda_setup_pe_seg(struct pci_controller *hose,
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 5d758db..e47a8d4 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -236,7 +236,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * prevent the pagetables from being freed on s390.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 	pgdp = pgd_offset(mm, addr);
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index bc4d3f5..99c8c5e 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -305,7 +305,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	/* We can't actually use the firmware value, we have
 	 * to read what is in the register right now.  One
 	 * reason is that in the case of IDE interfaces the
-	 * firmware can sample the value before the the IDE
+	 * firmware can sample the value before the IDE
 	 * interface is programmed into native mode.
 	 */
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 01ee23d..758cfa6 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -190,7 +190,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * the pagetables from being freed on sparc.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 71af574..f7f64c8 100644
--- a/arch/tile/include/asm/irqflags.h
+++ b/arch/tile/include/asm/irqflags.h
@@ -116,7 +116,7 @@
  * Note that in particular, the tile timer interrupt comes and goes
  * from this set, since we have no other way to turn off the timer.
  * Likewise, INTCTRL_K is removed and re-added during device
- * interrupts, as is the the hardwall UDN_FIREWALL interrupt.
+ * interrupts, as is the hardwall UDN_FIREWALL interrupt.
  * We use a low bit (MEM_ERROR) as our sentinel value and make sure it
  * is always claimed as an "active interrupt" so we can query that bit
  * to know our current state.
diff --git a/arch/tile/include/gxio/trio.h b/arch/tile/include/gxio/trio.h
index df10a66..50a3d5c 100644
--- a/arch/tile/include/gxio/trio.h
+++ b/arch/tile/include/gxio/trio.h
@@ -206,7 +206,7 @@ typedef struct {
 /* Initialize a TRIO context.
  *
  * This function allocates a TRIO "service domain" and maps the MMIO
- * registers into the the caller's VA space.
+ * registers into the caller's VA space.
  *
  * @param trio_index Which TRIO shim; Gx36 must pass 0.
  * @param context Context object to be initialized.
diff --git a/arch/tile/kernel/single_step.c b/arch/tile/kernel/single_step.c
index de07fa7..c554ffb 100644
--- a/arch/tile/kernel/single_step.c
+++ b/arch/tile/kernel/single_step.c
@@ -277,7 +277,7 @@ P("\n");
 
 /*
  * Called after execve() has started the new image.  This allows us
- * to reset the info state.  Note that the the mmap'ed memory, if there
+ * to reset the info state.  Note that the mmap'ed memory, if there
  * was any, has already been unmapped by the exec.
  */
 void single_step_execve(void)
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index bf156de..59213c3 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -72,7 +72,7 @@ static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  *
  * We use an xadd covering *both* parts of the lock, to increment the tail and
  * also load the position of the head, which takes care of memory ordering
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index 2c32df9..76f6cc0 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -522,7 +522,7 @@ static inline int uv_numa_blade_id(void)
 	return uv_hub_info->numa_blade_id;
 }
 
-/* Convert a cpu number to the the UV blade number */
+/* Convert a cpu number to the UV blade number */
 static inline int uv_cpu_to_blade_id(int cpu)
 {
 	return uv_cpu_to_blade[cpu];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a..458d830 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7040,7 +7040,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
-		 * unless the the memory map has changed due to process exit
+		 * unless the memory map has changed due to process exit
 		 * or fd copying.
 		 */
 		struct kvm_userspace_memory_region mem;
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index dd74e46..d9d367e 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -275,7 +275,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 *
 	 * So long as we atomically load page table pointers versus teardown
 	 * (which we do on x86, with the above PAE exception), we can follow the
-	 * address down to the the page and take a ref on it.
+	 * address down to the page and take a ref on it.
 	 */
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
@@ -347,7 +347,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 *
 	 * So long as we atomically load page table pointers versus teardown
 	 * (which we do on x86, with the above PAE exception), we can follow the
-	 * address down to the the page and take a ref on it.
+	 * address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 	pgdp = pgd_offset(mm, addr);
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 09f3059..0f7fd77 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -463,7 +463,7 @@ char * __init xen_memory_setup(void)
 	 *  - mfn_list
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
-	 * We tried to make the the memblock_reserve more selective so
+	 * We tried to make the memblock_reserve more selective so
 	 * that it would be clear what region is reserved. Sadly we ran
 	 * in the problem wherein on a 64-bit hypervisor with a 32-bit
 	 * initial domain, the pt_base has the cr3 value which is not
diff --git a/arch/xtensa/include/asm/initialize_mmu.h b/arch/xtensa/include/asm/initialize_mmu.h
index 722553f..3c8e71a 100644
--- a/arch/xtensa/include/asm/initialize_mmu.h
+++ b/arch/xtensa/include/asm/initialize_mmu.h
@@ -6,7 +6,7 @@
  *      For the new V3 MMU we remap the TLB from virtual == physical
  *      to the standard Linux mapping used in earlier MMU's.
  *
- *      The the MMU we also support a new configuration register that
+ *      In the MMU we also support a new configuration register that
  *      specifies how the S32C1I instruction operates with the cache
  *      controller.
  *
diff --git a/drivers/acpi/acpica/accommon.h b/drivers/acpi/acpica/accommon.h
index 8a6c4a0..90fe27f 100644
--- a/drivers/acpi/acpica/accommon.h
+++ b/drivers/acpi/acpica/accommon.h
@@ -47,7 +47,7 @@
 /*
  * Common set of includes for all ACPICA source files.
  * We put them here because we don't want to duplicate them
- * in the the source code again and again.
+ * in the source code again and again.
  *
  * Note: The order of these include files is important.
  */
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 55635ed..f6b702d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2700,7 +2700,7 @@ enum drbd_ret_code conn_new_minor(struct drbd_tconn *tconn, unsigned int minor,
 	}
 
 	add_disk(disk);
-	kref_init(&mdev->kref); /* one ref for both idrs and the the add_disk */
+	kref_init(&mdev->kref); /* one ref for both idrs and the add_disk */
 
 	/* inherit the connection state */
 	mdev->state.conn = tconn->cstate;
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index 46118f8..6834b01 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -559,7 +559,7 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 		wake_up_interruptible(&apm_waitqueue);
 
 		/*
-		 * Wait for the the suspend_acks_pending variable to drop to
+		 * Wait for the suspend_acks_pending variable to drop to
 		 * zero, meaning everybody acked the suspend event (or the
 		 * process was killed.)
 		 *
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.c b/drivers/char/xilinx_hwicap/fifo_icap.c
index 02225eb..619f3a3 100644
--- a/drivers/char/xilinx_hwicap/fifo_icap.c
+++ b/drivers/char/xilinx_hwicap/fifo_icap.c
@@ -111,7 +111,7 @@ static inline u32 fifo_icap_fifo_read(struct hwicap_drvdata *drvdata)
 }
 
 /**
- * fifo_icap_set_read_size - Set the the size register.
+ * fifo_icap_set_read_size - Set the size register.
  * @drvdata: a pointer to the drvdata.
  * @data: the size of the following read transaction, in words.
  **/
diff --git a/drivers/cpuidle/driver.c b/drivers/cpuidle/driver.c
index 3ac499d..b25ec77 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -56,7 +56,7 @@ static inline void __cpuidle_unset_driver(struct cpuidle_driver *drv)
 }
 
 /**
- * __cpuidle_set_driver - set per CPU driver variables the the given driver.
+ * __cpuidle_set_driver - set per CPU driver variables for the given driver.
  * @drv: a valid pointer to a struct cpuidle_driver
  *
  * For each CPU in the driver's cpumask, unset the registered driver per CPU
@@ -169,7 +169,7 @@ static int __cpuidle_driver_init(struct cpuidle_driver *drv)
 	/*
 	 * Look for the timer stop flag in the different states, so that we know
 	 * if the broadcast timer has to be set up.  The loop is in the reverse
-	 * order, because usually on of the the deeper states has this flag set.
+	 * order, because usually one of the deeper states has this flag set.
 	 */
 	for (i = drv->state_count - 1; i >= 0 ; i--) {
 
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 888f7f4..b5668e0 100644
--- a/drivers/crypto/picoxcell_crypto.c
+++ b/drivers/crypto/picoxcell_crypto.c
@@ -53,7 +53,7 @@
 #define CMD0_IRQ_THRESHOLD   1
 
 /*
- * The timeout period (in jiffies) for a PDU. When the the number of PDUs in
+ * The timeout period (in jiffies) for a PDU. When the number of PDUs in
  * flight is greater than the STAT_IRQ_THRESHOLD or 0 the timer is disabled.
  * When there are packets in flight but lower than the threshold, we enable
  * the timer and at expiry, attempt to remove any processed packets from the
diff --git a/drivers/crypto/ux500/hash/hash_core.c b/drivers/crypto/ux500/hash/hash_core.c
index 1c73f4f..2f2a427 100644
--- a/drivers/crypto/ux500/hash/hash_core.c
+++ b/drivers/crypto/ux500/hash/hash_core.c
@@ -435,7 +435,7 @@ static int hash_get_device_data(struct hash_ctx *ctx,
  * @keylen:		The lengt of the key.
  *
  * Note! This function DOES NOT write to the NBLW registry, even though
- * specified in the the hw design spec. Either due to incorrect info in the
+ * specified in the hw design spec. Either due to incorrect info in the
  * spec or due to a bug in the hw.
  */
 static void hash_hw_write_key(struct hash_device_data *device_data,
diff --git a/drivers/gpio/gpio-ich.c b/drivers/gpio/gpio-ich.c
index 814addb..ee45a3d 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -399,7 +399,7 @@ static int ichx_gpio_probe(struct platform_device *pdev)
 
 	/*
 	 * If necessary, determine the I/O address of ACPI/power management
-	 * registers which are needed to read the the GPE0 register for GPI pins
+	 * registers which are needed to read the GPE0 register for GPI pins
 	 * 0 - 15 on some chipsets.
 	 */
 	if (!ichx_priv.desc->uses_gpe0)
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d9e337f..2682b90 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2101,7 +2101,7 @@ int __i915_add_request(struct intel_ring_buffer *ring,
 
 	/* Whilst this request exists, batch_obj will be on the
 	 * active_list, and so will hold the active reference. Only when this
-	 * request is retired will the the batch_obj be moved onto the
+	 * request is retired will the batch_obj be moved onto the
 	 * inactive_list and lose its active reference. Hence we do not need
 	 * to explicitly hold another reference here.
 	 */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2489d0b..c292bb2 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2134,7 +2134,7 @@ void intel_display_handle_reset(struct drm_device *dev)
 	 * will get its events and not get stuck.
 	 *
 	 * Also update the base address of all primary
-	 * planes to the the last fb to make sure we're
+	 * planes to the last fb to make sure we're
 	 * showing the correct fb after a reset.
 	 *
 	 * Need to make two loops over the crtcs so that we
@@ -8895,7 +8895,7 @@ static int __intel_set_mode(struct drm_crtc *crtc,
 	}
 
 	/* Only after disabling all output pipelines that will be changed can we
-	 * update the the output configuration. */
+	 * update the output configuration. */
 	intel_modeset_update_state(dev, prepare_pipes);
 
 	if (dev_priv->display.modeset_global_resources)
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index af10f85..559002e 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -2779,8 +2779,8 @@ ucMaxNBVoltageHigh:     Voltage regulator dependent PWM value. High 8 bits of  t
 ucMinNBVoltageHigh:     Voltage regulator dependent PWM value. High 8 bits of the value for the min voltage.Set this one to 0x00 if VC without PWM or no VC at all.
 
 
-usInterNBVoltageLow:    Voltage regulator dependent PWM value. The value makes the the voltage >=Min NB voltage but <=InterNBVoltageHigh. Set this to 0x0000 if VC without PWM or no VC at all.
-usInterNBVoltageHigh:   Voltage regulator dependent PWM value. The value makes the the voltage >=InterNBVoltageLow but <=Max NB voltage.Set this to 0x0000 if VC without PWM or no VC at all.
+usInterNBVoltageLow:    Voltage regulator dependent PWM value. The value makes the voltage >=Min NB voltage but <=InterNBVoltageHigh. Set this to 0x0000 if VC without PWM or no VC at all.
+usInterNBVoltageHigh:   Voltage regulator dependent PWM value. The value makes the voltage >=InterNBVoltageLow but <=Max NB voltage.Set this to 0x0000 if VC without PWM or no VC at all.
 */
 
 
diff --git a/drivers/gpu/drm/radeon/r300_reg.h b/drivers/gpu/drm/radeon/r300_reg.h
index 00c0d2b..36af5f1 100644
--- a/drivers/gpu/drm/radeon/r300_reg.h
+++ b/drivers/gpu/drm/radeon/r300_reg.h
@@ -353,7 +353,7 @@
 #       define R300_PVS_CNTL_1_PROGRAM_START_SHIFT   0
 #       define R300_PVS_CNTL_1_POS_END_SHIFT         10
 #       define R300_PVS_CNTL_1_PROGRAM_END_SHIFT     20
-/* Addresses are relative the the vertex program parameters area. */
+/* Addresses are relative to the vertex program parameters area. */
 #define R300_VAP_PVS_CNTL_2                 0x22D4
 #       define R300_PVS_CNTL_2_PARAM_OFFSET_SHIFT 0
 #       define R300_PVS_CNTL_2_PARAM_COUNT_SHIFT  16
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 16cb879..b5c12df 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -321,7 +321,7 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
 
 /*
  * radeon_wb_*()
- * Writeback is the the method by which the the GPU updates special pages
+ * Writeback is the method by which the GPU updates special pages
  * in memory with the status of certain GPU events (fences, ring pointers,
  * etc.).
  */
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index ddb8f8e..555529a 100644
--- a/drivers/gpu/drm/radeon/radeon_fence.c
+++ b/drivers/gpu/drm/radeon/radeon_fence.c
@@ -45,7 +45,7 @@
  * for GPU/CPU synchronization.  When the fence is written,
  * it is expected that all buffers associated with that fence
  * are no longer in use by the associated ring on the GPU and
- * that the the relevant GPU caches have been flushed.  Whether
+ * that the relevant GPU caches have been flushed.  Whether
  * we use a scratch register or memory location depends on the asic
  * and whether writeback is enabled.
  */
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index b990b1a..2c0d2fb 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -405,7 +405,7 @@ void radeon_gart_fini(struct radeon_device *rdev)
  * (uncached system pages).
  * Each VM has an ID associated with it and there is a page table
  * associated with each VMID.  When execting a command buffer,
- * the kernel tells the the ring what VMID to use for that command
+ * the kernel tells the ring what VMID to use for that command
  * buffer.  VMIDs are allocated dynamically as commands are submitted.
  * The userspace drivers maintain their own address space and the kernel
  * sets up their pages tables accordingly when they submit their
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 6de6c98..423f156 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -586,7 +586,7 @@ EXPORT_SYMBOL_GPL(vmbus_close);
  * vmbus_sendpacket() - Send the specified buffer on the given channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
- * @bufferlen: Maximum size of what the the buffer will hold
+ * @bufferlen: Maximum size of what the buffer will hold
  * @requestid: Identifier of the request
  * @type: Type of packet that is being send e.g. negotiate, time
  * packet etc.
@@ -761,7 +761,7 @@ EXPORT_SYMBOL_GPL(vmbus_sendpacket_multipagebuffer);
  * vmbus_recvpacket() - Retrieve the user packet on the specified channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
- * @bufferlen: Maximum size of what the the buffer will hold
+ * @bufferlen: Maximum size of what the buffer will hold
  * @buffer_actual_len: The actual size of the data after it was received
  * @requestid: Identifier of the request
  *
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index f9fe46f..2e81686 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -714,7 +714,7 @@ void vmbus_device_unregister(struct hv_device *device_obj)
 
 
 /*
- * VMBUS is an acpi enumerated device. Get the the IRQ information
+ * VMBUS is an acpi enumerated device. Get the IRQ information
  * from DSDT.
  */
 
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 033d6ac..d41d7e3 100644
--- a/drivers/hwmon/pmbus/ucd9200.c
+++ b/drivers/hwmon/pmbus/ucd9200.c
@@ -117,7 +117,7 @@ static int ucd9200_probe(struct i2c_client *client,
 	 * This only affects the READ_IOUT and READ_TEMPERATURE2 registers.
 	 * READ_IOUT will return the sum of currents of all phases of a rail,
 	 * and READ_TEMPERATURE2 will return the maximum temperature detected
-	 * for the the phases of the rail.
+	 * for the phases of the rail.
 	 */
 	for (i = 0; i < info->pages; i++) {
 		/*
diff --git a/drivers/infiniband/hw/ipath/ipath_common.h b/drivers/infiniband/hw/ipath/ipath_common.h
index 28cfe97..231b545 100644
--- a/drivers/infiniband/hw/ipath/ipath_common.h
+++ b/drivers/infiniband/hw/ipath/ipath_common.h
@@ -87,7 +87,7 @@
  * These 3 values (SDR and DDR may be ORed for auto-speed
  * negotiation) are used for the 3rd argument to path_f_set_ib_cfg
  * with cmd IPATH_IB_CFG_SPD_ENB, by direct calls or via sysfs.  They
- * are also the the possible values for ipath_link_speed_enabled and active
+ * are also the possible values for ipath_link_speed_enabled and active
  * The values were chosen to match values used within the IB spec.
  */
 #define IPATH_IB_SDR 1
diff --git a/drivers/infiniband/hw/qib/qib.h b/drivers/infiniband/hw/qib/qib.h
index 1946101..1adecf0 100644
--- a/drivers/infiniband/hw/qib/qib.h
+++ b/drivers/infiniband/hw/qib/qib.h
@@ -333,7 +333,7 @@ struct qib_verbs_txreq {
  * These 7 values (SDR, DDR, and QDR may be ORed for auto-speed
  * negotiation) are used for the 3rd argument to path_f_set_ib_cfg
  * with cmd QIB_IB_CFG_SPD_ENB, by direct calls or via sysfs.  They
- * are also the the possible values for qib_link_speed_enabled and active
+ * are also the possible values for qib_link_speed_enabled and active
  * The values were chosen to match values used within the IB spec.
  */
 #define QIB_IB_SDR 1
diff --git a/drivers/input/mouse/gpio_mouse.c b/drivers/input/mouse/gpio_mouse.c
index 6b44413..59f820e6 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -18,7 +18,7 @@
 
 /*
  * Timer function which is run every scan_ms ms when the device is opened.
- * The dev input variable is set to the the input_dev pointer.
+ * The dev input variable is set to the input_dev pointer.
  */
 static void gpio_mouse_scan(struct input_polled_dev *dev)
 {
diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index 59aa240..9842375 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1017,7 +1017,7 @@ static int mxt_load_fw(struct device *dev, const char *fn)
 
 		frame_size = ((*(fw->data + pos) << 8) | *(fw->data + pos + 1));
 
-		/* We should add 2 at frame size as the the firmware data is not
+		/* We should add 2 at frame size as the firmware data is not
 		 * included the CRC bytes.
 		 */
 		frame_size += 2;
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 114f3bc..24c15bf 100644
--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1566,7 +1566,7 @@ reset_hfcsusb(struct hfcsusb *hw)
 	write_reg(hw, HFCUSB_USB_SIZE, (hw->packet_size / 8) |
 		  ((hw->packet_size / 8) << 4));
 
-	/* set USB_SIZE_I to match the the wMaxPacketSize for ISO transfers */
+	/* set USB_SIZE_I to match the wMaxPacketSize for ISO transfers */
 	write_reg(hw, HFCUSB_USB_SIZE_I, hw->iso_packet_size);
 
 	/* enable PCM/GCI master mode */
diff --git a/drivers/lguest/core.c b/drivers/lguest/core.c
index 0bf1e4e..def8b35 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -205,7 +205,7 @@ void __lgwrite(struct lg_cpu *cpu, unsigned long addr, const void *b,
 /*:*/
 
 /*H:030
- * Let's jump straight to the the main loop which runs the Guest.
+ * Let's jump straight to the main loop which runs the Guest.
  * Remember, this is called by the Launcher reading /dev/lguest, and we keep
  * going around and around until something interesting happens.
  */
diff --git a/drivers/media/dvb-frontends/tda1002x.h b/drivers/media/dvb-frontends/tda1002x.h
index e404b6e..ce0fb85 100644
--- a/drivers/media/dvb-frontends/tda1002x.h
+++ b/drivers/media/dvb-frontends/tda1002x.h
@@ -1,6 +1,6 @@
 /*
     TDA10021/TDA10023  - Single Chip Cable Channel Receiver driver module
-			 used on the the Siemens DVB-C cards
+			 used on the Siemens DVB-C cards
 
     Copyright (C) 1999 Convergence Integrated Media GmbH <ralph@convergence.de>
     Copyright (C) 2004 Markus Schulz <msc@antzsystem.de>
diff --git a/drivers/media/dvb-frontends/tda10048.c b/drivers/media/dvb-frontends/tda10048.c
index 71fb632..17534ff 100644
--- a/drivers/media/dvb-frontends/tda10048.c
+++ b/drivers/media/dvb-frontends/tda10048.c
@@ -1134,7 +1134,7 @@ struct dvb_frontend *tda10048_attach(const struct tda10048_config *config,
 		state->pll_pfactor = 0;
 	}
 
-	/* Establish any defaults the the user didn't pass */
+	/* Establish any defaults the user didn't pass */
 	tda10048_establish_defaults(&state->frontend);
 
 	/* Set the xtal and freq defaults */
diff --git a/drivers/media/pci/cx88/cx88-dsp.c b/drivers/media/pci/cx88/cx88-dsp.c
index a990726..1f8820f 100644
--- a/drivers/media/pci/cx88/cx88-dsp.c
+++ b/drivers/media/pci/cx88/cx88-dsp.c
@@ -37,7 +37,7 @@
 	 (compat_remainder(carrier + tone, srate)) / srate * 2 * INT_PI))
 
 /* We calculate the baseband frequencies of the carrier and the pilot tones
- * based on the the sampling rate of the audio rds fifo. */
+ * based on the sampling rate of the audio rds fifo. */
 
 #define FREQ_A2_CARRIER         baseband_freq(54687.5, 2689.36, 0.0)
 #define FREQ_A2_DUAL            baseband_freq(54687.5, 2689.36, 274.1)
diff --git a/drivers/media/pci/ivtv/ivtv-yuv.c b/drivers/media/pci/ivtv/ivtv-yuv.c
index 2ad65eb..00e0818 100644
--- a/drivers/media/pci/ivtv/ivtv-yuv.c
+++ b/drivers/media/pci/ivtv/ivtv-yuv.c
@@ -555,7 +555,7 @@ static void ivtv_yuv_handle_vertical(struct ivtv *itv, struct yuv_frame_info *f)
 	reg_2964 = (reg_2964 << 16) + reg_2964 + (reg_2964 * 46 / 94);
 
 	/* Okay, we've wasted time working out the correct value,
-	   but if we use it, it fouls the the window alignment.
+	   but if we use it, it fouls the window alignment.
 	   Fudge it to what we want... */
 	reg_2964 = 0x00010001 + ((reg_2964 & 0x0000FFFF) - (reg_2964 >> 16));
 	reg_2968 = 0x00010001 + ((reg_2968 & 0x0000FFFF) - (reg_2968 >> 16));
diff --git a/drivers/media/pci/saa7164/saa7164-core.c b/drivers/media/pci/saa7164/saa7164-core.c
index d37ee37..328956a 100644
--- a/drivers/media/pci/saa7164/saa7164-core.c
+++ b/drivers/media/pci/saa7164/saa7164-core.c
@@ -636,7 +636,7 @@ static irqreturn_t saa7164_irq(int irq, void *dev_id)
 	}
 
 	/* Check that the hardware is accessible. If the status bytes are
-	 * 0xFF then the device is not accessible, the the IRQ belongs
+	 * 0xFF then the device is not accessible, the IRQ belongs
 	 * to another driver.
 	 * 4 x u32 interrupt registers.
 	 */
diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 33b9660..6ea16e2 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -316,7 +316,7 @@ static int vpbe_set_default_output(struct vpbe_device *vpbe_dev)
  * vpbe_get_output - Get output
  * @vpbe_dev - vpbe device ptr
  *
- * return current vpbe output to the the index
+ * return current vpbe output to the index
  */
 static unsigned int vpbe_get_output(struct vpbe_device *vpbe_dev)
 {
diff --git a/drivers/media/platform/exynos4-is/fimc-capture.c b/drivers/media/platform/exynos4-is/fimc-capture.c
index fb27ff7..0a9140b 100644
--- a/drivers/media/platform/exynos4-is/fimc-capture.c
+++ b/drivers/media/platform/exynos4-is/fimc-capture.c
@@ -505,7 +505,7 @@ static int fimc_capture_open(struct file *file)
 
 		if (ret == 0 && vc->user_subdev_api && vc->inh_sensor_ctrls) {
 			/*
-			 * Recreate controls of the the video node to drop
+			 * Recreate controls of the video node to drop
 			 * any controls inherited from the sensor subdev.
 			 */
 			fimc_ctrls_delete(vc->ctx);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index df3a0ec..cdba0d5 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1671,7 +1671,7 @@ void omap3isp_print_status(struct isp_device *isp)
  * To solve this problem power management support is split into prepare/complete
  * and suspend/resume operations. The pipelines are stopped in prepare() and the
  * ISP clocks get disabled in suspend(). Similarly, the clocks are reenabled in
- * resume(), and the the pipelines are restarted in complete().
+ * resume(), and the pipelines are restarted in complete().
  *
  * TODO: PM dependencies between the ISP and sensors are not modeled explicitly
  * yet.
diff --git a/drivers/media/rc/iguanair.c b/drivers/media/rc/iguanair.c
index 19632b1..d01f106 100644
--- a/drivers/media/rc/iguanair.c
+++ b/drivers/media/rc/iguanair.c
@@ -308,7 +308,7 @@ static int iguanair_set_tx_carrier(struct rc_dev *dev, uint32_t carrier)
 		cycles = DIV_ROUND_CLOSEST(24000000, carrier * 2) -
 							ir->cycle_overhead;
 
-		/*  make up the the remainer of 4-cycle blocks */
+		/*  make up the remainer of 4-cycle blocks */
 		switch (cycles & 3) {
 		case 0:
 			sevens = 0;
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index d56f927..b5d2e80 100644
--- a/drivers/media/usb/dvb-usb/friio-fe.c
+++ b/drivers/media/usb/dvb-usb/friio-fe.c
@@ -2,7 +2,7 @@
  *
  * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
  *
- * This module is based off the the gl861 and vp702x modules.
+ * This module is based off the gl861 and vp702x modules.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/friio.c b/drivers/media/usb/dvb-usb/friio.c
index 474a17e..4c7f8fe 100644
--- a/drivers/media/usb/dvb-usb/friio.c
+++ b/drivers/media/usb/dvb-usb/friio.c
@@ -2,7 +2,7 @@
  *
  * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
  *
- * This module is based off the the gl861 and vp702x modules.
+ * This module is based off the gl861 and vp702x modules.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/dvb-usb/friio.h b/drivers/media/usb/dvb-usb/friio.h
index 0f461ca..82d19dc 100644
--- a/drivers/media/usb/dvb-usb/friio.h
+++ b/drivers/media/usb/dvb-usb/friio.h
@@ -2,7 +2,7 @@
  *
  * Copyright (C) 2009 Akihiro Tsukada <tskd2@yahoo.co.jp>
  *
- * This module is based off the the gl861 and vp702x modules.
+ * This module is based off the gl861 and vp702x modules.
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
diff --git a/drivers/media/usb/gspca/finepix.c b/drivers/media/usb/gspca/finepix.c
index 52bdb56..414c1b7 100644
--- a/drivers/media/usb/gspca/finepix.c
+++ b/drivers/media/usb/gspca/finepix.c
@@ -143,7 +143,7 @@ again:
 				 * for, then it's the end of the
 				 * frame. Sometimes the jpeg is not complete,
 				 * but there's nothing we can do. We also end
-				 * here if the the jpeg ends right at the end
+				 * here if the jpeg ends right at the end
 				 * of the frame. */
 				gspca_frame_add(gspca_dev, LAST_PACKET,
 						data, len);
diff --git a/drivers/media/usb/tm6000/tm6000-cards.c b/drivers/media/usb/tm6000/tm6000-cards.c
index 1ccaadd..e43f862 100644
--- a/drivers/media/usb/tm6000/tm6000-cards.c
+++ b/drivers/media/usb/tm6000/tm6000-cards.c
@@ -1313,7 +1313,7 @@ static int tm6000_usb_probe(struct usb_interface *interface,
 		le16_to_cpu(dev->udev->descriptor.idProduct),
 		interface->altsetting->desc.bInterfaceNumber);
 
-/* check if the the device has the iso in endpoint at the correct place */
+/* check if the device has the iso in endpoint at the correct place */
 	if (!dev->isoc_in.endp) {
 		printk(KERN_ERR "tm6000: probing error: no IN ISOC endpoint!\n");
 		rc = -ENODEV;
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index 3394c34..6d34f08 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -991,7 +991,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	}
 
 	/* Synchronize to the input stream by waiting for the FID bit to be
-	 * toggled when the the buffer state is not UVC_BUF_STATE_ACTIVE.
+	 * toggled when the buffer state is not UVC_BUF_STATE_ACTIVE.
 	 * stream->last_fid is initialized to -1, so the first isochronous
 	 * frame will always be in sync.
 	 *
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 04644e7..303b322 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -373,7 +373,7 @@ static const struct lpddr2_addressing *get_addressing_table(
 }
 
 /*
- * Find the the right timing table from the array of timing
+ * Find the right timing table from the array of timing
  * tables of the device using DDR clock frequency
  */
 static const struct lpddr2_timings *get_timings_table(struct emif_data *emif,
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 5653e50..eb9640c 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -101,7 +101,7 @@ static u8	mptspiInternalCtx = MPT_MAX_PROTOCOL_DRIVERS; /* Used only for interna
  *	@target: per target private data
  *	@sdev: SCSI device
  *
- * 	Update the target negotiation parameters based on the the Inquiry
+ *	Update the target negotiation parameters based on the Inquiry
  *	data, adapter capabilities, and NVRAM settings.
  **/
 static void
diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
index 53f371d..92cd9d4 100644
--- a/drivers/mfd/db8500-prcmu.c
+++ b/drivers/mfd/db8500-prcmu.c
@@ -898,7 +898,7 @@ void db8500_prcmu_get_abb_event_buffer(void __iomem **buf)
  * @opp: The new ARM operating point to which transition is to be made
  * Returns: 0 on success, non-zero on failure
  *
- * This function sets the the operating point of the ARM.
+ * This function sets the operating point of the ARM.
  */
 int db8500_prcmu_set_arm_opp(u8 opp)
 {
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 913de07..6482a9c 100644
--- a/drivers/misc/sgi-gru/grukservices.c
+++ b/drivers/misc/sgi-gru/grukservices.c
@@ -48,7 +48,7 @@
  * kernel/user requirements.
  *
  * Blade percpu resources reserved for kernel use. These resources are
- * reserved whenever the the kernel context for the blade is loaded. Note
+ * reserved whenever the kernel context for the blade is loaded. Note
  * that the kernel context is not guaranteed to be always available. It is
  * loaded on demand & can be stolen by a user if the user demand exceeds the
  * kernel demand. The kernel can always reload the kernel context but
diff --git a/drivers/misc/sgi-xp/xpc_uv.c b/drivers/misc/sgi-xp/xpc_uv.c
index b9e2000..a90b408 100644
--- a/drivers/misc/sgi-xp/xpc_uv.c
+++ b/drivers/misc/sgi-xp/xpc_uv.c
@@ -1594,7 +1594,7 @@ out_2:
 		 * by xpc_notify_senders_of_disconnect_uv(), and to also get an
 		 * error returned here will confuse them. Additionally, since
 		 * in this case the channel is being disconnected we don't need
-		 * to put the the msg_slot back on the free list.
+		 * to put the msg_slot back on the free list.
 		 */
 		if (cmpxchg(&msg_slot->func, func, NULL) != func) {
 			ret = xpSuccess;
diff --git a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
index 59ab069..c7e69c0 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -965,7 +965,7 @@ static uint8_t gpmi_read_byte(struct mtd_info *mtd)
 /*
  * Handles block mark swapping.
  * It can be called in swapping the block mark, or swapping it back,
- * because the the operations are the same.
+ * because the operations are the same.
  */
 static void block_mark_swapping(struct gpmi_nand_data *this,
 				void *payload, void *auxiliary)
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 8ea6297..86cabd9 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -253,7 +253,7 @@ struct ubi_fm_pool {
 
 /**
  * struct ubi_volume - UBI volume description data structure.
- * @dev: device object to make use of the the Linux device model
+ * @dev: device object to make use of the Linux device model
  * @cdev: character device object to create character device
  * @ubi: reference to the UBI device description object
  * @vol_id: volume ID
@@ -381,7 +381,7 @@ struct ubi_debug_info {
 
 /**
  * struct ubi_device - UBI device description structure
- * @dev: UBI device object to use the the Linux device model
+ * @dev: UBI device object to use for the Linux device model
  * @cdev: character device object to create character device
  * @ubi_num: UBI device number
  * @ubi_name: UBI device name
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 5df49d3..3f28964 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -726,7 +726,7 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
 /**
  * sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
- * @e: the the physical eraseblock to erase
+ * @e: the physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
  *
  * This function returns zero in case of success and a negative error code in
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 78d6d6b..9fe8a88 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1235,7 +1235,7 @@ static int xgmac_rx(struct xgmac_priv *priv, int limit)
  *  @budget : maximum number of packets that the current CPU can receive from
  *	      all interfaces.
  *  Description :
- *   This function implements the the reception process.
+ *   This function implements the reception process.
  *   Also it runs the TX completion thread
  */
 static int xgmac_poll(struct napi_struct *napi, int budget)
diff --git a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
index 4cbb2f9..065da74 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/t4_hw.c
@@ -2467,7 +2467,7 @@ int t4_fwaddrspace_write(struct adapter *adap, unsigned int mbox,
  *     @data: len bytes to hold the data read
  *     @len: amount of data to read from window.  Must be <=
  *            MEMWIN0_APERATURE after adjusting for 16B for T4 and
- *            128B for T5 alignment requirements of the the memory window.
+ *            128B for T5 alignment requirements of the memory window.
  *
  *     Read len bytes of data from MC starting at @addr.
  */
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 3224d28..a6cd241 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2128,7 +2128,7 @@ static irqreturn_t be_intx(int irq, void *dev)
 	}
 	be_eq_notify(adapter, eqo->q.id, false, true, num_evts);
 
-	/* Return IRQ_HANDLED only for the the first spurious intr
+	/* Return IRQ_HANDLED only for the first spurious intr
 	 * after a valid intr to stop the kernel from branding
 	 * this irq as a bad one!
 	 */
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 2879b96..0c988a2 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -4068,7 +4068,7 @@ static s32 e1000_do_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words,
  * @hw: Struct containing variables accessed by shared code
  *
  * Reads the first 64 16 bit words of the EEPROM and sums the values read.
- * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
+ * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
  * valid.
  */
 s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index af08188..8c618fc 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3533,7 +3533,7 @@ static s32 e1000_id_led_init_pchlan(struct e1000_hw *hw)
  *  @hw: pointer to the HW structure
  *
  *  ICH8 use the PCI Express bus, but does not contain a PCI Express Capability
- *  register, so the the bus width is hard coded.
+ *  register, so the bus width is hard coded.
  **/
 static s32 e1000_get_bus_info_ich8lan(struct e1000_hw *hw)
 {
diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 79b5835..f0b546a 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2079,7 +2079,7 @@ out:
  *  igb_reset_mdicnfg_82580 - Reset MDICNFG destination and com_mdio bits
  *  @hw: pointer to the HW structure
  *
- *  This resets the the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
+ *  This resets the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
  *  the values found in the EEPROM.  This addresses an issue in which these
  *  bits are not restored from EEPROM after reset.
  **/
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7aba452..1274e65 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -224,7 +224,7 @@ static void ixgbe_check_minimum_link(struct ixgbe_adapter *adapter,
 	enum pcie_link_width width = PCIE_LNK_WIDTH_UNKNOWN;
 	struct pci_dev *pdev;
 
-	/* determine whether to use the the parent device
+	/* determine whether to use the parent device
 	 */
 	if (ixgbe_pcie_from_parent(&adapter->hw))
 		pdev = adapter->pdev->bus->parent->self;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index 51b0094..bc93418 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2167,7 +2167,7 @@ static int verify_xena_quiescence(struct s2io_nic *sp)
 
 	/*
 	 * In PCI 33 mode, the P_PLL is not used, and therefore,
-	 * the the P_PLL_LOCK bit in the adapter_status register will
+	 * the P_PLL_LOCK bit in the adapter_status register will
 	 * not be asserted.
 	 */
 	if (!(val64 & ADAPTER_STATUS_P_PLL_LOCK) &&
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 64b4639..39fe59d 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
@@ -83,7 +83,7 @@ static int axienet_mdio_read(struct mii_bus *bus, int phy_id, int reg)
  * returns:	0 on success, -ETIMEDOUT on a timeout
  *
  * Writes the value to the requested register by first writing the value
- * into MWD register. The the MCR register is then appropriately setup
+ * into MWD register. The MCR register is then appropriately setup
  * to finish the write operation.
  */
 static int axienet_mdio_write(struct mii_bus *bus, int phy_id, int reg,
diff --git a/drivers/net/wimax/i2400m/i2400m.h b/drivers/net/wimax/i2400m/i2400m.h
index 79c6505..d773204 100644
--- a/drivers/net/wimax/i2400m/i2400m.h
+++ b/drivers/net/wimax/i2400m/i2400m.h
@@ -250,14 +250,14 @@ struct i2400m_barker_db;
  *
  * @bus_setup: [optional fill] Function called by the bus-generic code
  *     [i2400m_setup()] to setup the basic bus-specific communications
- *     to the the device needed to load firmware. See LIFE CYCLE above.
+ *     to the device needed to load firmware. See LIFE CYCLE above.
  *
  *     NOTE: Doesn't need to upload the firmware, as that is taken
  *     care of by the bus-generic code.
  *
  * @bus_release: [optional fill] Function called by the bus-generic
  *     code [i2400m_release()] to shutdown the basic bus-specific
- *     communications to the the device needed to load firmware. See
+ *     communications to the device needed to load firmware. See
  *     LIFE CYCLE above.
  *
  *     This function does not need to reset the device, just tear down
diff --git a/drivers/net/wimax/i2400m/rx.c b/drivers/net/wimax/i2400m/rx.c
index 0b60295..4466ee7 100644
--- a/drivers/net/wimax/i2400m/rx.c
+++ b/drivers/net/wimax/i2400m/rx.c
@@ -693,7 +693,7 @@ void __i2400m_roq_queue(struct i2400m *i2400m, struct i2400m_roq *roq,
 	 * right spot where to insert the packet; we know the queue is
 	 * not empty, so we are not the first ones; we also know we
 	 * are not going to be the last ones. The list is sorted, so
-	 * we have to insert before the the first guy with an nsn_itr
+	 * we have to insert before the first guy with an nsn_itr
 	 * greater that our nsn. */
 	skb_queue_walk(&roq->queue, skb_itr) {
 		roq_data_itr = (struct i2400m_roq_data *) &skb_itr->cb;
diff --git a/drivers/net/wimax/i2400m/tx.c b/drivers/net/wimax/i2400m/tx.c
index f20886a..1f7b2b9 100644
--- a/drivers/net/wimax/i2400m/tx.c
+++ b/drivers/net/wimax/i2400m/tx.c
@@ -233,7 +233,7 @@
  *    i2400m_tx_skip_tail()     Marks unusable FIFO tail space
  *    i2400m->bus_tx_kick()
  *
- * Now i2400m->bus_tx_kick() is the the bus-specific driver backend
+ * Now i2400m->bus_tx_kick() is the bus-specific driver backend
  * implementation; that would do:
  *
  * i2400m->bus_tx_kick()
diff --git a/drivers/net/wireless/ath/ath10k/rx_desc.h b/drivers/net/wireless/ath/ath10k/rx_desc.h
index bfec6c8..e43a5a8 100644
--- a/drivers/net/wireless/ath/ath10k/rx_desc.h
+++ b/drivers/net/wireless/ath/ath10k/rx_desc.h
@@ -77,7 +77,7 @@ struct rx_attention {
  *		first_msdu is set.
  *
  * peer_idx_invalid
- *		Indicates no matching entries within the the max search
+ *		Indicates no matching entries within the max search
  *		count.  Only set when first_msdu is set.
  *
  * peer_idx_timeout
diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index 61f6b21..cb15404 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -98,7 +98,7 @@ struct bus_request {
  *     emode - This indicates the whether the command is to be executed in a
  *             blocking or non-blocking fashion (HIF_SYNCHRONOUS/
  *             HIF_ASYNCHRONOUS). The read/write data paths in HTC have been
- *             implemented using the asynchronous mode allowing the the bus
+ *             implemented using the asynchronous mode allowing the bus
  *             driver to indicate the completion of operation through the
  *             registered callback routine. The requirement primarily comes
  *             from the contexts these operations get called from (a driver's
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 7126bdd..f382798 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1176,7 +1176,7 @@ static int ath6kl_sdio_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
 	 *        Wait for first 4 bytes to be in FIFO
 	 *        If CONSERVATIVE_BMI_READ is enabled, also wait for
 	 *        a BMI command credit, which indicates that the ENTIRE
-	 *        response is available in the the FIFO
+	 *        response is available in the FIFO
 	 *
 	 *  CASE 3: length > 128
 	 *        Wait for the first 4 bytes to be in FIFO
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 1fc1fa9..700e308 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -638,7 +638,7 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN,
 			    AR_PHY_SPECTRAL_SCAN_SHORT_REPEAT);
 
-	/* on AR92xx, the highest bit of count will make the the chip send
+	/* on AR92xx, the highest bit of count will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index e897648..c973a79 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1615,7 +1615,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 4608e0e..e34b184 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -3819,7 +3819,7 @@ static void brcms_b_set_shortslot(struct brcms_hardware *wlc_hw, bool shortslot)
 }
 
 /*
- * Suspend the the MAC and update the slot timing
+ * Suspend the MAC and update the slot timing
  * for standard 11b/g (20us slots) or shortslot 11g (9us slots).
  */
 static void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
index d606197..c03e73f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -194,7 +194,7 @@ enum iwl_tx_flags {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @key: security key
  * @next_frame_flags: TX_CMD_SEC_* and TX_CMD_NEXT_FRAME_*
@@ -545,7 +545,7 @@ struct iwl_beacon_notif {
 
 /**
  * enum iwl_dump_control - dump (flush) control flags
- * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
+ * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the FIFO is empty
  *	and the TFD queues are empty.
  */
 enum iwl_dump_control {
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index a8652dd..89061e0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
@@ -65,7 +65,7 @@
 #include "fw-api.h"
 #include "mvm.h"
 
-/* Maps the driver specific channel width definition to the the fw values */
+/* Maps the driver specific channel width definition to the fw values */
 static inline u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 {
 	switch (chandef->width) {
@@ -86,7 +86,7 @@ static inline u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 static inline u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 865d3f6..04f8ffb 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1737,7 +1737,7 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
  * of_alias_scan - Scan all properties of 'aliases' node
  *
  * The function scans all the properties of 'aliases' node and populate
- * the the global lookup table with the properties.  It returns the
+ * the global lookup table with the properties.  It returns the
  * number of alias_prop found, or error code in error case.
  *
  * @dt_alloc:	An allocator that provides a virtual address to memory
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index f6488ad..0426b66 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -36,7 +36,7 @@
  *    when the bridge is scanned and it loses a refcount when the bridge
  *    is removed.
  *  - When a P2P bridge is present, we elevate the refcount on the subordinate
- *    bus. It loses the refcount when the the driver unloads.
+ *    bus. It loses the refcount when the driver unloads.
  */
 
 #include <linux/init.h>
diff --git a/drivers/pcmcia/pxa2xx_hx4700.c b/drivers/pcmcia/pxa2xx_hx4700.c
index 7dfef3e..40511e3 100644
--- a/drivers/pcmcia/pxa2xx_hx4700.c
+++ b/drivers/pcmcia/pxa2xx_hx4700.c
@@ -33,7 +33,7 @@ static int hx4700_pcmcia_hw_init(struct soc_pcmcia_socket *skt)
 	/*
 	 * IRQ type must be set before soc_pcmcia_hw_init() calls request_irq().
 	 * The asic3 default IRQ type is level trigger low level detect, exactly
-	 * the the signal present on GPIOD4_CF_nCD when a CF card is inserted.
+	 * the signal present on GPIOD4_CF_nCD when a CF card is inserted.
 	 * If the IRQ type is not changed, the asic3 interrupt handler will loop
 	 * repeatedly because it is unable to clear the level trigger interrupt.
 	 */
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 44420d1..aa6d52e 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -294,8 +294,9 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 
 		ret = power_supply_show_property(dev, attr, prop_buf);
 		if (ret == -ENODEV || ret == -ENODATA) {
-			/* When a battery is absent, we expect -ENODEV. Don't abort;
-			   send the uevent with at least the the PRESENT=0 property */
+			/* When a battery is absent, we expect -ENODEV.
+			 * Don't abort; send the uevent with at least
+			 * the PRESENT=0 property */
 			ret = 0;
 			continue;
 		}
diff --git a/drivers/rtc/rtc-rs5c372.c b/drivers/rtc/rtc-rs5c372.c
index ccf54f0..2108302 100644
--- a/drivers/rtc/rtc-rs5c372.c
+++ b/drivers/rtc/rtc-rs5c372.c
@@ -122,7 +122,7 @@ static int rs5c_get_regs(struct rs5c372 *rs5c)
 	 * least 80219 chips; this works around that bug.
 	 *
 	 * The third method on the other hand doesn't work for the SMBus-only
-	 * configurations, so we use the the first method there, stripping off
+	 * configurations, so we use the first method there, stripping off
 	 * the extra register in the process.
 	 */
 	if (rs5c->smbus) {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 0a328d0..8f4b19f 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3374,7 +3374,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			if (!atomic_read(&queue->set_pci_flags_count)) {
 				/*
 				 * there's no outstanding PCI any more, so we
-				 * have to request a PCI to be sure the the PCI
+				 * have to request a PCI to be sure that the PCI
 				 * will wake at some time in the future then we
 				 * can flush packed buffers that might still be
 				 * hanging around, which can happen if no
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 2035b0d..e62a734 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -1983,7 +1983,7 @@ bfa_fcs_rport_gidpn_response(void *fcsarg, struct bfa_fcxp_s *fcxp, void *cbarg,
 			/*
 			 * Device's PID has changed. We need to cleanup
 			 * and re-login. If there is another device with
-			 * the the newly discovered pid, send an scn notice
+			 * the newly discovered pid, send an scn notice
 			 * so that its new pid can be discovered.
 			 */
 			list_for_each(qe, &rport->port->rport_q) {
diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index 07453bb..b02b9e5 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -509,7 +509,7 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
  * @skb:      The receive skb
  * @netdev:   The associated net device
  * @ptype:    The packet_type structure which was used to register this handler
- * @orig_dev: The original net_device the the skb was received on.
+ * @orig_dev: The original net_device that the skb was received on.
  *	      (in case dev is a bond)
  *
  * Returns: 0 for success
@@ -2709,7 +2709,7 @@ module_exit(fcoe_exit);
  * fcoe_flogi_resp() - FCoE specific FLOGI and FDISC response handler
  * @seq: active sequence in the FLOGI or FDISC exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc FLOGI response handler.
@@ -2738,7 +2738,7 @@ done:
  * fcoe_logo_resp() - FCoE specific LOGO response handler
  * @seq: active sequence in the LOGO exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc LOGO response handler.
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 203415e..3bd4e86 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -193,7 +193,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 	 * that doesn't have a priv (fcf was deleted). However,
 	 * libfcoe will always delete FCFs before trying to add
 	 * them. This is ensured because both recv_adv and
-	 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+	 * age_fcfs are protected by the fcoe_ctlr's mutex.
 	 * This means that we should never get a FCF with a
 	 * non-NULL priv pointer.
 	 */
@@ -655,7 +655,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
- * The the skb must also be an fc_frame.
+ * The skb must also be an fc_frame.
  *
  * This is called from the lower-level driver with spinlocks held,
  * so we must not take a mutex here.
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 4911310..cc2b2c0 100644
--- a/drivers/scsi/isci/host.h
+++ b/drivers/scsi/isci/host.h
@@ -244,7 +244,7 @@ enum sci_controller_states {
 	SCIC_INITIALIZED,
 
 	/**
-	 * This state indicates the the controller is in the process of becoming
+	 * This state indicates that the controller is in the process of becoming
 	 * ready (i.e. starting).  In this state no new IO operations are permitted.
 	 * This state is entered from the INITIALIZED state.
 	 */
diff --git a/drivers/scsi/isci/remote_device.h b/drivers/scsi/isci/remote_device.h
index 47a013f..07af745 100644
--- a/drivers/scsi/isci/remote_device.h
+++ b/drivers/scsi/isci/remote_device.h
@@ -198,7 +198,7 @@ enum sci_status sci_remote_device_reset_complete(
  * permitted.  This state is entered from the INITIAL state.  This state
  * is entered from the STOPPING state.
  *
- * @SCI_DEV_STARTING: This state indicates the the remote device is in
+ * @SCI_DEV_STARTING: This state indicates that the remote device is in
  * the process of becoming ready (i.e. starting).  In this state no new
  * IO operations are permitted.  This state is entered from the STOPPED
  * state.
diff --git a/drivers/scsi/isci/remote_node_context.h b/drivers/scsi/isci/remote_node_context.h
index c7ee81d..f22950b 100644
--- a/drivers/scsi/isci/remote_node_context.h
+++ b/drivers/scsi/isci/remote_node_context.h
@@ -154,7 +154,7 @@ enum sci_remote_node_context_destination_state {
 /**
  * struct sci_remote_node_context - This structure contains the data
  *    associated with the remote node context object.  The remote node context
- *    (RNC) object models the the remote device information necessary to manage
+ *    (RNC) object models the remote device information necessary to manage
  *    the silicon RNC.
  */
 struct sci_remote_node_context {
diff --git a/drivers/scsi/isci/task.c b/drivers/scsi/isci/task.c
index 0d30ca8..63da523 100644
--- a/drivers/scsi/isci/task.c
+++ b/drivers/scsi/isci/task.c
@@ -67,7 +67,7 @@
 /**
 * isci_task_refuse() - complete the request to the upper layer driver in
 *     the case where an I/O needs to be completed back in the submit path.
-* @ihost: host on which the the request was queued
+* @ihost: host on which the request was queued
 * @task: request to complete
 * @response: response code for the completed task.
 * @status: status code for the completed task.
diff --git a/drivers/scsi/lpfc/lpfc_attr.c b/drivers/scsi/lpfc/lpfc_attr.c
index 16498e0..e5803a6 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1654,7 +1654,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * takes a default argument, a minimum and maximum argument.
  *
  * lpfc_##attr##_init: Initializes an attribute.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Validates the min and max values then sets the adapter config field
@@ -1687,7 +1687,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
  * into a function with the name lpfc_hba_queue_depth_set
  *
  * lpfc_##attr##_set: Sets an attribute value.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Description:
@@ -1820,7 +1820,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * lpfc_##attr##_init: validates the min and max values then sets the
  * adapter config field accordingly, or uses the default if out of range
  * and prints an error message.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Returns:
@@ -1852,7 +1852,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
  * lpfc_##attr##_set: validates the min and max values then sets the
  * adapter config field if in the valid range. prints error message
  * and does not set the parameter if invalid.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val:	integer attribute value.
  *
  * Returns:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 110445f..1ced982 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5783,7 +5783,7 @@ reject_out:
  * @rrq: Pointer to the rrq struct.
  *
  * Build a ELS RRQ command and send it to the target. If the issue_iocb is
- * Successful the the completion handler will clear the RRQ.
+ * successful, the completion handler will clear the RRQ.
  *
  * Return codes
  *   0 - Successfully sent rrq els iocb.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 60d6ca2..4f09f33 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2014,7 +2014,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the the round robin slection for the particular priority level
+ * flag so that the round robin selection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
@@ -5692,7 +5692,7 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 }
 
 /* This routine decrements the reference count for a ndlp structure. If the
- * count goes to 0, this indicates the the associated nodelist should be
+ * count goes to 0, this indicates that the associated nodelist should be
  * freed. Returning 1 indicates the ndlp resource has been released; on the
  * other hand, returning 0 indicates the ndlp resource has not been released
  * yet.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 501147c..1eb3e98 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3783,7 +3783,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	bf_set(lpfc_mbx_read_top_link_spd, la,
 	       lpfc_sli4_parse_latt_link_speed(phba, acqe_link));
 
-	/* Fake the the following irrelvant fields */
+	/* Fake the following irrelevant fields */
 	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
 	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
 	bf_set(lpfc_mbx_read_top_il, la, 0);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1f292e2..d9a9ddb 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -2265,7 +2265,7 @@ lpfc_sli4_dump_cfg_rg23(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
  * information via a READ_FCF mailbox command. This mailbox command also is used
  * to indicate where received unsolicited frames from this FCF will be sent. By
  * default this routine will set up the FCF to forward all unsolicited frames
- * the the RQ ID passed in the @phba. This can be overridden by the caller for
+ * that the RQ ID passed in the @phba. This can be overridden by the caller for
  * more complicated setups.
  **/
 void
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 0392e11..5cb256d 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16185,7 +16185,7 @@ out:
  * the offset after the write object mailbox has completed. @size is used to
  * determine the end of the object and whether the eof bit should be set.
  *
- * Return 0 is successful and offset will contain the the new offset to use
+ * Return 0 is successful and offset will contain the new offset to use
  * for the next write.
  * Return negative value for error cases.
  **/
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 4a21957..90cc9b4 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3204,7 +3204,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
  *
  * when HBA driver received the identify done event or initiate FIS received
  * event(for SATA), it will invoke this function to notify the sas layer that
- * the sas toplogy has formed, please discover the the whole sas domain,
+ * the sas toplogy has formed, please discover the whole sas domain,
  * while receive a broadcast(change) primitive just tell the sas
  * layer to discover the changed domain rather than the whole domain.
  */
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 0ee53c2..d79aab1 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -353,7 +353,7 @@ static void spi_ppc4xx_enable(struct ppc4xx_spi *hw)
 {
 	/*
 	 * On all 4xx PPC's the SPI bus is shared/multiplexed with
-	 * the 2nd I2C bus. We need to enable the the SPI bus before
+	 * the 2nd I2C bus. We need to enable the SPI bus before
 	 * using it.
 	 */
 
diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
index cbe3451..98161a5 100644
--- a/drivers/staging/android/binder.h
+++ b/drivers/staging/android/binder.h
@@ -246,7 +246,7 @@ enum binder_driver_return_protocol {
 
 	BR_FAILED_REPLY = _IO('r', 17),
 	/*
-	 * The the last transaction (either a bcTRANSACTION or
+	 * The last transaction (either a bcTRANSACTION or
 	 * a bcATTEMPT_ACQUIRE) failed (e.g. out of memory).  No parameters.
 	 */
 };
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index f73e58f..55d41ab 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1242,7 +1242,7 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	/* Initialize the Space Available Register */
 	writel(0, &rxmac->space_avail);
 
-	/* Initialize the the mif_ctrl register
+	/* Initialize the mif_ctrl register
 	 * bit 3:  Receive code error. One or more nibbles were signaled as
 	 *	   errors  during the reception of the packet.  Clear this
 	 *	   bit in Gigabit, set it in 100Mbit.  This was derived
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 253f026..e53b57a 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -318,7 +318,7 @@ int ll_file_release(struct inode *inode, struct file *file)
 	fd = LUSTRE_FPRIVATE(file);
 	LASSERT(fd != NULL);
 
-	/* The last ref on @file, maybe not the the owner pid of statahead.
+	/* The last ref on @file, maybe not the owner pid of statahead.
 	 * Different processes can open the same dir, "ll_opendir_key" means:
 	 * it is me that should stop the statahead thread. */
 	if (S_ISDIR(inode->i_mode) && lli->lli_opendir_key == fd &&
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 227a0ae..c30abe1 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -507,7 +507,7 @@ struct timeout_item* ptlrpc_new_timeout(int time, enum timeout_event event,
 }
 
 /**
- * Register timeout event on the the pinger thread.
+ * Register timeout event on the pinger thread.
  * Note: the timeout list is an sorted list with increased timeout value.
  */
 static struct timeout_item*
diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
index 10b2210..89adfb8 100644
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c
@@ -216,7 +216,7 @@ ieee80211_rx_frame_mgmt(struct ieee80211_device *ieee, struct sk_buff *skb,
 {
 	struct ieee80211_hdr_4addr *hdr;
 
-	// cheat the the hdr type
+	/* cheat the hdr type */
 	hdr = (struct ieee80211_hdr_4addr *)skb->data;
 
 	/* On the struct stats definition there is written that
@@ -485,7 +485,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 	struct ieee80211_crypt_data *crypt = NULL;
 	int keyidx = 0;
 
-	// cheat the the hdr type
+	/* cheat the hdr type */
 	hdr = (struct ieee80211_hdr_4addr *)skb->data;
 	stats = &ieee->stats;
 
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 9632ef4..0d1f95d 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -968,7 +968,7 @@ _func_enter_;
 
 	psecnetwork->IELength = 0;
 	/*  Added by Albert 2009/02/18 */
-	/*  If the the driver wants to use the bssid to create the connection. */
+	/*  If the driver wants to use the bssid to create the connection. */
 	/*  If not,  we have to copy the connecting AP's MAC address to it so that */
 	/*  the driver just has the bssid information for PMKIDList searching. */
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 59900bf..0f47b34 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -926,7 +926,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	int i;
 	struct ieee80211_rxb *rxb = NULL;
-	// cheat the the hdr type
+	/* cheat the hdr type */
 	hdr = (struct ieee80211_hdr_4addr *)skb->data;
 	stats = &ieee->stats;
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index f16307f..5b30e7c 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -536,7 +536,7 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 		memcpy(&psecuritypriv->authenticator_ie[1],
 			&psecnetwork->IEs[12], (256-1));
 	psecnetwork->IELength = 0;
-	/* If the the driver wants to use the bssid to create the connection.
+	/* If the driver wants to use the bssid to create the connection.
 	 * If not,  we copy the connecting AP's MAC address to it so that
 	 * the driver just has the bssid information for PMKIDList searching.
 	 */
diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 6a98a20..2571180 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -1209,7 +1209,7 @@ static int sep_lock_user_pages(struct sep_device *sep,
 	int error = 0;
 	u32 count;
 	int result;
-	/* The the page of the end address of the user space buffer */
+	/* The page of the end address of the user space buffer */
 	u32 end_page;
 	/* The page of the start address of the user space buffer */
 	u32 start_page;
@@ -1413,7 +1413,7 @@ static int sep_lli_table_secure_dma(struct sep_device *sep,
 {
 	int error = 0;
 	u32 count;
-	/* The the page of the end address of the user space buffer */
+	/* The page of the end address of the user space buffer */
 	u32 end_page;
 	/* The page of the start address of the user space buffer */
 	u32 start_page;
@@ -1732,7 +1732,7 @@ static void *sep_shared_area_bus_to_virt(struct sep_device *sep,
  * @num_table_entries: number of entries
  * @table_data_size: total data size
  *
- * Walk the the list of the print created tables and print all the data
+ * Walk the list of the print created tables and print all the data
  */
 static void sep_debug_print_lli_tables(struct sep_device *sep,
 	struct sep_lli_entry *lli_table_ptr,
diff --git a/drivers/staging/tidspbridge/include/dspbridge/drv.h b/drivers/staging/tidspbridge/include/dspbridge/drv.h
index b0c7708..ee44aae 100644
--- a/drivers/staging/tidspbridge/include/dspbridge/drv.h
+++ b/drivers/staging/tidspbridge/include/dspbridge/drv.h
@@ -253,7 +253,7 @@ extern int drv_get_dev_object(u32 index,
 /*
  *  ======== drv_get_next_dev_object ========
  *  Purpose:
- *      Returns the Ptr to the Next Device Object from the the List
+ *      Returns the Ptr to the Next Device Object from the List
  *  Parameters:
  *      hdev_obj:     Handle to the Device Object
  *  Requires:
@@ -269,7 +269,7 @@ extern u32 drv_get_next_dev_object(u32 hdev_obj);
 /*
  *  ======== drv_get_next_dev_extension ========
  *  Purpose:
- *      Returns the Ptr to the Next Device Extension from the the List
+ *      Returns the Ptr to the Next Device Extension from the List
  *  Parameters:
  *      dev_extension:      Handle to the Device Extension
  *  Requires:
diff --git a/drivers/staging/tidspbridge/pmgr/dev.c b/drivers/staging/tidspbridge/pmgr/dev.c
index 6234ffb..408bb6b 100644
--- a/drivers/staging/tidspbridge/pmgr/dev.c
+++ b/drivers/staging/tidspbridge/pmgr/dev.c
@@ -897,7 +897,7 @@ int dev_get_dev_type(struct dev_object *dev_obj, u8 *dev_type)
  *
  *      1. All Bridge function pointers which are NULL; and
  *      2. All function slots in the struct dev_object structure which have no
- *         corresponding slots in the the Bridge's interface, because the Bridge
+ *         corresponding slots in the Bridge's interface, because the Bridge
  *         is of an *older* version.
  *  Parameters:
  *      intf_fxns:      Interface fxn Structure of the Bridge's Dev Object.
diff --git a/drivers/staging/wlags49_h2/README.wlags49 b/drivers/staging/wlags49_h2/README.wlags49
index f65acd6..368a22b 100644
--- a/drivers/staging/wlags49_h2/README.wlags49
+++ b/drivers/staging/wlags49_h2/README.wlags49
@@ -396,7 +396,7 @@ Version 7.22 abg - July 28, 2004
     TxKey=1
 
     this configures eth1 to associate to the ESSID 'some_network' with
-    encryption on, where the the first encryption key is 'net01' and the key to
+    encryption on, where the first encryption key is 'net01' and the key to
     use for encryption is Key 1.
 
     Note that this only works on Agere hardware which uses this driver. For
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index cbe48ab..c1392223 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -331,7 +331,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		} else {
 			/*
 			 * Extact the RELATIVE TARGET PORT IDENTIFIER to identify
-			 * the Target Port in question for the the incoming
+			 * the Target Port in question for the incoming
 			 * SET_TARGET_PORT_GROUPS op.
 			 */
 			rtpi = get_unaligned_be16(ptr + 2);
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 558605d..b69b337 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -263,7 +263,7 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 		/*
 		 * Mike Isely <isely@pobox.com> 2-Feb-2008: The
 		 * Cypress app note that describes this mechanism
-		 * states the the low-speed part can't handle more
+		 * states that the low-speed part can't handle more
 		 * than 800 bytes/sec, in which case 4800 baud is the
 		 * safest speed for a part like that.
 		 */
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index 84657e0..a107e37 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -432,7 +432,7 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 }
 
 /*
- * This is the the common top part of all parallel port callback operations that
+ * This is the common top part of all parallel port callback operations that
  * send synchronous messages to the device.  This implements convoluted locking
  * that avoids two scenarios: (1) a port operation is called after usbserial
  * has called our release function, at which point struct mos7715_parport has
@@ -471,7 +471,7 @@ static int parport_prologue(struct parport *pp)
 }
 
 /*
- * This is the the common bottom part of all parallel port functions that send
+ * This is the common bottom part of all parallel port functions that send
  * synchronous messages to the device.
  */
 static inline void parport_epilogue(struct parport *pp)
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 33a1278..b2aa189 100644
--- a/drivers/usb/wusbcore/devconnect.c
+++ b/drivers/usb/wusbcore/devconnect.c
@@ -46,7 +46,7 @@
  *
  * ASSUMPTIONS:
  *
- *  - We use the the as device address the port number where it is
+ *  - We use as device address the port number where it is
  *    connected (port 0 doesn't exist). For unauth, it is 128 + that.
  *
  * ROADMAP:
diff --git a/drivers/uwb/drp-ie.c b/drivers/uwb/drp-ie.c
index b7d4f6b..caa4cb4 100644
--- a/drivers/uwb/drp-ie.c
+++ b/drivers/uwb/drp-ie.c
@@ -262,7 +262,7 @@ int uwb_drp_ie_update(struct uwb_rsv *rsv)
  * We are given a zone id and the MAS bitmap of bits that need to be set in
  * this zone. Note that this zone may already have bits set and this only
  * adds settings - we cannot simply assign the MAS bitmap contents to the
- * zone contents. We iterate over the the bits (MAS) in the zone and set the
+ * zone contents. We iterate over the bits (MAS) in the zone and set the
  * bits that are set in the given MAS bitmap.
  */
 static
diff --git a/drivers/video/omap/sossi.c b/drivers/video/omap/sossi.c
index d4e7684..501bc08 100644
--- a/drivers/video/omap/sossi.c
+++ b/drivers/video/omap/sossi.c
@@ -370,7 +370,7 @@ static void sossi_set_bits_per_cycle(int bpc)
 	int bus_pick_count, bus_pick_width;
 
 	/*
-	 * We set explicitly the the bus_pick_count as well, although
+	 * We set explicitly the bus_pick_count as well, although
 	 * with remapping/reordering disabled it will be calculated by HW
 	 * as (32 / bus_pick_width).
 	 */
diff --git a/drivers/video/sis/sis_accel.c b/drivers/video/sis/sis_accel.c
index ceb434c..9177b80 100644
--- a/drivers/video/sis/sis_accel.c
+++ b/drivers/video/sis/sis_accel.c
@@ -215,7 +215,7 @@ SiS310SubsequentScreenToScreenCopy(struct sis_video_info *ivideo, int src_x, int
 	 * and destination blitting areas overlap and
 	 * adapt the bitmap addresses synchronously
 	 * if the coordinates exceed the valid range.
-	 * The the areas do not overlap, we do our
+	 * If the areas do not overlap, we do our
 	 * normal check.
 	 */
 	if((mymax - mymin) < height) {
diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
index 0f00da3..6a646a0 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -492,7 +492,7 @@ static int autofs_dev_ioctl_askumount(struct file *fp,
  * located path is the root of a mount we return 1 along with
  * the super magic of the mount or 0 otherwise.
  *
- * In both cases the the device number (as returned by
+ * In both cases the device number (as returned by
  * new_encode_dev()) is also returned.
  */
 static int autofs_dev_ioctl_ismountpoint(struct file *fp,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index 5f8f334..cac9a70 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -810,7 +810,7 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 		 * something that can happen if the dev_replace
 		 * procedure is suspended by an umount and then
 		 * the tgtdev is missing (or "btrfs dev scan") was
-		 * not called and the the filesystem is remounted
+		 * not called and the filesystem is remounted
 		 * in degraded state. This does not stop the
 		 * dev_replace procedure. It needs to be canceled
 		 * manually if the cancelation is wanted.
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 2e14fd8..6628d43 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -2789,7 +2789,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		/*
 		 * We may have refs where the parent directory does not exist
 		 * yet. This happens if the parent directories inum is higher
-		 * the the current inum. To handle this case, we create the
+		 * than the current inum. To handle this case, we create the
 		 * parent directory out of order. But we need to check if this
 		 * did already happen before due to other refs in the same dir.
 		 */
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index ff60d89..203092b 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2522,7 +2522,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
-	 * nobody else is going to jump in and write the the ctree
+	 * nobody else is going to jump in and write the ctree
 	 * super here because the log_commit atomic below is protecting
 	 * us.  We must be called with a transaction handle pinning
 	 * the running transaction open, so a full commit can't hop
diff --git a/fs/dcache.c b/fs/dcache.c
index 4d9df3c..fab316e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1824,8 +1824,8 @@ EXPORT_SYMBOL(d_splice_alias);
  * same inode, only the actual correct case is stored in the dcache for
  * case-insensitive filesystems.
  *
- * For a case-insensitive lookup match and if the the case-exact dentry
- * already exists in in the dcache, use it and return it.
+ * For a case-insensitive lookup match and if the case-exact dentry
+ * already exists in the dcache, use it and return it.
  *
  * If no entry exists with the exact case name, allocate new dentry with
  * the exact case, and return the spliced entry.
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 7d52806..080ad57 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -900,7 +900,7 @@ struct ecryptfs_parse_tag_70_packet_silly_stack {
  * @filename: This function kmalloc's the memory for the filename
  * @filename_size: This function sets this to the amount of memory
  *                 kmalloc'd for the filename
- * @packet_size: This function sets this to the the number of octets
+ * @packet_size: This function sets this to the number of octets
  *               in the packet parsed
  * @mount_crypt_stat: The mount-wide cryptographic context
  * @data: The memory location containing the start of the tag 70
diff --git a/fs/ext2/ext2.h b/fs/ext2/ext2.h
index d9a17d0..c9c6f2e 100644
--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -51,7 +51,7 @@ struct ext2_block_alloc_info {
 	/*
 	 * Was i_next_alloc_goal in ext2_inode_info
 	 * is the *physical* companion to i_next_alloc_block.
-	 * it the the physical block number of the block which was most-recentl
+	 * it is the physical block number of the block which was most-recently
 	 * allocated to this file.  This give us the goal (target) for the next
 	 * allocation when we detect linearly ascending requests.
 	 */
diff --git a/fs/ext4/inline.c b/fs/ext4/inline.c
index d9ecbf1..1ff32c5 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -276,7 +276,7 @@ static int ext4_create_inline_data(handle_t *handle,
 		len = 0;
 	}
 
-	/* Insert the the xttr entry. */
+	/* Insert the xttr entry. */
 	i.value = value;
 	i.value_len = len;
 
@@ -832,7 +832,7 @@ out:
 
 /*
  * Prepare the write for the inline data.
- * If the the data can be written into the inode, we just read
+ * If the data can be written into the inode, we just read
  * the page and make it uptodate, and start the journal.
  * Otherwise read the page, makes it dirty so that it can be
  * handle in writepages(the i_disksize update is left to the
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index bdd10ea..8926ba8 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -153,7 +153,7 @@ struct seg_entry {
 	unsigned short valid_blocks;	/* # of valid blocks */
 	unsigned char *cur_valid_map;	/* validity bitmap of blocks */
 	/*
-	 * # of valid blocks and the validity bitmap stored in the the last
+	 * # of valid blocks and the validity bitmap stored in the last
 	 * checkpoint pack. This information is used by the SSR mode.
 	 */
 	unsigned short ckpt_valid_blocks;
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index cd5496b..dd27d2b 100644
--- a/fs/ocfs2/localalloc.c
+++ b/fs/ocfs2/localalloc.c
@@ -690,7 +690,7 @@ int ocfs2_reserve_local_alloc_bits(struct ocfs2_super *osb,
 		/*
 		 * Under certain conditions, the window slide code
 		 * might have reduced the number of bits available or
-		 * disabled the the local alloc entirely. Re-check
+		 * disabled the local alloc entirely. Re-check
 		 * here and return -ENOSPC if necessary.
 		 */
 		status = -ENOSPC;
diff --git a/fs/xfs/xfs_export.c b/fs/xfs/xfs_export.c
index 066df42..1230796 100644
--- a/fs/xfs/xfs_export.c
+++ b/fs/xfs/xfs_export.c
@@ -71,7 +71,7 @@ xfs_fs_encode_fh(
 		fileid_type = FILEID_INO32_GEN_PARENT;
 
 	/*
-	 * If the the filesystem may contain 64bit inode numbers, we need
+	 * If the filesystem may contain 64bit inode numbers, we need
 	 * to use larger file handles that can represent them.
 	 *
 	 * While we only allocate inodes that do not fit into 32 bits any
diff --git a/include/drm/drm_rect.h b/include/drm/drm_rect.h
index d128629..1f6d6c3 100644
--- a/include/drm/drm_rect.h
+++ b/include/drm/drm_rect.h
@@ -120,7 +120,7 @@ static inline int drm_rect_height(const struct drm_rect *r)
 }
 
 /**
- * drm_rect_visible - determine if the the rectangle is visible
+ * drm_rect_visible - determine if the rectangle is visible
  * @r: rectangle whose visibility is returned
  *
  * RETURNS:
diff --git a/include/linux/mm.h b/include/linux/mm.h
index caf543c..f288632 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -178,7 +178,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_TRIED	0x40	/* second try */
 
 /*
- * vm_fault is filled by the the pagefault handler and passed to the vma's
+ * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index c3eb102..cf956c9 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -94,7 +94,7 @@ struct kparam_array
  * ".") the kernel commandline parameter.  Note that - is changed to _, so
  * the user can use "foo-bar=1" even for variable "foo_bar".
  *
- * @perm is 0 if the the variable is not to appear in sysfs, or 0444
+ * @perm is 0 if the variable is not to appear in sysfs, or 0444
  * for world-readable, 0644 for root-writable, etc.  Note that if it
  * is writable, you may need to use kparam_block_sysfs_write() around
  * accesses (esp. charp, which can be kfreed when it changes).
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 2ddb48d..2c6a7ba 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2511,7 +2511,7 @@ static inline bool skb_defer_rx_timestamp(struct sk_buff *skb)
  * must call this function to return the skb back to the stack, with
  * or without a timestamp.
  *
- * @skb: clone of the the original outgoing packet
+ * @skb: clone of the original outgoing packet
  * @hwtstamps: hardware time stamps, may be NULL if not available
  *
  */
diff --git a/include/net/caif/caif_layer.h b/include/net/caif/caif_layer.h
index 94e5ed6..e9a8d52 100644
--- a/include/net/caif/caif_layer.h
+++ b/include/net/caif/caif_layer.h
@@ -184,7 +184,7 @@ struct cflayer {
 	 *	CAIF packet downwards in the stack.
 	 *	Packet handling rules:
 	 *	      - The CAIF packet (cfpkt) ownership is passed to the
-	 *		transmit function. This means that the the packet
+	 *		transmit function. This means that the packet
 	 *		cannot be accessed after passing it to the below
 	 *		layer using dn->transmit().
 	 *
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 48ec25a..4abf055 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -100,7 +100,7 @@ struct rt6_info {
 	struct in6_addr			rt6i_gateway;
 
 	/* Multipath routes:
-	 * siblings is a list of rt6_info that have the the same metric/weight,
+	 * siblings is a list of rt6_info that have the same metric/weight,
 	 * destination, but not the same gateway. nsiblings is just a cache
 	 * to speed up lookup.
 	 */
diff --git a/include/net/wimax.h b/include/net/wimax.h
index bbb74f9..e1f28cc 100644
--- a/include/net/wimax.h
+++ b/include/net/wimax.h
@@ -43,7 +43,7 @@
  *
  * USAGE
  *
- * Embed a `struct wimax_dev` at the beginning of the the device's
+ * Embed a `struct wimax_dev` at the beginning of the device's
  * private structure, initialize and register it. For details, see
  * `struct wimax_dev`s documentation.
  *
diff --git a/init/main.c b/init/main.c
index af310af..71a7395 100644
--- a/init/main.c
+++ b/init/main.c
@@ -484,7 +484,7 @@ asmlinkage void __init start_kernel(void)
 	debug_objects_early_init();
 
 	/*
-	 * Set up the the initial canary ASAP:
+	 * Set up the initial canary ASAP:
 	 */
 	boot_init_stack_canary();
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 297a924..3cf4a90 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -17,7 +17,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-/* mutex to protect coming/going of the the jump_label table */
+/* mutex to protect coming/going of the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
 void jump_label_lock(void)
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index b4e8500..722b5a1 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2721,7 +2721,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
  * @len: length of line placed into buffer
  *
  * Start at the end of the kmsg buffer and fill the provided buffer
- * with as many of the the *youngest* kmsg records that fit into it.
+ * with as many of the *youngest* kmsg records that fit into it.
  * If the buffer is large enough, all available kmsg records will be
  * copied with a single call.
  *
diff --git a/kernel/smp.c b/kernel/smp.c
index 0564571..f9e336a 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -602,7 +602,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * for all the required CPUs to finish. This may include the local
  * processor.
  * @cond_func:	A callback function that is passed a cpu id and
- *		the the info parameter. The function is called
+ *		the info parameter. The function is called
  *		with preemption disabled. The function should
  *		return a blooean value indicating whether to IPI
  *		the specified CPU.
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index cc2f66f..04fb641 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2874,7 +2874,7 @@ rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
  * This function lets the user discard an event in the ring buffer
  * and then that event will not be read later.
  *
- * This function only works if it is called before the the item has been
+ * This function only works if it is called before the item has been
  * committed. It will try to free the event from the ring buffer
  * if another event has not been added behind it.
  *
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 06f7e4f..8fa2ad3 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -882,7 +882,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * read it, you're overqualified for your current job.)
  *
  * In other words, @orig is mapped onto (surjectively) @dst,
- * using the the map { <n, m> | the n-th bit of @relmap is the
+ * using the map { <n, m> | the n-th bit of @relmap is the
  * m-th set bit of @relmap }.
  *
  * Any set bits in @orig above bit number W, where W is the
diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index 0777c5a..2ad6fc3 100644
--- a/lib/dynamic_queue_limits.c
+++ b/lib/dynamic_queue_limits.c
@@ -60,7 +60,7 @@ void dql_completed(struct dql *dql, unsigned int count)
 		 * the whole interval (the check above).
 		 *
 		 * If there is slack, the amount of execess data queued above
-		 * the the amount needed to prevent starvation, the queue limit
+		 * the amount needed to prevent starvation, the queue limit
 		 * can be decreased.  To avoid hysteresis we consider the
 		 * minimum amount of slack found over several iterations of the
 		 * completion routine.
diff --git a/lib/earlycpio.c b/lib/earlycpio.c
index 3eb3e47..9d4da0a 100644
--- a/lib/earlycpio.c
+++ b/lib/earlycpio.c
@@ -50,7 +50,7 @@ enum cpio_fields {
 /**
  * cpio_data find_cpio_data - Search for files in an uncompressed cpio
  * @path:       The directory to search for, including a slash at the end
- * @data:       Pointer to the the cpio archive or a header inside
+ * @data:       Pointer to the cpio archive or a header inside
  * @len:        Remaining length of the cpio based on data pointer
  * @nextoff:    When a matching file is found, this is the offset from the
  *              beginning of the cpio to the beginning of the next file, not the
diff --git a/lib/syscall.c b/lib/syscall.c
index 58710ee..90fc637 100644
--- a/lib/syscall.c
+++ b/lib/syscall.c
@@ -31,7 +31,7 @@ static int collect_syscall(struct task_struct *target, long *callno,
  * @pc:			filled with user PC
  *
  * If @target is blocked in a system call, returns zero with *@callno
- * set to the the call's number and @args filled in with its arguments.
+ * set to the call's number and @args filled in with its arguments.
  * Registers not used for system call arguments may not be available and
  * it is not kosher to use &struct user_regset calls while the system
  * call is still in progress.  Note we may get this result if @target
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b49579c..a81ee77 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1139,7 +1139,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the the freed pages across the
+	 * free_pool_huge_page() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0ee638f..9812fa1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4116,7 +4116,7 @@ static int __meminit zone_batchsize(struct zone *zone)
  * locking.
  *
  * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording the the above rule).
+ * those fields changing asynchronously (according to the above rule).
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index f081712..f87b46f 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -703,7 +703,7 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 	return 0;
 }
 
-/* Encrypt the the link */
+/* Encrypt the link */
 static void hci_conn_encrypt(struct hci_conn *conn)
 {
 	BT_DBG("hcon %p", conn);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 634deba..add9fd7 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -616,7 +616,7 @@ static void hci_init3_req(struct hci_request *req, unsigned long opt)
 	 * Delete Stored Link Key command. They are clearly indicating its
 	 * absence in the bit mask of supported commands.
 	 *
-	 * Check the supported commands and only if the the command is marked
+	 * Check the supported commands and only if the command is marked
 	 * as supported send it. If not supported assume that the controller
 	 * does not have actual support for stored link keys which makes this
 	 * command redundant anyway.
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 7bd5ed4..4a8d5cc 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -200,7 +200,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
 
 	max = asoc->frag_point;
-	/* If the the peer requested that we authenticate DATA chunks
+	/* If the peer requested that we authenticate DATA chunks
 	 * we need to accound for bundling of the AUTH chunks along with
 	 * DATA.
 	 */
diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index f6d84be..856e05f 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -184,7 +184,7 @@ void rpc_destroy_generic_auth(void)
 }
 
 /*
- * Test the the current time (now) against the underlying credential key expiry
+ * Test the current time (now) against the underlying credential key expiry
  * minus a timeout and setup notification.
  *
  * The normal case:
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 0cc3d90..c243712 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -920,7 +920,7 @@ int tipc_link_send_buf(struct tipc_link *l_ptr, struct sk_buff *buf)
 
 /*
  * tipc_link_send(): same as tipc_link_send_buf(), but the link to use has
- * not been selected yet, and the the owner node is not locked
+ * not been selected yet, and the owner node is not locked
  * Called by TIPC internal users, e.g. the name distributor
  */
 int tipc_link_send(struct sk_buff *buf, u32 dest, u32 selector)
diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index 7ab60ba..123539f 100644
--- a/net/wimax/op-rfkill.c
+++ b/net/wimax/op-rfkill.c
@@ -135,7 +135,7 @@ EXPORT_SYMBOL_GPL(wimax_report_rfkill_hw);
  * @state: New state of the RF kill switch. %WIMAX_RF_ON radio on,
  *     %WIMAX_RF_OFF radio off.
  *
- * Reports changes in the software RF switch state to the the WiMAX
+ * Reports changes in the software RF switch state to the WiMAX
  * stack.
  *
  * The main use is during initialization, so the driver can query the
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index db40fa0..9eb8c74 100644
--- a/scripts/tracing/draw_functrace.py
+++ b/scripts/tracing/draw_functrace.py
@@ -8,7 +8,7 @@ This script parses a trace provided by the function tracer in
 kernel/trace/trace_functions.c
 The resulted trace is processed into a tree to produce a more human
 view of the call stack by drawing textual but hierarchical tree of
-calls. Only the functions's names and the the call time are provided.
+calls. Only the functions's names and the call time are provided.
 
 Usage:
 	Be sure that you have CONFIG_FUNCTION_TRACER
diff --git a/security/apparmor/context.c b/security/apparmor/context.c
index 3064c6c..7b9769e 100644
--- a/security/apparmor/context.c
+++ b/security/apparmor/context.c
@@ -13,7 +13,7 @@
  * License.
  *
  *
- * AppArmor sets confinement on every task, via the the aa_task_cxt and
+ * AppArmor sets confinement on every task, via the aa_task_cxt and
  * the aa_task_cxt.profile, both of which are required and are not allowed
  * to be NULL.  The aa_task_cxt is not reference counted and is unique
  * to each cred (which is reference count).  The profile pointed to by
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 33cfd27..3969a80 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -459,7 +459,7 @@ error:
  * keyring, otherwise replace the link to the matching key with a link to the
  * new key.
  *
- * The key must grant the caller Link permission and the the keyring must grant
+ * The key must grant the caller Link permission and the keyring must grant
  * the caller Write permission.  Furthermore, if an additional link is created,
  * the keyring's quota will be extended.
  *
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index 5b6c4e3..cca0e93 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -4981,7 +4981,7 @@ EXPORT_SYMBOL_HDA(snd_hda_power_save);
  * @nid: NID to check / update
  *
  * Check whether the given NID is in the amp list.  If it's in the list,
- * check the current AMP status, and update the the power-status according
+ * check the current AMP status, and update the power-status according
  * to the mute status.
  *
  * This function is supposed to be set or called from the check_power_status
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index fba0cef..c0f4058 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -858,7 +858,7 @@ static int stac_auto_create_beep_ctls(struct hda_codec *codec,
 	static struct snd_kcontrol_new beep_vol_ctl =
 		HDA_CODEC_VOLUME(NULL, 0, 0, 0);
 
-	/* check for mute support for the the amp */
+	/* check for mute support for the amp */
 	if ((caps & AC_AMPCAP_MUTE) >> AC_AMPCAP_MUTE_SHIFT) {
 		const struct snd_kcontrol_new *temp;
 		if (spec->anabeep_nid == nid)
diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index e610339..6f8e563 100644
--- a/sound/pci/ice1712/prodigy192.c
+++ b/sound/pci/ice1712/prodigy192.c
@@ -31,7 +31,7 @@
  *		  Experimentally I found out that only a combination of
  *		  OCKS0=1, OCKS1=1 (128fs, 64fs output) and ice1724 -
  *		  VT1724_MT_I2S_MCLK_128X=0 (256fs input) yields correct
- *		  sampling rate. That means the the FPGA doubles the
+ *		  sampling rate. That means that the FPGA doubles the
  *		  MCK01 rate.
  *
  *	Copyright (c) 2003 Takashi Iwai <tiwai@suse.de>
diff --git a/sound/soc/codecs/wm9713.c b/sound/soc/codecs/wm9713.c
index a53e175..6022481 100644
--- a/sound/soc/codecs/wm9713.c
+++ b/sound/soc/codecs/wm9713.c
@@ -694,7 +694,7 @@ static void pll_factors(struct _pll_div *pll_div, unsigned int source)
 	u64 Kpart;
 	unsigned int K, Ndiv, Nmod, target;
 
-	/* The the PLL output is always 98.304MHz. */
+	/* The PLL output is always 98.304MHz. */
 	target = 98304000;
 
 	/* If the input frequency is over 14.4MHz then scale it down. */
diff --git a/sound/soc/fsl/fsl_dma.c b/sound/soc/fsl/fsl_dma.c
index 9cc5c1f..54f9a36 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -169,7 +169,7 @@ static void fsl_dma_abort_stream(struct snd_pcm_substream *substream)
 /**
  * fsl_dma_update_pointers - update LD pointers to point to the next period
  *
- * As each period is completed, this function changes the the link
+ * As each period is completed, this function changes the link
  * descriptor pointers for that period to point to the next period.
  */
 static void fsl_dma_update_pointers(struct fsl_dma_private *dma_private)
diff --git a/sound/soc/fsl/fsl_ssi.c b/sound/soc/fsl/fsl_ssi.c
index c6b7439..0ab23e4 100644
--- a/sound/soc/fsl/fsl_ssi.c
+++ b/sound/soc/fsl/fsl_ssi.c
@@ -1020,7 +1020,7 @@ static int fsl_ssi_probe(struct platform_device *pdev)
 		}
 	}
 
-	/* Initialize the the device_attribute structure */
+	/* Initialize the device_attribute structure */
 	dev_attr = &ssi_private->dev_attr;
 	sysfs_attr_init(&dev_attr->attr);
 	dev_attr->attr.name = "statistics";
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index eee7afc..a28b953 100644
--- a/sound/sparc/dbri.c
+++ b/sound/sparc/dbri.c
@@ -615,7 +615,7 @@ A circular command buffer is used here. A new command is being added
 while another can be executed. The scheme works by adding two WAIT commands
 after each sent batch of commands. When the next batch is prepared it is
 added after the WAIT commands then the WAITs are replaced with single JUMP
-command to the new batch. The the DBRI is forced to reread the last WAIT
+command to the new batch. The DBRI is forced to reread the last WAIT
 command (replaced by the JUMP by then). If the DBRI is still executing
 previous commands the request to reread the WAIT command is ignored.
 
diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fdfceee..29b9bcd 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -180,7 +180,7 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
   - period being the hist entry period value
 
-  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
+  - WEIGHT-A/WEIGHT-B being user suplied weights in the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
     - WIEGHT-A being the weight of the data file
     - WIEGHT-B being the weight of the baseline data file
diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index b4ddb74..7e8aa3f 100644
--- a/tools/power/x86/turbostat/turbostat.8
+++ b/tools/power/x86/turbostat/turbostat.8
@@ -35,9 +35,9 @@ The \fB-c MSR#\fP option includes the delta of the specified 32-bit MSR counter.
 .PP
 The \fB-C MSR#\fP option includes the delta of the specified 64-bit MSR counter.
 .PP
-The \fB-m MSR#\fP option includes the the specified 32-bit MSR value.
+The \fB-m MSR#\fP option includes the specified 32-bit MSR value.
 .PP
-The \fB-M MSR#\fP option includes the the specified 64-bit MSR value.
+The \fB-M MSR#\fP option includes the specified 64-bit MSR value.
 .PP
 The \fB-i interval_sec\fP option prints statistics every \fiinterval_sec\fP seconds.
 The default is 5 seconds.
-- 
1.8.1.2

