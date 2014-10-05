Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaJEXQ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 19:16:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbaJEXQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 19:16:01 -0400
Date: Sun, 5 Oct 2014 16:16:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.20
Message-ID: <20141005231600.GA22108@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.20 kernel.

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

 Documentation/devicetree/bindings/interrupt-controller/interrupts.txt |   =
12=20
 Makefile                                                              |   =
 2=20
 arch/arm/boot/dts/dra7-evm.dts                                        |   =
14=20
 arch/arm/boot/dts/dra7.dtsi                                           |   =
16=20
 arch/arm/include/asm/tls.h                                            |   =
64 ++
 arch/arm/kernel/irq.c                                                 |   =
 2=20
 arch/arm/kernel/process.c                                             |   =
 2=20
 arch/arm/kernel/thumbee.c                                             |   =
 2=20
 arch/arm/kernel/traps.c                                               |   =
17=20
 arch/arm/kvm/handle_exit.c                                            |   =
 2=20
 arch/arm/kvm/init.S                                                   |   =
 4=20
 arch/arm/mach-omap2/omap_hwmod.c                                      |   =
 3=20
 arch/arm/mach-omap2/omap_hwmod_7xx_data.c                             |   =
22=20
 arch/arm/mach-omap2/soc.h                                             |   =
 6=20
 arch/arm/mm/abort-ev6.S                                               |   =
 6=20
 arch/arm/mm/abort-ev7.S                                               |   =
 6=20
 arch/arm/mm/alignment.c                                               |   =
 3=20
 arch/arm64/include/asm/hw_breakpoint.h                                |   =
 1=20
 arch/arm64/kernel/irq.c                                               |   =
12=20
 arch/arm64/kernel/process.c                                           |   =
18=20
 arch/arm64/kernel/ptrace.c                                            |   =
 3=20
 arch/arm64/kernel/sys_compat.c                                        |   =
 6=20
 arch/arm64/kvm/handle_exit.c                                          |   =
 2=20
 arch/arm64/kvm/hyp-init.S                                             |   =
 4=20
 arch/mips/boot/compressed/decompress.c                                |   =
 1=20
 arch/mips/kernel/mcount.S                                             |   =
12=20
 arch/parisc/Makefile                                                  |   =
 7=20
 arch/parisc/kernel/syscall.S                                          |  2=
33 +++++++++-
 arch/powerpc/include/asm/ptrace.h                                     |   =
 7=20
 arch/powerpc/include/asm/spinlock.h                                   |   =
 1=20
 arch/powerpc/lib/locks.c                                              |   =
 4=20
 arch/powerpc/perf/callchain.c                                         |   =
 2=20
 arch/s390/mm/pgtable.c                                                |   =
10=20
 arch/x86/boot/compressed/aslr.c                                       |   =
15=20
 arch/x86/include/asm/fixmap.h                                         |   =
 6=20
 arch/x86/include/asm/pgtable_64.h                                     |   =
 1=20
 arch/x86/kernel/cpu/perf_event_intel_rapl.c                           |   =
12=20
 arch/x86/kernel/smpboot.c                                             |   =
 3=20
 arch/x86/xen/mmu.c                                                    |   =
27 -
 arch/xtensa/include/asm/pgtable.h                                     |   =
 7=20
 arch/xtensa/include/asm/uaccess.h                                     |   =
 5=20
 arch/xtensa/include/uapi/asm/ioctls.h                                 |   =
19=20
 arch/xtensa/kernel/entry.S                                            |   =
26 -
 arch/xtensa/kernel/pci-dma.c                                          |   =
12=20
 block/cfq-iosched.c                                                   |   =
11=20
 block/genhd.c                                                         |   =
26 -
 block/partition-generic.c                                             |   =
 2=20
 block/partitions/aix.c                                                |   =
 2=20
 drivers/acpi/acpi_cmos_rtc.c                                          |   =
 2=20
 drivers/acpi/acpica/aclocal.h                                         |   =
 1=20
 drivers/acpi/acpica/acobject.h                                        |   =
 1=20
 drivers/acpi/acpica/dsfield.c                                         |   =
 2=20
 drivers/acpi/acpica/evregion.c                                        |   =
47 +-
 drivers/acpi/acpica/exfield.c                                         |   =
67 ++
 drivers/acpi/acpica/exprep.c                                          |   =
 2=20
 drivers/acpi/container.c                                              |   =
 8=20
 drivers/acpi/scan.c                                                   |   =
 5=20
 drivers/ata/ahci.c                                                    |   =
10=20
 drivers/ata/ata_piix.c                                                |   =
 8=20
 drivers/ata/libata-core.c                                             |   =
 2=20
 drivers/ata/pata_scc.c                                                |   =
15=20
 drivers/base/regmap/regcache.c                                        |   =
 2=20
 drivers/base/regmap/regmap.c                                          |   =
 2=20
 drivers/clk/clk.c                                                     |   =
 7=20
 drivers/clk/qcom/mmcc-msm8960.c                                       |   =
