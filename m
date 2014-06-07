Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753424AbaFGXMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 19:12:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaFGXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 19:12:33 -0400
Date: Sat, 7 Jun 2014 16:12:28 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.6
Message-ID: <20140607231228.GA4739@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.6 kernel.

All users of the 3.14 kernel series must upgrade.

The updated 3.14.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.14.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/dma/ti-edma.txt     |    4=20
 Documentation/i2c/busses/i2c-i801                     |    1=20
 Documentation/input/elantech.txt                      |    5=20
 Documentation/ja_JP/HOWTO                             |    2=20
 Documentation/ja_JP/stable_kernel_rules.txt           |    6=20
 Documentation/zh_CN/HOWTO                             |    2=20
 Documentation/zh_CN/stable_kernel_rules.txt           |    2=20
 Makefile                                              |    2=20
 arch/arm/boot/dts/am33xx.dtsi                         |    2=20
 arch/arm/boot/dts/armada-xp-db.dts                    |    2=20
 arch/arm/boot/dts/armada-xp-gp.dts                    |    2=20
 arch/arm/boot/dts/armada-xp-openblocks-ax3-4.dts      |    2=20
 arch/arm/boot/dts/imx53.dtsi                          |    2=20
 arch/arm/boot/dts/kirkwood-mv88f6281gtw-ge.dts        |   18=20
 arch/arm/boot/dts/kirkwood-nsa310-common.dtsi         |   18=20
 arch/arm/boot/dts/ste-ccu8540.dts                     |    1=20
 arch/arm/common/edma.c                                |   48 --
 arch/arm/kernel/crash_dump.c                          |    2=20
 arch/arm/mach-mvebu/mvebu-soc-id.c                    |   13=20
 arch/arm/mach-orion5x/common.h                        |    2=20
 arch/arm64/kernel/irq.c                               |   10=20
 arch/arm64/mm/hugetlbpage.c                           |    4=20
 arch/metag/include/asm/barrier.h                      |    3=20
 arch/metag/include/asm/processor.h                    |    2=20
 arch/mips/cavium-octeon/octeon-irq.c                  |    2=20
 arch/mips/lantiq/dts/easy50712.dts                    |    1=20
 arch/mips/loongson/lemote-2f/clock.c                  |    5=20
 arch/mips/ralink/dts/mt7620a_eval.dts                 |    1=20
 arch/mips/ralink/dts/rt2880_eval.dts                  |    1=20
 arch/mips/ralink/dts/rt3052_eval.dts                  |    1=20
 arch/mips/ralink/dts/rt3883_eval.dts                  |    1=20
 arch/parisc/Kconfig                                   |    1=20
 arch/parisc/include/asm/processor.h                   |    2=20
 arch/parisc/kernel/syscall.S                          |   12=20
 arch/parisc/kernel/traps.c                            |   54 +-
 arch/parisc/mm/fault.c                                |   44 +-
 arch/powerpc/Makefile                                 |    4=20
 arch/powerpc/include/asm/ppc_asm.h                    |    7=20
 arch/powerpc/kernel/machine_kexec_64.c                |    2=20
 arch/powerpc/kernel/time.c                            |    3=20
 arch/powerpc/platforms/powernv/eeh-ioda.c             |    3=20
 arch/s390/crypto/aes_s390.c                           |    3=20
 arch/s390/crypto/des_s390.c                           |    3=20
 arch/x86/include/asm/hugetlb.h                        |    1=20
 arch/x86/kernel/ldt.c                                 |    4=20
 arch/x86/vdso/vdso32-setup.c                          |    8=20
 crypto/crypto_wq.c                                    |    2=20
 drivers/acpi/Kconfig                                  |   17=20
 drivers/acpi/Makefile                                 |    1=20
 drivers/acpi/ac.c                                     |  117 +++---
 drivers/acpi/acpi_platform.c                          |    1=20
 drivers/acpi/acpi_processor.c                         |    1=20
 drivers/acpi/acpica/acglobal.h                        |    4=20
 drivers/acpi/acpica/tbutils.c                         |    7=20
 drivers/acpi/battery.c                                |  329 +++++++++++++=
