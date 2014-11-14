Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161777AbaKNTiQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:38:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53280 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaKNTiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:38:12 -0500
Date: Fri, 14 Nov 2014 11:38:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.17.3
Message-ID: <20141114193811.GA23441@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.17.3 kernel.

All users of the 3.17 kernel series must upgrade.

The updated 3.17.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.17.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Makefile                                           |    2=20
 arch/arc/boot/dts/nsimosci.dts                     |    2=20
 arch/arc/include/asm/arcregs.h                     |    8=20
 arch/arc/include/asm/kgdb.h                        |   32 +-
 arch/arc/include/asm/processor.h                   |    9=20
 arch/arm/Kconfig.debug                             |    2=20
 arch/arm/boot/dts/zynq-parallella.dts              |    4=20
 arch/arm/mach-pxa/include/mach/addr-map.h          |    5=20
 arch/mips/include/asm/ftrace.h                     |    4=20
 arch/mips/include/uapi/asm/ptrace.h                |    2=20
 arch/mips/loongson/lemote-2f/clock.c               |    5=20
 arch/mips/math-emu/cp1emu.c                        |    4=20
 arch/mips/mm/tlbex.c                               |    6=20
 arch/powerpc/kernel/entry_64.S                     |    6=20
 arch/powerpc/platforms/powernv/opal-lpc.c          |   59 ++++
 arch/powerpc/platforms/pseries/dlpar.c             |    4=20
 arch/s390/kernel/topology.c                        |   18 -
 arch/sh/kernel/cpu/sh3/setup-sh770x.c              |    6=20
 arch/um/drivers/ubd_kern.c                         |    5=20
 arch/x86/ia32/ia32entry.S                          |   18 +
 arch/x86/include/asm/elf.h                         |    5=20
 arch/x86/include/asm/kvm_host.h                    |   16 +
 arch/x86/include/uapi/asm/vmx.h                    |    2=20
 arch/x86/kernel/acpi/boot.c                        |   16 -
 arch/x86/kernel/apb_timer.c                        |    2=20
 arch/x86/kernel/apic/apic.c                        |    4=20
 arch/x86/kernel/cpu/common.c                       |    2=20
 arch/x86/kernel/cpu/intel.c                        |   17 +
 arch/x86/kernel/iosf_mbi.c                         |    2=20
 arch/x86/kernel/signal.c                           |    5=20
 arch/x86/kernel/tsc.c                              |    5=20
 arch/x86/kernel/xsave.c                            |    7=20
 arch/x86/kvm/emulate.c                             |  295 +++++++++++++++-=