84 +--
 drivers/cpufreq/cpufreq.c                                             |   =
 2=20
 drivers/dma/TODO                                                      |   =
 1=20
 drivers/dma/dw/core.c                                                 |   =
38 -
 drivers/gpu/drm/ast/ast_main.c                                        |   =
 2=20
 drivers/gpu/drm/i915/i915_gem.c                                       |   =
11=20
 drivers/gpu/drm/i915/intel_bios.c                                     |   =
 2=20
 drivers/gpu/drm/i915/intel_crt.c                                      |   =
 2=20
 drivers/gpu/drm/i915/intel_lvds.c                                     |   =
 2=20
 drivers/gpu/drm/i915/intel_ringbuffer.c                               |   =
 3=20
 drivers/gpu/drm/i915/intel_tv.c                                       |   =
 4=20
 drivers/gpu/drm/nouveau/nouveau_vga.c                                 |   =
 9=20
 drivers/gpu/drm/radeon/ci_dpm.c                                       |   =
16=20
 drivers/gpu/drm/radeon/cik.c                                          |   =
 9=20
 drivers/gpu/drm/radeon/cik_sdma.c                                     |   =
 7=20
 drivers/gpu/drm/radeon/ni_dma.c                                       |   =
 6=20
 drivers/gpu/drm/radeon/r600_dma.c                                     |   =
 9=20
 drivers/gpu/drm/radeon/radeon.h                                       |   =
 3=20
 drivers/gpu/drm/radeon/radeon_atombios.c                              |   =
72 ++-
 drivers/gpu/drm/radeon/radeon_device.c                                |   =
29 +
 drivers/gpu/drm/radeon/radeon_kms.c                                   |   =
 9=20
 drivers/gpu/drm/radeon/radeon_pm.c                                    |   =
24 -
 drivers/gpu/drm/radeon/radeon_semaphore.c                             |   =
 2=20
 drivers/gpu/drm/radeon/si.c                                           |   =
 2=20
 drivers/gpu/drm/radeon/trinity_dpm.c                                  |   =
11=20
 drivers/gpu/drm/tilcdc/tilcdc_drv.c                                   |   =
 7=20
 drivers/gpu/drm/tilcdc/tilcdc_panel.c                                 |   =
 5=20
 drivers/gpu/drm/tilcdc/tilcdc_slave.c                                 |   =
 1=20
 drivers/gpu/drm/tilcdc/tilcdc_tfp410.c                                |   =
 1=20
 drivers/gpu/drm/ttm/ttm_page_alloc.c                                  |   =
29 -
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c                              |   =
34 -
 drivers/gpu/drm/vmwgfx/vmwgfx_fifo.c                                  |   =
 3=20
 drivers/gpu/vga/vga_switcheroo.c                                      |   =
 6=20
 drivers/hid/hid-logitech-dj.c                                         |   =
43 +
 drivers/hid/hid-logitech-dj.h                                         |   =
 1=20
 drivers/hid/hid-magicmouse.c                                          |   =
10=20
 drivers/hid/hid-picolcd_core.c                                        |   =
 6=20
 drivers/hwmon/ds1621.c                                                |   =
 1=20
 drivers/i2c/busses/i2c-at91.c                                         |   =
32 +
 drivers/i2c/busses/i2c-ismt.c                                         |   =
 4=20
 drivers/i2c/busses/i2c-mv64xxx.c                                      |   =
 3=20
 drivers/iio/accel/bma180.c                                            |   =
 2=20
 drivers/iio/adc/ad_sigma_delta.c                                      |   =
 2=20
 drivers/iio/common/hid-sensors/hid-sensor-trigger.c                   |   =
 3=20
 drivers/iio/common/st_sensors/st_sensors_trigger.c                    |   =
 2=20
 drivers/iio/gyro/itg3200_buffer.c                                     |   =
 2=20
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c                         |   =
 2=20
 drivers/iio/inkern.c                                                  |   =
 2=20
 drivers/iio/magnetometer/st_magn_core.c                               |   =
52 +-
 drivers/infiniband/core/uverbs_marshall.c                             |   =
 4=20
 drivers/infiniband/hw/mlx4/main.c                                     |   =
53 +-
 drivers/infiniband/hw/qib/qib_debugfs.c                               |   =
 3=20
 drivers/infiniband/hw/qib/qib_qp.c                                    |   =
 8=20
 drivers/infiniband/ulp/isert/ib_isert.c                               |   =
 7=20
 drivers/input/keyboard/atkbd.c                                        |   =
 8=20
 drivers/input/mouse/elantech.c                                        |   =
 7=20
 drivers/input/mouse/synaptics.c                                       |   =
68 ++
 drivers/input/mouse/synaptics.h                                       |   =