++++-
 drivers/acpi/blacklist.c                              |   21 +
 drivers/acpi/cm_sbs.c                                 |  105 +++++
 drivers/acpi/ec.c                                     |   21 -
 drivers/acpi/video.c                                  |   16=20
 drivers/ata/libata-core.c                             |    9=20
 drivers/ata/pata_at91.c                               |   11=20
 drivers/base/dd.c                                     |   17=20
 drivers/base/platform.c                               |    7=20
 drivers/base/topology.c                               |    3=20
 drivers/bluetooth/ath3k.c                             |    2=20
 drivers/bluetooth/btusb.c                             |    5=20
 drivers/bus/mvebu-mbus.c                              |    6=20
 drivers/char/ipmi/ipmi_kcs_sm.c                       |    5=20
 drivers/char/ipmi/ipmi_si_intf.c                      |   46 +-
 drivers/char/tpm/tpm_ppi.c                            |    8=20
 drivers/clk/clk.c                                     |   74 +---
 drivers/clk/tegra/clk-pll.c                           |    2=20
 drivers/clk/versatile/clk-vexpress-osc.c              |    2=20
 drivers/clocksource/exynos_mct.c                      |   12=20
 drivers/cpufreq/intel_pstate.c                        |   34 -
 drivers/cpufreq/loongson2_cpufreq.c                   |    4=20
 drivers/crypto/caam/error.c                           |   10=20
 drivers/dma/dmaengine.c                               |    2=20
 drivers/dma/dw/core.c                                 |   11=20
 drivers/dma/mv_xor.c                                  |    8=20
 drivers/gpu/drm/i915/i915_drv.c                       |   90 ++++
 drivers/gpu/drm/i915/i915_gem.c                       |    4=20
 drivers/gpu/drm/i915/i915_irq.c                       |   18=20
 drivers/gpu/drm/i915/intel_display.c                  |   52 +-
 drivers/gpu/drm/i915/intel_drv.h                      |    3=20
 drivers/gpu/drm/i915/intel_hdmi.c                     |    9=20
 drivers/gpu/drm/i915/intel_panel.c                    |    8=20
 drivers/gpu/drm/i915/intel_pm.c                       |   10=20
 drivers/gpu/drm/i915/intel_uncore.c                   |    2=20
 drivers/gpu/drm/nouveau/core/subdev/therm/fan.c       |   19 -
 drivers/gpu/drm/nouveau/nouveau_acpi.c                |    3=20
 drivers/gpu/drm/nouveau/nouveau_display.c             |    2=20
 drivers/gpu/drm/radeon/ci_dpm.c                       |    8=20
 drivers/gpu/drm/radeon/cik.c                          |  104 +++++
 drivers/gpu/drm/radeon/cik_sdma.c                     |    2=20
 drivers/gpu/drm/radeon/cikd.h                         |    9=20
 drivers/gpu/drm/radeon/dce6_afmt.c                    |   14=20
 drivers/gpu/drm/radeon/evergreen.c                    |   28 +
 drivers/gpu/drm/radeon/r600.c                         |   13=20
 drivers/gpu/drm/radeon/r600_dpm.c                     |   35 +
 drivers/gpu/drm/radeon/radeon.h                       |   12=20
 drivers/gpu/drm/radeon/radeon_atpx_handler.c          |    9=20
 drivers/gpu/drm/radeon/radeon_device.c                |   19 -
 drivers/gpu/drm/radeon/radeon_display.c               |    4=20
 drivers/gpu/drm/radeon/radeon_drv.c                   |   24 -
 drivers/gpu/drm/radeon/radeon_family.h                |    1=20
 drivers/gpu/drm/radeon/radeon_kms.c                   |   12=20
 drivers/gpu/drm/radeon/radeon_pm.c                    |   51 +-
 drivers/gpu/drm/radeon/radeon_ucode.h                 |    7=20
 drivers/gpu/drm/radeon/radeon_uvd.c                   |    4=20
 drivers/gpu/drm/radeon/si.c                           |   65 ++-
 drivers/gpu/drm/radeon/uvd_v1_0.c                     |   10=20
 drivers/gpu/host1x/hw/intr_hw.c                       |    4=20
 drivers/hwmon/coretemp.c                              |    4=20
 drivers/hwmon/emc1403.c                               |   10=20
 drivers/i2c/busses/Kconfig                            |    1=20
 drivers/i2c/busses/i2c-designware-core.c              |    3=20
 drivers/i2c/busses/i2c-i801.c                         |    3=20
 drivers/i2c/busses/i2c-rcar.c                         |    9=20
 drivers/i2c/busses/i2c-s3c2410.c                      |    2=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c            |    7=20
 drivers/infiniband/ulp/isert/ib_isert.c               |   27 -
 drivers/infiniband/ulp/isert/ib_isert.h               |    2=20
 drivers/input/keyboard/atkbd.c                        |   29 +
 drivers/input/mouse/elantech.c                        |   26 +
 drivers/input/mouse/elantech.h                        |    1=20
 drivers/input/mouse/synaptics.c                       |  195 ++++------
 drivers/input/serio/i8042-x86ia64io.h                 |   15=20
 drivers/input/serio/i8042.c                           |    6=20
 drivers/input/serio/serio.c                           |   14=20
 drivers/iommu/amd_iommu.c                             |    2=20
 drivers/irqchip/irq-armada-370-xp.c                   |   17=20
 drivers/irqchip/irq-gic.c                             |    8=20
 drivers/leds/leds-pwm.c                               |   23 -
 drivers/md/dm-cache-target.c                          |    1=20
 drivers/md/dm-crypt.c                                 |   61 ---
 drivers/md/dm-thin.c                                  |   23 +
 drivers/md/dm-verity.c                                |   15=20
 drivers/md/md.c                                       |    3=20
 drivers/md/raid10.c                                   |   13=20
 drivers/media/i2c/ov7670.c                            |    2=20
 drivers/media/media-device.c                          |    1=20
 drivers/media/tuners/fc2580.c                         |    6=20
 drivers/media/tuners/fc2580_priv.h                    |    1=20
 drivers/media/v4l2-core/v4l2-compat-ioctl32.c         |   12=20
 drivers/memory/mvebu-devbus.c                         |   15=20
 drivers/net/ethernet/intel/e1000e/netdev.c            |   20 -
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c    |    2=20
 drivers/net/ethernet/intel/igb/igb_main.c             |    7=20
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |   14=20
 drivers/net/wireless/iwlwifi/iwl-7000.c               |    5=20
 drivers/net/wireless/iwlwifi/mvm/bt-coex.c            |   12=20
 drivers/net/wireless/iwlwifi/mvm/mac80211.c           |    7=20
 drivers/net/wireless/iwlwifi/mvm/rs.c                 |  219 +++++++----
 drivers/net/wireless/iwlwifi/mvm/rs.h                 |    2=20
 drivers/net/wireless/iwlwifi/mvm/sf.c                 |    3=20
 drivers/net/wireless/iwlwifi/pcie/drv.c               |    2=20
 drivers/net/wireless/iwlwifi/pcie/trans.c             |   10=20
 drivers/net/wireless/rt2x00/rt2x00mac.c               |   22 -
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.c           |    2=20
 drivers/of/irq.c                                      |   26 +
 drivers/of/platform.c                                 |    4=20
 drivers/pci/host/pci-mvebu.c                          |   92 ++++-
 drivers/pci/hotplug/shpchp_ctrl.c                     |    4=20
 drivers/pci/pci.c                                     |    5=20
 drivers/pnp/pnpacpi/core.c                            |   44 +-
 drivers/rtc/rtc-hym8563.c                             |    3=20
 drivers/spi/spi.c                                     |   11=20
 drivers/target/iscsi/iscsi_target.c                   |    4=20
 drivers/target/target_core_device.c                   |   12=20
 drivers/target/target_core_transport.c                |    2=20
 drivers/target/tcm_fc/tfc_cmd.c                       |    8=20
 drivers/tty/serial/8250/8250_core.c                   |    2=20
 drivers/tty/serial/8250/8250_dma.c                    |    9=20
 drivers/usb/gadget/at91_udc.c                         |   10=20
 drivers/usb/host/ehci-fsl.c                           |    3=20
 drivers/usb/host/ohci-hub.c                           |   18=20
 drivers/usb/host/ohci-pci.c                           |    1=20
 drivers/usb/host/ohci.h                               |    2=20
 drivers/usb/serial/qcserial.c                         |   15=20
 drivers/usb/storage/shuttle_usbat.c                   |    2=20
 drivers/usb/storage/unusual_devs.h                    |   14=20
 fs/affs/super.c                                       |    2=20
 fs/aio.c                                              |    6=20
 fs/autofs4/root.c                                     |    4=20
 fs/ceph/dir.c                                         |    9=20
 fs/ceph/inode.c                                       |   71 ---
 fs/ceph/super.h                                       |    1=20
 fs/coredump.c                                         |    7=20
 fs/dcache.c                                           |    3=20
 fs/exec.c                                             |    6=20
 fs/kernfs/file.c                                      |    2=20
 fs/namei.c                                            |    6=20
 fs/nfsd/nfs4acl.c                                     |   17=20
 fs/nfsd/nfs4state.c                                   |   40 +-
 fs/posix_acl.c                                        |    6=20
 fs/sysfs/file.c                                       |    3=20
 include/linux/dmaengine.h                             |    1=20
 include/linux/ftrace.h                                |    2=20
 include/linux/interrupt.h                             |   40 ++
 include/linux/irq.h                                   |    3=20
 include/linux/of_irq.h                                |    5=20
 include/linux/serio.h                                 |    1=20
 include/net/cfg80211.h                                |   12=20
 include/trace/events/module.h                         |    2=20
 include/uapi/drm/tegra_drm.h                          |    1=20
 include/uapi/linux/input.h                            |    1=20
 kernel/futex.c                                        |  239 ++++++++++---
 kernel/hrtimer.c                                      |   30 +
 kernel/irq/manage.c                                   |   17=20
 kernel/kexec.c                                        |    8=20
 kernel/locking/rtmutex.c                              |   32 +
 kernel/module.c                                       |    6=20
 kernel/timer.c                                        |    2=20
 kernel/trace/ftrace.c                                 |   27 -
 kernel/workqueue.c                                    |   36 +
 mm/compaction.c                                       |   22 -
 mm/memory-failure.c                                   |   15=20
 mm/memory.c                                           |    5=20
 mm/mremap.c                                           |    9=20
 mm/page-writeback.c                                   |    6=20
 mm/percpu.c                                           |    2=20
 mm/vmscan.c                                           |   18=20
 net/bluetooth/hci_conn.c                              |    9=20
 net/bluetooth/hci_event.c                             |    6=20
 net/ceph/messenger.c                                  |   20 +
 net/mac80211/ieee80211_i.h                            |    1=20
 net/mac80211/mlme.c                                   |   20 -
 net/mac80211/offchannel.c                             |   27 +
 net/mac80211/util.c                                   |    2=20
 net/wireless/reg.c                                    |   19 -
 net/wireless/scan.c                                   |   12=20
 net/wireless/sme.c                                    |    2=20
 security/device_cgroup.c                              |  203 ++++++++---
 sound/pci/hda/hda_intel.c                             |    3=20
 sound/pci/hda/patch_hdmi.c                            |    4=20
 sound/soc/codecs/wm8962.c                             |   15=20
 sound/soc/codecs/wm8962.h                             |    4=20
 sound/soc/soc-dapm.c                                  |    7=20
 sound/usb/card.h                                      |    1=20
 sound/usb/endpoint.c                                  |   15=20
 241 files changed, 2916 insertions(+), 1247 deletions(-)