-----
 arch/x86/kvm/i8254.c                               |    2=20
 arch/x86/kvm/svm.c                                 |    8=20
 arch/x86/kvm/vmx.c                                 |   24 +
 arch/x86/kvm/x86.c                                 |   38 ++
 arch/x86/mm/pageattr.c                             |    2=20
 arch/x86/net/bpf_jit_comp.c                        |   25 +
 arch/x86/platform/intel-mid/sfi.c                  |    2=20
 block/blk-mq-tag.c                                 |    4=20
 block/blk-settings.c                               |    4=20
 block/scsi_ioctl.c                                 |    3=20
 crypto/algif_skcipher.c                            |    2=20
 drivers/acpi/device_pm.c                           |    2=20
 drivers/acpi/ec.c                                  |   25 +
 drivers/ata/libata-sff.c                           |   20 -
 drivers/ata/pata_serverworks.c                     |   13=20
 drivers/base/core.c                                |    4=20
 drivers/base/power/main.c                          |    2=20
 drivers/block/drbd/drbd_interval.c                 |    4=20
 drivers/block/rbd.c                                |    5=20
 drivers/block/xen-blkback/blkback.c                |    1=20
 drivers/block/xen-blkback/xenbus.c                 |    6=20
 drivers/char/random.c                              |    8=20
 drivers/cpufreq/cpufreq.c                          |   23 +
 drivers/cpufreq/intel_pstate.c                     |  110 ++++++-
 drivers/edac/cpc925_edac.c                         |    2=20
 drivers/edac/e7xxx_edac.c                          |    2=20
 drivers/edac/i3200_edac.c                          |    4=20
 drivers/edac/i82860_edac.c                         |    2=20
 drivers/gpu/drm/ast/ast_mode.c                     |    4=20
 drivers/gpu/drm/cirrus/cirrus_drv.c                |    2=20
 drivers/gpu/drm/i915/i915_gem_userptr.c            |   31 +-
 drivers/gpu/drm/i915/i915_irq.c                    |    5=20
 drivers/gpu/drm/i915/intel_display.c               |    5=20
 drivers/gpu/drm/i915/intel_dp.c                    |    7=20
 drivers/gpu/drm/i915/intel_panel.c                 |    8=20
 drivers/gpu/drm/nouveau/Makefile                   |    2=20
 drivers/gpu/drm/nouveau/core/engine/device/nv50.c  |   22 -
 drivers/gpu/drm/nouveau/core/engine/device/nvc0.c  |   14=20
 drivers/gpu/drm/nouveau/core/include/subdev/gpio.h |    2=20
 drivers/gpu/drm/nouveau/core/subdev/bios/dcb.c     |    1=20
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv92.c    |   74 -----
 drivers/gpu/drm/nouveau/core/subdev/gpio/nv94.c    |   74 +++++
 drivers/gpu/drm/nouveau/core/subdev/gpio/nvd0.c    |    4=20
 drivers/gpu/drm/nouveau/core/subdev/gpio/priv.h    |    4=20
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   12=20
 drivers/gpu/drm/nouveau/nv50_display.c             |   18 -
 drivers/gpu/drm/qxl/qxl_display.c                  |   16 -
 drivers/gpu/drm/radeon/cik_sdma.c                  |   21 -
 drivers/gpu/drm/radeon/dce3_1_afmt.c               |    4=20
 drivers/gpu/drm/radeon/dce6_afmt.c                 |    6=20
 drivers/gpu/drm/radeon/evergreen_hdmi.c            |    6=20
 drivers/gpu/drm/radeon/kv_dpm.c                    |   19 +
 drivers/gpu/drm/radeon/r600_dma.c                  |   21 -
 drivers/gpu/drm/radeon/radeon.h                    |    2=20
 drivers/gpu/drm/radeon/radeon_cs.c                 |    2=20
 drivers/gpu/drm/radeon/radeon_device.c             |    2=20
 drivers/gpu/drm/radeon/radeon_ring.c               |    4=20
 drivers/gpu/drm/radeon/radeon_vm.c                 |    4=20
 drivers/gpu/drm/radeon/si_dpm.c                    |    2=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                |   60 +++-
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.c                |    6=20
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |   16 -
 drivers/hid/hid-debug.c                            |    6=20
 drivers/hid/hid-ids.h                              |    7=20
 drivers/hid/hid-input.c                            |   12=20
 drivers/hid/usbhid/hid-core.c                      |   26 +
 drivers/hid/usbhid/hid-quirks.c                    |    5=20
 drivers/i2c/busses/i2c-at91.c                      |    2=20
 drivers/iio/common/st_sensors/st_sensors_buffer.c  |    2=20
 drivers/iio/proximity/as3935.c                     |    2=20
 drivers/infiniband/hw/mlx4/main.c                  |   10=20
 drivers/infiniband/ulp/isert/ib_isert.c            |    4=20
 drivers/input/mouse/alps.c                         |    4=20
 drivers/input/mouse/synaptics.c                    |   22 +
 drivers/input/mouse/synaptics.h                    |    8=20
 drivers/input/serio/i8042-x86ia64io.h              |   22 +
 drivers/iommu/amd_iommu.c                          |   27 -
 drivers/iommu/iommu.c                              |  163 ++++++-----
 drivers/irqchip/irq-armada-370-xp.c                |   23 +
 drivers/md/dm-bufio.c                              |    5=20
 drivers/md/dm-log-userspace-transfer.c             |    2=20
 drivers/media/common/siano/sms-cards.c             |    6=20
 drivers/media/common/siano/sms-cards.h             |    1=20
 drivers/media/dvb-frontends/ds3000.c               |    7=20
 drivers/media/i2c/tda7432.c                        |    2=20
 drivers/media/platform/Kconfig                     |    6=20
 drivers/media/platform/exynos4-is/Kconfig          |    2=20
 drivers/media/platform/s5p-tv/Kconfig              |    2=20
 drivers/media/rc/imon.c                            |    3=20
 drivers/media/rc/rc-ir-raw.c                       |    1=20
 drivers/media/rc/rc-main.c                         |    2=20
 drivers/media/tuners/m88ts2022.c                   |    2=20
 drivers/media/usb/em28xx/em28xx-cards.c            |   11=20
 drivers/media/usb/em28xx/em28xx-core.c             |   12=20
 drivers/media/usb/em28xx/em28xx-video.c            |   15 -
 drivers/media/usb/siano/smsusb.c                   |    2=20
 drivers/media/usb/uvc/uvc_driver.c                 |    9=20
 drivers/media/v4l2-core/v4l2-common.c              |    9=20
 drivers/media/v4l2-core/videobuf-dma-sg.c          |    6=20
 drivers/mfd/rtsx_pcr.c                             |    2=20
 drivers/mfd/ti_am335x_tscadc.c                     |    5=20
 drivers/mmc/core/sdio.c                            |   12=20
 drivers/mmc/core/sdio_irq.c                        |    4=20
 drivers/mmc/core/slot-gpio.c                       |    2=20
 drivers/mmc/host/mmc_spi.c                         |    1=20
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |    7=20
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |    7=20
 drivers/mmc/host/sdhci-pxav3.c                     |    3=20
 drivers/mmc/host/sdhci-s3c.c                       |    4=20
 drivers/mmc/host/sdhci-sirf.c                      |    1=20
 drivers/mmc/host/tmio_mmc_pio.c                    |    1=20
 drivers/mtd/chips/cfi_cmdset_0001.c                |    2=20
 drivers/mtd/devices/m25p80.c                       |   50 +++
 drivers/mtd/ubi/block.c                            |   25 +
 drivers/mtd/ubi/cdev.c                             |    4=20
 drivers/mtd/ubi/fastmap.c                          |    1=20
 drivers/net/Kconfig                                |    2=20
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |    1=20
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    7=20
 drivers/net/ethernet/mellanox/mlx4/mcg.c           |    4=20
 drivers/net/ethernet/stmicro/stmmac/stmmac_pci.c   |    7=20
 drivers/net/hyperv/netvsc_drv.c                    |    1=20
 drivers/net/macvlan.c                              |   10=20
 drivers/net/macvtap.c                              |    3=20
 drivers/net/ppp/ppp_generic.c                      |    2=20
 drivers/net/tun.c                                  |    6=20
 drivers/net/usb/ax88179_178a.c                     |    7=20
 drivers/net/vxlan.c                                |   15 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c        |   24 -
 drivers/net/wireless/iwlwifi/iwl-trans.h           |    2=20
 drivers/net/wireless/iwlwifi/mvm/coex.c            |    4=20
 drivers/net/wireless/iwlwifi/mvm/coex_legacy.c     |    4=20
 drivers/net/wireless/iwlwifi/mvm/fw-api-power.h    |   35 ++
 drivers/net/wireless/iwlwifi/mvm/fw-api.h          |    1=20
 drivers/net/wireless/iwlwifi/mvm/fw.c              |    9=20
 drivers/net/wireless/iwlwifi/mvm/ops.c             |    1=20
 drivers/net/wireless/iwlwifi/mvm/tx.c              |    8=20
 drivers/net/wireless/iwlwifi/pcie/trans.c          |   16 -
 drivers/net/wireless/rt2x00/rt2800.h               |    4=20
 drivers/net/wireless/rt2x00/rt2800lib.c            |    6=20
 drivers/net/wireless/rt2x00/rt2800usb.c            |    1=20
 drivers/of/base.c                                  |   88 +-----
 drivers/of/selftest.c                              |   66 ++++
 drivers/of/testcase-data/tests-phandle.dtsi        |    2=20
 drivers/pci/pci-sysfs.c                            |    8=20
 drivers/phy/phy-omap-usb2.c                        |    6=20
 drivers/pinctrl/pinctrl-baytrail.c                 |    2=20
 drivers/platform/x86/acer-wmi.c                    |   11=20
 drivers/platform/x86/samsung-laptop.c              |   10=20
 drivers/power/charger-manager.c                    |    5=20
 drivers/regulator/max77693.c                       |    2=20
 drivers/rtc/Kconfig                                |    2=20
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   11=20
 drivers/scsi/scsi_lib.c                            |    5=20
 drivers/spi/spi-fsl-dspi.c                         |    4=20
 drivers/spi/spi-pl022.c                            |    2=20
 drivers/spi/spi-pxa2xx.c                           |    7=20
 drivers/staging/comedi/comedi_fops.c               |   18 -
 drivers/staging/iio/adc/mxs-lradc.c                |   12=20
 drivers/staging/iio/impedance-analyzer/ad5933.c    |   15 -
 drivers/staging/iio/meter/ade7758.h                |    1=20
 drivers/staging/iio/meter/ade7758_core.c           |   57 ----
 drivers/staging/iio/meter/ade7758_ring.c           |    5=20
 drivers/target/target_core_device.c                |    3=20
 drivers/target/target_core_pr.c                    |    6=20
 drivers/target/target_core_pr.h                    |    2=20
 drivers/target/target_core_tpg.c                   |    8=20
 drivers/target/target_core_transport.c             |    3=20
 drivers/tty/serial/msm_serial.c                    |   22 -
 drivers/tty/serial/serial_core.c                   |    2=20
 drivers/tty/tty_io.c                               |    7=20
 drivers/tty/vt/consolemap.c                        |    7=20
 drivers/usb/chipidea/core.c                        |    1=20
 drivers/usb/class/cdc-acm.c                        |   20 +
 drivers/usb/class/cdc-acm.h                        |    2=20
 drivers/usb/core/hcd.c                             |    2=20
 drivers/usb/core/hub.c                             |    3=20
 drivers/usb/core/quirks.c                          |   10=20
 drivers/usb/dwc3/dwc3-omap.c                       |   15 -
 drivers/usb/dwc3/ep0.c                             |    4=20
 drivers/usb/dwc3/gadget.c                          |   19 -
 drivers/usb/dwc3/gadget.h                          |    2=20
 drivers/usb/gadget/function/f_acm.c                |    7=20
 drivers/usb/gadget/function/f_fs.c                 |   42 ++
 drivers/usb/gadget/udc/udc-core.c                  |    5=20
 drivers/usb/host/Kconfig                           |    4=20
 drivers/usb/host/xhci-pci.c                        |   18 -
 drivers/usb/musb/musb_cppi41.c                     |    3=20
 drivers/usb/musb/musb_dsps.c                       |    4=20
 drivers/usb/serial/cp210x.c                        |    1=20
 drivers/usb/serial/ftdi_sio.c                      |    3=20
 drivers/usb/serial/ftdi_sio_ids.h                  |   12=20
 drivers/usb/serial/kobil_sct.c                     |    5=20
 drivers/usb/serial/opticon.c                       |    2=20
 drivers/usb/serial/option.c                        |   10=20
 drivers/usb/storage/transport.c                    |   26 +
 drivers/usb/storage/unusual_uas.h                  |   28 +
 drivers/video/console/bitblit.c                    |    3=20
 drivers/video/console/fbcon_ccw.c                  |    3=20
 drivers/video/console/fbcon_cw.c                   |    3=20
 drivers/video/console/fbcon_ud.c                   |    3=20
 drivers/video/fbdev/core/cfbcopyarea.c             |   13=20
 drivers/virtio/virtio_pci.c                        |   33 ++
 fs/btrfs/file-item.c                               |    2=20
 fs/buffer.c                                        |    8=20
 fs/dcache.c                                        |    7=20
 fs/ext3/super.c                                    |    7=20
 fs/ext4/balloc.c                                   |   12=20
 fs/ext4/bitmap.c                                   |   12=20
 fs/ext4/ext4.h                                     |   13=20
 fs/ext4/extents.c                                  |    6=20
 fs/ext4/file.c                                     |    2=20
 fs/ext4/ialloc.c                                   |    7=20
 fs/ext4/inline.c                                   |    3=20
 fs/ext4/inode.c                                    |   46 ++-
 fs/ext4/ioctl.c                                    |   13=20
 fs/ext4/mmp.c                                      |    6=20
 fs/ext4/namei.c                                    |   45 +--
 fs/ext4/resize.c                                   |    5=20
 fs/ext4/super.c                                    |   32 --
 fs/ext4/xattr.c                                    |   38 +-
 fs/jbd2/recovery.c                                 |    1=20
 fs/jffs2/jffs2_fs_sb.h                             |    2=20
 fs/jffs2/wbuf.c                                    |   17 -
 fs/lockd/mon.c                                     |    6=20
 fs/namei.c                                         |    3=20
 fs/namespace.c                                     |    3=20
 fs/nfsd/nfs4proc.c                                 |    7=20
 fs/ocfs2/cluster/tcp.c                             |    2=20
 fs/pstore/inode.c                                  |    4=20
 fs/quota/dquot.c                                   |    2=20
 fs/super.c                                         |    2=20
 fs/ubifs/commit.c                                  |    8=20
 fs/ubifs/log.c                                     |   19 -
 fs/xfs/xfs_itable.c                                |  250 ++++++++---------
 fs/xfs/xfs_itable.h                                |   16 -
 include/drm/drm_pciids.h                           |    1=20
 include/linux/blkdev.h                             |    8=20
 include/linux/hid.h                                |    1=20
 include/linux/memcontrol.h                         |   58 +---
 include/linux/mm.h                                 |    2=20
 include/linux/of.h                                 |   84 ++++-
 include/linux/oom.h                                |    3=20
 include/linux/string.h                             |    5=20
 include/linux/sunrpc/xprt.h                        |    1=20
 include/linux/usb/quirks.h                         |    3=20
 include/net/ipv6.h                                 |    2=20
 include/scsi/scsi_tcq.h                            |    8=20
 include/uapi/drm/vmwgfx_drm.h                      |    2=20
 include/uapi/linux/input.h                         |    7=20
 kernel/events/core.c                               |   54 ++-
 kernel/freezer.c                                   |    3=20
 kernel/futex.c                                     |   22 -
 kernel/module.c                                    |    2=20
 kernel/power/hibernate.c                           |    8=20
 kernel/power/process.c                             |   40 ++
 kernel/sched/core.c                                |   19 +
 kernel/time/posix-timers.c                         |    1=20
 kernel/trace/trace_syscalls.c                      |    8=20
 lib/bitmap.c                                       |    8=20
 lib/scatterlist.c                                  |    6=20
 lib/string.c                                       |   16 +
 mm/balloon_compaction.c                            |    2=20
 mm/cma.c                                           |    1=20
 mm/huge_memory.c                                   |    4=20
 mm/memcontrol.c                                    |  105 ++++---
 mm/memory.c                                        |    1=20
 mm/oom_kill.c                                      |   17 +
 mm/page-writeback.c                                |   43 +--
 mm/page_alloc.c                                    |    8=20
 mm/page_cgroup.c                                   |    1=20
 mm/percpu.c                                        |    2=20
 mm/rmap.c                                          |   20 -
 mm/truncate.c                                      |   56 +++
 net/ceph/messenger.c                               |    6=20
 net/core/tso.c                                     |    3=20
 net/ipv4/fib_semantics.c                           |    2=20
 net/ipv4/gre_offload.c                             |    2=20
 net/ipv4/ip_output.c                               |   12=20
 net/ipv4/ip_tunnel_core.c                          |    3=20
 net/ipv4/route.c                                   |    1=20
 net/ipv4/tcp.c                                     |   59 +---
 net/ipv4/tcp_ipv4.c                                |    4=20
 net/ipv6/output_core.c                             |   34 ++
 net/ipv6/tcp_ipv6.c                                |    4=20
 net/mac80211/rate.c                                |    2=20
 net/netlink/af_netlink.c                           |   39 +-
 net/sunrpc/clnt.c                                  |    3=20
 net/sunrpc/xprtsock.c                              |    4=20
 net/tipc/link.c                                    |    7=20
 security/integrity/evm/evm_main.c                  |   16 -
 security/integrity/ima/ima_appraise.c              |    2=20
 security/integrity/integrity.h                     |    1=20
 security/selinux/hooks.c                           |    2=20
 sound/core/pcm_compat.c                            |    2=20
 sound/firewire/bebob/bebob_focusrite.c             |   62 +++-
 sound/firewire/bebob/bebob_stream.c                |   18 +
 sound/pci/hda/hda_intel.c                          |    4=20
 sound/pci/hda/patch_realtek.c                      |    3=20
 sound/soc/codecs/adau1761.c                        |    4=20
 sound/soc/codecs/tlv320aic3x.c                     |   13=20
 sound/soc/intel/sst-haswell-pcm.c                  |    4=20
 sound/soc/soc-core.c                               |    4=20
 sound/soc/soc-dapm.c                               |   25 -
 sound/soc/soc-pcm.c                                |    2=20
 sound/usb/card.c                                   |    9=20
 virt/kvm/iommu.c                                   |    8=20
 340 files changed, 2977 insertions(+), 1497 deletions(-)