11=20
 drivers/input/serio/i8042-x86ia64io.h                                 |   =
15=20
 drivers/input/serio/serport.c                                         |   =
45 +
 drivers/iommu/arm-smmu.c                                              |   =
 7=20
 drivers/md/dm-cache-target.c                                          |   =
 4=20
 drivers/md/dm-crypt.c                                                 |   =
20=20
 drivers/md/raid1.c                                                    |   =
40 -
 drivers/media/dvb-core/dvb-usb-ids.h                                  |   =
 2=20
 drivers/media/i2c/adv7604.c                                           |   =
 2=20
 drivers/media/pci/cx18/cx18-driver.c                                  |   =
 1=20
 drivers/media/usb/dvb-usb-v2/af9035.c                                 |   =
 4=20
 drivers/net/ethernet/ibm/ibmveth.c                                    |   =
18=20
 drivers/net/wireless/ath/carl9170/carl9170.h                          |   =
 1=20
 drivers/net/wireless/ath/carl9170/usb.c                               |   =
31 +
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c                        |   =
12=20
 drivers/net/wireless/brcm80211/brcmfmac/fweh.h                        |   =
 2=20
 drivers/net/wireless/iwlwifi/dvm/rxon.c                               |   =
12=20
 drivers/net/wireless/iwlwifi/iwl-config.h                             |   =
 2=20
 drivers/net/wireless/iwlwifi/iwl-nvm-parse.c                          |   =
 4=20
 drivers/net/wireless/iwlwifi/mvm/fw-api.h                             |   =
 4=20
 drivers/net/wireless/iwlwifi/mvm/sf.c                                 |   =
 2=20
 drivers/net/wireless/iwlwifi/mvm/tx.c                                 |   =
 8=20
 drivers/net/wireless/rtlwifi/rtl8192cu/sw.c                           |   =
 1=20
 drivers/nfc/microread/microread.c                                     |   =
16=20
 drivers/of/irq.c                                                      |   =
17=20
 drivers/phy/phy-twl4030-usb.c                                         |  1=
21 +++--
 drivers/scsi/libiscsi.c                                               |   =
10=20
 drivers/spi/spi-dw-pci.c                                              |   =
 2=20
 drivers/spi/spi-omap2-mcspi.c                                         |   =
 3=20
 drivers/staging/iio/meter/ade7758_trigger.c                           |   =
 2=20
 drivers/staging/imx-drm/ipuv3-plane.c                                 |   =
 3=20
 drivers/staging/lustre/lustre/Kconfig                                 |   =
 1=20
 drivers/target/iscsi/iscsi_target.c                                   |   =
 4=20
 drivers/target/iscsi/iscsi_target_parameters.c                        |   =
 2=20
 drivers/target/target_core_configfs.c                                 |   =
 2=20
 drivers/tty/serial/8250/8250_dma.c                                    |   =
17=20
 drivers/usb/chipidea/ci_hdrc_msm.c                                    |   =
 7=20
 drivers/usb/core/hub.c                                                |   =
 4=20
 drivers/usb/dwc3/core.c                                               |   =
13=20
 drivers/usb/dwc3/dwc3-omap.c                                          |   =
 2=20
 drivers/usb/host/ehci-hcd.c                                           |   =
 2=20
 drivers/usb/host/xhci-hub.c                                           |   =
 8=20
 drivers/usb/host/xhci-mem.c                                           |   =
 2=20
 drivers/usb/host/xhci.c                                               |   =
12=20
 drivers/usb/misc/sisusbvga/sisusb.c                                   |   =
 1=20
 drivers/usb/phy/phy-tegra-usb.c                                       |   =
 4=20
 drivers/usb/serial/ftdi_sio.c                                         |   =
 3=20
 drivers/usb/serial/ftdi_sio_ids.h                                     |   =
12=20
 drivers/usb/serial/option.c                                           |   =
31 +
 drivers/usb/serial/pl2303.c                                           |   =
 1=20
 drivers/usb/serial/pl2303.h                                           |   =
 1=20
 drivers/usb/serial/sierra.c                                           |   =
 9=20
 drivers/usb/serial/usb-serial.c                                       |   =
37 +
 drivers/usb/serial/zte_ev.c                                           |   =
24 -
 drivers/usb/storage/unusual_devs.h                                    |   =
38 +
 drivers/uwb/lc-dev.c                                                  |   =
13=20
 drivers/xen/manage.c                                                  |   =
 7=20
 fs/aio.c                                                              |   =
91 +++
 fs/buffer.c                                                           |   =
 6=20
 fs/cifs/link.c                                                        |   =
 8=20
 fs/eventpoll.c                                                        |   =
 3=20
 fs/gfs2/inode.c                                                       |   =
 5=20
 fs/lockd/svc.c                                                        |   =
 4=20
 fs/namei.c                                                            |   =
33 -
 fs/nfs/nfs4client.c                                                   |   =