Aaro Koskinen (1):
      MIPS/loongson2_cpufreq: Fix CPU clock rate setting

Aaron Lu (2):
      drm/i915: restore backlight precision when converting from ACPI
      ACPI / video: correct DMI tag for Dell Inspiron 7520

Al Viro (1):
      fix races between __d_instantiate() and checks of dentry flags

Alan Stern (1):
      USB: OHCI: fix problem with global suspend on ATI controllers

Alex Deucher (14):
      drm/radeon: fix audio pin counts for DCE6+ (v2)
      drm/radeon: fix runpm handling on APUs (v4)
      drm/radeon: disable mclk dpm on R7 260X
      drm/radeon: add support for newer mc ucode on SI (v2)
      drm/radeon: add support for newer mc ucode on CI (v2)
      drm/radeon: re-enable mclk dpm on R7 260X asics
      drm/radeon/si: make sure mc ucode is loaded before checking the size
      drm/radeon/ci: make sure mc ucode is loaded before checking the size
      drm/radeon: properly unregister hwmon interface (v2)
      drm/radeon: fix ATPX detection on non-VGA GPUs
      drm/radeon/pm: don't walk the crtc list before it has been initialize=
d (v2)
      drm/radeon: don't allow runpm=3D1 on systems with out ATPX
      drm/radeon: disable dpm on rv770 by default
      drm/radeon: fix count in cik_sdma_ring_test()