Aaro Koskinen (2):
      MIPS: ptrace.h: Add a missing include
      MIPS: loongson2_cpufreq: Fix CPU clock rate setting mismerge

Adel Gadllah (4):
      USB: quirks: enable device-qualifier quirk for another Elan touchscre=
en
      USB: quirks: enable device-qualifier quirk for yet another Elan touch=
screen
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 009b
      HID: usbhid: enable always-poll quirk for Elan Touchscreen 016f

Al Viro (5):
      missing data dependency barrier in prepend_name()
      kill wbuf_queued/wbuf_dwork_lock
      fix misuses of f_count() in ppp and netlink
      fix inode leaks on d_splice_alias() failure exits
      fix breakage in o2net_send_tcp_msg()

Alan Stern (1):
      usb-storage: handle a skipped data phase

Alex Deucher (6):
      drm/radeon: fix speaker allocation setup
      drm/radeon: use gart memory for DMA ring tests
      drm/radeon: fix vm page table block size calculation
      drm/radeon/dpm: disable ulv support on SI
      drm/radeon: dpm fixes for asrock systems
      drm/radeon: remove invalid pci id

Alex Williamson (2):
      iommu: Rework iommu_group_get_for_pci_dev()
      iommu/amd: Split init_iommu_group() from iommu_init_device()

