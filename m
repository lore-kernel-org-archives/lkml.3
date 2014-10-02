Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056AbaJBTYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 15:24:47 -0400
Received: from top.free-electrons.com ([176.31.233.9]:43368 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751748AbaJBTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 15:24:38 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: rdunlap@infradead.org, trivial@kernel.org, joe@perches.com,
        akpm@linux-foundation.org, arend@broadcom.com,
        gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the "
Date: Thu,  2 Oct 2014 21:24:30 +0200
Message-Id: <1412277870-4960-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <542DA51C.1080209@free-electrons.com>
References: <542DA51C.1080209@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix all occurrences of "the the ", and occasionally "in in ",
in the source code, comments and documentation.

The replacement couldn't be automated because sometimes
the first "the" was meant to be another word.

Example: "according the the"
meaning: "according to the"

Note that I sometimes took the opportunity to fix
other spelling issues or typos in the same sentences,
and to reformat some comments impacted by the changes.

I also fixed a few checkpatch errors in the same
lines, but not all of them (should be addressed by
separate patches).

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Reviewed-by: rdunlap@infradead.org
---
 Documentation/ABI/testing/sysfs-devices-memory               |  2 +-
 Documentation/DocBook/media/v4l/controls.xml                 |  2 +-
 Documentation/DocBook/media/v4l/vidioc-g-parm.xml            |  2 +-
 Documentation/devicetree/bindings/arm/msm/timer.txt          |  2 +-
 .../devicetree/bindings/ata/cavium-compact-flash.txt         |  2 +-
 Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt      |  2 +-
 Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt    |  2 +-
 Documentation/devicetree/bindings/mtd/fsmc-nand.txt          |  2 +-
 .../devicetree/bindings/net/broadcom-systemport.txt          |  2 +-
 Documentation/filesystems/autofs4-mount-control.txt          |  4 ++--
 Documentation/phy.txt                                        |  2 +-
 Documentation/vm/unevictable-lru.txt                         |  2 +-
 arch/arm/Kconfig                                             |  2 +-
 arch/arm/include/asm/unwind.h                                |  2 +-
 arch/arm/mach-omap2/omap_hwmod.c                             |  6 +++---
 arch/arm/mach-pxa/stargate2.c                                |  2 +-
 arch/arm64/crypto/aes-neon.S                                 |  2 +-
 arch/blackfin/mach-common/entry.S                            |  2 +-
 arch/c6x/platforms/cache.c                                   |  2 +-
 arch/ia64/include/asm/spinlock.h                             |  2 +-
 arch/ia64/include/asm/uv/uv_hub.h                            |  2 +-
 arch/m68k/platform/coldfire/intc-2.c                         |  2 +-
 arch/metag/kernel/process.c                                  |  2 +-
 arch/microblaze/kernel/entry.S                               |  2 +-
 arch/mips/alchemy/devboards/pm.c                             |  2 +-
 arch/mips/include/asm/octeon/cvmx-pip.h                      |  2 +-
 arch/mips/include/asm/spinlock.h                             |  2 +-
 arch/mips/kvm/mips.c                                         |  2 +-
 arch/mips/mm/c-octeon.c                                      |  4 ++--
 arch/mips/netlogic/xlr/fmn.c                                 |  2 +-
 arch/powerpc/include/asm/cache.h                             |  2 +-
 arch/powerpc/include/asm/epapr_hcalls.h                      |  2 +-
 arch/powerpc/include/asm/hw_breakpoint.h                     |  2 +-
 arch/powerpc/kernel/head_64.S                                |  2 +-
 arch/powerpc/mm/gup.c                                        |  2 +-
 arch/powerpc/mm/hugetlbpage.c                                |  2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c                    |  2 +-
 arch/powerpc/platforms/chrp/setup.c                          |  2 +-
 arch/powerpc/platforms/powernv/pci-ioda.c                    |  2 +-
 arch/s390/kernel/perf_cpum_sf.c                              |  2 +-
 arch/s390/mm/gup.c                                           |  2 +-
 arch/sparc/kernel/pci.c                                      |  2 +-
 arch/sparc/mm/gup.c                                          |  2 +-
 arch/tile/include/asm/irqflags.h                             |  2 +-
 arch/tile/include/gxio/trio.h                                |  2 +-
 arch/tile/kernel/single_step.c                               |  2 +-
 arch/x86/include/asm/spinlock.h                              |  2 +-
 arch/x86/include/asm/uv/uv_hub.h                             |  2 +-
 arch/x86/kvm/x86.c                                           |  2 +-
 arch/x86/mm/gup.c                                            |  4 ++--
 arch/x86/xen/setup.c                                         |  2 +-
 arch/xtensa/include/asm/initialize_mmu.h                     |  2 +-
 arch/xtensa/kernel/entry.S                                   | 12 ++++++------
 crypto/asymmetric_keys/pkcs7_parser.h                        |  2 +-
 drivers/acpi/acpica/accommon.h                               |  2 +-
 drivers/acpi/acpica/tbfadt.c                                 |  2 +-
 drivers/char/apm-emulation.c                                 |  2 +-
 drivers/char/xilinx_hwicap/fifo_icap.c                       |  2 +-
 drivers/cpuidle/driver.c                                     |  2 +-
 drivers/crypto/picoxcell_crypto.c                            |  2 +-
 drivers/crypto/ux500/hash/hash_core.c                        |  2 +-
 drivers/gpio/gpio-ich.c                                      |  2 +-
 drivers/gpio/gpio-sch.c                                      |  4 ++--
 drivers/gpu/drm/drm_mm.c                                     |  4 ++--
 drivers/gpu/drm/i915/i915_gem.c                              |  2 +-
 drivers/gpu/drm/i915/i915_gem_userptr.c                      |  2 +-
 drivers/gpu/drm/i915/intel_display.c                         |  4 ++--
 drivers/gpu/drm/radeon/atombios.h                            |  4 ++--
 drivers/gpu/drm/radeon/r300_reg.h                            |  2 +-
 drivers/gpu/drm/radeon/radeon_device.c                       |  2 +-
 drivers/gpu/drm/radeon/radeon_fence.c                        |  2 +-
 drivers/gpu/drm/radeon/radeon_vm.c                           |  4 ++--
 drivers/hv/channel.c                                         |  4 ++--
 drivers/hv/vmbus_drv.c                                       |  4 ++--
 drivers/hwmon/pmbus/ucd9200.c                                |  2 +-
 drivers/infiniband/hw/ipath/ipath_common.h                   |  2 +-
 drivers/infiniband/hw/qib/qib.h                              |  2 +-
 drivers/input/mouse/gpio_mouse.c                             |  2 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c                        |  2 +-
 drivers/lguest/core.c                                        |  2 +-
 drivers/media/dvb-frontends/tda1002x.h                       |  2 +-
 drivers/media/dvb-frontends/tda10048.c                       |  2 +-
 drivers/media/pci/cx88/cx88-dsp.c                            |  2 +-
 drivers/media/pci/ivtv/ivtv-yuv.c                            |  2 +-
 drivers/media/pci/saa7164/saa7164-core.c                     |  2 +-
 drivers/media/platform/davinci/vpbe.c                        |  2 +-
 drivers/media/platform/exynos4-is/fimc-capture.c             |  2 +-
 drivers/media/platform/omap3isp/isp.c                        |  2 +-
 drivers/media/usb/dvb-usb/friio-fe.c                         |  2 +-
 drivers/media/usb/dvb-usb/friio.c                            |  2 +-
 drivers/media/usb/dvb-usb/friio.h                            |  2 +-
 drivers/media/usb/gspca/finepix.c                            |  2 +-
 drivers/media/usb/tm6000/tm6000-cards.c                      |  2 +-
 drivers/media/usb/uvc/uvc_video.c                            |  2 +-
 drivers/media/v4l2-core/v4l2-ioctl.c                         |  2 +-
 drivers/memory/emif.c                                        |  2 +-
 drivers/message/fusion/mptspi.c                              |  2 +-
 drivers/mfd/db8500-prcmu.c                                   |  2 +-
 drivers/misc/mic/bus/mic_bus.c                               |  2 +-
 drivers/misc/sgi-gru/grukservices.c                          |  2 +-
 drivers/misc/sgi-xp/xpc_uv.c                                 |  2 +-
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c                       |  2 +-
 drivers/mtd/ubi/ubi.h                                        |  4 ++--
 drivers/mtd/ubi/wl.c                                         |  2 +-
 drivers/net/can/xilinx_can.c                                 |  2 +-
 drivers/net/ethernet/calxeda/xgmac.c                         |  2 +-
 drivers/net/ethernet/emulex/benet/be_main.c                  |  2 +-
 drivers/net/ethernet/intel/e1000/e1000_hw.c                  |  2 +-
 drivers/net/ethernet/intel/e1000e/ich8lan.c                  |  2 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c                 |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                |  2 +-
 drivers/net/ethernet/neterion/s2io.c                         |  2 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c            |  2 +-
 drivers/net/wimax/i2400m/i2400m.h                            |  4 ++--
 drivers/net/wimax/i2400m/rx.c                                |  2 +-
 drivers/net/wimax/i2400m/tx.c                                |  2 +-
 drivers/net/wireless/ath/ath10k/rx_desc.h                    |  2 +-
 drivers/net/wireless/ath/ath6kl/hif.h                        |  2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c                       |  2 +-
 drivers/net/wireless/ath/ath9k/ar9002_phy.c                  |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c                  |  2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h                       |  8 ++++----
 drivers/net/wireless/brcm80211/brcmsmac/main.c               |  2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                 |  4 ++--
 drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                  |  4 ++--
 drivers/net/wireless/mwifiex/debugfs.c                       |  2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c                      |  4 ++--
 drivers/net/wireless/ti/wl1251/acx.h                         |  2 +-
 drivers/of/base.c                                            |  2 +-
 drivers/pci/hotplug/acpiphp_glue.c                           |  2 +-
 drivers/pcmcia/pxa2xx_hx4700.c                               |  2 +-
 drivers/pinctrl/nomadik/pinctrl-nomadik.c                    |  2 +-
 drivers/pinctrl/pinctrl-at91.c                               |  2 +-
 drivers/power/power_supply_sysfs.c                           |  5 +++--
 drivers/rtc/rtc-rs5c372.c                                    |  2 +-
 drivers/s390/net/qeth_core_main.c                            |  2 +-
 drivers/scsi/bfa/bfa_fcs_rport.c                             |  2 +-
 drivers/scsi/fcoe/fcoe.c                                     |  6 +++---
 drivers/scsi/fcoe/fcoe_ctlr.c                                |  4 ++--
 drivers/scsi/isci/host.h                                     |  2 +-
 drivers/scsi/isci/remote_device.h                            |  2 +-
 drivers/scsi/isci/remote_node_context.h                      |  2 +-
 drivers/scsi/isci/task.c                                     |  2 +-
 drivers/scsi/lpfc/lpfc_attr.c                                |  8 ++++----
 drivers/scsi/lpfc/lpfc_els.c                                 |  2 +-
 drivers/scsi/lpfc/lpfc_hbadisc.c                             |  4 ++--
 drivers/scsi/lpfc/lpfc_init.c                                |  2 +-
 drivers/scsi/lpfc/lpfc_mbox.c                                |  2 +-
 drivers/scsi/lpfc/lpfc_sli.c                                 |  2 +-
 drivers/scsi/pm8001/pm8001_hwi.c                             |  2 +-
 drivers/spi/spi-ppc4xx.c                                     |  2 +-
 drivers/staging/android/ion/ion.c                            |  2 +-
 drivers/staging/android/uapi/binder.h                        |  2 +-
 drivers/staging/et131x/et131x.c                              |  2 +-
 drivers/staging/lustre/lustre/llite/file.c                   |  2 +-
 drivers/staging/lustre/lustre/ptlrpc/pinger.c                |  2 +-
 drivers/staging/rtl8188eu/core/rtw_cmd.c                     |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c            |  2 +-
 drivers/staging/rtl8712/rtl871x_cmd.c                        |  2 +-
 drivers/staging/rtl8723au/core/rtw_cmd.c                     |  2 +-
 .../staging/unisys/common-spar/include/channels/iochannel.h  |  4 ++--
 .../unisys/common-spar/include/channels/vbuschannel.h        |  6 +++---
 drivers/staging/unisys/virtpci/virtpci.c                     |  2 +-
 drivers/target/target_core_alua.c                            |  2 +-
 drivers/thunderbolt/ctl.h                                    |  2 +-
 drivers/usb/host/max3421-hcd.c                               |  3 +--
 drivers/usb/host/xhci-ring.c                                 |  2 +-
 drivers/usb/serial/cypress_m8.c                              |  2 +-
 drivers/usb/serial/mos7720.c                                 |  2 +-
 drivers/usb/wusbcore/devconnect.c                            |  2 +-
 drivers/uwb/drp-ie.c                                         |  2 +-
 drivers/video/fbdev/omap/sossi.c                             |  2 +-
 drivers/video/fbdev/sis/sis_accel.c                          |  2 +-
 fs/autofs4/dev-ioctl.c                                       |  2 +-
 fs/btrfs/dev-replace.c                                       |  2 +-
 fs/btrfs/send.c                                              |  2 +-
 fs/btrfs/tree-log.c                                          |  2 +-
 fs/dcache.c                                                  |  4 ++--
 fs/ecryptfs/keystore.c                                       |  2 +-
 fs/ext2/ext2.h                                               |  2 +-
 fs/ext4/inline.c                                             |  4 ++--
 fs/f2fs/segment.h                                            |  2 +-
 fs/kernfs/file.c                                             |  2 +-
 fs/ocfs2/localalloc.c                                        |  2 +-
 fs/xfs/xfs_export.c                                          |  2 +-
 include/drm/drm_rect.h                                       |  2 +-
 include/linux/mic_bus.h                                      |  2 +-
 include/linux/mm.h                                           |  2 +-
 include/linux/moduleparam.h                                  |  2 +-
 include/linux/skbuff.h                                       |  2 +-
 include/net/caif/caif_layer.h                                |  2 +-
 include/net/ip6_fib.h                                        |  2 +-
 include/net/wimax.h                                          |  2 +-
 include/uapi/asm-generic/fcntl.h                             |  2 +-
 init/Kconfig                                                 |  4 ++--
 init/main.c                                                  |  2 +-
 kernel/jump_label.c                                          |  2 +-
 kernel/printk/printk.c                                       |  2 +-
 kernel/smp.c                                                 |  2 +-
 kernel/trace/ring_buffer.c                                   |  2 +-
 lib/bitmap.c                                                 |  2 +-
 lib/dynamic_queue_limits.c                                   |  2 +-
 lib/earlycpio.c                                              |  2 +-
 lib/syscall.c                                                |  2 +-
 mm/hugetlb.c                                                 |  2 +-
 mm/page_alloc.c                                              |  2 +-
 net/bluetooth/hci_conn.c                                     |  2 +-
 net/bluetooth/hci_core.c                                     |  2 +-
 net/sctp/associola.c                                         |  2 +-
 net/sctp/chunk.c                                             |  2 +-
 net/sunrpc/auth_generic.c                                    |  2 +-
 net/wimax/op-rfkill.c                                        |  2 +-
 scripts/coccinelle/misc/badty.cocci                          |  2 +-
 scripts/tracing/draw_functrace.py                            |  2 +-
 security/apparmor/context.c                                  |  2 +-
 security/keys/keyctl.c                                       |  2 +-
 sound/pci/hda/hda_codec.c                                    |  2 +-
 sound/pci/hda/patch_sigmatel.c                               |  2 +-
 sound/pci/ice1712/prodigy192.c                               |  2 +-
 sound/soc/codecs/wm9713.c                                    |  2 +-
 sound/soc/fsl/fsl_dma.c                                      |  2 +-
 sound/sparc/dbri.c                                           |  2 +-
 tools/perf/Documentation/perf-diff.txt                       |  2 +-
 tools/power/x86/turbostat/turbostat.8                        |  4 ++--
 tools/thermal/tmon/pid.c                                     |  2 +-
 225 files changed, 266 insertions(+), 266 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
index 7405de26ee60..4b3c0208d0a5 100644
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
index 9f5ffd85560b..a232065a7c6a 100644
--- a/Documentation/DocBook/media/v4l/controls.xml
+++ b/Documentation/DocBook/media/v4l/controls.xml
@@ -3415,7 +3415,7 @@ giving priority to the center of the metered area.</entry>
 		<row>
 		  <entry><constant>V4L2_EXPOSURE_METERING_MATRIX</constant>&nbsp;</entry>
 		  <entry>A multi-zone metering. The light intensity is measured
-in several points of the frame and the the results are combined. The
+in several points of the frame and the results are combined. The
 algorithm of the zones selection and their significance in calculating the
 final value is device dependent.</entry>
 		</row>
diff --git a/Documentation/DocBook/media/v4l/vidioc-g-parm.xml b/Documentation/DocBook/media/v4l/vidioc-g-parm.xml
index f4e28e7d4751..721728745407 100644
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
diff --git a/Documentation/devicetree/bindings/arm/msm/timer.txt b/Documentation/devicetree/bindings/arm/msm/timer.txt
index c6ef8f13dc7e..74607b6c1117 100644
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
index 93986a5a8018..3bacc8e0931e 100644
--- a/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
+++ b/Documentation/devicetree/bindings/ata/cavium-compact-flash.txt
@@ -9,7 +9,7 @@ Properties:
 
   Compatibility with many Cavium evaluation boards.
 
-- reg: The base address of the the CF chip select banks.  Depending on
+- reg: The base address of the CF chip select banks.  Depending on
   the device configuration, there may be one or two banks.
 
 - cavium,bus-width: The width of the connection to the CF devices.  Valid
diff --git a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
index d63194a2c848..ada4e2973323 100644
--- a/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
+++ b/Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt
@@ -39,7 +39,7 @@ Optional Properties:
   - lines-initial-states: Bitmask that specifies the initial state of each
   line. When a bit is set to zero, the corresponding line will be initialized to
   the input (pulled-up) state. When the  bit is set to one, the line will be
-  initialized the the low-level output state. If the property is not specified
+  initialized the low-level output state. If the property is not specified
   all lines will be initialized to the input state.
 
   The I/O expander can detect input state changes, and thus optionally act as
diff --git a/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt b/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
index d9ee909d2b78..d71258e2d456 100644
--- a/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
+++ b/Documentation/devicetree/bindings/iio/adc/xilinx-xadc.txt
@@ -59,7 +59,7 @@ Optional properties:
 	  Each child node represents one channel and has the following
 	  properties:
 		Required properties:
-			* reg: Pair of pins the the channel is connected to.
+			* reg: Pair of pins the channel is connected to.
 				0: VP/VN
 				1: VAUXP[0]/VAUXN[0]
 				2: VAUXP[1]/VAUXN[1]
diff --git a/Documentation/devicetree/bindings/mtd/fsmc-nand.txt b/Documentation/devicetree/bindings/mtd/fsmc-nand.txt
index ec42935f3908..5235cbc551b0 100644
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
diff --git a/Documentation/devicetree/bindings/net/broadcom-systemport.txt b/Documentation/devicetree/bindings/net/broadcom-systemport.txt
index aa7ad622259d..877da34145b0 100644
--- a/Documentation/devicetree/bindings/net/broadcom-systemport.txt
+++ b/Documentation/devicetree/bindings/net/broadcom-systemport.txt
@@ -3,7 +3,7 @@
 Required properties:
 - compatible: should be one of "brcm,systemport-v1.00" or "brcm,systemport"
 - reg: address and length of the register set for the device.
-- interrupts: interrupts for the device, first cell must be for the the rx
+- interrupts: interrupts for the device, first cell must be for the rx
   interrupts, and the second cell should be for the transmit queues. An
   optional third interrupt cell for Wake-on-LAN can be specified
 - local-mac-address: Ethernet MAC address (48 bits) of this adapter
diff --git a/Documentation/filesystems/autofs4-mount-control.txt b/Documentation/filesystems/autofs4-mount-control.txt
index aff22113a986..e54896427b4a 100644
--- a/Documentation/filesystems/autofs4-mount-control.txt
+++ b/Documentation/filesystems/autofs4-mount-control.txt
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
 
diff --git a/Documentation/phy.txt b/Documentation/phy.txt
index c6594af94d25..27fb3656ec8e 100644
--- a/Documentation/phy.txt
+++ b/Documentation/phy.txt
@@ -87,7 +87,7 @@ should contain the phy name as given in the dt data and in the case of
 non-dt boot, it should contain the label of the PHY.  The two
 devm_phy_get associates the device with the PHY using devres on
 successful PHY get. On driver detach, release function is invoked on
-the the devres data and devres data is freed. phy_optional_get and
+the devres data and devres data is freed. phy_optional_get and
 devm_phy_optional_get should be used when the phy is optional. These
 two functions will never return -ENODEV, but instead returns NULL when
 the phy cannot be found.
diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
index 744f82f86c58..441dd2266531 100644
--- a/Documentation/vm/unevictable-lru.txt
+++ b/Documentation/vm/unevictable-lru.txt
@@ -453,7 +453,7 @@ putback_lru_page() function to add migrated pages back to the LRU.
 mmap(MAP_LOCKED) SYSTEM CALL HANDLING
 -------------------------------------
 
-In addition the mlock()/mlockall() system calls, an application can request
+In addition to the mlock()/mlockall() system calls, an application can request
 that a region of memory be mlocked supplying the MAP_LOCKED flag to the mmap()
 call.  Furthermore, any mmap() call or brk() call that expands the heap by a
 task that has previously called mlockall() with the MCL_FUTURE flag will result
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 32cbbd565902..df27c39b2488 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1909,7 +1909,7 @@ config ARM_ATAG_DTB_COMPAT_CMDLINE_EXTEND
 	bool "Extend with bootloader kernel arguments"
 	help
 	  The command-line arguments provided by the boot loader will be
-	  appended to the the device tree bootargs property.
+	  appended to the device tree bootargs property.
 
 endchoice
 
diff --git a/arch/arm/include/asm/unwind.h b/arch/arm/include/asm/unwind.h
index d1c3f3a71c94..4f697edd0bad 100644
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
index 9e91a4e7519a..300bd6c004de 100644
--- a/arch/arm/mach-omap2/omap_hwmod.c
+++ b/arch/arm/mach-omap2/omap_hwmod.c
@@ -753,7 +753,7 @@ static int _del_initiator_dep(struct omap_hwmod *oh, struct omap_hwmod *init_oh)
 }
 
 /**
- * _init_main_clk - get a struct clk * for the the hwmod's main functional clk
+ * _init_main_clk - get a struct clk * for the hwmod's main functional clk
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh _clk (main
@@ -791,7 +791,7 @@ static int _init_main_clk(struct omap_hwmod *oh)
 }
 
 /**
- * _init_interface_clks - get a struct clk * for the the hwmod's interface clks
+ * _init_interface_clks - get a struct clk * for the hwmod's interface clks
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh OCP slave interface
@@ -835,7 +835,7 @@ static int _init_interface_clks(struct omap_hwmod *oh)
 }
 
 /**
- * _init_opt_clk - get a struct clk * for the the hwmod's optional clocks
+ * _init_opt_clk - get a struct clk * for the hwmod's optional clocks
  * @oh: struct omap_hwmod *
  *
  * Called from _init_clocks().  Populates the @oh omap_hwmod_opt_clk
diff --git a/arch/arm/mach-pxa/stargate2.c b/arch/arm/mach-pxa/stargate2.c
index 01de542432a6..6f92e75b6c35 100644
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
diff --git a/arch/arm64/crypto/aes-neon.S b/arch/arm64/crypto/aes-neon.S
index b93170e1cc93..d0f01cff23b3 100644
--- a/arch/arm64/crypto/aes-neon.S
+++ b/arch/arm64/crypto/aes-neon.S
@@ -47,7 +47,7 @@
 	prepare		.LReverse_Sbox, .LReverse_ShiftRows, \temp
 	.endm
 
-	/* apply SubBytes transformation using the the preloaded Sbox */
+	/* apply SubBytes transformation using the preloaded Sbox */
 	.macro		sub_bytes, in
 	sub		v9.16b, \in\().16b, v12.16b
 	tbl		\in\().16b, {v16.16b-v19.16b}, \in\().16b