Alex Williamson (1):
      iommu/amd: Fix interrupt remapping for aliased devices

Andy Grover (2):
      target: Allow non-supporting backends to set pi_prot_type to 0
      target: Don't allow setting WC emulation if device doesn't support

Andy Shevchenko (1):
      dmaengine: dw: went back to plain {request,free}_irq() calls

Anssi Hannula (1):
      ALSA: hda - hdmi: Set converter channel count even without sink

Anthony Iliopoulos (1):
      x86, mm, hugetlb: Add missing TLB page invalidation for hugetlb_cow()

Anton Blanchard (1):
      powerpc: irq work racing with timer interrupt can result in timer int=
errupt hang

Antti Palosaari (1):
      media: fc2580: fix tuning failure on 32-bit arch

Aristeu Rozanski (2):
      device_cgroup: rework device access check and exception checking
      device_cgroup: check if exception removal is allowed

Arnd Bergmann (1):
      genirq: Provide irq_force_affinity fallback for non-SMP

Atilla Filiz (1):
      iio:imu:mpu6050: Fixed segfault in Invensens MPU driver due to null d=
ereference

Bartlomiej Zolnierkiewicz (1):
      pata_at91: fix ata_host_activate() failure handling

Ben Hutchings (1):
      rtl8192cu: Fix unbalanced irq enable in error path of rtl92cu_hw_init=