38 -
 fs/nfs/nfs4proc.c                                                     |   =
30 -
 fs/nilfs2/inode.c                                                     |   =
 7=20
 fs/notify/fdinfo.c                                                    |   =
 4=20
 fs/ocfs2/dlm/dlmmaster.c                                              |   =
18=20
 include/acpi/acpi_bus.h                                               |   =
 1=20
 include/linux/iio/trigger.h                                           |   =
 4=20
 include/linux/seqlock.h                                               |   =
 2=20
 include/linux/vga_switcheroo.h                                        |   =
 2=20
 include/linux/workqueue.h                                             |   =
 2=20
 include/net/regulatory.h                                              |   =
 2=20
 include/uapi/linux/usb/functionfs.h                                   |   =
10=20
 include/uapi/linux/xattr.h                                            |   =
 2=20
 kernel/cgroup.c                                                       |   =
 1=20
 kernel/events/core.c                                                  |   =
10=20
 kernel/futex.c                                                        |   =
 1=20
 kernel/kcmp.c                                                         |   =
 7=20
 kernel/power/main.c                                                   |   =
21=20
 kernel/power/power.h                                                  |   =
 9=20
 kernel/power/suspend.c                                                |   =
66 +-
 kernel/power/suspend_test.c                                           |   =
24 -
 kernel/time/alarmtimer.c                                              |   =
34 -
 kernel/trace/ring_buffer.c                                            |   =
16=20
 mm/memblock.c                                                         |   =
 3=20
 mm/memory.c                                                           |   =
 2=20
 mm/percpu-vm.c                                                        |   =
22=20
 mm/percpu.c                                                           |   =
 2=20
 mm/shmem.c                                                            |   =
 4=20
 mm/slab.c                                                             |   =
11=20
 net/mac80211/mlme.c                                                   |   =
 3=20
 net/netfilter/ipvs/ip_vs_conn.c                                       |   =
 1=20
 net/netfilter/ipvs/ip_vs_core.c                                       |   =
 2=20
 net/netfilter/ipvs/ip_vs_xmit.c                                       |   =
 2=20
 net/netfilter/xt_cgroup.c                                             |   =
 2=20
 net/netfilter/xt_hashlimit.c                                          |   =
31 -
 net/wireless/nl80211.c                                                |   =
 6=20
 sound/core/info.c                                                     |   =
 4=20
 sound/core/pcm_lib.c                                                  |   =
 8=20
 sound/pci/hda/patch_conexant.c                                        |   =
 9=20
 sound/pci/hda/patch_realtek.c                                         |   =
 2=20
 sound/pci/hda/patch_sigmatel.c                                        |   =
17=20
 sound/soc/davinci/davinci-mcasp.c                                     |   =
11=20
 227 files changed, 2063 insertions(+), 850 deletions(-)

Al Viro (2):
      don't bugger nd->seq on set_root_rcu() from follow_dotdot_rcu()
      GFS2: fix d_splice_alias() misuses

Alan Douglas (1):
      xtensa: fix address checks in dma_{alloc,free}_coherent

Alan Stern (1):
      USB: EHCI: unlink QHs even after the controller has stopped

Alex Deucher (18):
      drm/radeon/dpm: handle voltage info fetching on hawaii
      drm/radeon: re-enable dpm by default on cayman
      drm/radeon: re-enable dpm by default on BTC
      drm/radeon: load the lm63 driver for an lm64 thermal chip.
      drm/radeon/atom: add new voltage fetch function for hawaii
      drm/radeon: tweak ACCEL_WORKING2 query for hawaii
      drm/radeon: enable bapm by default on desktop TN/RL boards
      drm/radeon/TN: only enable bapm on MSI systems
      drm/radeon: fix pm handling in radeon_gpu_reset
      drm/radeon/dpm: set the thermal type properly for special configs
      drm/radeon: add connector quirk for fujitsu board
      drm/radeon: don't reset dma on NI/SI init
      drm/radeon: don't reset sdma on CIK init
      drm/radeon: don't reset dma on r6xx-evergreen init
      drm/radeon/cik: use a separate counter for CP init timeout
      vgaswitcheroo: add vga_switcheroo_fini_domain_pm_ops
      drm/nouveau/runpm: fix module unload
      drm/radeon/px: fix module unload

Alex Gartrell (1):
      ipvs: Maintain all DSCP and ECN bits for ipv6 tun forwarding

Andreas Rohner (1):
      nilfs2: fix data loss with mmap()

Andrey Vagin (2):
      fsnotify/fdinfo: use named constants instead of hardcoded values
      fs/notify: don't show f_handle if exportfs_encode_inode_fh failed

Andy Shevchenko (3):
      spi: dw-pci: fix bug when regs left uninitialized
      dmaengine: dw: introduce dwc_dostart_first_queued() helper
      dmaengine: dw: don't perform DMA when dmaengine_submit is called