diff --git a/arch/blackfin/mach-common/entry.S b/arch/blackfin/mach-common/entry.S
index 86b5a095c5a1..9c8612385e00 100644
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
index 86318a16a252..dc21f94aaaaf 100644
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
index 45698cd15b7b..bd6ea40f3ef9 100644
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
index 53e9dfacd073..3ea4168f28f7 100644
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
index 995093357c59..f74f0e473119 100644
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
index 483dff986a23..30052da1f1a4 100644
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
index 0536bc021cc6..b417be09196d 100644
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
index bfeb8f3c0be6..203767dbeb64 100644
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
index df69bfd2b006..4ec669f5b0d4 100644
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
index 78d201fb6c87..b6f41f6b6c70 100644
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
diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
index cd7114147ae7..6660ac807d5a 100644
--- a/arch/mips/kvm/mips.c
+++ b/arch/mips/kvm/mips.c
@@ -1191,7 +1191,7 @@ int __init kvm_mips_init(void)
 	 * requires TLBs. The TLB handling code is statically linked with
 	 * the rest of the kernel (tlb.c) to avoid the possibility of
 	 * double faulting. The issue is that the TLB code references
-	 * routines that are part of the the KVM module, which are only
+	 * routines that are part of the KVM module, which are only
 	 * available once the module is loaded.
 	 */
 	kvm_mips_gfn_to_pfn = gfn_to_pfn;
diff --git a/arch/mips/mm/c-octeon.c b/arch/mips/mm/c-octeon.c
index 05b1d7cf9514..1647426364b9 100644
--- a/arch/mips/mm/c-octeon.c
+++ b/arch/mips/mm/c-octeon.c
@@ -350,7 +350,7 @@ static void co_cache_error_call_notifiers(unsigned long val)
 }
 
 /*
- * Called when the the exception is recoverable
+ * Called when the exception is recoverable
  */
 
 asmlinkage void cache_parity_error_octeon_recoverable(void)
@@ -359,7 +359,7 @@ asmlinkage void cache_parity_error_octeon_recoverable(void)
 }
 
 /**
- * Called when the the exception is not recoverable
+ * Called when the exception is not recoverable
  */
 
 asmlinkage void cache_parity_error_octeon_non_recoverable(void)
diff --git a/arch/mips/netlogic/xlr/fmn.c b/arch/mips/netlogic/xlr/fmn.c
index d428e8471eec..1d1eb1e10ae2 100644
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
diff --git a/arch/powerpc/include/asm/cache.h b/arch/powerpc/include/asm/cache.h
index 34a05a1a990b..af6f17b32531 100644
--- a/arch/powerpc/include/asm/cache.h
+++ b/arch/powerpc/include/asm/cache.h
@@ -52,7 +52,7 @@ static inline void logmpp(u64 x)
 /*
  * For a snooping icache, we still need a dummy icbi to purge all the
  * prefetched instructions from the ifetch buffers. We also need a sync
- * before the icbi to order the the actual stores to memory that might
+ * before the icbi to order the actual stores to memory that might
  * have modified instructions with the icbi.
  */
 #define PURGE_PREFETCHED_INS	\
diff --git a/arch/powerpc/include/asm/epapr_hcalls.h b/arch/powerpc/include/asm/epapr_hcalls.h
index 334459ad145b..b3219b0ca2c4 100644
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
index ac6432d9be46..a18702780733 100644
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
index d48125d0c048..01ecece4ca83 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -94,7 +94,7 @@ __secondary_hold_acknowledge:
 #ifdef CONFIG_RELOCATABLE
 	/* This flag is set to 1 by a loader if the kernel should run
 	 * at the loaded address instead of the linked address.  This
-	 * is used by kexec-tools to keep the the kdump kernel in the
+	 * is used by kexec-tools to keep the kdump kernel in the
 	 * crash_kernel region.  The loader is responsible for
 	 * observing the alignment requirement.
 	 */