()

Bj=F8rn Mork (1):
      usb: qcserial: add a number of Dell devices

Bodo Stroesser (1):
      ipmi: Fix a race restarting the timer

Charles Keepax (1):
      ASoC: wm8962: Update register CLASS_D_CONTROL_1 to be non-volatile

Chen Yucong (1):
      hwpoison, hugetlb: lock_page/unlock_page does not match for handling =
a free hugepage

Chew, Kean ho (1):
      i2c: i801: enable Intel BayTrail SMBUS

Chris Wilson (1):
      drm/i915: Fix unsafe loop iteration over vma whilst unbinding them

Christian K=F6nig (2):
      drm/radeon/uvd: use lower clocks on old UVD to boot v2
      drm/radeon: use pflip irq on R600+ v2

Christoph Hellwig (1):
      posix_acl: handle NULL ACL in posix_acl_equiv_mode

Christoph Paasch (2):
      igb: Fix Null-pointer dereference in igb_reset_q_vector
      igb: Unset IGB_FLAG_HAS_MSIX-flag when falling back to msi-only

Chunwei Chen (1):
      libceph: fix corruption when using page_count 0 page in rbd

Clemens Ladisch (1):
      ALSA: usb-audio: work around corrupted TEAC UD-H01 feedback data

Corey Minyard (1):
      ipmi: Reset the KCS timeout when starting error recovery

Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Dan Carpenter (2):
      i40e: potential array underflow in i40e_vc_process_vf_msg()
      clk: vexpress: NULL dereference on error path

Daniel Vetter (3):
      drm/i915: Don't check gmch state on inherited configs
      drm/i915: Don't WARN nor handle unexpected hpd interrupts on gmch pla=
tforms
      drm/i915: Disable self-refresh for untiled fbs on i915gm

Daniele Forsi (2):
      usb: storage: shuttle_usbat: fix discs being detected twice
      USB: Nokia 5300 should be treated as unusual dev

David Ertman (1):
      e1000e: Fix no connectivity when driver loaded with cable out

Dirk Brandewie (2):
      intel_pstate: Set turbo VID for BayTrail
      intel_pstate: remove setting P state to MAX on init

Du, Wenkai (1):
      i2c: designware: Mask all interrupts during i2c controller enable

Edward Lin (1):
      ACPI: blacklist win8 OSI for Dell Inspiron 7737

Egbert Eich (1):
      drm/i915: Break encoder->crtc link separately in intel_sanitize_crtc()

Eliad Peller (4):
      cfg80211: free sme on connection failures
      cfg80211: add cfg80211_sched_scan_stopped_rtnl
      mac80211: fix nested rtnl locking on ieee80211_reconfig
      iwlwifi: add rs_rate_scale_clear_tbl_windows helper function

Emil Goode (1):
      brcmsmac: fix deadlock on missing firmware

Emmanuel Grumbach (7):
      iwlwifi: add MODULE_FIRMWARE for 7265
      iwlwifi: 7000: bump API to 9
      mac80211: fix suspend vs. association race
      iwlwifi: pcie: disable interrupts upon PCIe alloc
      iwlwifi: mvm: fix setting channel in monitor mode
      iwlwifi: mvm: BT Coex - fix Look Up Table
      iwlwifi: mvm: disable beacon filtering

Eric Dumazet (1):
      coredump: fix va_list corruption

Eyal Shapira (6):
      iwlwifi: mvm: rs: fix mimo delimiter in LQ cmd
      iwlwifi: mvm: rs: fallback to legacy Tx columns
      iwlwifi: mvm: avoid searching unnecessary columns
      iwlwifi: mvm: rs: fix and cleanup rs_get_rate_action
      iwlwifi: mvm: rs: reinit rs if no tx for a long time
      iwlwifi: mvm: rs: clear per rate stats when aggregation changes

Ezequiel Garcia (1):
      dma: mv_xor: Flush descriptors before activating a channel

Fabian Frederick (1):
      fs/affs/super.c: bugfix / double free

Gavin Shan (2):
      PCI: Wrong register used to check pending traffic
      powerpc/powernv: Reset root port in firmware

Geert Uytterhoeven (2):
      Documentation: Update stable address in Chinese and Japanese translat=
ions
      spi: core: Ignore unsupported Dual/Quad Transfer Mode bits

Grant Likely (1):
      drivercore: deferral race condition fix

Greg Kroah-Hartman (1):
      Linux 3.14.6