Anssi Hannula (1):
      dm cache: fix race causing dirty blocks to be marked as clean

Anton Altaparmakov (1):
      Fix nasty 32-bit overflow bug in buffer i/o code.

Anton Blanchard (2):
      ibmveth: Fix endian issues with rx_no_buffer statistic
      powerpc/perf: Fix ABIv2 kernel backtraces

Arend van Spriel (1):
      brcmfmac: handle IF event for P2P_DEVICE interface

Arjun Sreedharan (1):
      pata_scc: propagate return value of scc_wait_after_reset

Arnd Bergmann (1):
      staging/lustre: disable virtual block device for 64K pages

Aurelien Jarno (1):
      MIPS: ZBOOT: add missing <linux/string.h> include

Benjamin LaHaise (1):
      aio: fix reqs_available handling

Benjamin Tissoires (1):
      HID: logitech-dj: prevent false errors to be shown

Bj=F8rn Mork (2):
      USB: sierra: avoid CDC class functions on "68A3" devices
      USB: sierra: add 1199:68AA device ID

Bob Moore (1):
      ACPICA: Update to GPIO region handler interface.

Brennan Ashton (1):
      USB: option: add VIA Telecom CDS7 chipset device id

Chen-Yu Tsai (1):
      i2c: mv64xxx: continue probe when clock-frequency is missing

Christian Borntraeger (1):
      KVM: s390/mm: try a cow on read only pages for key ops

Christian K=F6nig (2):
      drm/radeon: set VM base addr using the PFP v2
      drm/radeon: fix semaphore value init

Christoffer Dall (1):
      arm/arm64: KVM: Complete WFI/WFE instructions

Clemens Ladisch (2):
      ALSA: core: fix buffer overflow in snd_info_get_line()
      ALSA: pcm: fix fifo_size frame calculation

Cong Wang (1):
      perf: Fix a race condition in perf_remove_from_context()

Dan Carpenter (2):
      NFC: microread: Potential overflows in microread_target_discovered()
      partitions: aix.c: off by one bug

Daniel Borkmann (1):
      netfilter: x_tables: allow to use default cgroup match

Daniel Vetter (1):
      drm/i915: Fix EIO/wedged handling in gem fault handler

Dave Young (1):
      x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

David Rientjes (1):
      mm, slab: initialize object alignment on cache creation

Denis CIOCCA (1):
      iio:magnetometer: bugfix magnetometers gain values

Dmitry Torokhov (2):
      Input: synaptics - add support for ForcePads
      Input: atkbd - do not try 'deactivate' keyboard on any LG laptops

Eliad Peller (2):
      iwlwifi: increase DEFAULT_MAX_TX_POWER
      regulatory: add NUL to alpha2

Emmanuel Grumbach (2):
      Revert "iwlwifi: dvm: don't enable CTS to self"
      iwlwifi: mvm: fix endianity issues with Smart Fifo commands

Eric Dumazet (1):
      netfilter: xt_hashlimit: perform garbage collection from process cont=
ext

Eyal Shapira (1):
      iwlwifi: mvm: treat EAPOLs like mgmt frames wrt rate

Fan Du (1):
      i2c: ismt: use correct length when copy buffer

Felipe Balbi (4):
      usb: host: xhci: fix compliance mode workaround
      usb: dwc3: omap: fix ordering for runtime pm calls
      usb: dwc3: core: fix order of PM runtime calls
      usb: dwc3: core: fix ordering for PHY suspend

Filipe Brandenburger (1):
      xattr: fix check for simultaneous glibc header inclusion

Florian Fainelli (1):
      of/irq: Fix lookup to use 'interrupts-extended' property first

Greg KH (1):
      USB: serial: pl2303: add device id for ztek device

Greg Kroah-Hartman (1):
      Linux 3.14.20

Gu Zheng (1):
      aio: block exit_aio() until all context requests are completed

Guido Mart=EDnez (6):
      drm/tilcdc: panel: fix dangling sysfs connector node
      drm/tilcdc: slave: fix dangling sysfs connector node
      drm/tilcdc: tfp410: fix dangling sysfs connector node
      drm/tilcdc: panel: fix leak when unloading the module
      drm/tilcdc: fix release order on exit
      drm/tilcdc: fix double kfree

Guy Martin (1):
      parisc: Implement new LWS CAS supporting 64 bit operations.

Hans Verkuil (2):
      media: cx18: fix kernel oops with tda8290 tuner
      media: adv7604: fix inverted condition

Hans de Goede (3):
      Input: elantech - fix detection of touchpad on ASUS s301l
      Input: i8042 - add Fujitsu U574 to no_timeout dmi table
      Input: i8042 - add nomux quirk for Avatar AVIU-145A6

Heikki Krogerus (1):
      serial: 8250_dma: check the result of TX buffer mapping