Alexander Stein (1):
      spi: fsl-dspi: Fix CTAR selection

Alexei Starovoitov (1):
      x86: bpf_jit: fix two bugs in eBPF JIT compiler

Alexey Khoroshilov (1):
      dm log userspace: fix memory leak in dm_ulog_tfr_init failure path

Andreas Bosch (1):
      Input: alps - fix v4 button press recognition

Andreas F=E4rber (1):
      ARM: dts: zynq: Enable PL clocks for Parallella

Andriy Skulysh (1):
      sh: fix sh770x SCIF memory regions

Andy Honig (2):
      KVM: x86: Prevent host from panicking on shared MSR writes.
      KVM: x86: Improve thread safety in pit

Andy Lutomirski (3):
      x86_64, entry: Filter RFLAGS.NT on entry from userspace
      x86_64, entry: Fix out of bounds read on sysenter
      x86, apic: Handle a bad TSC more gracefully

Andy Shevchenko (1):
      stmmac: pci: set default of the filter bins

Anish Bhatt (1):
      cxgb4 : Fix missing initialization of win0_lock

Anton Blanchard (1):
      powerpc: do_notify_resume can be called with bad thread_info flags ar=
gument

Anton Kolesov (1):
      ARC: Update order of registers in KGDB to match GDB 7.5

Antti Palosaari (1):
      media: m88ts2022: fix 32bit overflow on filter calc

Artem Bityutskiy (2):
      UBIFS: fix a race condition
      UBIFS: fix free log space calculation

Axel Lin (1):
      media: tda7432: Fix setting TDA7432_MUTE bit for TDA7432_RF register

Bartlomiej Zolnierkiewicz (1):
      mmc: sdhci-s3c: fix runtime PM handling on sdhci_add_host() failure