Guennadi Liakhovetski (2):
      media: V4L2: ov7670: fix a wrong index, potentially Oopsing the kerne=
l from user-space
      media: V4L2: fix VIDIOC_CREATE_BUFS in 64- / 32-bit compatibility mode

Guenter Roeck (3):
      Revert "hwmon: (coretemp) Refine TjMax detection"
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"
      powerpc: Fix 64 bit builds with binutils 2.24

Hans de Goede (12):
      Input: serio - add firmware_id sysfs attribute
      Input: i8042 - add firmware_id support
      Input: Add INPUT_PROP_TOPBUTTONPAD device property
      Input: synaptics - report INPUT_PROP_TOPBUTTONPAD property
      Input: elantech - fix touchpad initialization on Gigabyte U2442
      Input: synaptics - add min/max quirk for the ThinkPad W540
      Input: synaptics - T540p - unify with other LEN0034 models
      Input: synaptics - add a matches_pnp_id helper function
      Input: synaptics - change min/max quirk table to pnp-id matching
      ACPI / video: Add use_native_backlight quirks for more systems
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015=
PX
      ACPI / video: Revert native brightness quirk for ThinkPad T530

Harald Freudenberger (1):
      crypto: s390 - fix aes,des ctr mode concurrency finding.

Heiko Stuebner (1):
      drivers/rtc/rtc-hym8563.c: set uie_unsupported

Helge Deller (1):
      parisc: ratelimit userspace segfault printing

Horia Geanta (1):
      crypto: caam - add allocation failure handling in SPRINTFCAT macro

Ian Kent (1):
      autofs: fix lockref lookup

Igor Mammedov (1):
      ACPI / processor: do not mark present at boot but not onlined CPU as =
onlined

Ilan Peer (1):
      cfg80211: fix few minor issues in reg_process_hint()

Ilia Mirkin (1):
      drm/nouveau/acpi: allow non-optimus setups to load vbios from acpi

Imre Deak (1):
      drm/i915: move power domain init earlier during system resume

J. Bruce Fields (2):
      nfsd4: warn on finding lockowner without stateid's
      nfsd4: remove lockowner when removing lock stateid

James Hogan (1):
      metag: Reduce maximum stack size to 256MB

Jani Nikula (2):
      drm/i915/vlv: reset VLV media force wake request register
      drm/i915: quirk invert brightness for Acer Aspire 5336

Jean Delvare (1):
      hwmon: (emc1403) Fix resource leak on module unload

Jean-Jacques Hiblot (1):
      usb: gadget: at91-udc: fix irq and iomem resource retrieval

Jianyu Zhan (1):
      percpu: make pcpu_alloc_chunk() use pcpu_mem_free() instead of kfree()

Jiri Bohac (1):
      timer: Prevent overflow in apply_slack

Joe Thornber (2):
      dm thin: allow metadata commit if pool is in PM_OUT_OF_DATA_SPACE mode
      dm thin: add timeout to stop out-of-data-space mode holding IO forever

Johan Hedberg (2):
      Bluetooth: Fix triggering BR/EDR L2CAP Connect too early
      Bluetooth: Fix redundant encryption request for reauthentication

Johannes Berg (2):
      mac80211: fix on-channel remain-on-channel
      iwlwifi: mvm: delay enabling smart FIFO until after beacon RX

Johannes Weiner (1):
      revert "mm: vmscan: do not swap anon pages just because free+file is =
low"

John David Anglin (1):
      parisc: Improve LWS-CAS performance

Josef Gajdusek (2):
      hwmon: (emc1403) fix inverted store_hyst()
      hwmon: (emc1403) Support full range of known chip revision numbers

Kieran Clancy (1):
      ACPI / EC: Process rather than discard events in acpi_ec_clear

Kinglong Mee (1):
      NFSD: Call ->set_acl with a NULL ACL structure if no entries

Kirill A. Shutemov (1):
      mm, thp: close race between mremap() and split_huge_page()

Krzysztof Kozlowski (1):
      clocksource: Exynos_mct: Register clock event after request_irq()

Lai Jiangshan (2):
      workqueue: fix a possible race condition between rescuer and pwq-rele=
ase
      workqueue: make rescuer_thread() empty wq->maydays list before exiting

Lan Tianyu (2):
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"

Lars-Peter Clausen (1):
      ASoC: dapm: Skip CODEC<->CODEC links in connect_dai_link_widgets()

Leif Lindholm (2):
      mips: dts: Fix missing device_type=3D"memory" property in memory nodes
      arm: dts: Fix missing device_type=3D"memory" for ste-ccu8540

Leo Liu (1):
      drm/radeon: check buffer relocation offset