Honggang Li (1):
      percpu: free percpu allocation info for uniprocessor system

Ivan T. Ivanov (2):
      usb: chipidea: msm: Use USB PHY API to control PHY state
      usb: chipidea: msm: Initialize PHY on reset event

J. Bruce Fields (1):
      lockd: fix rpcbind crash on lockd startup failure

James Ralston (2):
      ahci: Add Device IDs for Intel 9 Series PCH
      ata_piix: Add Device IDs for Intel 9 Series PCH

Jeff Moyer (1):
      aio: add missing smp_rmb() in read_events_ring

Jens Axboe (1):
      genhd: fix leftover might_sleep() in blk_free_devt()

Jiri Kosina (3):
      drm/i915: read HEAD register back in init_ring_common() to enforce or=
dering
      HID: picolcd: sanity check report size in raw_event() callback
      HID: magicmouse: sanity check report size in raw_event() callback

Joe Lawrence (1):
      usb: hub: take hub->hdev reference when processing from eventlist

Joern Engel (1):
      iscsi-target: avoid NULL pointer in iscsi_copy_param_list failure

Johan Hovold (8):
      USB: serial: fix potential stack buffer overflow
      USB: serial: fix potential heap buffer overflow
      USB: option: reduce interrupt-urb logging verbosity
      Revert "USB: option,zte_ev: move most ZTE CDMA devices to zte_ev"
      USB: zte_ev: remove duplicate Gobi PID
      USB: zte_ev: remove duplicate Qualcom PID
      USB: ftdi_sio: add support for NOVITUS Bono E thermal printer
      USB: zte_ev: fix removed PIDs

Johannes Berg (2):
      Revert "mac80211: disable uAPSD if all ACs are under ACM"
      nl80211: clear skb cb before passing to netlink

Johannes Pointner (1):
      iio:inkern: fix overwritten -EPROBE_DEFER in of_iio_channel_get_by_na=
me

John David Anglin (1):
      parisc: Only use -mfast-indirect-calls option for 32-bit kernel builds

John Sung (1):
      Input: serport - add compat handling for SPIOCSTYPE ioctl

Jorge A. Ventura (1):
      spi/omap-mcspi: Fix the spi task hangs waiting dma_rx

Josef Bacik (1):
      trace: Fix epoll hang when we race with new entries

Joseph Qi (1):
      ocfs2/dlm: do not get resource spinlock if lockres is new

Julian Anastasov (2):
      ipvs: avoid netns exit crash on ip_vs_conn_drop_conntrack
      ipvs: fix ipv6 hook registration for local replies

Karol Lewandowski (1):
      usb: gadget: f_fs: drop duplicate usb_functionfs_descs_head declarati=
on

Kees Cook (1):
      x86/kaslr: Avoid the setup_data area when picking location

Keith Busch (1):
      block: Fix dev_t minor allocation lifetime

Larry Finger (1):
      rtlwifi: rtl8192cu: Add new ID

Lee, Chun-Yi (1):
      ACPI / RTC: Fix CMOS RTC opregion handler accesses to wrong addresses

Malcolm Priestley (1):
      media: af9035: new IDs: add support for PCTV 78e and PCTV 79e

Marek Roszko (1):
      i2c: at91: add bound checking on SMBus block length bytes

Mark (4):
      storage: Add single-LUN quirk for Jaz USB Adapter
      USB: storage: Add quirk for Adaptec USBConnect 2000 USB-to-SCSI Adapt=
er
      USB: storage: Add quirk for Ariston Technologies iConnect USB to SCSI=
 adapter
      USB: storage: Add quirks for Entrega/Xircom USB to SCSI converters

Mark Brown (2):
      regmap: Fix handling of volatile registers for format_write() chips
      regmap: Don't attempt block writes when syncing cache on single_rw de=
vices

Mark Rutland (1):
      ARM: 8128/1: abort: don't clear the exclusive monitors

Markos Chandras (1):
      MIPS: mcount: Adjust stack pointer for static trace in MIPS32

Matan Barak (1):
      IB/core: When marshaling uverbs path, clear unused fields

Mathias Krause (1):
      drm/i915: Remove bogus __init annotation from DMI callbacks

Mathias Nyman (2):
      xhci: Fix null pointer dereference if xhci initialization fails
      xhci: fix oops when xhci resumes from hibernate with hw lpm capable d=
evices

Max Filippov (4):
      xtensa: replace IOCTL code definitions with constants
      xtensa: fix access to THREAD_RA/THREAD_SP/THREAD_DS
      xtensa: fix TLBTEMP_BASE_2 region handling in fast_second_level_miss
      xtensa: fix a6 and a7 handling in fast_syscall_xtensa

Michael Ellerman (2):
      powerpc: Add smp_mb() to arch_spin_is_locked()
      powerpc: Add smp_mb()s to arch_spin_unlock_wait()