Ben Hutchings (4):
      drivers/net, ipv6: Select IPv6 fragment idents for virtio UFO packets
      drivers/net: macvtap and tun depend on INET
      x86: Reject x32 executables if x32 ABI not supported
      mtd: m25p80: Fix module aliases for m25p80

Ben Skeggs (3):
      drm/nouveau/bios: memset dcb struct to zero before parsing
      drm/gt214-/kms: fix hda eld regression
      drm/nouveau: fix regression on agp boards

Benjamin Coddington (2):
      lockd: Try to reconnect if statd has moved
      SUNRPC: Don't wake tasks during connection abort

Benjamin Herrenschmidt (2):
      drm/ast: Fix HW cursor image
      powerpc/powernv: Properly fix LPC debugfs endianness

Brian Silverman (1):
      futex: Fix a race condition between REQUEUE_PI and task death

Bryan O'Donoghue (1):
      x86: Add cpu_detect_cache_sizes to init_intel() add Quark legacy_cach=
e()

Canek Pel=E1ez Vald=E9s (1):
      rt2x00: support Ralink 5362.

Chris Ball (1):
      mfd: rtsx_pcr: Fix MSI enable error handling

Chris Mason (1):
      Btrfs: fix kfree on list_head in btrfs_lookup_csums_range error clean=
up

Chris Wilson (1):
      drm/i915: Do not store the error pointer for a failed userptr registr=
ation

Christian Vogel (1):
      ALSA: bebob: Uninitialized id returned by saffirepro_both_clk_src_get

Christoph Hellwig (2):
      Revert "block: all blk-mq requests are tagged"
      scsi: set REQ_QUEUE for the blk-mq case

Cong Wang (1):
      freezer: Do not freeze tasks killed by OOM killer

Cyril Brulebois (1):
      wireless: rt2x00: add new rt2800usb device

Dan Carpenter (1):
      media: vmalloc_sg: off by one in error handling

Dan Streetman (1):
      powerpc: use device_online/offline() instead of cpu_up/down()

Dan Williams (1):
      USB: option: add Haier CE81B CDMA modem

Daniel Borkmann (1):
      random: add and use memzero_explicit() for clearing data

Daniel Mack (3):
      ASoC: core: fix use after free in snd_soc_remove_platform()
      ASoC: soc-dapm: fix use after free
      ASoC: soc-pcm: fix sig_bits determination in soc_pcm_apply_msb()

Daniele Palmas (1):
      usb: option: add support for Telit LE910

Darrick J. Wong (4):
      jbd2: free bh when descriptor block checksum fails
      ext4: check EA value offset when loading
      ext4: check s_chksum_driver when looking for bg csum presence
      ext4: enable journal checksum when metadata checksum feature enabled

Dave Chinner (7):
      xfs: bulkstat doesn't release AGI buffer on error
      xfs: bulkstat btree walk doesn't terminate
      xfs: bulkstat chunk formatting cursor is broken
      xfs: bulkstat chunk-formatter has issues
      xfs: bulkstat main loop logic is a mess
      xfs: bulkstat error handling is broken
      xfs: track bulkstat progress by agino

David Cohen (2):
      usb: ffs: fix regression when quirk_ep_out_aligned_size flag is set
      pinctrl: baytrail: show output gpio state correctly on Intel Baytrail

David Daney (1):
      MIPS: tlbex: Properly fix HUGE TLB Refill exception handler

David E. Box (1):
      x86/platform/intel/iosf: Add Braswell PCI ID

Dexuan Cui (1):
      x86, pageattr: Prevent overflow in slow_virt_to_phys() for X86_PAE

Dirk Brandewie (4):
      cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
      intel_pstate: Don't lose sysfs settings during cpu offline
      intel_pstate: Fix BYT frequency reporting
      intel_pstate: Correct BYT VID values.

Dmitry Eremin-Solenikov (2):
      spi: pxa2xx: toggle clocks on suspend if not disabled by runtime PM
      mtd: cfi_cmdset_0001.c: fix resume for LH28F640BF chips

Dmitry Kasatkin (3):
      evm: properly handle INTEGRITY_NOXATTRS EVM status
      evm: check xattr value length and type in evm_inode_setxattr()
      ima: check xattr value length and type in the ima_inode_setxattr()

Dmitry Lavnikevich (1):
      ASoC: tlv320aic3x: fix PLL D configuration

Dmitry Monakhov (4):
      ext4: grab missed write_count for EXT4_IOC_SWAP_BOOT
      ext4: Replace open coded mdata csum feature to helper function
      ext4: move error report out of atomic context in ext4_init_block_bitm=
ap()
      ext4: prevent bugon on race between write/fcntl

Dmitry Torokhov (1):
      Input: synaptics - gate forcepad support by DMI check

Emil Velikov (1):
      drm/nouveau/gpio: rename g92 class to g94

Emmanuel Grumbach (4):
      iwlwifi: mvm: BT Coex - update the MPLUT Boost register value
      iwlwifi: configure the LTR
      iwlwifi: dvm: drop non VO frames when flushing
      Revert "iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate"

Eric Dumazet (2):
      tcp: md5: do not use alloc_percpu()
      macvlan: fix a race on port dismantle and possible skb leaks

Eric Rannaud (1):
      fs: allow open(dir, O_TMPFILE|..., 0) with mode 0

Eric Sandeen (1):
      ext4: fix reservation overflow in ext4_da_write_begin

Eric W. Biederman (1):
      mnt: Prevent pivot_root from creating a loop in the mount tree

Ezequiel Garcia (4):
      UBI: block: Fix block device size setting
      UBI: block: Add support for the UBI_VOLUME_UPDATED notification
      UBI: Dispatch update notification if the volume is updated
      drm/tilcdc: Fix the error path in tilcdc_load()

Fabio Estevam (1):
      iio: adc: mxs-lradc: Disable the clock on probe failure

Felipe Balbi (3):
      usb: gadget: udc: core: fix kernel oops with soft-connect
      usb: dwc3: gadget: fix set_halt() bug with pending transfers
      usb: gadget: function: acm: make f_acm pass USB20CV Chapter9