Leon Ma (1):
      hrtimer: Prevent remote enqueue of leftmost timers

Leon Yu (1):
      aio: fix potential leak in aio_run_iocb().

Levente Kurusa (1):
      libata: clean up ZPODD when a port is detached

Linus Torvalds (2):
      mm: make fixup_user_fault() check the vma access rights too
      x86-64, modify_ldt: Make support for 16-bit segments a runtime option

Liu Hua (1):
      ARM: 8012/1: kdump: Avoid overflow when converting pfn to physaddr

Loic Poulain (2):
      serial: 8250: Fix thread unsafe __dma_tx_complete function
      8250_core: Fix unwanted TX chars write

Lv Zheng (2):
      ACPICA: Tables: Fix invalid pointer accesses in acpi_tb_parse_root_ta=
ble().
      ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.

Maarten Lankhorst (1):
      drm/nouveau: fix another lock unbalance in nouveau_crtc_page_flip

Marcel Apfelbaum (1):
      PCI: shpchp: Check bridge's secondary (not primary) bus speed

Marcel Holtmann (1):
      Revert "Bluetooth: Enable autosuspend for Intel Bluetooth device"

Mark Salter (1):
      arm64: fix pud_huge() for 2-level pagetables

Martin Peres (1):
      drm/nouveau/pm/fan: drop the fan lock in fan_update() before reschedu=
ling

Mike Snitzer (1):
      dm cache: fix writethrough mode quiescing in cache_map

Mikulas Patocka (3):
      metag: fix memory barriers
      target: fix memory leak on XCOPY
      dm crypt: fix cpu hotplug crash by removing per-cpu structure

Milan Broz (1):
      dm verity: fix biovecs hash calculation regression

Mohammed Habibulla (1):
      Bluetooth: Add support for Lite-on [04ca:3007]

Neil Greatorex (1):
      irqchip: armada-370-xp: Fix releasing of MSIs

NeilBrown (2):
      md/raid10: call wait_barrier() for each request submitted.
      md: avoid possible spinning md thread at shutdown.

Nicholas Bellinger (2):
      iscsi-target: Change BUG_ON to REJECT in iscsit_process_nop_out
      tcm_fc: Fix free-after-use regression in ft_free_cmd

Nikita Yushchenko (1):
      fsl-usb: do not test for PHY_CLK_VALID bit on controller version 1.6

Olof Johansson (1):
      i2c: s3c2410: resume race fix

Oren Givon (1):
      iwlwifi: add new 7265 HW IDs

Rafael J. Wysocki (2):
      PNP / ACPI: Do not return errors if _DIS or _SRS are not present
      ACPI / TPM: Fix resume regression on Chromebooks

Rik van Riel (1):
      mm/page-writeback.c: fix divide by zero in pos_ratio_polynom

Rob Herring (1):
      of/irq: do irq resolution in platform_get_irq

Romain Izard (1):
      trace: module: Maintain a valid user count

Russell King (1):
      leds: leds-pwm: properly clean up after probe failure

Rusty Russell (1):
      module: remove warning about waiting module removal.

Sagi Grimberg (2):
      Target/iser: Fix wrong connection requests list addition
      Target/iser: Fix iscsit_accept_np and rdma_cm racy flow

Salva Peir=F3 (1):
      media: media-device: fix infoleak in ioctl media_enum_entities()

Sascha Hauer (1):
      ARM: dts: i.MX53: Fix ipu register space size

Sebastian Hesselbarth (1):
      ARM: dts: kirkwood: fix mislocated pcie-controller nodes

Sheng-Liang Song (1):
      Input: atkbd - fix keyboard not working on some LG laptops

Srivatsa S. Bhat (1):
      powerpc, kexec: Fix "Processor X is stuck" issue during kexec from ST=
 mode

Stanislaw Gruszka (1):
      rt2x00: fix beaconing on USB

Stephen Boyd (2):
      clk: Fix double free due to devm_clk_register()
      clk: Fix slab corruption in clk_unregister()

Stephen Warren (1):
      gpu: host1x: handle the correct # of syncpt regs

Steven Rostedt (Red Hat) (1):
      ftrace/module: Hardcode ftrace_module_init() call into load_module()

Stuart Hayes (1):
      hrtimer: Prevent all reprogramming if hang detected

Sudeep Holla (1):
      arm64: use cpu_online_mask when using forced irq_set_affinity

Takashi Iwai (1):
      ALSA: hda - Fix onboard audio on Intel H97/Z97 chipsets

Tejun Heo (2):
      kernfs: add back missing error check in kernfs_fop_mmap()
      sysfs: make sure read buffer is zeroed