Mika Westerberg (1):
      ACPI / scan: Correct error return value of create_modalias()

Mike Christie (1):
      SCSI: libiscsi: fix potential buffer overrun in __iscsi_conn_send_pdu

Mike Marciniszyn (1):
      IB/qib: Correct reference counting in debugfs qp_stats

Miklos Szeredi (1):
      shmem: fix nlink for rename overwrite directory

Mikulas Patocka (1):
      dm crypt: fix access beyond the end of allocated space

Moni Shoua (2):
      IB/mlx4: Avoid null pointer dereference in mlx4_ib_scan_netdevs()
      IB/mlx4: Don't duplicate the default RoCE GID

Murali Karicheri (1):
      ahci: add pcid for Marvel 0x9182 controller

Nathan Lynch (2):
      ARM: 8148/1: flush TLS and thumbee register state during exec
      ARM: 8178/1: fix set_tls for !CONFIG_KUSER_HELPERS

NeilBrown (8):
      md/raid1: clean up request counts properly in close_sync()
      md/raid1: be more cautious where we read-balance during resync.
      md/raid1: make sure resync waits for conflicting writes to complete.
      md/raid1: Don't use next_resync to determine how far resync has progr=
essed
      md/raid1: update next_resync under resync_lock.
      md/raid1: count resync requests in nr_pending.
      md/raid1: fix_read_error should act on all non-faulty devices.
      md/raid1: intialise start_next_window for READ case to avoid hang

Nicholas Bellinger (1):
      iscsi-target: Fix memory corruption in iscsit_logout_post_handler_dif=
fcid

Nicolas Iooss (1):
      eventpoll: fix uninitialized variable in epoll_ctl

Nishanth Menon (2):
      ARM: dts: DRA7: fix interrupt-cells for GPIO
      ARM: dts: dra7-evm: Fix spi1 mux documentation

Olav Haugan (1):
      iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1

Oleg Chernovskiy (1):
      drm/radeon: Add missing lines to ci_set_thermal_temperature_range

Pali Roh=E1r (1):
      drm/radeon: Add ability to get and change dpm state when radeon PX ca=
rd is turned off

Peter Feiner (1):
      mm: softdirty: keep bit when zapping file pte

Peter Ujfalusi (1):
      ASoC: davinci-mcasp: Correct rx format unit configuration

Pranavkumar Sawargaonkar (1):
      ARM/ARM64: KVM: Nuke Hyp-mode tlbs before enabling MMU

Prarit Bhargava (1):
      cpufreq: release policy->rwsem on error

Rafael J. Wysocki (3):
      ACPI / hotplug: Generate online uevents for ACPI containers
      PM / sleep: Add state field to pm_states[] entries
      PM / sleep: Use valid_state() for platform-dependent sleep states only

Rajendra Nayak (2):
      ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
      ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x() varian=
ts

Rasmus Villemoes (1):
      kcmp: fix standard comparison bug

Richard Larocque (3):
      alarmtimer: Return relative times in timer_gettime
      alarmtimer: Do not signal SIGEV_NONE timers
      alarmtimer: Lock k_itimer during timer callback

Robert Coulson (1):
      hwmon: (ds1621) Update zbits after conversion rate change

Robin Murphy (1):
      ARM: 8165/1: alignment: don't break misaligned NEON load/store

Ronald Wahl (1):
      carl9170: fix sending URBs with wrong type when using full-speed

Ross Lagerwall (1):
      xen/manage: Always freeze/thaw processes when suspend/resuming

Russell King (1):
      imx-drm: ipuv3-plane: fix ipu_plane_dpms()

Sagi Grimberg (2):
      Target/iser: Get isert_conn reference once got to connected_handler
      Target/iser: Don't put isert_conn inside disconnected handler

Sebastian Herbszt (1):
      target: Fix inverted logic in SE_DEV_ALUA_SUPPORT_STATE_STORE

Simon Lindgren (1):
      i2c: at91: Fix a race condition during signal handling in at91_do_twi=
_xfer.

Srinivas Pandruvada (8):
      iio:trigger: modify return value for iio_trigger_get
      iio: accel: bma180: Fix indio_dev->trig assignment
      iio: hid_sensor_hub: Fix indio_dev->trig assignment
      iio: gyro: itg3200: Fix indio_dev->trig assignment
      iio: inv_mpu6050: Fix indio_dev->trig assignment
      iio: meter: ade7758: Fix indio_dev->trig assignment
      iio: st_sensors: Fix indio_dev->trig assignment
      iio: adc: ad_sigma_delta: Fix indio_dev->trig assignment

Stefan Bader (1):
      x86/xen: don't copy bogus duplicate entries into kernel page tables

Stephen Boyd (2):
      clk: qcom: Fix MN frequency tables, parent map, and jpegd
      clk: qcom: mdp_lut_clk is a child of mdp_src

Stephen Hemminger (1):
      USB: sisusb: add device id for Magic Control USB video