Frank Schaefer (3):
      media: em28xx: check if a device has audio earlier"
      media: em28xx-v4l: give back all active video buffers to the vb2 core=
 properly on streaming stop
      media: em28xx-v4l: fix video buffer field order reporting in progress=
ive mode

Frans Klaver (1):
      usb: serial: ftdi_sio: add Awinda Station and Dongle products

Fu Zhonghui (1):
      mmc: core: sdio: Fix unconditional wake_up_process() on sdio thread

Gabriele Mazzotta (1):
      cpufreq: intel_pstate: Reflect current no_turbo state correctly

George McCollister (1):
      iio: as3935: allocate correct iio_device size

Grant Likely (1):
      of: Fix overflow bug in string property parsing functions

Greg Kroah-Hartman (2):
      PCI: Rename sysfs 'enabled' file back to 'enable'
      Linux 3.17.3

Grzegorz Jaszczyk (2):
      irqchip: armada-370-xp: Fix MSI interrupt handling
      irqchip: armada-370-xp: Fix MPIC interrupt handling

Guenter Roeck (1):
      Revert "percpu: free percpu allocation info for uniprocessor system"

Haiyang Zhang (1):
      hyperv: Fix the total_data_buflen in send path

Hans de Goede (9):
      Input: i8042 - add noloop quirk for Asus X750LN
      Input: i8042 - quirks for Fujitsu Lifebook A544 and Lifebook AH544
      uas: Add NO_ATA_1X for VIA VL711 devices
      uas: Add US_FL_NO_ATA_1X quirk for 2 more Seagate models
      uas: Add US_FL_NO_ATA_1X quirk for 1 more Seagate model
      usb: Do not allow usb_alloc_streams on unconfigured devices
      xhci: Disable streams on Asmedia 1042 xhci controllers
      acer-wmi: Add acpi_backlight=3Dvideo quirk for the Acer KAV80
      samsung-laptop: Add broken-acpi-video quirk for NC210/NC110

Hui Wang (1):
      ALSA: hda - fix mute led problem for three HP laptops

Ian Abbott (2):
      staging: comedi: (regression) channel list must be set for COMEDI_CMD=
 ioctl
      staging: comedi: fix memory leak / bad pointer freeing for chanlist

Ian Morgan (1):
      ax88179_178a: fix bonding failure

Ilya Dryomov (2):
      rbd: rbd workqueues need a resque worker
      libceph: ceph-msgr workqueue needs a resque worker

Imre Deak (3):
      tty/vt: don't set font mappings on vc not supporting this
      PM / Sleep: fix async suspend_late/freeze_late error handling
      PM / Sleep: fix recovery during resuming from hibernation

J. Bruce Fields (2):
      nfsd4: fix response size estimation for OP_SEQUENCE
      nfsd4: fix crash on unknown operation number

Jack Pham (1):
      usb: dwc3: gadget: Properly initialize LINK TRB

Jan Kara (12):
      vfs: fix data corruption when blocksize < pagesize for mmaped data
      ext4: don't check quota format when there are no quota files
      ext4: fix mmap data corruption when blocksize < pagesize
      ext4: fix oops when loading block bitmap failed
      ext4: fix overflow when updating superblock backups after resize
      lib/bitmap.c: fix undefined shift in __bitmap_shift_{left|right}()
      scsi: Fix error handling in SCSI_IOCTL_SEND_COMMAND
      ext3: Don't check quota format when there are no quota files
      quota: Properly return errors from dquot_writeback_dquots()
      mm: Remove false WARN_ON from pagecache_isize_extended()
      rbd: Fix error recovery in rbd_obj_read_sync()
      xfs: Check error during inode btree iteration in xfs_bulkstat()

Jason Baron (4):
      i82860_edac: Report CE events properly
      i3200_edac: Report CE events properly
      e7xxx_edac: Report CE events properly
      cpc925_edac: Report UE events properly

Jason Gerecke (1):
      HID: input: Fix TransducerSerialNumber implementation

Jens Axboe (1):
      blk-mq: fix potential hang if rolling wakeup depth is too high

Jiang Liu (3):
      x86: ACPI: Do not translate GSI number if IOAPIC is disabled
      ACPI, irq, x86: Return IRQ instead of GSI in mp_register_gsi()
      x86, intel-mid: Create IRQs for APB timers and RTC timers

Jiri Pirko (1):
      ipv4: fix nexthop attlen check in fib_nh_match

Joe Thornber (1):
      dm bufio: update last_accessed when relinking a buffer

Joern Engel (1):
      qla_target: don't delete changed nacls

Johan Hovold (9):
      USB: cdc-acm: add device id for GW Instek AFG-2225
      USB: cdc-acm: only raise DTR on transitions from B0
      USB: cdc-acm: add quirk for control-line state requests
      USB: core: add device-qualifier quirk
      USB: quirks: enable device-qualifier quirk for Elan Touchscreen
      HID: usbhid: add always-poll quirk
      HID: usbhid: enable always-poll quirk for Elan Touchscreen
      USB: opticon: fix non-atomic allocation in write path
      USB: kobil_sct: fix non-atomic allocation in write path

Johannes Weiner (2):
      mm: page-writeback: inline account_page_dirtied() into single caller
      mm: memcontrol: fix missed end-writeback page accounting

Jon Paul Maloy (1):
      tipc: fix bug in bundled buffer reception

Josh Boyer (1):
      drm/vmwgfx: Fix drm.h include

Karl Beldan (2):
      net: tso: fix unaligned access to crafted TCP header in helper API
      mac80211: fix typo in starting baserate for rts_cts_rate_idx

Kirill Tkhai (2):
      sched: Use dl_bw_of() under RCU read lock
      sched: Use rq->rd in sched_setaffinity() under RCU read lock

Konstantin Khlebnikov (1):
      mm/balloon_compaction: fix deflation when compaction is disabled

Krzysztof Kozlowski (2):
      power: charger-manager: Fix NULL pointer exception with missing cm-fu=
el-gauge
      regulator: max77693: Fix use of uninitialized regulator config

Lai Jiangshan (1):
      drbd: compute the end before rb_insert_augmented()