Thierry Reding (1):
      drm/tegra: Remove gratuitous pad field

Thomas Gleixner (11):
      futex: Add another early deadlock detection check
      futex: Prevent attaching to kernel threads
      rtmutex: Fix deadlock detector for real
      irqchip: Gic: Support forced affinity setting
      genirq: Allow forcing cpu affinity of interrupts
      clocksource: Exynos_mct: Use irq_force_affinity() in cpu bringup
      ARM: common: edma: Fix xbar mapping
      futex-prevent-requeue-pi-on-same-futex.patch futex: Forbid uaddr =3D=
=3D uaddr2 in futex_requeue(..., requeue_pi=3D1)
      futex: Validate atomic acquisition in futex_lock_pi_atomic()
      futex: Always cleanup owner tid in unlock_pi
      futex: Make lookup_pi_state more robust

Thomas Petazzoni (11):
      irqchip: armada-370-xp: fix invalid cast of signed value into unsigne=
d variable
      irqchip: armada-370-xp: implement the ->check_device() msi_chip opera=
tion
      ARM: orion5x: fix target ID for crypto SRAM window
      ARM: mvebu: fix NOR bus-width in Armada XP GP Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP DB Device Tree
      ARM: mvebu: fix NOR bus-width in Armada XP OpenBlocks AX3 Device Tree
      memory: mvebu-devbus: fix the conversion of the bus width
      bus: mvebu-mbus: allow several windows with the same target/attribute
      PCI: mvebu: split PCIe BARs into multiple MBus windows when needed
      ARM: mvebu: mvebu-soc-id: add missing clk_put() call
      ARM: mvebu: mvebu-soc-id: keep clock enabled if PCIe unit is enabled

Tim Chen (1):
      crypto: crypto_wq - Fix late crypto work queue initialization

Trond Myklebust (2):
      NFSd: Move default initialisers from create_client() to alloc_client()
      NFSd: call rpc_destroy_wait_queue() from free_client()

Tuomas Tynkkynen (1):
      clk: tegra: Fix wrong value written to PLLE_AUX

Victor A. Santos (1):
      USB: Nokia 305 should be treated as unusual dev

Ville Syrj=E4l=E4 (1):
      drm/i915: Allow user modes to exceed DVI 165MHz limit

Vincent Stehl=E9 (1):
      topology: Fix compilation warning when not in SMP

Viresh Kumar (1):
      hrtimer: Set expiry time before switch_hrtimer_base()

Vlastimil Babka (1):
      mm/compaction: make isolate_freepages start at pageblock boundary

Willy Tarreau (1):
      PCI: mvebu: fix off-by-one in the computed size of the mbus windows

Wolfram Sang (1):
      i2c: rcar: bail out on zero length transfers

Xuelin Shi (1):
      dmaengine: fix dmaengine_unmap failure

Yan, Zheng (1):
      ceph: clear directory's completeness when creating file


--liOOAslEiF7prFVr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTk5xcAAoJEDjbvchgkmk+9rgP/18LhhnpPonpOo7a/xUzgdUV
oXHqyThKzOMEM+gfDNFw0pb7hwuzajXvSHQNWBZkSE74XnKaAnTl8MX5QX9V+Iqh
ozpG6hlk5bT50GggG4ec7IAPq4gArRzONJ7ufN0azsX32CecRzDCaPBBp75f8w0e
eykmpAM8yRPrgzKWIxruI6oLmQn+naQSREWwCpneNwxSPOKFhZcBWe6aSRAEWa0D
Cq652lSSUzE1CAxKHCd8uxHNGTmR5ME6UXnyPf0nJTxxE6ELgSkzTWIM3sY21njJ
cxoes3ZzqcAevt76leZUSfjr+R0IDpyozUusr14FHhTPR3v5jOa4HYBRjUj5qDmy
4aYE1Bum67PdCjFUBIun5mRCvn+RS1h+kmhTlxc++cIrAKxxCoe9pEbWDBDg28Eu
HEuuMccHn+XSmGrYM2SOmqgmicZq0givEmzD7AjQFkZKV6GXmvej9GUDvR76i4Ay
9nfz3QCwY8QGkz9kOEszK/YdFu+V2+kJvc5ipXt5s5KKy+Tsp6HRxnnYye0TfTAW
dKZMiVUr/36+NNGXZRlhuvvlUe1KWWZF/yn4BcLzfhaDM8LM2rGuG43N8h5sy1YU
BCX3Jo/c12jDYmsgD7Incd/wpOJPI/uxO0OV1otY4BizXb5IgA7kMzm46zyURz0l
x3HcMVH+CHFPcaDJKICz
=iyjn
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