Steve Dickson (1):
      NFSv4: nfs4_state_manager() vs. nfs_server_remove_lists()

Steve French (1):
      SMB3: Fix oops when creating symlinks on smb3

Sudeep Holla (2):
      arm64: use irq_set_affinity with force=3Dfalse when migrating irqs
      ARM: 8133/1: use irq_set_affinity with force=3Dfalse when migrating i=
rqs

Takashi Iwai (3):
      ALSA: hda - Fix digital mic on Acer Aspire 3830TG
      ALSA: hda - Fix COEF setups for ALC1150 codec
      ALSA: hda - Fix invalid pin powermap without jack detection

Tang Chen (1):
      memblock, memhotplug: fix wrong type in memblock_find_in_range_node().

Taylor Braun-Jones (1):
      USB: ftdi_sio: Add support for GE Healthcare Nemo Tracker device

Tejun Heo (4):
      libata: widen Crucial M550 blacklist matching
      workqueue: apply __WQ_ORDERED to create_singlethread_workqueue()
      percpu: fix pcpu_alloc_pages() failure path
      percpu: perform tlb flush after pcpu_map_pages() failure

Tero Kristo (1):
      clk: prevent erronous parsing of children during rate change

Tetsuo Handa (5):
      drm/ttm: Fix possible division by 0 in ttm_dma_pool_shrink_scan().
      drm/ttm: Choose a pool to shrink correctly in ttm_dma_pool_shrink_sca=
n().
      drm/ttm: Use mutex_trylock() to avoid deadlock inside shrinker functi=
ons.
      drm/ttm: Fix possible stack overflow by recursive shrinker calls.
      drm/ttm: Pass GFP flags in order to avoid deadlock.

Thierry Reding (1):
      usb: phy: tegra: Avoid use of sizeof(void)

Thomas Gleixner (1):
      futex: Unlock hb->lock in futex_wait_requeue_pi() error path

Thomas Hellstrom (1):
      drm/vmwgfx: Fix a potential infinite spin waiting for fifo idle

Thomas Pugliese (1):
      uwb: init beacon cache entry before registering uwb device

Tony Lindgren (2):
      usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down
      usb: phy: twl4030-usb: Fix regressions to runtime PM on omaps

Toshiaki Makita (1):
      cfq-iosched: Fix wrong children_weight calculation

Trond Myklebust (2):
      NFSv4: Fix another bug in the close/open_downgrade code
      lockdep: Revert lockdep check in raw_seqcount_begin()

Venkatesh Srinivas (1):
      perf/x86/intel: Use rdmsrl_safe() when initializing RAPL PMU

Ville Syrj=E4l=E4 (1):
      drm/i915: Wait for vblank before enabling the TV encoder

Wanpeng Li (1):
      sched: Fix unreleased llc_shared_mask bit during CPU hotplug

Will Deacon (2):
      arm64: flush TLS registers during exec
      arm64: ptrace: fix compat hardware watchpoint reporting

Y.C. Chen (1):
      drm/ast: AST2000 cannot be detected correctly

Zefan Li (1):
      cgroup: fix unbalanced locking


--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUMdEwAAoJEDjbvchgkmk+ZksQAKFBhf+sW7dQKSD6Ot4ZCx0J
ZHAM7c8YSgr9j0EOmxYLPLydqUiCt2j+UWMYOeps2bQdry/W0D0fnUZSUnCk/hKW
0W24BHcSiUK/pw4gLlvOdaKeYWyLlonubFgUEoxEPfp7MYaV0BZI16CCDb9CUDIr
HW3+UDPWOIqScQrgjECQGI5yIg54/GuAAddlVCtHYZFw83SXUoi/+jbG2t0hwFuj
ZYFKha98MO9dyrexeZ/02eZ51DsUORX5QjCRdjtmnNCZ9m4PAc8OXUQcOCrICFxA
YdiZ64Y6seKuujJ44qGzcpt/1laQhxrBWH/eb0zYigerPtHlc4LQwtWwVoFsVzwI
sY10vcftLOyoWImRdGCxR/zUjwPf+xAI/8a0FS3Afs0f4e/kPOjzpNBvhSGoaNcx
dPlH3B9h7ndkz4cP0Vc13FoVI1HqYorlc7c/haetTGbWDZjqoPxFE4cIKqlewemk
RZ0lK3x6U1xqePY4jH9X9KKyWYbWMK+hZ1ceqUZBttV+YA8E+u7E1kY7LS3v+gSI
zkTjN+iakJgbHYONa8I22r2f6Ij9mNzvluBV4xoeyPkKSY2CPazGsgZL5ELurO/n
xyBC5e4WQ0S0j1WTexUQeRuFWhxdKTmjtUwQEA51jGDrKnAl1PWP8HkoguLd80BF
GXCRWVV+xEnHrunt2cZd
=BM5c
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
