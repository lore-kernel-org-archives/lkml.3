Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaCEFzP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 00:55:15 -0500
Received: from top.free-electrons.com ([176.31.233.9]:46461 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753078AbaCEFzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 00:55:13 -0500
Message-ID: <5316BC3A.7060701@free-electrons.com>
Date: Wed, 05 Mar 2014 06:55:06 +0100
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: trivial@kernel.org
CC: arend@broadcom.com, linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: Re: [PATCH] [RESEND][TRIVIAL] treewide: fix occurrences of "the the
 "
References: <1386585386-7541-1-git-send-email-michael.opdenacker@free-electrons.com> <1393998723-4475-1-git-send-email-michael.opdenacker@free-electrons.com>
In-Reply-To: <1393998723-4475-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2014 06:52 AM, Michael Opdenacker wrote:
> Fix all occurrences of "the the " in the source code,
> comments and documentation.
>
> The replacement couldn't be automated because sometimes
> the first "the" was meant to be another word.
>
> Example: "according the the"
> meaning: "according to the"
>
> Note that I sometimes took the opportunity to fix
> other spelling issues or typos in the same sentences.
> I also fixed a few checkpatch errors in the same
> lines.
>
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
> ---
>  Documentation/ABI/testing/sysfs-devices-memory                 | 2 +-
>  Documentation/DocBook/media/v4l/controls.xml                   | 2 +-
>  Documentation/DocBook/media/v4l/vidioc-g-parm.xml              | 2 +-
>  Documentation/devicetree/bindings/arm/msm/timer.txt            | 2 +-
>  Documentation/devicetree/bindings/ata/cavium-compact-flash.txt | 2 +-
>  Documentation/devicetree/bindings/gpio/gpio-pcf857x.txt        | 2 +-
>  Documentation/devicetree/bindings/mtd/fsmc-nand.txt            | 2 +-
>  Documentation/filesystems/autofs4-mount-control.txt            | 6 +++---
>  Documentation/futex-requeue-pi.txt                             | 2 +-
>  Documentation/input/multi-touch-protocol.txt                   | 2 +-
>  Documentation/kmemcheck.txt                                    | 2 +-
>  Documentation/memory-barriers.txt                              | 2 +-
>  Documentation/networking/spider_net.txt                        | 2 +-
>  Documentation/phy.txt                                          | 2 +-
>  Documentation/power/devices.txt                                | 2 +-
>  Documentation/security/Smack.txt                               | 2 +-
>  Documentation/trace/ring-buffer-design.txt                     | 2 +-
>  Documentation/usb/WUSB-Design-overview.txt                     | 2 +-
>  Documentation/virtual/kvm/api.txt                              | 2 +-
>  Documentation/vm/unevictable-lru.txt                           | 2 +-
>  arch/arm/Kconfig                                               | 2 +-
>  arch/arm/include/asm/unwind.h                                  | 2 +-
>  arch/arm/mach-omap2/omap_hwmod.c                               | 6 +++---
>  arch/arm/mach-pxa/stargate2.c                                  | 2 +-
>  arch/blackfin/mach-common/entry.S                              | 2 +-
>  arch/c6x/platforms/cache.c                                     | 2 +-
>  arch/ia64/include/asm/spinlock.h                               | 2 +-
>  arch/ia64/include/asm/uv/uv_hub.h                              | 2 +-
>  arch/m68k/platform/coldfire/intc-2.c                           | 2 +-
>  arch/metag/kernel/process.c                                    | 2 +-
>  arch/microblaze/kernel/entry.S                                 | 2 +-
>  arch/mips/alchemy/devboards/pm.c                               | 2 +-
>  arch/mips/include/asm/octeon/cvmx-pip.h                        | 2 +-
>  arch/mips/include/asm/spinlock.h                               | 2 +-
>  arch/mips/kernel/smtc.c                                        | 2 +-
>  arch/mips/kvm/kvm_mips.c                                       | 2 +-
>  arch/mips/mm/c-octeon.c                                        | 4 ++--
>  arch/mips/netlogic/xlr/fmn.c                                   | 2 +-
>  arch/powerpc/include/asm/cache.h                               | 2 +-
>  arch/powerpc/include/asm/epapr_hcalls.h                        | 2 +-
>  arch/powerpc/include/asm/hw_breakpoint.h                       | 2 +-
>  arch/powerpc/kernel/head_64.S                                  | 2 +-
>  arch/powerpc/mm/gup.c                                          | 2 +-
>  arch/powerpc/mm/hugetlbpage.c                                  | 2 +-
>  arch/powerpc/platforms/52xx/mpc52xx_gpt.c                      | 2 +-
>  arch/powerpc/platforms/chrp/setup.c                            | 2 +-
>  arch/powerpc/platforms/powernv/pci-ioda.c                      | 2 +-
>  arch/s390/kernel/perf_cpum_sf.c                                | 2 +-
>  arch/s390/mm/gup.c                                             | 2 +-
>  arch/sparc/kernel/pci.c                                        | 2 +-
>  arch/sparc/mm/gup.c                                            | 2 +-
>  arch/tile/include/asm/irqflags.h                               | 2 +-
>  arch/tile/include/gxio/trio.h                                  | 2 +-
>  arch/tile/kernel/single_step.c                                 | 2 +-
>  arch/x86/include/asm/spinlock.h                                | 2 +-
>  arch/x86/include/asm/uv/uv_hub.h                               | 2 +-
>  arch/x86/kvm/x86.c                                             | 2 +-
>  arch/x86/mm/gup.c                                              | 4 ++--
>  arch/x86/xen/setup.c                                           | 2 +-
>  arch/xtensa/include/asm/initialize_mmu.h                       | 2 +-
>  arch/xtensa/kernel/entry.S                                     | 4 ++--
>  drivers/acpi/acpica/accommon.h                                 | 2 +-
>  drivers/acpi/acpica/tbfadt.c                                   | 2 +-
>  drivers/block/drbd/drbd_main.c                                 | 2 +-
>  drivers/char/apm-emulation.c                                   | 2 +-
>  drivers/char/xilinx_hwicap/fifo_icap.c                         | 2 +-
>  drivers/cpuidle/driver.c                                       | 2 +-
>  drivers/crypto/picoxcell_crypto.c                              | 2 +-
>  drivers/crypto/ux500/hash/hash_core.c                          | 2 +-
>  drivers/gpio/gpio-ich.c                                        | 2 +-
>  drivers/gpu/drm/i915/i915_gem.c                                | 2 +-
>  drivers/gpu/drm/i915/intel_display.c                           | 4 ++--
>  drivers/gpu/drm/radeon/atombios.h                              | 4 ++--
>  drivers/gpu/drm/radeon/r300_reg.h                              | 2 +-
>  drivers/gpu/drm/radeon/radeon_device.c                         | 2 +-
>  drivers/gpu/drm/radeon/radeon_fence.c                          | 2 +-
>  drivers/gpu/drm/radeon/radeon_gart.c                           | 2 +-
>  drivers/hv/channel.c                                           | 4 ++--
>  drivers/hv/vmbus_drv.c                                         | 2 +-
>  drivers/hwmon/pmbus/ucd9200.c                                  | 2 +-
>  drivers/infiniband/hw/ipath/ipath_common.h                     | 2 +-
>  drivers/infiniband/hw/qib/qib.h                                | 2 +-
>  drivers/input/mouse/gpio_mouse.c                               | 2 +-
>  drivers/input/touchscreen/atmel_mxt_ts.c                       | 2 +-
>  drivers/isdn/hardware/mISDN/hfcsusb.c                          | 2 +-
>  drivers/lguest/core.c                                          | 2 +-
>  drivers/media/dvb-frontends/tda1002x.h                         | 2 +-
>  drivers/media/dvb-frontends/tda10048.c                         | 2 +-
>  drivers/media/pci/cx88/cx88-dsp.c                              | 2 +-
>  drivers/media/pci/ivtv/ivtv-yuv.c                              | 2 +-
>  drivers/media/pci/saa7164/saa7164-core.c                       | 2 +-
>  drivers/media/platform/davinci/vpbe.c                          | 2 +-
>  drivers/media/platform/exynos4-is/fimc-capture.c               | 2 +-
>  drivers/media/platform/omap3isp/isp.c                          | 2 +-
>  drivers/media/usb/dvb-usb/friio-fe.c                           | 2 +-
>  drivers/media/usb/dvb-usb/friio.c                              | 2 +-
>  drivers/media/usb/dvb-usb/friio.h                              | 2 +-
>  drivers/media/usb/gspca/finepix.c                              | 2 +-
>  drivers/media/usb/tm6000/tm6000-cards.c                        | 2 +-
>  drivers/media/usb/uvc/uvc_video.c                              | 2 +-
>  drivers/memory/emif.c                                          | 2 +-
>  drivers/message/fusion/mptspi.c                                | 2 +-
>  drivers/mfd/db8500-prcmu.c                                     | 2 +-
>  drivers/misc/sgi-gru/grukservices.c                            | 2 +-
>  drivers/misc/sgi-xp/xpc_uv.c                                   | 2 +-
>  drivers/mtd/nand/gpmi-nand/gpmi-nand.c                         | 2 +-
>  drivers/mtd/ubi/ubi.h                                          | 4 ++--
>  drivers/mtd/ubi/wl.c                                           | 2 +-
>  drivers/net/ethernet/calxeda/xgmac.c                           | 2 +-
>  drivers/net/ethernet/chelsio/cxgb4/t4_hw.c                     | 2 +-
>  drivers/net/ethernet/emulex/benet/be_main.c                    | 2 +-
>  drivers/net/ethernet/intel/e1000/e1000_hw.c                    | 2 +-
>  drivers/net/ethernet/intel/e1000e/ich8lan.c                    | 2 +-
>  drivers/net/ethernet/intel/igb/e1000_82575.c                   | 2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c                  | 2 +-
>  drivers/net/ethernet/neterion/s2io.c                           | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_mdio.c              | 2 +-
>  drivers/net/wimax/i2400m/i2400m.h                              | 4 ++--
>  drivers/net/wimax/i2400m/rx.c                                  | 2 +-
>  drivers/net/wimax/i2400m/tx.c                                  | 2 +-
>  drivers/net/wireless/ath/ath10k/rx_desc.h                      | 2 +-
>  drivers/net/wireless/ath/ath6kl/hif.h                          | 2 +-
>  drivers/net/wireless/ath/ath6kl/sdio.c                         | 2 +-
>  drivers/net/wireless/ath/ath9k/ar9002_phy.c                    | 2 +-
>  drivers/net/wireless/ath/ath9k/ar9003_phy.c                    | 2 +-
>  drivers/net/wireless/ath/wcn36xx/hal.h                         | 6 +++---
>  drivers/net/wireless/brcm80211/brcmsmac/main.c                 | 2 +-
>  drivers/net/wireless/iwlwifi/mvm/fw-api-tx.h                   | 4 ++--
>  drivers/net/wireless/iwlwifi/mvm/phy-ctxt.c                    | 4 ++--
>  drivers/net/wireless/ti/wl1251/acx.h                           | 2 +-
>  drivers/of/base.c                                              | 2 +-
>  drivers/pci/hotplug/acpiphp_glue.c                             | 2 +-
>  drivers/pcmcia/pxa2xx_hx4700.c                                 | 2 +-
>  drivers/power/power_supply_sysfs.c                             | 5 +++--
>  drivers/rtc/rtc-rs5c372.c                                      | 2 +-
>  drivers/s390/net/qeth_core_main.c                              | 2 +-
>  drivers/scsi/bfa/bfa_fcs_rport.c                               | 2 +-
>  drivers/scsi/fcoe/fcoe.c                                       | 6 +++---
>  drivers/scsi/fcoe/fcoe_ctlr.c                                  | 4 ++--
>  drivers/scsi/isci/host.h                                       | 2 +-
>  drivers/scsi/isci/remote_device.h                              | 2 +-
>  drivers/scsi/isci/remote_node_context.h                        | 2 +-
>  drivers/scsi/isci/task.c                                       | 2 +-
>  drivers/scsi/lpfc/lpfc_attr.c                                  | 8 ++++----
>  drivers/scsi/lpfc/lpfc_els.c                                   | 2 +-
>  drivers/scsi/lpfc/lpfc_hbadisc.c                               | 4 ++--
>  drivers/scsi/lpfc/lpfc_init.c                                  | 2 +-
>  drivers/scsi/lpfc/lpfc_mbox.c                                  | 2 +-
>  drivers/scsi/lpfc/lpfc_sli.c                                   | 2 +-
>  drivers/scsi/pm8001/pm8001_hwi.c                               | 2 +-
>  drivers/spi/spi-ppc4xx.c                                       | 2 +-
>  drivers/staging/android/binder.h                               | 2 +-
>  drivers/staging/android/ion/ion.c                              | 2 +-
>  drivers/staging/et131x/et131x.c                                | 2 +-
>  drivers/staging/lustre/lustre/llite/file.c                     | 2 +-
>  drivers/staging/lustre/lustre/ptlrpc/pinger.c                  | 2 +-
>  drivers/staging/rtl8187se/ieee80211/ieee80211_rx.c             | 4 ++--
>  drivers/staging/rtl8188eu/core/rtw_cmd.c                       | 2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c              | 2 +-
>  drivers/staging/rtl8712/rtl871x_cmd.c                          | 2 +-
>  drivers/staging/sep/sep_main.c                                 | 6 +++---
>  drivers/staging/tidspbridge/include/dspbridge/drv.h            | 4 ++--
>  drivers/staging/tidspbridge/pmgr/dev.c                         | 2 +-
>  drivers/staging/wlags49_h2/README.wlags49                      | 2 +-
>  drivers/target/target_core_alua.c                              | 4 ++--
>  drivers/usb/host/xhci-ring.c                                   | 2 +-
>  drivers/usb/serial/cypress_m8.c                                | 2 +-
>  drivers/usb/serial/mos7720.c                                   | 2 +-
>  drivers/usb/wusbcore/devconnect.c                              | 2 +-
>  drivers/uwb/drp-ie.c                                           | 2 +-
>  drivers/video/omap/sossi.c                                     | 2 +-
>  drivers/video/sis/sis_accel.c                                  | 2 +-
>  fs/autofs4/dev-ioctl.c                                         | 2 +-
>  fs/btrfs/dev-replace.c                                         | 2 +-
>  fs/btrfs/send.c                                                | 2 +-
>  fs/btrfs/tree-log.c                                            | 2 +-
>  fs/dcache.c                                                    | 4 ++--
>  fs/ecryptfs/keystore.c                                         | 2 +-
>  fs/ext2/ext2.h                                                 | 2 +-
>  fs/ext4/inline.c                                               | 4 ++--
>  fs/f2fs/segment.h                                              | 2 +-
>  fs/kernfs/file.c                                               | 2 +-
>  fs/ocfs2/localalloc.c                                          | 2 +-
>  fs/xfs/xfs_export.c                                            | 2 +-
>  include/drm/drm_rect.h                                         | 2 +-
>  include/linux/mm.h                                             | 2 +-
>  include/linux/moduleparam.h                                    | 2 +-
>  include/linux/skbuff.h                                         | 2 +-
>  include/net/caif/caif_layer.h                                  | 2 +-
>  include/net/ip6_fib.h                                          | 2 +-
>  include/net/wimax.h                                            | 2 +-
>  init/main.c                                                    | 2 +-
>  kernel/jump_label.c                                            | 2 +-
>  kernel/printk/printk.c                                         | 2 +-
>  kernel/smp.c                                                   | 2 +-
>  kernel/trace/ring_buffer.c                                     | 2 +-
>  lib/bitmap.c                                                   | 2 +-
>  lib/dynamic_queue_limits.c                                     | 2 +-
>  lib/earlycpio.c                                                | 2 +-
>  lib/syscall.c                                                  | 2 +-
>  mm/hugetlb.c                                                   | 2 +-
>  mm/page_alloc.c                                                | 2 +-
>  net/bluetooth/hci_conn.c                                       | 2 +-
>  net/bluetooth/hci_core.c                                       | 2 +-
>  net/sctp/chunk.c                                               | 4 ++--
>  net/sunrpc/auth_generic.c                                      | 2 +-
>  net/tipc/link.c                                                | 2 +-
>  net/wimax/op-rfkill.c                                          | 2 +-
>  scripts/tracing/draw_functrace.py                              | 2 +-
>  security/apparmor/context.c                                    | 2 +-
>  security/keys/keyctl.c                                         | 2 +-
>  sound/pci/hda/hda_codec.c                                      | 2 +-
>  sound/pci/hda/patch_sigmatel.c                                 | 2 +-
>  sound/pci/ice1712/prodigy192.c                                 | 2 +-
>  sound/soc/codecs/wm9713.c                                      | 2 +-
>  sound/soc/fsl/fsl_dma.c                                        | 2 +-
>  sound/sparc/dbri.c                                             | 2 +-
>  tools/perf/Documentation/perf-diff.txt                         | 2 +-
>  tools/power/x86/turbostat/turbostat.8                          | 4 ++--
>  tools/thermal/tmon/pid.c                                       | 2 +-
>  220 files changed, 254 insertions(+), 253 deletions(-)
My patch didn't get picked last time. Shall I split it into many commits
and send them to individual maintainers? I would like to avoid creating
unnecessary commits in the kernel history, but if that's the only way...

Cheers,

Michael.