diff --git a/arch/powerpc/mm/gup.c b/arch/powerpc/mm/gup.c
index d8746684f606..a97b81d5cfa6 100644
--- a/arch/powerpc/mm/gup.c
+++ b/arch/powerpc/mm/gup.c
@@ -168,7 +168,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * the pagetables from being freed on powerpc.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_save(flags);
 
diff --git a/arch/powerpc/mm/hugetlbpage.c b/arch/powerpc/mm/hugetlbpage.c
index 7e70ae968e5f..bf66090de7cc 100644
--- a/arch/powerpc/mm/hugetlbpage.c
+++ b/arch/powerpc/mm/hugetlbpage.c
@@ -933,7 +933,7 @@ void flush_dcache_icache_hugepage(struct page *page)
  * (4) hugepd pointer, bottom two bits == 00, next 4 bits indicate size of table
  *
  * So long as we atomically load page table pointers we are safe against teardown,
- * we can follow the address down to the the page and take a ref on it.
+ * we can follow the address down to the page and take a ref on it.
  */
 
 pte_t *find_linux_pte_or_hugepte(pgd_t *pgdir, unsigned long ea, unsigned *shift)
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 692998244d2c..a2ce00831362 100644
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
index 7044fd36197b..864ced973445 100644
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
index df241b11d4f7..b7bb2977e87a 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1421,7 +1421,7 @@ static void pnv_pci_init_ioda_msis(struct pnv_phb *phb) { }
 
 /*
  * This function is supposed to be called on basis of PE from top
- * to bottom style. So the the I/O or MMIO segment assigned to
+ * to bottom style. So the I/O or MMIO segment assigned to
  * parent PE could be overrided by its child PEs if necessary.
  */
 static void pnv_ioda_setup_pe_seg(struct pci_controller *hose,
diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index ea0c7b2ef030..a0b4797a296d 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1128,7 +1128,7 @@ static void debug_sample_entry(struct hws_combined_entry *sample,
  * combined-sampling data entry consists of a basic- and a diagnostic-sampling
  * data entry.	The sampling function is determined by the flags in the perf
  * event hardware structure.  The function always works with a combined-sampling
- * data entry but ignores the the diagnostic portion if it is not available.
+ * data entry but ignores the diagnostic portion if it is not available.
  *
  * Note that the implementation focuses on basic-sampling data entries and, if
  * such an entry is not valid, the entire combined-sampling data entry is
diff --git a/arch/s390/mm/gup.c b/arch/s390/mm/gup.c
index 639fce464008..2f03d7badf95 100644
--- a/arch/s390/mm/gup.c
+++ b/arch/s390/mm/gup.c
@@ -187,7 +187,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * prevent the pagetables from being freed on s390.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
diff --git a/arch/sparc/kernel/pci.c b/arch/sparc/kernel/pci.c
index b36365f49478..ef36086d3db1 100644
--- a/arch/sparc/kernel/pci.c
+++ b/arch/sparc/kernel/pci.c
@@ -306,7 +306,7 @@ static struct pci_dev *of_create_pci_dev(struct pci_pbm_info *pbm,
 	/* We can't actually use the firmware value, we have
 	 * to read what is in the register right now.  One
 	 * reason is that in the case of IDE interfaces the
-	 * firmware can sample the value before the the IDE
+	 * firmware can sample the value before the IDE
 	 * interface is programmed into native mode.
 	 */
 	pci_read_config_dword(dev, PCI_CLASS_REVISION, &class);
diff --git a/arch/sparc/mm/gup.c b/arch/sparc/mm/gup.c
index 1aed0432c64b..74ed2d607036 100644
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -189,7 +189,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 * the pagetables from being freed on sparc.
 	 *
 	 * So long as we atomically load page table pointers versus teardown,
-	 * we can follow the address down to the the page and take a ref on it.
+	 * we can follow the address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 
diff --git a/arch/tile/include/asm/irqflags.h b/arch/tile/include/asm/irqflags.h
index 71af5747874d..f7f64c80c5b2 100644
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
index df10a662cc25..50a3d5cbad20 100644
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
index de07fa7d1315..c554ffbb50f7 100644
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
index 54f1c8068c02..04266c294db1 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -71,7 +71,7 @@ static __always_inline int arch_spin_value_unlocked(arch_spinlock_t lock)
  * the queue, and the other indicating the current tail. The lock is acquired
  * by atomically noting the tail and incrementing it by one (thus adding
  * ourself to the queue and noting our position), then waiting until the head
- * becomes equal to the the initial value of the tail.
+ * becomes equal to the initial value of the tail.
  *
  * We use an xadd covering *both* parts of the lock, to increment the tail and
  * also load the position of the head, which takes care of memory ordering
diff --git a/arch/x86/include/asm/uv/uv_hub.h b/arch/x86/include/asm/uv/uv_hub.h
index c63e925fd6b7..361144223ed7 100644
--- a/arch/x86/include/asm/uv/uv_hub.h
+++ b/arch/x86/include/asm/uv/uv_hub.h
@@ -512,7 +512,7 @@ static inline int uv_numa_blade_id(void)
 	return uv_hub_info->numa_blade_id;
 }
 
-/* Convert a cpu number to the the UV blade number */
+/* Convert a cpu number to the UV blade number */
 static inline int uv_cpu_to_blade_id(int cpu)
 {
 	return uv_cpu_to_blade[cpu];
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8f1e22d3b286..5dc89fb405be 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7219,7 +7219,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
 	if (current->mm == kvm->mm) {
 		/*
 		 * Free memory regions allocated on behalf of userspace,
-		 * unless the the memory map has changed due to process exit
+		 * unless the memory map has changed due to process exit
 		 * or fd copying.
 		 */
 		struct kvm_userspace_memory_region mem;
diff --git a/arch/x86/mm/gup.c b/arch/x86/mm/gup.c
index 207d9aef662d..a1f84cebb9aa 100644
--- a/arch/x86/mm/gup.c
+++ b/arch/x86/mm/gup.c
@@ -288,7 +288,7 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 *
 	 * So long as we atomically load page table pointers versus teardown
 	 * (which we do on x86, with the above PAE exception), we can follow the
-	 * address down to the the page and take a ref on it.
+	 * address down to the page and take a ref on it.
 	 */
 	local_irq_save(flags);
 	pgdp = pgd_offset(mm, addr);
@@ -360,7 +360,7 @@ int get_user_pages_fast(unsigned long start, int nr_pages, int write,
 	 *
 	 * So long as we atomically load page table pointers versus teardown
 	 * (which we do on x86, with the above PAE exception), we can follow the
-	 * address down to the the page and take a ref on it.
+	 * address down to the page and take a ref on it.
 	 */
 	local_irq_disable();
 	pgdp = pgd_offset(mm, addr);
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index 2e555163c2fe..80e25d7659a2 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -472,7 +472,7 @@ char * __init xen_memory_setup(void)
 	 *  - mfn_list
 	 *  - xen_start_info
 	 * See comment above "struct start_info" in <xen/interface/xen.h>
-	 * We tried to make the the memblock_reserve more selective so
+	 * We tried to make the memblock_reserve more selective so
 	 * that it would be clear what region is reserved. Sadly we ran
 	 * in the problem wherein on a 64-bit hypervisor with a 32-bit
 	 * initial domain, the pt_base has the cr3 value which is not
diff --git a/arch/xtensa/include/asm/initialize_mmu.h b/arch/xtensa/include/asm/initialize_mmu.h
index 600781edc8a3..2e1d20d0b71f 100644
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
diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 82bbfa5a05b3..ccadbfd6645e 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -384,7 +384,7 @@ common_exception:
 	/* Save optional registers. */
 
 	save_xtregs_opt a1 a2 a4 a5 a6 a7 PT_XTREGS_OPT
-	
+
 #ifdef CONFIG_TRACE_IRQFLAGS
 	l32i	a4, a1, PT_DEPC
 	/* Double exception means we came here with an exception
@@ -433,7 +433,7 @@ common_exception_return:
 	 * We need to check some flags for signal handling and rescheduling,
 	 * and have to restore WB and WS, extra states, and all registers
 	 * in the register file that were in use in the user task.
-	 * Note that we don't disable interrupts here. 
+	 * Note that we don't disable interrupts here.
 	 */
 
 	_bbsi.l	a4, TIF_NEED_RESCHED, 3f
@@ -830,14 +830,14 @@ ENDPROC(unrecoverable_exception)
  * of the proper size instead.
  *
  * This algorithm simply backs out the register changes started by the user
- * excpetion handler, makes it appear that we have started a window underflow
+ * exception handler, makes it appear that we have started a window underflow
  * by rotating the window back and then setting the old window base (OWB) in
  * the 'ps' register with the rolled back window base. The 'movsp' instruction
  * will be re-executed and this time since the next window frames is in the
  * active AR registers it won't cause an exception.
  *
  * If the WindowUnderflow code gets a TLB miss the page will get mapped
- * the the partial windeowUnderflow will be handeled in the double exception
+ * and the partial windeowUnderflow will be handled in the double exception
  * handler.
  *
  * Entry condition:
@@ -1567,8 +1567,8 @@ ENTRY(fast_second_level_miss)
 
 2:	/* Special case for cache aliasing.
 	 * We (should) only get here if a clear_user_page, copy_user_page
-	 * or the aliased cache flush functions got preemptively interrupted 
-	 * by another task. Re-establish temporary mapping to the 
+	 * or the aliased cache flush functions got preemptively interrupted
+	 * by another task. Re-establish temporary mapping to the
 	 * TLBTEMP_BASE areas.
 	 */
 
diff --git a/crypto/asymmetric_keys/pkcs7_parser.h b/crypto/asymmetric_keys/pkcs7_parser.h
index d25f4d15370f..31a2ee79dae7 100644
--- a/crypto/asymmetric_keys/pkcs7_parser.h
+++ b/crypto/asymmetric_keys/pkcs7_parser.h
@@ -42,7 +42,7 @@ struct pkcs7_signed_info {
 	 *
 	 * This contains the generated digest of _either_ the Content Data or
 	 * the Authenticated Attributes [RFC2315 9.3].  If the latter, one of
-	 * the attributes contains the digest of the the Content Data within
+	 * the attributes contains the digest of the Content Data within
 	 * it.
 	 */
 	struct public_key_signature sig;
diff --git a/drivers/acpi/acpica/accommon.h b/drivers/acpi/acpica/accommon.h
index 6f1c616910ac..826a754954f3 100644
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
diff --git a/drivers/acpi/acpica/tbfadt.c b/drivers/acpi/acpica/tbfadt.c
index 41519a958083..75e61da5d998 100644
--- a/drivers/acpi/acpica/tbfadt.c
+++ b/drivers/acpi/acpica/tbfadt.c
@@ -435,7 +435,7 @@ void acpi_tb_create_local_fadt(struct acpi_table_header *table, u32 length)
  * The 64-bit X fields are optional extensions to the original 32-bit FADT
  * V1.0 fields. Even if they are present in the FADT, they are optional and
  * are unused if the BIOS sets them to zero. Therefore, we must copy/expand
- * 32-bit V1.0 fields to the 64-bit X fields if the the 64-bit X field is
+ * 32-bit V1.0 fields to the 64-bit X fields if the 64-bit X field is
  * originally zero.
  *
  * For ACPI 1.0 FADTs (that contain no 64-bit addresses), all 32-bit address
diff --git a/drivers/char/apm-emulation.c b/drivers/char/apm-emulation.c
index dd9dfa15e9d1..d086acf9562f 100644
--- a/drivers/char/apm-emulation.c
+++ b/drivers/char/apm-emulation.c
@@ -563,7 +563,7 @@ static int apm_suspend_notifier(struct notifier_block *nb,
 		wake_up_interruptible(&apm_waitqueue);
 
 		/*
-		 * Wait for the the suspend_acks_pending variable to drop to
+		 * Wait for the suspend_acks_pending variable to drop to
 		 * zero, meaning everybody acked the suspend event (or the
 		 * process was killed.)
 		 *
diff --git a/drivers/char/xilinx_hwicap/fifo_icap.c b/drivers/char/xilinx_hwicap/fifo_icap.c
index 02225eb19cf6..619f3a30ec55 100644
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
index e431d11abf8d..231f0149c540 100644
--- a/drivers/cpuidle/driver.c
+++ b/drivers/cpuidle/driver.c
@@ -168,7 +168,7 @@ static void __cpuidle_driver_init(struct cpuidle_driver *drv)
 	/*
 	 * Look for the timer stop flag in the different states, so that we know
 	 * if the broadcast timer has to be set up.  The loop is in the reverse
-	 * order, because usually one of the deeper states have this flag set.
+	 * order, because usually one of the deeper states has this flag set.
 	 */
 	for (i = drv->state_count - 1; i >= 0 ; i--) {
 		if (drv->states[i].flags & CPUIDLE_FLAG_TIMER_STOP) {
diff --git a/drivers/crypto/picoxcell_crypto.c b/drivers/crypto/picoxcell_crypto.c
index 5da5b98b8f29..60f2267c1350 100644
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
index 1c73f4fbc252..2f2a4276a014 100644
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
index 3784e81e7762..d548a717d5b9 100644
--- a/drivers/gpio/gpio-ich.c
+++ b/drivers/gpio/gpio-ich.c
@@ -471,7 +471,7 @@ static int ichx_gpio_probe(struct platform_device *pdev)
 
 	/*
 	 * If necessary, determine the I/O address of ACPI/power management
-	 * registers which are needed to read the the GPE0 register for GPI pins
+	 * registers which are needed to read the GPE0 register for GPI pins
 	 * 0 - 15 on some chipsets.
 	 */
 	if (!ichx_priv.desc->uses_gpe0)
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 41e91d70301e..9b43e701db28 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -111,7 +111,7 @@ static int sch_gpio_core_direction_out(struct gpio_chip *gc,
 	/*
 	 * according to the datasheet, writing to the level register has no
 	 * effect when GPIO is programmed as input.
-	 * Actually the the level register is read-only when configured as input.
+	 * Actually the level register is read-only when configured as input.
 	 * Thus presetting the output level before switching to output is _NOT_ possible.
 	 * Hence we set the level after configuring the GPIO as output.
 	 * But we cannot prevent a short low pulse if direction is set to high
@@ -201,7 +201,7 @@ static int sch_gpio_resume_direction_out(struct gpio_chip *gc,
 	/*
 	* according to the datasheet, writing to the level register has no
 	* effect when GPIO is programmed as input.
-	* Actually the the level register is read-only when configured as input.
+	* Actually the level register is read-only when configured as input.
 	* Thus presetting the output level before switching to output is _NOT_ possible.
 	* Hence we set the level after configuring the GPIO as output.
 	* But we cannot prevent a short low pulse if direction is set to high
diff --git a/drivers/gpu/drm/drm_mm.c b/drivers/gpu/drm/drm_mm.c
index 04a209e2b66d..ff92d4c5e379 100644
--- a/drivers/gpu/drm/drm_mm.c
+++ b/drivers/gpu/drm/drm_mm.c
@@ -529,12 +529,12 @@ EXPORT_SYMBOL(drm_mm_replace_node);
  *
  * The DRM range allocator supports this use-case through the scanning
  * interfaces. First a scan operation needs to be initialized with
- * drm_mm_init_scan() or drm_mm_init_scan_with_range(). The the driver adds
+ * drm_mm_init_scan() or drm_mm_init_scan_with_range(). The driver adds
  * objects to the roaster (probably by walking an LRU list, but this can be
  * freely implemented) until a suitable hole is found or there's no further
  * evitable object.
  *
- * The the driver must walk through all objects again in exactly the reverse
+ * The driver must walk through all objects again in exactly the reverse
  * order to restore the allocator state. Note that while the allocator is used
  * in the scan mode no other operation is allowed.
  *
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index ad55b06a3cb1..a73c82dff95f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2366,7 +2366,7 @@ int __i915_add_request(struct intel_engine_cs *ring,
 
 	/* Whilst this request exists, batch_obj will be on the
 	 * active_list, and so will hold the active reference. Only when this
-	 * request is retired will the the batch_obj be moved onto the
+	 * request is retired will the batch_obj be moved onto the
 	 * inactive_list and lose its active reference. Hence we do not need
 	 * to explicitly hold another reference here.
 	 */
diff --git a/drivers/gpu/drm/i915/i915_gem_userptr.c b/drivers/gpu/drm/i915/i915_gem_userptr.c
index d38413997379..7a6a4fed2833 100644
--- a/drivers/gpu/drm/i915/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/i915_gem_userptr.c
@@ -225,7 +225,7 @@ i915_mmu_notifier_add(struct drm_device *dev,
 		 * either has cancelled gup work queued and we need to
 		 * return back to the user to give time for the gup-workers
 		 * to flush their object references upon which the object will
-		 * be removed from the interval-tree, or the the range is
+		 * be removed from the interval-tree, or the range is
 		 * still in use by another client and the overlap is invalid.
 		 *
 		 * If we do have an overlap, we cannot use the interval tree
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index d8324c69fa86..7b3d64f2ad3f 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2607,7 +2607,7 @@ void intel_display_handle_reset(struct drm_device *dev)
 	 * will get its events and not get stuck.
 	 *
 	 * Also update the base address of all primary
-	 * planes to the the last fb to make sure we're
+	 * planes to the last fb to make sure we're
 	 * showing the correct fb after a reset.
 	 *
 	 * Need to make two loops over the crtcs so that we
@@ -10854,7 +10854,7 @@ static int __intel_set_mode(struct drm_crtc *crtc,
 	}
 
 	/* Only after disabling all output pipelines that will be changed can we
-	 * update the the output configuration. */
+	 * update the output configuration. */
 	intel_modeset_update_state(dev, prepare_pipes);
 
 	if (dev_priv->display.modeset_global_resources)
diff --git a/drivers/gpu/drm/radeon/atombios.h b/drivers/gpu/drm/radeon/atombios.h
index 92be50c39ffd..2be3040b28f1 100644
--- a/drivers/gpu/drm/radeon/atombios.h
+++ b/drivers/gpu/drm/radeon/atombios.h
@@ -2802,8 +2802,8 @@ ucMaxNBVoltageHigh:     Voltage regulator dependent PWM value. High 8 bits of  t
 ucMinNBVoltageHigh:     Voltage regulator dependent PWM value. High 8 bits of the value for the min voltage.Set this one to 0x00 if VC without PWM or no VC at all.
 
 
-usInterNBVoltageLow:    Voltage regulator dependent PWM value. The value makes the the voltage >=Min NB voltage but <=InterNBVoltageHigh. Set this to 0x0000 if VC without PWM or no VC at all.
-usInterNBVoltageHigh:   Voltage regulator dependent PWM value. The value makes the the voltage >=InterNBVoltageLow but <=Max NB voltage.Set this to 0x0000 if VC without PWM or no VC at all.
+usInterNBVoltageLow:    Voltage regulator dependent PWM value. The value makes the voltage >=Min NB voltage but <=InterNBVoltageHigh. Set this to 0x0000 if VC without PWM or no VC at all.
+usInterNBVoltageHigh:   Voltage regulator dependent PWM value. The value makes the voltage >=InterNBVoltageLow but <=Max NB voltage.Set this to 0x0000 if VC without PWM or no VC at all.
 */
 
 
diff --git a/drivers/gpu/drm/radeon/r300_reg.h b/drivers/gpu/drm/radeon/r300_reg.h
index 00c0d2ba22d3..36af5f14f622 100644
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
index 12c8329644c4..212cc45defc7 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -379,7 +379,7 @@ void radeon_doorbell_free(struct radeon_device *rdev, u32 doorbell)
 
 /*
  * radeon_wb_*()
- * Writeback is the the method by which the the GPU updates special pages
+ * Writeback is the method by which the GPU updates special pages
  * in memory with the status of certain GPU events (fences, ring pointers,
  * etc.).
  */
diff --git a/drivers/gpu/drm/radeon/radeon_fence.c b/drivers/gpu/drm/radeon/radeon_fence.c
index 913787085dfa..d616aea4a52c 100644
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
diff --git a/drivers/gpu/drm/radeon/radeon_vm.c b/drivers/gpu/drm/radeon/radeon_vm.c
index 088ffdc2f577..6dbaac58c81e 100644
--- a/drivers/gpu/drm/radeon/radeon_vm.c
+++ b/drivers/gpu/drm/radeon/radeon_vm.c
@@ -40,8 +40,8 @@
  * can be mapped as snooped (cached system pages) or unsnooped
  * (uncached system pages).
  * Each VM has an ID associated with it and there is a page table
- * associated with each VMID.  When execting a command buffer,
- * the kernel tells the the ring what VMID to use for that command
+ * associated with each VMID.  When executing a command buffer,
+ * the kernel tells the ring what VMID to use for that command
  * buffer.  VMIDs are allocated dynamically as commands are submitted.
  * The userspace drivers maintain their own address space and the kernel
  * sets up their pages tables accordingly when they submit their
diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 531a593912ec..90947e08e44d 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -553,7 +553,7 @@ EXPORT_SYMBOL_GPL(vmbus_close);
  * vmbus_sendpacket() - Send the specified buffer on the given channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
- * @bufferlen: Maximum size of what the the buffer will hold
+ * @bufferlen: Maximum size of what the buffer will hold
  * @requestid: Identifier of the request
  * @type: Type of packet that is being send e.g. negotiate, time
  * packet etc.
@@ -730,7 +730,7 @@ EXPORT_SYMBOL_GPL(vmbus_sendpacket_multipagebuffer);
  * vmbus_recvpacket() - Retrieve the user packet on the specified channel
  * @channel: Pointer to vmbus_channel structure.
  * @buffer: Pointer to the buffer you want to receive the data into.
- * @bufferlen: Maximum size of what the the buffer will hold
+ * @bufferlen: Maximum size of what the buffer will hold
  * @buffer_actual_len: The actual size of the data after it was received
  * @requestid: Identifier of the request
  *
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 4d6b26979fbd..5a358e591403 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -849,8 +849,8 @@ void vmbus_device_unregister(struct hv_device *device_obj)
 
 
 /*
- * VMBUS is an acpi enumerated device. Get the the information we
- * need from DSDT.
+ * VMBUS is an acpi enumerated device. Get the IRQ information
+ * from DSDT.
  */
 
 static acpi_status vmbus_walk_resources(struct acpi_resource *res, void *ctx)
diff --git a/drivers/hwmon/pmbus/ucd9200.c b/drivers/hwmon/pmbus/ucd9200.c
index 033d6aca47d3..d41d7e3bf31c 100644
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
index 28cfe97cf1e9..231b54591e2b 100644
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
index c00ae093b6f8..6b6499a690af 100644
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
index 8c7d94200bdb..c1418e619f0c 100644
--- a/drivers/input/mouse/gpio_mouse.c
+++ b/drivers/input/mouse/gpio_mouse.c
@@ -17,7 +17,7 @@
 
 /*
  * Timer function which is run every scan_ms ms when the device is opened.
- * The dev input variable is set to the the input_dev pointer.
+ * The dev input variable is set to the input_dev pointer.
  */
 static void gpio_mouse_scan(struct input_polled_dev *dev)
 {
diff --git a/drivers/isdn/hardware/mISDN/hfcsusb.c b/drivers/isdn/hardware/mISDN/hfcsusb.c
index 114f3bcba1b0..24c15bfb2199 100644
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
index 6590558d1d31..010d3c6cd5f4 100644
--- a/drivers/lguest/core.c
+++ b/drivers/lguest/core.c
@@ -202,7 +202,7 @@ void __lgwrite(struct lg_cpu *cpu, unsigned long addr, const void *b,
 /*:*/
 
 /*H:030
- * Let's jump straight to the the main loop which runs the Guest.
+ * Let's jump straight to the main loop which runs the Guest.
  * Remember, this is called by the Launcher reading /dev/lguest, and we keep
  * going around and around until something interesting happens.
  */
diff --git a/drivers/media/dvb-frontends/tda1002x.h b/drivers/media/dvb-frontends/tda1002x.h
index e404b6e44802..ce0fb855c705 100644
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
index 71fb63299de7..17534ff576ca 100644
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
index a9907265ff66..1f8820f5f8c0 100644
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
index 2ad65eb29832..00e0818abfc9 100644
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
index 1bf06970ca3e..ab627dfd7b28 100644
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
index 33b9660b7f77..6ea16e20449d 100644
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
index 3d2babd5067a..b8181874a149 100644
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
index 2c7aa6720569..5b8a0e779d0f 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -1710,7 +1710,7 @@ void omap3isp_print_status(struct isp_device *isp)
  * To solve this problem power management support is split into prepare/complete
  * and suspend/resume operations. The pipelines are stopped in prepare() and the
  * ISP clocks get disabled in suspend(). Similarly, the clocks are reenabled in
- * resume(), and the the pipelines are restarted in complete().
+ * resume(), and the pipelines are restarted in complete().
  *
  * TODO: PM dependencies between the ISP and sensors are not modelled explicitly
  * yet.
diff --git a/drivers/media/usb/dvb-usb/friio-fe.c b/drivers/media/usb/dvb-usb/friio-fe.c
index d56f927fc31a..b5d2e805380d 100644
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
index 474a17e4db0c..4c7f8fed8046 100644
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
index 0f461ca10cb9..82d19dcdebc0 100644
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
index 52bdb569760b..414c1b752911 100644
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
index 2e8c3afe4ec4..b7b5a1f630af 100644
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
index 9144a2f3ed82..62adffa2bd50 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1000,7 +1000,7 @@ static int uvc_video_decode_start(struct uvc_streaming *stream,
 	}
 
 	/* Synchronize to the input stream by waiting for the FID bit to be
-	 * toggled when the the buffer state is not UVC_BUF_STATE_ACTIVE.
+	 * toggled when the buffer state is not UVC_BUF_STATE_ACTIVE.
 	 * stream->last_fid is initialized to -1, so the first isochronous
 	 * frame will always be in sync.
 	 *
diff --git a/drivers/media/v4l2-core/v4l2-ioctl.c b/drivers/media/v4l2-core/v4l2-ioctl.c
index d15e16737eef..32d8d6a07e99 100644
--- a/drivers/media/v4l2-core/v4l2-ioctl.c
+++ b/drivers/media/v4l2-core/v4l2-ioctl.c
@@ -981,7 +981,7 @@ static void v4l_sanitize_format(struct v4l2_format *fmt)
 	/*
 	 * The v4l2_pix_format structure has been extended with fields that were
 	 * not previously required to be set to zero by applications. The priv
-	 * field, when set to a magic value, indicates the the extended fields
+	 * field, when set to a magic value, indicates that the extended fields
 	 * are valid. Otherwise they will contain undefined values. To simplify
 	 * the API towards drivers zero the extended fields and set the priv
 	 * field to the magic value when the extended pixel format structure
diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 04644e7b42b1..303b322756c7 100644
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
index 787933d43d32..4328cf6ecf13 100644
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
index 193cf168ba84..5d03af1f5103 100644
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
diff --git a/drivers/misc/mic/bus/mic_bus.c b/drivers/misc/mic/bus/mic_bus.c
index 961ae90aae47..1b15af8c5101 100644
--- a/drivers/misc/mic/bus/mic_bus.c
+++ b/drivers/misc/mic/bus/mic_bus.c
@@ -17,7 +17,7 @@
  *
  * Intel MIC Bus driver.
  *
- * This implementation is very similar to the the virtio bus driver
+ * This implementation is very similar to the virtio bus driver
  * implementation @ drivers/virtio/virtio.c
  */
 #include <linux/slab.h>
diff --git a/drivers/misc/sgi-gru/grukservices.c b/drivers/misc/sgi-gru/grukservices.c
index 913de07e577c..6482a9c4eb44 100644
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
index 95c894482fdd..f87520cfb787 100644
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
index 959cb9b70310..c5b1237ecb33 100644
--- a/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
+++ b/drivers/mtd/nand/gpmi-nand/gpmi-nand.c
@@ -942,7 +942,7 @@ static uint8_t gpmi_read_byte(struct mtd_info *mtd)
 /*
  * Handles block mark swapping.
  * It can be called in swapping the block mark, or swapping it back,
- * because the the operations are the same.
+ * because the operations are the same.
  */
 static void block_mark_swapping(struct gpmi_nand_data *this,
 				void *payload, void *auxiliary)
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7bf416329c19..3430b17875b5 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -252,7 +252,7 @@ struct ubi_fm_pool {
 
 /**
  * struct ubi_volume - UBI volume description data structure.
- * @dev: device object to make use of the the Linux device model
+ * @dev: device object to make use of the Linux device model
  * @cdev: character device object to create character device
  * @ubi: reference to the UBI device description object
  * @vol_id: volume ID
@@ -380,7 +380,7 @@ struct ubi_debug_info {
 
 /**
  * struct ubi_device - UBI device description structure
- * @dev: UBI device object to use the the Linux device model
+ * @dev: UBI device object to use for the Linux device model
  * @cdev: character device object to create character device
  * @ubi_num: UBI device number
  * @ubi_name: UBI device name
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 20f491713145..72b64109a22f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -727,7 +727,7 @@ static int prot_queue_del(struct ubi_device *ubi, int pnum)
 /**
  * sync_erase - synchronously erase a physical eraseblock.
  * @ubi: UBI device description object
- * @e: the the physical eraseblock to erase
+ * @e: the physical eraseblock to erase
  * @torture: if the physical eraseblock has to be tortured
  *
  * This function returns zero in case of success and a negative error code in
diff --git a/drivers/net/can/xilinx_can.c b/drivers/net/can/xilinx_can.c
index 5e8b5609c067..ad5bfe8618a6 100644
--- a/drivers/net/can/xilinx_can.c
+++ b/drivers/net/can/xilinx_can.c
@@ -532,7 +532,7 @@ static int xcan_rx(struct net_device *ndev)
  * @isr:	interrupt status register value
  *
  * This is the CAN error interrupt and it will
- * check the the type of error and forward the error
+ * check the type of error and forward the error
  * frame to upper layers.
  */
 static void xcan_err_interrupt(struct net_device *ndev, u32 isr)
diff --git a/drivers/net/ethernet/calxeda/xgmac.c b/drivers/net/ethernet/calxeda/xgmac.c
index 25d6b2a10e4e..a6fa3c211f69 100644
--- a/drivers/net/ethernet/calxeda/xgmac.c
+++ b/drivers/net/ethernet/calxeda/xgmac.c
@@ -1234,7 +1234,7 @@ static int xgmac_rx(struct xgmac_priv *priv, int limit)
  *  @budget : maximum number of packets that the current CPU can receive from
  *	      all interfaces.
  *  Description :
- *   This function implements the the reception process.
+ *   This function implements the reception process.
  *   Also it runs the TX completion thread
  */
 static int xgmac_poll(struct napi_struct *napi, int budget)
diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 93ff8ef39352..50a7353a85c8 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2363,7 +2363,7 @@ static irqreturn_t be_intx(int irq, void *dev)
 	}
 	be_eq_notify(adapter, eqo->q.id, false, true, num_evts);
 
-	/* Return IRQ_HANDLED only for the the first spurious intr
+	/* Return IRQ_HANDLED only for the first spurious intr
 	 * after a valid intr to stop the kernel from branding
 	 * this irq as a bad one!
 	 */
diff --git a/drivers/net/ethernet/intel/e1000/e1000_hw.c b/drivers/net/ethernet/intel/e1000/e1000_hw.c
index 1acf5034db10..ee82072b4c08 100644
--- a/drivers/net/ethernet/intel/e1000/e1000_hw.c
+++ b/drivers/net/ethernet/intel/e1000/e1000_hw.c
@@ -3986,7 +3986,7 @@ static s32 e1000_do_read_eeprom(struct e1000_hw *hw, u16 offset, u16 words,
  * @hw: Struct containing variables accessed by shared code
  *
  * Reads the first 64 16 bit words of the EEPROM and sums the values read.
- * If the the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
+ * If the sum of the 64 16 bit words is 0xBABA, the EEPROM's checksum is
  * valid.
  */
 s32 e1000_validate_eeprom_checksum(struct e1000_hw *hw)
diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.c b/drivers/net/ethernet/intel/e1000e/ich8lan.c
index 48b74a549155..392eb5748897 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.c
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.c
@@ -3892,7 +3892,7 @@ static s32 e1000_id_led_init_pchlan(struct e1000_hw *hw)
  *  @hw: pointer to the HW structure
  *
  *  ICH8 use the PCI Express bus, but does not contain a PCI Express Capability
- *  register, so the the bus width is hard coded.
+ *  register, so the bus width is hard coded.
  **/
 static s32 e1000_get_bus_info_ich8lan(struct e1000_hw *hw)
 {
diff --git a/drivers/net/ethernet/intel/igb/e1000_82575.c b/drivers/net/ethernet/intel/igb/e1000_82575.c
index 236a6183a865..0172e6b70eee 100644
--- a/drivers/net/ethernet/intel/igb/e1000_82575.c
+++ b/drivers/net/ethernet/intel/igb/e1000_82575.c
@@ -2166,7 +2166,7 @@ out:
  *  igb_reset_mdicnfg_82580 - Reset MDICNFG destination and com_mdio bits
  *  @hw: pointer to the HW structure
  *
- *  This resets the the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
+ *  This resets the MDICNFG.Destination and MDICNFG.Com_MDIO bits based on
  *  the values found in the EEPROM.  This addresses an issue in which these
  *  bits are not restored from EEPROM after reset.
  **/
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 87bd53fdd209..81e6836f38ee 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -229,7 +229,7 @@ static void ixgbe_check_minimum_link(struct ixgbe_adapter *adapter,
 	enum pcie_link_width width = PCIE_LNK_WIDTH_UNKNOWN;
 	struct pci_dev *pdev;
 
-	/* determine whether to use the the parent device
+	/* determine whether to use the parent device
 	 */
 	if (ixgbe_pcie_from_parent(&adapter->hw))
 		pdev = adapter->pdev->bus->parent->self;
diff --git a/drivers/net/ethernet/neterion/s2io.c b/drivers/net/ethernet/neterion/s2io.c
index f5e4b820128b..aad8fdb4dfc6 100644
--- a/drivers/net/ethernet/neterion/s2io.c
+++ b/drivers/net/ethernet/neterion/s2io.c
@@ -2158,7 +2158,7 @@ static int verify_xena_quiescence(struct s2io_nic *sp)
 
 	/*
 	 * In PCI 33 mode, the P_PLL is not used, and therefore,
-	 * the the P_PLL_LOCK bit in the adapter_status register will
+	 * the P_PLL_LOCK bit in the adapter_status register will
 	 * not be asserted.
 	 */
 	if (!(val64 & ADAPTER_STATUS_P_PLL_LOCK) &&
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c b/drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c
index 3b67d60d4378..b8da6e89059a 100644
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
index 5a34e72bab9a..6113a29f01bc 100644
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
index 0b602951ff6b..4466ee71d1e4 100644
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
index f20886ade1cc..1f7b2b922fae 100644
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
index 1c584c4b019c..f34f24d362ed 100644
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
index dc6bd8cd9b83..e32154fe1732 100644
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
index 339d89f14d32..8c866de2fe43 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1173,7 +1173,7 @@ static int ath6kl_sdio_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
 	 *        Wait for first 4 bytes to be in FIFO
 	 *        If CONSERVATIVE_BMI_READ is enabled, also wait for
 	 *        a BMI command credit, which indicates that the ENTIRE
-	 *        response is available in the the FIFO
+	 *        response is available in the FIFO
 	 *
 	 *  CASE 3: length > 128
 	 *        Wait for the first 4 bytes to be in FIFO
diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index 9a2afa2c690b..5184d6cbcb90 100644
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
index 542a8d51d3b0..5c8f1e6da5dc 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1627,7 +1627,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index a1f1127d7808..24cce9db3ce0 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -1609,7 +1609,7 @@ struct wcn36xx_hal_config_bss_params {
 
 	/* HAL should update the existing BSS entry, if this flag is set.
 	 * UMAC will set this flag in case of reassoc, where we want to
-	 * resue the the old BSSID and still return success 0 = Add, 1 =
+	 * reuse the old BSSID and still return success 0 = Add, 1 =
 	 * Update */
 	u8 action;
 
@@ -1746,7 +1746,7 @@ struct wcn36xx_hal_config_bss_params_v1 {
 
 	/* HAL should update the existing BSS entry, if this flag is set.
 	 * UMAC will set this flag in case of reassoc, where we want to
-	 * resue the the old BSSID and still return success 0 = Add, 1 =
+	 * reuse the old BSSID and still return success 0 = Add, 1 =
 	 * Update */
 	u8 action;
 
@@ -3736,10 +3736,10 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
 	/* success or failure */
 	u32 status;
 
-	/* Length of the responce message */
+	/* Length of the response message */
 	u32 rsp_length;
 
-	/* FIXME: Currently considering the the responce will be less than
+	/* FIXME: Currently considering that the response will be less than
 	 * 100bytes */
 	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
 } __packed;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 1b474828d5b8..46a0d6575454 100644
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
index d6073f67b212..c2f550cfbf41 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h
@@ -189,7 +189,7 @@ enum iwl_tx_flags {
  *	cleared. Combination of RATE_MCS_*
  * @sta_id: index of destination station in FW station table
  * @sec_ctl: security control, TX_CMD_SEC_*
- * @initial_rate_index: index into the the rate table for initial TX attempt.
+ * @initial_rate_index: index into the rate table for initial TX attempt.
  *	Applied if TX_CMD_FLG_STA_RATE_MSK is set, normally 0 for data frames.
  * @key: security key
  * @next_frame_flags: TX_CMD_SEC_* and TX_CMD_NEXT_FRAME_*
@@ -552,7 +552,7 @@ struct iwl_extended_beacon_notif {
 
 /**
  * enum iwl_dump_control - dump (flush) control flags
- * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the the FIFO is empty
+ * @DUMP_TX_FIFO_FLUSH: Dump MSDUs until the FIFO is empty
  *	and the TFD queues are empty.
  */
 enum iwl_dump_control {
diff --git a/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c
index 6cc243f7cf60..8357397cf7d0 100644
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
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 2713f7acd35e..53618b0e29c0 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -262,7 +262,7 @@ free_and_exit:
  * This function is called when the 'fw_dump' file is opened for
  * reading.
  * This function dumps firmware memory in different files
- * (ex. DTCM, ITCM, SQRAM etc.) based on the the segments for
+ * (ex. DTCM, ITCM, SQRAM etc.) based on the segments for
  * debugging.
  */
 static ssize_t
diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio.c b/drivers/net/wireless/rsi/rsi_91x_sdio.c
index 8428858204a6..e1f05ad89d9e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio.c
@@ -596,7 +596,7 @@ static int rsi_sdio_host_intf_write_pkt(struct rsi_hw *adapter,
  * rsi_sdio_host_intf_read_pkt() - This function reads the packet
 				   from the device.
  * @adapter: Pointer to the adapter data structure.
- * @pkt: Pointer to the packet data to be read from the the device.
+ * @pkt: Pointer to the packet data to be read from the device.
  * @length: Length of the data to be read from the device.
  *
  * Return: 0 on success, -1 on failure.
@@ -627,7 +627,7 @@ int rsi_sdio_host_intf_read_pkt(struct rsi_hw *adapter,
  * rsi_init_sdio_interface() - This function does init specific to SDIO.
  *
  * @adapter: Pointer to the adapter data structure.
- * @pkt: Pointer to the packet data to be read from the the device.
+ * @pkt: Pointer to the packet data to be read from the device.
  *
  * Return: 0 on success, -1 on failure.
  */
diff --git a/drivers/net/wireless/ti/wl1251/acx.h b/drivers/net/wireless/ti/wl1251/acx.h
index 2bdec38699f4..bfe998947957 100644
--- a/drivers/net/wireless/ti/wl1251/acx.h
+++ b/drivers/net/wireless/ti/wl1251/acx.h
@@ -1243,7 +1243,7 @@ struct wl1251_acx_arp_filter {
 	u8 address[16];	/* The IP address used to filter ARP packets.
 			   ARP packets that do not match this address are
 			   dropped. When the IP Version is 4, the last 12
-			   bytes of the the address are ignored. */
+			   bytes of the address are ignored. */
 } __attribute__((packed));
 
 struct wl1251_acx_ac_cfg {
diff --git a/drivers/of/base.c b/drivers/of/base.c
index 293ed4b687ba..be53777b9f3d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1849,7 +1849,7 @@ static void of_alias_add(struct alias_prop *ap, struct device_node *np,
  * of_alias_scan - Scan all properties of 'aliases' node
  *
  * The function scans all the properties of 'aliases' node and populate
- * the the global lookup table with the properties.  It returns the
+ * the global lookup table with the properties.  It returns the
  * number of alias_prop found, or error code in error case.
  *
  * @dt_alloc:	An allocator that provides a virtual address to memory
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 6cd5160fc057..89f16d320ead 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -36,7 +36,7 @@
  *    when the bridge is scanned and it loses a refcount when the bridge
  *    is removed.
  *  - When a P2P bridge is present, we elevate the refcount on the subordinate
- *    bus. It loses the refcount when the the driver unloads.
+ *    bus. It loses the refcount when the driver unloads.
  */
 
 #define pr_fmt(fmt) "acpiphp_glue: " fmt
diff --git a/drivers/pcmcia/pxa2xx_hx4700.c b/drivers/pcmcia/pxa2xx_hx4700.c
index 7dfef3ee5b53..40511e39cea5 100644
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
diff --git a/drivers/pinctrl/nomadik/pinctrl-nomadik.c b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
index e7cab07eef47..37060a07f260 100644
--- a/drivers/pinctrl/nomadik/pinctrl-nomadik.c
+++ b/drivers/pinctrl/nomadik/pinctrl-nomadik.c
@@ -1250,7 +1250,7 @@ static int nmk_gpio_probe(struct platform_device *dev)
 	platform_set_drvdata(dev, nmk_chip);
 
 	/*
-	 * Let the generic code handle this edge IRQ, the the chained
+	 * Let the generic code handle this edge IRQ, the chained
 	 * handler will perform the actual work of handling the parent
 	 * interrupt.
 	 */
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 60464a2648aa..67a538ebea90 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1461,7 +1461,7 @@ static int at91_gpio_of_irq_setup(struct device_node *node,
 	writel_relaxed(~0, at91_gpio->regbase + PIO_IDR);
 
 	/*
-	 * Let the generic code handle this edge IRQ, the the chained
+	 * Let the generic code handle this edge IRQ, the chained
 	 * handler will perform the actual work of handling the parent
 	 * interrupt.
 	 */
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 750a20275664..b01c7698df02 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -298,8 +298,9 @@ int power_supply_uevent(struct device *dev, struct kobj_uevent_env *env)
 
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
index ccf54f06396b..2108302cc965 100644
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
index fd22c811cbe1..8a84e2e42ca2 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -3454,7 +3454,7 @@ static void qeth_flush_buffers(struct qeth_qdio_out_q *queue, int index,
 			if (!atomic_read(&queue->set_pci_flags_count)) {
 				/*
 				 * there's no outstanding PCI any more, so we
-				 * have to request a PCI to be sure the the PCI
+				 * have to request a PCI to be sure that the PCI
 				 * will wake at some time in the future then we
 				 * can flush packed buffers that might still be
 				 * hanging around, which can happen if no
diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index 2035b0d64351..e62a7346428a 100644
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
index 00ee0ed642aa..0b88610b9795 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -510,7 +510,7 @@ static void fcoe_interface_cleanup(struct fcoe_interface *fcoe)
  * @skb:      The receive skb
  * @netdev:   The associated net device
  * @ptype:    The packet_type structure which was used to register this handler
- * @orig_dev: The original net_device the the skb was received on.
+ * @orig_dev: The original net_device that the skb was received on.
  *	      (in case dev is a bond)
  *
  * Returns: 0 for success
@@ -2727,7 +2727,7 @@ module_exit(fcoe_exit);
  * fcoe_flogi_resp() - FCoE specific FLOGI and FDISC response handler
  * @seq: active sequence in the FLOGI or FDISC exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc FLOGI response handler.
@@ -2756,7 +2756,7 @@ done:
  * fcoe_logo_resp() - FCoE specific LOGO response handler
  * @seq: active sequence in the LOGO exchange
  * @fp: response frame, or error encoded in a pointer (timeout)
- * @arg: pointer the the fcoe_ctlr structure
+ * @arg: pointer to the fcoe_ctlr structure
  *
  * This handles MAC address management for FCoE, then passes control on to
  * the libfc LOGO response handler.
diff --git a/drivers/scsi/fcoe/fcoe_ctlr.c b/drivers/scsi/fcoe/fcoe_ctlr.c
index 34a1b1f333b4..65a53a9eb059 100644
--- a/drivers/scsi/fcoe/fcoe_ctlr.c
+++ b/drivers/scsi/fcoe/fcoe_ctlr.c
@@ -213,7 +213,7 @@ static int fcoe_sysfs_fcf_add(struct fcoe_fcf *new)
 		 * that doesn't have a priv (fcf was deleted). However,
 		 * libfcoe will always delete FCFs before trying to add
 		 * them. This is ensured because both recv_adv and
-		 * age_fcfs are protected by the the fcoe_ctlr's mutex.
+		 * age_fcfs are protected by the fcoe_ctlr's mutex.
 		 * This means that we should never get a FCF with a
 		 * non-NULL priv pointer.
 		 */
@@ -694,7 +694,7 @@ static int fcoe_ctlr_encaps(struct fcoe_ctlr *fip, struct fc_lport *lport,
  *
  * The caller must check that the length is a multiple of 4.
  * The SKB must have enough headroom (28 bytes) and tailroom (8 bytes).
- * The the skb must also be an fc_frame.
+ * The skb must also be an fc_frame.
  *
  * This is called from the lower-level driver with spinlocks held,
  * so we must not take a mutex here.
diff --git a/drivers/scsi/isci/host.h b/drivers/scsi/isci/host.h
index 22a9bb1abae1..025ec5c10978 100644
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
index 47a013fffae7..07af745220eb 100644
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
index c7ee81d01125..f22950b12b8b 100644
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
index 5d6fda72d659..ba330e56bfe7 100644
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
index 6eed9e76a166..20bdd0603108 100644
--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -1680,7 +1680,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * takes a default argument, a minimum and maximum argument.
  *
  * lpfc_##attr##_init: Initializes an attribute.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Validates the min and max values then sets the adapter config field
@@ -1713,7 +1713,7 @@ lpfc_##attr##_init(struct lpfc_hba *phba, uint val) \
  * into a function with the name lpfc_hba_queue_depth_set
  *
  * lpfc_##attr##_set: Sets an attribute value.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Description:
@@ -1846,7 +1846,7 @@ lpfc_##attr##_show(struct device *dev, struct device_attribute *attr, \
  * lpfc_##attr##_init: validates the min and max values then sets the
  * adapter config field accordingly, or uses the default if out of range
  * and prints an error message.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val: integer attribute value.
  *
  * Returns:
@@ -1878,7 +1878,7 @@ lpfc_##attr##_init(struct lpfc_vport *vport, uint val) \
  * lpfc_##attr##_set: validates the min and max values then sets the
  * adapter config field if in the valid range. prints error message
  * and does not set the parameter if invalid.
- * @phba: pointer the the adapter structure.
+ * @phba: pointer to the adapter structure.
  * @val:	integer attribute value.
  *
  * Returns:
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 7a5d81a65be8..5a447c2c6522 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5813,7 +5813,7 @@ reject_out:
  * @rrq: Pointer to the rrq struct.
  *
  * Build a ELS RRQ command and send it to the target. If the issue_iocb is
- * Successful the the completion handler will clear the RRQ.
+ * successful, the completion handler will clear the RRQ.
  *
  * Return codes
  *   0 - Successfully sent rrq els iocb.
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2a17e31265b8..fbad2c534691 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -2012,7 +2012,7 @@ static void lpfc_sli4_fcf_pri_list_del(struct lpfc_hba *phba,
  * @phba: pointer to lpfc hba data structure.
  * @fcf_index the index of the fcf record to update
  * This routine acquires the hbalock and then set the LPFC_FCF_FLOGI_FAILED
- * flag so the the round robin slection for the particular priority level
+ * flag so that the round robin selection for the particular priority level
  * will try a different fcf record that does not have this bit set.
  * If the fcf record is re-read for any reason this flag is cleared brfore
  * adding it to the priority list.
@@ -5727,7 +5727,7 @@ lpfc_nlp_get(struct lpfc_nodelist *ndlp)
 }
 
 /* This routine decrements the reference count for a ndlp structure. If the
- * count goes to 0, this indicates the the associated nodelist should be
+ * count goes to 0, this indicates that the associated nodelist should be
  * freed. Returning 1 indicates the ndlp resource has been released; on the
  * other hand, returning 0 indicates the ndlp resource has not been released
  * yet.
diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index a5769a9960ac..ae2d01f7e67d 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3903,7 +3903,7 @@ lpfc_sli4_async_link_evt(struct lpfc_hba *phba,
 	bf_set(lpfc_mbx_read_top_link_spd, la,
 	       lpfc_sli4_parse_latt_link_speed(phba, acqe_link));
 
-	/* Fake the the following irrelvant fields */
+	/* Fake the following irrelevant fields */
 	bf_set(lpfc_mbx_read_top_topology, la, LPFC_TOPOLOGY_PT_PT);
 	bf_set(lpfc_mbx_read_top_alpa_granted, la, 0);
 	bf_set(lpfc_mbx_read_top_il, la, 0);
diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index 1f292e29d566..d9a9ddbf1771 100644
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
index 32ada0505576..a24a0b1e59d4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -16748,7 +16748,7 @@ out:
  * the offset after the write object mailbox has completed. @size is used to
  * determine the end of the object and whether the eof bit should be set.
  *
- * Return 0 is successful and offset will contain the the new offset to use
+ * Return 0 is successful and offset will contain the new offset to use
  * for the next write.
  * Return negative value for error cases.
  **/
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index dd12c6fe57a6..7508ee4810a8 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3212,7 +3212,7 @@ int pm8001_mpi_local_phy_ctl(struct pm8001_hba_info *pm8001_ha, void *piomb)
  *
  * when HBA driver received the identify done event or initiate FIS received
  * event(for SATA), it will invoke this function to notify the sas layer that
- * the sas toplogy has formed, please discover the the whole sas domain,
+ * the sas toplogy has formed, please discover the whole sas domain,
  * while receive a broadcast(change) primitive just tell the sas
  * layer to discover the changed domain rather than the whole domain.
  */
diff --git a/drivers/spi/spi-ppc4xx.c b/drivers/spi/spi-ppc4xx.c
index 80b8408ac3e3..4cbdc43d509c 100644
--- a/drivers/spi/spi-ppc4xx.c
+++ b/drivers/spi/spi-ppc4xx.c
@@ -354,7 +354,7 @@ static void spi_ppc4xx_enable(struct ppc4xx_spi *hw)
 {
 	/*
 	 * On all 4xx PPC's the SPI bus is shared/multiplexed with
-	 * the 2nd I2C bus. We need to enable the the SPI bus before
+	 * the 2nd I2C bus. We need to enable the SPI bus before
 	 * using it.
 	 */
 
diff --git a/drivers/staging/android/ion/ion.c b/drivers/staging/android/ion/ion.c
index 270360912b2c..200ea0ccf7c4 100644
--- a/drivers/staging/android/ion/ion.c
+++ b/drivers/staging/android/ion/ion.c
@@ -901,7 +901,7 @@ void ion_pages_sync_for_device(struct device *dev, struct page *page,
 	sg_set_page(&sg, page, size, 0);
 	/*
 	 * This is not correct - sg_dma_address needs a dma_addr_t that is valid
-	 * for the the targeted device, but this works on the currently targeted
+	 * for the targeted device, but this works on the currently targeted
 	 * hardware.
 	 */
 	sg_dma_address(&sg) = page_to_phys(page);
diff --git a/drivers/staging/android/uapi/binder.h b/drivers/staging/android/uapi/binder.h
index 904adb7600cf..1dd36442263e 100644
--- a/drivers/staging/android/uapi/binder.h
+++ b/drivers/staging/android/uapi/binder.h
@@ -265,7 +265,7 @@ enum binder_driver_return_protocol {
 
 	BR_FAILED_REPLY = _IO('r', 17),
 	/*
-	 * The the last transaction (either a bcTRANSACTION or
+	 * The last transaction (either a bcTRANSACTION or
 	 * a bcATTEMPT_ACQUIRE) failed (e.g. out of memory).  No parameters.
 	 */
 };
diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 831b7c6fe494..3f1f28e2dce2 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -1234,7 +1234,7 @@ static void et1310_config_rxmac_regs(struct et131x_adapter *adapter)
 	/* Initialize the Space Available Register */
 	writel(0, &rxmac->space_avail);
 
-	/* Initialize the the mif_ctrl register
+	/* Initialize the mif_ctrl register
 	 * bit 3:  Receive code error. One or more nibbles were signaled as
 	 *	   errors  during the reception of the packet.  Clear this
 	 *	   bit in Gigabit, set it in 100Mbit.  This was derived
diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index fd1b75a3a569..6c40b3665521 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -364,7 +364,7 @@ int ll_file_release(struct inode *inode, struct file *file)
 	fd = LUSTRE_FPRIVATE(file);
 	LASSERT(fd != NULL);
 
-	/* The last ref on @file, maybe not the the owner pid of statahead.
+	/* The last ref on @file, maybe not the owner pid of statahead.
 	 * Different processes can open the same dir, "ll_opendir_key" means:
 	 * it is me that should stop the statahead thread. */
 	if (S_ISDIR(inode->i_mode) && lli->lli_opendir_key == fd &&
diff --git a/drivers/staging/lustre/lustre/ptlrpc/pinger.c b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
index 5e4e49fab63c..815c5866cb4b 100644
--- a/drivers/staging/lustre/lustre/ptlrpc/pinger.c
+++ b/drivers/staging/lustre/lustre/ptlrpc/pinger.c
@@ -447,7 +447,7 @@ struct timeout_item* ptlrpc_new_timeout(int time, enum timeout_event event,
 }
 
 /**
- * Register timeout event on the the pinger thread.
+ * Register timeout event on the pinger thread.
  * Note: the timeout list is an sorted list with increased timeout value.
  */
 static struct timeout_item*
diff --git a/drivers/staging/rtl8188eu/core/rtw_cmd.c b/drivers/staging/rtl8188eu/core/rtw_cmd.c
index 104b01fa0fad..803ddfb8d065 100644
--- a/drivers/staging/rtl8188eu/core/rtw_cmd.c
+++ b/drivers/staging/rtl8188eu/core/rtw_cmd.c
@@ -453,7 +453,7 @@ u8 rtw_joinbss_cmd(struct adapter  *padapter, struct wlan_network *pnetwork)
 
 	psecnetwork->IELength = 0;
 	/*  Added by Albert 2009/02/18 */
-	/*  If the the driver wants to use the bssid to create the connection. */
+	/*  If the driver wants to use the bssid to create the connection. */
 	/*  If not,  we have to copy the connecting AP's MAC address to it so that */
 	/*  the driver just has the bssid information for PMKIDList searching. */
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
index 73410ccfb1ec..ebefffd2e96a 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c
@@ -920,7 +920,7 @@ int ieee80211_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
 
 	int i;
 	struct ieee80211_rxb *rxb = NULL;
-	// cheat the the hdr type
+	/* cheat the hdr type */
 	hdr = (struct ieee80211_hdr_4addr *)skb->data;
 	stats = &ieee->stats;
 
diff --git a/drivers/staging/rtl8712/rtl871x_cmd.c b/drivers/staging/rtl8712/rtl871x_cmd.c
index d9c1561e3272..5aae4cce8477 100644
--- a/drivers/staging/rtl8712/rtl871x_cmd.c
+++ b/drivers/staging/rtl8712/rtl871x_cmd.c
@@ -527,7 +527,7 @@ u8 r8712_joinbss_cmd(struct _adapter  *padapter, struct wlan_network *pnetwork)
 		memcpy(&psecuritypriv->authenticator_ie[1],
 			&psecnetwork->IEs[12], (256-1));
 	psecnetwork->IELength = 0;
-	/* If the the driver wants to use the bssid to create the connection.
+	/* If the driver wants to use the bssid to create the connection.
 	 * If not,  we copy the connecting AP's MAC address to it so that
 	 * the driver just has the bssid information for PMKIDList searching.
 	 */
diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
index 7241a5a8731c..611cd1f6c555 100644
--- a/drivers/staging/rtl8723au/core/rtw_cmd.c
+++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
@@ -518,7 +518,7 @@ int rtw_joinbss_cmd23a(struct rtw_adapter *padapter,
 
 	psecnetwork->IELength = 0;
 	/*  Added by Albert 2009/02/18 */
-	/*  If the the driver wants to use the bssid to create the
+	/*  If the driver wants to use the bssid to create the
 	 *  connection. If not,  we have to copy the connecting AP's
 	 *  MAC address to it so that the driver just has the bssid
 	 *  information for PMKIDList searching. */
diff --git a/drivers/staging/unisys/common-spar/include/channels/iochannel.h b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
index 24e11858e0ee..0fce4fd54ce9 100644
--- a/drivers/staging/unisys/common-spar/include/channels/iochannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
@@ -595,7 +595,7 @@ struct uiscmdrsp_scsitaskmgmt {
 	    * For windows guests, this is a pointer to a location that a waiting
 	    * thread is testing to see if the taskmgmt command has completed.
 	    * When the rsp is received by guest, the thread receiving the
-	    * response uses this to notify the the thread waiting for taskmgmt
+	    * response uses this to notify the thread waiting for taskmgmt
 	    * command completion.  Its value is preserved by iopart & returned
 	    * as is in the task mgmt rsp. */
 	void *notifyresult;
@@ -642,7 +642,7 @@ struct uiscmdrsp_vdiskmgmt {
 	    * For windows guests, this is a pointer to a location that a waiting
 	    * thread is testing to see if the taskmgmt command has completed.
 	    * When the rsp is received by guest, the thread receiving the
-	    * response uses this to notify the the thread waiting for taskmgmt
+	    * response uses this to notify the thread waiting for taskmgmt
 	    * command completion.  Its value is preserved by iopart & returned
 	    * as is in the task mgmt rsp. */
 	void *notifyresult;
diff --git a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
index 8facb51143ae..9dc629f36cc1 100644
--- a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
@@ -68,11 +68,11 @@ typedef struct _ULTRA_VBUS_HEADERINFO {
 	u32 devInfoCount;	/* num of items in DevInfo member */
 	/* (this is the allocated size) */
 	u32 chpInfoByteOffset;	/* byte offset from beginning of this struct */
-	/* to the the ChpInfo struct (below) */
+	/* to the ChpInfo struct (below) */
 	u32 busInfoByteOffset;	/* byte offset from beginning of this struct */
-	/* to the the BusInfo struct (below) */
+	/* to the BusInfo struct (below) */
 	u32 devInfoByteOffset;	/* byte offset from beginning of this struct */
-	/* to the the DevInfo array (below) */
+	/* to the DevInfo array (below) */
 	u8 reserved[104];
 } ULTRA_VBUS_HEADERINFO;
 
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index d9443a968ddf..97f3d823c688 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -745,7 +745,7 @@ static int virtpci_device_resume(struct device *dev)
 
 /* For a child device just created on a client bus, fill in
  * information about the driver that is controlling this device into
- * the the appropriate slot within the vbus channel of the bus
+ * the appropriate slot within the vbus channel of the bus
  * instance.
  */
 static void fix_vbus_devInfo(struct device *dev, int devNo, int devType,
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index fbc5ebb5f761..c0664ec01fc2 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -411,7 +411,7 @@ target_emulate_set_target_port_groups(struct se_cmd *cmd)
 		} else {
 			/*
 			 * Extract the RELATIVE TARGET PORT IDENTIFIER to identify
-			 * the Target Port in question for the the incoming
+			 * the Target Port in question for the incoming
 			 * SET_TARGET_PORT_GROUPS op.
 			 */
 			rtpi = get_unaligned_be16(ptr + 2);
diff --git a/drivers/thunderbolt/ctl.h b/drivers/thunderbolt/ctl.h
index ba87d6e731dd..1a4ba247f160 100644
--- a/drivers/thunderbolt/ctl.h
+++ b/drivers/thunderbolt/ctl.h
@@ -44,7 +44,7 @@ struct tb_cfg_result {
 			    * If err = 1 then this is the port that send the
 			    * error.
 			    * If err = 0 and if this was a cfg_read/write then
-			    * this is the the upstream port of the responding
+			    * this is the upstream port of the responding
 			    * switch.
 			    * Otherwise the field is set to zero.
 			    */
diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 6234c75da33f..50294f31f227 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -313,8 +313,7 @@ static const int hrsl_to_error[] = {
 
 /*
  * See http://www.beyondlogic.org/usbnutshell/usb4.shtml#Control for a
- * reasonable overview of how control transfers use the the IN/OUT
- * tokens.
+ * reasonable overview of how control transfers use the IN/OUT tokens.
  */
 #define MAX3421_HXFR_BULK_IN(ep)	(0x00 | (ep))	/* bulk or interrupt */
 #define MAX3421_HXFR_SETUP		 0x10
diff --git a/drivers/usb/host/xhci-ring.c b/drivers/usb/host/xhci-ring.c
index abed30b82905..54674c03d22b 100644
--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -1652,7 +1652,7 @@ static void handle_port_status(struct xhci_hcd *xhci,
 
 	/*
 	 * Check to see if xhci-hub.c is waiting on RExit to U0 transition (or
-	 * RExit to a disconnect state).  If so, let the the driver know it's
+	 * RExit to a disconnect state).  If so, let the driver know it's
 	 * out of the RExit state.
 	 */
 	if (!DEV_SUPERSPEED(temp) &&
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index 01bf53392819..1b99a08ca2de 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -261,7 +261,7 @@ static int analyze_baud_rate(struct usb_serial_port *port, speed_t new_rate)
 		/*
 		 * Mike Isely <isely@pobox.com> 2-Feb-2008: The
 		 * Cypress app note that describes this mechanism
-		 * states the the low-speed part can't handle more
+		 * states that the low-speed part can't handle more
 		 * than 800 bytes/sec, in which case 4800 baud is the
 		 * safest speed for a part like that.
 		 */
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index dfd728a263d2..71636a617d89 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -429,7 +429,7 @@ static int write_parport_reg_nonblock(struct mos7715_parport *mos_parport,
 }
 
 /*
- * This is the the common top part of all parallel port callback operations that
+ * This is the common top part of all parallel port callback operations that
  * send synchronous messages to the device.  This implements convoluted locking
  * that avoids two scenarios: (1) a port operation is called after usbserial
  * has called our release function, at which point struct mos7715_parport has
diff --git a/drivers/usb/wusbcore/devconnect.c b/drivers/usb/wusbcore/devconnect.c
index 0677139c6065..d435940d5598 100644
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
index b7d4f6b75eef..caa4cb40334d 100644
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
diff --git a/drivers/video/fbdev/omap/sossi.c b/drivers/video/fbdev/omap/sossi.c
index d4e7684e7045..501bc08dc125 100644
--- a/drivers/video/fbdev/omap/sossi.c
+++ b/drivers/video/fbdev/omap/sossi.c
@@ -370,7 +370,7 @@ static void sossi_set_bits_per_cycle(int bpc)
 	int bus_pick_count, bus_pick_width;
 
 	/*
-	 * We set explicitly the the bus_pick_count as well, although
+	 * We set explicitly the bus_pick_count as well, although
 	 * with remapping/reordering disabled it will be calculated by HW
 	 * as (32 / bus_pick_width).
 	 */
diff --git a/drivers/video/fbdev/sis/sis_accel.c b/drivers/video/fbdev/sis/sis_accel.c
index ceb434c95c0d..9177b8056356 100644
--- a/drivers/video/fbdev/sis/sis_accel.c
+++ b/drivers/video/fbdev/sis/sis_accel.c
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
index 5b570b6efa28..ecbd6b7b6c9a 100644
--- a/fs/autofs4/dev-ioctl.c
+++ b/fs/autofs4/dev-ioctl.c
@@ -507,7 +507,7 @@ static int autofs_dev_ioctl_askumount(struct file *fp,
  * located path is the root of a mount we return 1 along with
  * the super magic of the mount or 0 otherwise.
  *
- * In both cases the the device number (as returned by
+ * In both cases the device number (as returned by
  * new_encode_dev()) is also returned.
  */
 static int autofs_dev_ioctl_ismountpoint(struct file *fp,
diff --git a/fs/btrfs/dev-replace.c b/fs/btrfs/dev-replace.c
index eea26e1b2fda..8ae32564e6d7 100644
--- a/fs/btrfs/dev-replace.c
+++ b/fs/btrfs/dev-replace.c
@@ -849,7 +849,7 @@ int btrfs_dev_replace_is_ongoing(struct btrfs_dev_replace *dev_replace)
 		 * something that can happen if the dev_replace
 		 * procedure is suspended by an umount and then
 		 * the tgtdev is missing (or "btrfs dev scan") was
-		 * not called and the the filesystem is remounted
+		 * not called and the filesystem is remounted
 		 * in degraded state. This does not stop the
 		 * dev_replace procedure. It needs to be canceled
 		 * manually if the cancelation is wanted.
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index 6528aa662181..6c5ce8e50f32 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -3402,7 +3402,7 @@ verbose_printk("btrfs: process_recorded_refs %llu\n", sctx->cur_ino);
 		/*
 		 * We may have refs where the parent directory does not exist
 		 * yet. This happens if the parent directories inum is higher
-		 * the the current inum. To handle this case, we create the
+		 * than the current inum. To handle this case, we create the
 		 * parent directory out of order. But we need to check if this
 		 * did already happen before due to other refs in the same dir.
 		 */
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 1d1ba083ca6e..3d5b414003b3 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2654,7 +2654,7 @@ int btrfs_sync_log(struct btrfs_trans_handle *trans,
 	mutex_unlock(&log_root_tree->log_mutex);
 
 	/*
-	 * nobody else is going to jump in and write the the ctree
+	 * nobody else is going to jump in and write the ctree
 	 * super here because the log_commit atomic below is protecting
 	 * us.  We must be called with a transaction handle pinning
 	 * the running transaction open, so a full commit can't hop
diff --git a/fs/dcache.c b/fs/dcache.c
index cb25a1a5e307..4a327e47b6b0 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1885,8 +1885,8 @@ EXPORT_SYMBOL(d_obtain_root);
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
index 4725a07f003c..bcdfbc7568d7 100644
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
index d9a17d0b124d..c9c6f2e5a0a0 100644
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
index bea662bd0ca6..3b94971b7b9b 100644
--- a/fs/ext4/inline.c
+++ b/fs/ext4/inline.c
@@ -271,7 +271,7 @@ static int ext4_create_inline_data(handle_t *handle,
 		len = 0;
 	}
 
-	/* Insert the the xttr entry. */
+	/* Insert the xttr entry. */
 	i.value = value;
 	i.value_len = len;
 
@@ -829,7 +829,7 @@ out:
 
 /*
  * Prepare the write for the inline data.
- * If the the data can be written into the inode, we just read
+ * If the data can be written into the inode, we just read
  * the page and make it uptodate, and start the journal.
  * Otherwise read the page, makes it dirty so that it can be
  * handle in writepages(the i_disksize update is left to the
diff --git a/fs/f2fs/segment.h b/fs/f2fs/segment.h
index ff483257283b..5b3f3135fb0a 100644
--- a/fs/f2fs/segment.h
+++ b/fs/f2fs/segment.h
@@ -150,7 +150,7 @@ struct seg_entry {
 	unsigned short valid_blocks;	/* # of valid blocks */
 	unsigned char *cur_valid_map;	/* validity bitmap of blocks */
 	/*
-	 * # of valid blocks and the validity bitmap stored in the the last
+	 * # of valid blocks and the validity bitmap stored in the last
 	 * checkpoint pack. This information is used by the SSR mode.
 	 */
 	unsigned short ckpt_valid_blocks;
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 4429d6d9217f..2d4e4ef09b73 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -259,7 +259,7 @@ static ssize_t kernfs_fop_read(struct file *file, char __user *user_buf,
  * There is no easy way for us to know if userspace is only doing a partial
  * write, so we don't support them. We expect the entire buffer to come on
  * the first write.  Hint: if you're writing a value, first read the file,
- * modify only the the value you're changing, then write entire buffer
+ * modify only the value you're changing, then write entire buffer
  * back.
  */
 static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
diff --git a/fs/ocfs2/localalloc.c b/fs/ocfs2/localalloc.c
index 044013455621..c0aa12bdb106 100644
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
index 5a6bd5d8779a..85438d16e633 100644
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
index 26bb55e9e8b6..37cdb83e1e24 100644
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
diff --git a/include/linux/mic_bus.h b/include/linux/mic_bus.h
index d5b5f76d57ef..91c32b80c6d1 100644
--- a/include/linux/mic_bus.h
+++ b/include/linux/mic_bus.h
@@ -17,7 +17,7 @@
  *
  * Intel MIC Bus driver.
  *
- * This implementation is very similar to the the virtio bus driver
+ * This implementation is very similar to the virtio bus driver
  * implementation @ include/linux/virtio.h.
  */
 #ifndef _MIC_BUS_H_
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 8981cc882ed2..0b3da6784a66 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -196,7 +196,7 @@ extern pgprot_t protection_map[16];
 #define FAULT_FLAG_USER		0x80	/* The fault originated in userspace */
 
 /*
- * vm_fault is filled by the the pagefault handler and passed to the vma's
+ * vm_fault is filled by the pagefault handler and passed to the vma's
  * ->fault function. The vma's ->fault is responsible for returning a bitmask
  * of VM_FAULT_xxx flags that give details about how the fault was handled.
  *
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 494f99e852da..f9f20ca81f51 100644
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
index abde271c18ae..51301dc8c0c5 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2697,7 +2697,7 @@ static inline bool skb_defer_rx_timestamp(struct sk_buff *skb)
  * must call this function to return the skb back to the stack, with
  * or without a timestamp.
  *
- * @skb: clone of the the original outgoing packet
+ * @skb: clone of the original outgoing packet
  * @hwtstamps: hardware time stamps, may be NULL if not available
  *
  */
diff --git a/include/net/caif/caif_layer.h b/include/net/caif/caif_layer.h
index 94e5ed64dc6d..e9a8d524ab06 100644
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
index 9bcb220bd4ad..f422729b30c3 100644
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
index c52b68577cb0..c9705a3eb3b7 100644
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
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 7543b3e51331..3c8f396825b8 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -142,7 +142,7 @@
  * record  locks, but are "owned" by the open file description, not the
  * process. This means that they are inherited across fork() like BSD (flock)
  * locks, and they are only released automatically when the last reference to
- * the the open file against which they were acquired is put.
+ * the open file against which they were acquired is put.
  */
 #define F_OFD_GETLK	36
 #define F_OFD_SETLK	37
diff --git a/init/Kconfig b/init/Kconfig
index e84c6423a2e5..19e94edc0ac8 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -848,8 +848,8 @@ config LOG_CPU_MAX_BUF_SHIFT
 	  used as it forces an exact (power of two) size of the ring buffer.
 
 	  The number of possible CPUs is used for this computation ignoring
-	  hotplugging making the compuation optimal for the the worst case
-	  scenerio while allowing a simple algorithm to be used from bootup.
+	  hotplugging making the computation optimal for the worst case
+	  scenario while allowing a simple algorithm to be used from bootup.
 
 	  Examples shift values and their meaning:
 		     17 => 128 KB for each CPU
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..ceb26e85e416 100644
--- a/init/main.c
+++ b/init/main.c
@@ -512,7 +512,7 @@ asmlinkage __visible void __init start_kernel(void)
 	debug_objects_early_init();
 
 	/*
-	 * Set up the the initial canary ASAP:
+	 * Set up the initial canary ASAP:
 	 */
 	boot_init_stack_canary();
 
diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 9019f15deab2..6e82ca9e2735 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -17,7 +17,7 @@
 
 #ifdef HAVE_JUMP_LABEL
 
-/* mutex to protect coming/going of the the jump_label table */
+/* mutex to protect coming/going of the jump_label table */
 static DEFINE_MUTEX(jump_label_mutex);
 
 void jump_label_lock(void)
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 1ce770687ea8..8cd9ce2a6bcc 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2878,7 +2878,7 @@ EXPORT_SYMBOL_GPL(kmsg_dump_get_line);
  * @len: length of line placed into buffer
  *
  * Start at the end of the kmsg buffer and fill the provided buffer
- * with as many of the the *youngest* kmsg records that fit into it.
+ * with as many of the *youngest* kmsg records that fit into it.
  * If the buffer is large enough, all available kmsg records will be
  * copied with a single call.
  *
diff --git a/kernel/smp.c b/kernel/smp.c
index aff8aa14f547..c6174667d632 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -622,7 +622,7 @@ EXPORT_SYMBOL(on_each_cpu_mask);
  * for all the required CPUs to finish. This may include the local
  * processor.
  * @cond_func:	A callback function that is passed a cpu id and
- *		the the info parameter. The function is called
+ *		the info parameter. The function is called
  *		with preemption disabled. The function should
  *		return a blooean value indicating whether to IPI
  *		the specified CPU.
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index b38fb2b9e237..612b68cd4599 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2881,7 +2881,7 @@ rb_decrement_entry(struct ring_buffer_per_cpu *cpu_buffer,
  * This function lets the user discard an event in the ring buffer
  * and then that event will not be read later.
  *
- * This function only works if it is called before the the item has been
+ * This function only works if it is called before the item has been
  * committed. It will try to free the event from the ring buffer
  * if another event has not been added behind it.
  *
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 1e031f2c9aba..6a76a7f29c3f 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -884,7 +884,7 @@ EXPORT_SYMBOL(bitmap_bitremap);
  * read it, you're overqualified for your current job.)
  *
  * In other words, @orig is mapped onto (surjectively) @dst,
- * using the the map { <n, m> | the n-th bit of @relmap is the
+ * using the map { <n, m> | the n-th bit of @relmap is the
  * m-th set bit of @relmap }.
  *
  * Any set bits in @orig above bit number W, where W is the
diff --git a/lib/dynamic_queue_limits.c b/lib/dynamic_queue_limits.c
index 0777c5a45fa0..2ad6fc394f07 100644
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
index 3eb3e4722b8e..9d4da0a6a6ed 100644
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
index e30e03932480..624d80430969 100644
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
index eeceeeb09019..fdd76586e1a4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1308,7 +1308,7 @@ static void return_unused_surplus_pages(struct hstate *h,
 	 * evenly across all nodes with memory. Iterate across these nodes
 	 * until we can no longer free unreserved surplus pages. This occurs
 	 * when the nodes with surplus pages have no free pages.
-	 * free_pool_huge_page() will balance the the freed pages across the
+	 * free_pool_huge_page() will balance the freed pages across the
 	 * on-line nodes with memory and will handle the hstate accounting.
 	 */
 	while (nr_pages--) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 18cee0d4c8a2..c9c9b33608f3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4222,7 +4222,7 @@ static int zone_batchsize(struct zone *zone)
  * locking.
  *
  * Any new users of pcp->batch and pcp->high should ensure they can cope with
- * those fields changing asynchronously (acording the the above rule).
+ * those fields changing asynchronously (according to the above rule).
  *
  * mutex_is_locked(&pcp_batch_high_lock) required when calling this function
  * outside of boot time (or some other assurance that no concurrent updaters
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index faff6247ac8f..9f4c71ba8dd1 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -966,7 +966,7 @@ static int hci_conn_auth(struct hci_conn *conn, __u8 sec_level, __u8 auth_type)
 	return 0;
 }
 
-/* Encrypt the the link */
+/* Encrypt the link */
 static void hci_conn_encrypt(struct hci_conn *conn)
 {
 	BT_DBG("hcon %p", conn);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 1d9c29a00568..5b2b17522561 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -1674,7 +1674,7 @@ static void hci_init3_req(struct hci_request *req, unsigned long opt)
 	 * Delete Stored Link Key command. They are clearly indicating its
 	 * absence in the bit mask of supported commands.
 	 *
-	 * Check the supported commands and only if the the command is marked
+	 * Check the supported commands and only if the command is marked
 	 * as supported send it. If not supported assume that the controller
 	 * does not have actual support for stored link keys which makes this
 	 * command redundant anyway.
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a88b8524846e..9d83a2e05baf 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1349,7 +1349,7 @@ static void sctp_select_active_and_retran_path(struct sctp_association *asoc)
 	}
 
 	/* We did not find anything useful for a possible retransmission
-	 * path; either primary path that we found is the the same as
+	 * path; either primary path that we found is the same as
 	 * the current one, or we didn't generally find an active one.
 	 */
 	if (trans_sec == NULL)
diff --git a/net/sctp/chunk.c b/net/sctp/chunk.c
index 158701da2d31..f0424e16beb7 100644
--- a/net/sctp/chunk.c
+++ b/net/sctp/chunk.c
@@ -199,7 +199,7 @@ struct sctp_datamsg *sctp_datamsg_from_user(struct sctp_association *asoc,
 		sizeof(struct sctphdr) - sizeof(struct sctp_data_chunk)) & ~3;
 
 	max = asoc->frag_point;
-	/* If the the peer requested that we authenticate DATA chunks
+	/* If the peer requested that we authenticate DATA chunks
 	 * we need to account for bundling of the AUTH chunks along with
 	 * DATA.
 	 */
diff --git a/net/sunrpc/auth_generic.c b/net/sunrpc/auth_generic.c
index 6f6b829c9e8e..1ef370a9f675 100644
--- a/net/sunrpc/auth_generic.c
+++ b/net/sunrpc/auth_generic.c
@@ -190,7 +190,7 @@ void rpc_destroy_generic_auth(void)
 }
 
 /*
- * Test the the current time (now) against the underlying credential key expiry
+ * Test the current time (now) against the underlying credential key expiry
  * minus a timeout and setup notification.
  *
  * The normal case:
diff --git a/net/wimax/op-rfkill.c b/net/wimax/op-rfkill.c
index 403078d670a9..b21863009913 100644
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
diff --git a/scripts/coccinelle/misc/badty.cocci b/scripts/coccinelle/misc/badty.cocci
index 2fc06fc71927..7bde383f577b 100644
--- a/scripts/coccinelle/misc/badty.cocci
+++ b/scripts/coccinelle/misc/badty.cocci
@@ -3,7 +3,7 @@
 //# This makes an effort to find cases where the argument to sizeof is wrong
 //# in memory allocation functions by checking the type of the allocated memory
 //# when it is a double pointer and ensuring the sizeof argument takes a pointer
-//# to the the memory being allocated. There are false positives in cases the
+//# to the memory being allocated. There are false positives in cases the
 //# sizeof argument is not used in constructing the return value. The result
 //# may need some reformatting.
 //
diff --git a/scripts/tracing/draw_functrace.py b/scripts/tracing/draw_functrace.py
index db40fa04cd51..9eb8c74b69a1 100644
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
index 3064c6ced87c..7b9769e7985a 100644
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
index e26f860e5f2e..112d40974504 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -474,7 +474,7 @@ error:
  * keyring, otherwise replace the link to the matching key with a link to the
  * new key.
  *
- * The key must grant the caller Link permission and the the keyring must grant
+ * The key must grant the caller Link permission and the keyring must grant
  * the caller Write permission.  Furthermore, if an additional link is created,
  * the keyring's quota will be extended.
  *
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index ec6a7d0d1886..e3ecc7538f8e 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -5110,7 +5110,7 @@ EXPORT_SYMBOL_GPL(snd_hda_power_save);
  * @nid: NID to check / update
  *
  * Check whether the given NID is in the amp list.  If it's in the list,
- * check the current AMP status, and update the the power-status according
+ * check the current AMP status, and update the power-status according
  * to the mute status.
  *
  * This function is supposed to be set or called from the check_power_status
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 98cd1908c039..f193b73de0f2 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -887,7 +887,7 @@ static int stac_auto_create_beep_ctls(struct hda_codec *codec,
 	static struct snd_kcontrol_new beep_vol_ctl =
 		HDA_CODEC_VOLUME(NULL, 0, 0, 0);
 
-	/* check for mute support for the the amp */
+	/* check for mute support for the amp */
 	if ((caps & AC_AMPCAP_MUTE) >> AC_AMPCAP_MUTE_SHIFT) {
 		const struct snd_kcontrol_new *temp;
 		if (spec->anabeep_nid == nid)
diff --git a/sound/pci/ice1712/prodigy192.c b/sound/pci/ice1712/prodigy192.c
index f3b491aa3e22..df5cb3b4b6e2 100644
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
index bddee30a4bc7..eaac777ee91d 100644
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
index a609aafc994d..3c1c7b71e69b 100644
--- a/sound/soc/fsl/fsl_dma.c
+++ b/sound/soc/fsl/fsl_dma.c
@@ -164,7 +164,7 @@ static void fsl_dma_abort_stream(struct snd_pcm_substream *substream)
 /**
  * fsl_dma_update_pointers - update LD pointers to point to the next period
  *
- * As each period is completed, this function changes the the link
+ * As each period is completed, this function changes the link
  * descriptor pointers for that period to point to the next period.
  */
 static void fsl_dma_update_pointers(struct fsl_dma_private *dma_private)
diff --git a/sound/sparc/dbri.c b/sound/sparc/dbri.c
index b2c3d0d5dca3..8dc8cc9b8348 100644
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
index b3b8abae62b8..6acad619044b 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -196,7 +196,7 @@ If specified the 'Weighted diff' column is displayed with value 'd' computed as:
 
   - period being the hist entry period value
 
-  - WEIGHT-A/WEIGHT-B being user suplied weights in the the '-c' option
+  - WEIGHT-A/WEIGHT-B being user suplied weights in the '-c' option
     behind ':' separator like '-c wdiff:1,2'.
     - WIEGHT-A being the weight of the data file
     - WIEGHT-B being the weight of the baseline data file
diff --git a/tools/power/x86/turbostat/turbostat.8 b/tools/power/x86/turbostat/turbostat.8
index 56bfb523c5bb..6940d8849434 100644
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
diff --git a/tools/thermal/tmon/pid.c b/tools/thermal/tmon/pid.c
index fd7e9e9d6f4a..1aa7faa0e0e0 100644
--- a/tools/thermal/tmon/pid.c
+++ b/tools/thermal/tmon/pid.c
@@ -38,7 +38,7 @@
 
 /**************************************************************************
  * PID (Proportional-Integral-Derivative) controller is commonly used in
- * linear control system, consider the the process.
+ * linear control system, consider the process.
  * G(s) = U(s)/E(s)
  * kp = proportional gain
  * ki = integral gain
-- 
1.9.1