Lars-Peter Clausen (6):
      ASoC: adau1761: Fix input PGA volume
      staging:iio:ad5933: Fix NULL pointer deref when enabling buffer
      staging:iio:ad5933: Drop "raw" from channel names
      staging:iio:ade7758: Fix NULL pointer deref when enabling buffer
      staging:iio:ade7758: Fix check if channels are enabled in prenable
      staging:iio:ade7758: Remove "raw" from channel name

Laurent Pinchart (1):
      mm: cma: Don't crash on allocation if CMA area can't be activated

Li RongQing (4):
      vxlan: fix a use after free in vxlan_encap_bypass
      vxlan: using pskb_may_pull as early as possible
      vxlan: fix a free after use
      ipv4: fix a potential use after free in ip_tunnel_core.c

Liam Girdwood (1):
      ASoC: Intel: HSW/BDW only support S16 and S24 formats.

Lv Zheng (1):
      ACPI / EC: Fix regression due to conflicting firmware behavior betwee=
n Samsung and Acer.

Maciej Matraszek (1):
      media: v4l2-common: fix overflow in v4l_bound_align_image()

Marc-Andr=E9 Lureau (1):
      qxl: don't create too large primary surface

Markos Chandras (2):
      MIPS: cp1emu: Fix ISA restrictions for cop1x_op instructions
      MIPS: ftrace: Fix a microMIPS build problem

Martin Schwidefsky (1):
      s390/topology: call set_sched_topology early

Mathias Krause (1):
      posix-timers: Fix stack info leak in timer_create()

Matt Fleming (1):
      rtc: Disable EFI rtc for x86

Mauro Carvalho Chehab (1):
      media: siano: add support for PCTV 77e

Michael S. Tsirkin (2):
      virtio_pci: fix virtio spec compliance on restore
      kvm: x86: don't kill guest on unknown exit reason

Michal Hocko (1):
      OOM, PM: OOM killed task shouldn't escape PM suspend

Michel D=E4nzer (1):
      drm/radeon: Use drm_malloc_ab instead of kmalloc_array

Mike Snitzer (1):
      block: fix alignment_offset math that assumes io_min is a power-of-2

Mikulas Patocka (4):
      fs: make cont_expand_zero interruptible
      dm bufio: when done scanning return from __scan immediately
      framebuffer: fix screen corruption when copying
      framebuffer: fix border color

Nadav Amit (8):
      KVM: x86: Decoding guest instructions which cross page boundary may f=
ail
      KVM: x86: Emulator does not decode clflush well
      KVM: x86: PREFETCH and HINT_NOP should have SrcMem flag
      KVM: x86: Check non-canonical addresses upon WRMSR
      KVM: x86: Fix wrong masking on relative jump/call
      KVM: x86: Emulator fixes for eip canonical checks on near branches
      KVM: x86: Handle errors when RIP is set during far jumps
      KVM: x86: Fix far-jump to non-canonical check

Nathaniel Ting (1):
      USB: serial: cp210x: add Silicon Labs 358x VID and PID

Nicholas Bellinger (2):
      iser-target: Disable TX completion interrupt coalescing
      target: Fix APTPL metadata handling for dynamic MappedLUNs

Nicolas Cavallari (1):
      ipv4: Do not cache routing failures due to disabled forwarding.

Olaf Hering (1):
      drm/cirrus: bind also to qemu-xen-traditional

Oleg Nesterov (2):
      x86, fpu: __restore_xstate_sig()->math_state_restore() needs preempt_=
disable()
      x86, fpu: shift drop_init_fpu() from save_xstate_sig() to handle_sign=
al()

Oliver Neukum (3):
      HID: usbhid: fix PIXART optical mouse
      HID: usbhid: add another mouse that needs QUIRK_ALWAYS_POLL
      xhci: no switching back on non-ULT Haswell

Olivier Gay (1):
      HID: add keyboard input assist hid usages

Ondrej Kozina (1):
      crypto: algif - avoid excessive use of socket buffer in skcipher

Ondrej Zary (1):
      libata-sff: Fix controllers with no ctl port

Or Gerlitz (2):
      net/mlx4_en: Don't attempt to TX offload the outer UDP checksum for V=
XLAN
      mlx4: Avoid leaking steering rules on flow creation error flow

Oussama Ghorbel (1):
      phy: omap-usb2: Enable runtime PM of omap-usb2 phy properly

Pali Roh=E1r (1):
      cpufreq: intel_pstate: Fix setting max_perf_pct in performance policy

Paolo Bonzini (2):
      KVM: emulator: fix execution close to the segment limit
      KVM: emulate: avoid accessing NULL ctxt->memopp

Paul Fertser (1):
      media: usb: uvc: add a quirk for Dell XPS M1330 webcam

Paulo Zanoni (1):
      drm/i915: properly reenable gen8 pipe IRQs

Perry Hung (1):
      usb: serial: ftdi_sio: add "bricked" FTDI device PID

Peter Griffin (1):
      mmc: sdhci-pxav3: set_uhs_signaling is initialized twice differently

Peter Hurley (2):
      serial: Fix divide-by-zero fault in uart_get_divisor()
      tty: Fix high cpu load if tty is unreleaseable

Peter Zijlstra (1):
      perf: Fix unclone_ctx() vs. locking

Petr Matousek (1):
      kvm: vmx: handle invvpid vm exit gracefully

Prarit Bhargava (1):
      modules, lock around setting of MODULE_STATE_UNFORMED

Quentin Casasnovas (1):
      kvm: fix excessive pages un-pinning in kvm_iommu_map error path.

Quinn Tran (1):
      target: Fix queue full status NULL pointer for SCF_TRANSPORT_TASK_SEN=
SE

Rabin Vincent (1):
      tracing/syscalls: Ignore numbers outside NR_syscalls' range

Ray Jui (1):
      spi: pl022: Fix incorrect dma_unmap_sg

Richard Genoud (1):
      UBI: add missing kmem_cache_free() in process_pool_aeb error path

Robert Baldyga (1):
      usb: gadget: f_fs: remove redundant ffs_data_get()

Robert Jarzmik (1):
      ARM: pxa: fix hang on startup with DEBUG_LL

Robin van der Gracht (1):
      iio: st_sensors: Fix buffer copy

Roger Pau Monn=E9 (1):
      xen-blkback: fix leak on grant map error path

Roger Quadros (1):
      Revert "usb: dwc3: dwc3-omap: Disable/Enable only wrapper interrupts =
in prepare/complete"

Roger Tseng (2):
      mmc: rtsx_usb_sdmmc: fix incorrect last byte in R2 response
      mmc: rtsx_pci_sdmmc: fix incorrect last byte in R2 response

Sathya Perla (1):
      net: fix saving TX flow hash in sock for outgoing connections

Scott Carter (1):
      pata_serverworks: disable 64-KB DMA transfers on Broadcom OSB4 IDE Co=
ntroller

Sebastian Andrzej Siewior (2):
      mfd: ti_am335x_tscadc: Fix TSC resume
      usb: musb: dsps: start OTG timer on resume again

Sinclair Yeh (1):
      drm/vmwgfx: Filter out modes those cannot be supported by the current=
 VRAM size.

Stephen Boyd (1):
      serial: msm_serial: Fix kgdb continue

Stephen Smalley (1):
      selinux: fix inode security list corruption

Stephen Warren (1):
      mmc: don't request CD IRQ until mmc_start_host()

Sylwester Nawrocki (2):
      usb: Remove references to non-existent PLAT_S5P symbol
      media: Remove references to non-existent PLAT_S5P symbol

Takashi Iwai (3):
      ALSA: hda - Add workaround for CMI8888 snoop behavior
      ALSA: pcm: Zero-clear reserved fields of PCM status ioctl in compat m=
ode
      ALSA: usb-audio: Fix device_del() sysfs warnings at disconnect

Tetsuo Handa (1):
      fs: Fix theoretical division by 0 in super_cache_scan().

Theodore Ts'o (2):
      ext4: add ext4_iget_normal() which is to be used for dir tree lookups
      ext4: don't orphan or truncate the boot loader inode

Thomas Gleixner (1):
      usb: musb: cppi41: restart hrtimer only if not yet done

Thomas Graf (1):
      netlink: Re-add locking to netlink_lookup() and seq walker

Thorsten Knabe (1):
      um: ubd: Fix for processes stuck in D state forever

Tom Herbert (1):
      gre: Use inner mac length when computing tunnel length

Tomas Melin (1):
      media: rc-core: fix protocol_change regression in ir_raw_event_regist=
er

Tony Battersby (1):
      lib/scatterlist: fix memory leak with scsi-mq

Torsten Fleischer (1):
      usb: chipidea: Fix oops when removing the ci_hdrc module

Trond Myklebust (1):
      SUNRPC: Add missing support for RPC_CLNT_CREATE_NO_RETRANS_TIMEOUT

Tvrtko Ursulin (1):
      drm/i915: Do not leak pages when freeing userptr objects

U. Artie Eoff (1):
      drm/i915: intel_backlight scale() math WA

Ulrich Eckhardt (2):
      media: imon: fix other RC type protocol support
      media: ds3000: fix LNB supply voltage on Tevii S480 on initialization

Valdis Kletnieks (1):
      pstore: Fix duplicate {console,ftrace}-efi entries

Vasily Averin (1):
      ipv4: dst_entry leak in ip_send_unicast_reply()

Vignesh R (1):
      mfd: ti_am335x_tscadc: Fix TSC operation after ADC continouous mode

Ville Syrj=E4l=E4 (2):
      drm/i915: Do a dummy DPCD read before the actual read
      drm/i915: Fix GMBUSFREQ on vlv/chv

Vineet Gupta (2):
      ARC: [nsimosci] Allow "headless" models to boot
      ARC: unbork FPU save/restore

Vitaly Kuznetsov (1):
      xen/blkback: unmap all persistent grants when frontend gets disconnec=
ted

Wang Nan (1):
      cgroup/kmemleak: add kmemleak_free() for cgroup deallocations.

Will Deacon (1):
      zap_pte_range: update addr when forcing flush after TLB batching faiu=
re

Wolfram Sang (1):
      i2c: at91: don't account as iowait

Yijing Wang (1):
      sysfs: driver core: Fix glue dir race condition by gdp_mutex

Yu Zhao (1):
      mm: free compound page with correct order

Zhang Rui (1):
      ACPI: invoke acpi_device_wakeup() with correct parameters

jens stein (1):
      drm/i915: Ignore VBT backlight check on Macbook 2, 1


--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUZlojAAoJEDjbvchgkmk+bUoQANeor2gmwjbqET0wc0HnbwZW
qlWjf9M208SKX+k8uGN1Jp/sWGLz6laIIfZbuYecZ3IGec1l3VWBQYjaLB6s22zY
Gqwl/9Jg1Ni8l7uejI/PtS9YLD/sRCCUe5rb7p0/xKjW7cmgwiy0W46Sh1bSeJbO
UdbNZRqIraYG5YcfJV0HIlGGY76mxNi72jDWg3IpOhNXptGl7YBrpmZFAz2E8pNN
JFFDe9WIxN2K/NTgVvnCU6W5i/dNWrhqE9m6U5Vkx1u4xZzMXLnhw576deNPj5f8
TjV5nIFrEnMcp9qmn0pbVnioKKNRoC9cXGnzfE+0Otp33QQiPNucPdCW3ZbmHj7z
xnw3GssrVJ0iQDEpHyRLoSkvND1iTR+JW2nICAAVNQcz8ARr/V5LWj/dejXZHWwx
hEeZ6S5uXd1/uo92RAnrc21cZQSc2IOkfOX72CZqIFsh7ByQfkOeeL/wCGOC1jKB
cL5EKVfM4EZHU8HzT4zBoR71451Zp6Qh1++hNtYfBCwBls3ifL369o0f0HmjErOJ
j161rTtNKx1ZzdePUxzHvsiVjNJW66l31iu8DjKGY6mm+CM40/Idg9/xJy+ElwT1
PrzZgX9icu/HHOrtO3uoamBfz1Pu4dzzK4FOdVXOUar0B+UPT/HJz4qXbyB8ECWn
riIaGXMmW9bGChYXKg4y
=IGaq
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
