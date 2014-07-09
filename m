Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932451AbaGITd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:33:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47554 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbaGITdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:33:21 -0400
Date: Wed, 9 Jul 2014 12:37:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.15.5
Message-ID: <20140709193745.GA16521@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uAKRQypu60I7Lcqm"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.15.5 kernel.

All users of the 3.15 kernel series must upgrade.

The updated 3.15.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.15.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/devicetree/bindings/arm/armada-38x.txt |   14 ++
 Documentation/sysctl/vm.txt                          |    3=20
 Makefile                                             |    2=20
 arch/arc/kernel/ctx_sw_asm.S                         |    2=20
 arch/arm/boot/dts/armada-380.dtsi                    |    2=20
 arch/arm/boot/dts/armada-385-db.dts                  |    2=20
 arch/arm/boot/dts/armada-385-rd.dts                  |    2=20
 arch/arm/boot/dts/armada-385.dtsi                    |    2=20
 arch/arm/boot/dts/armada-38x.dtsi                    |    2=20
 arch/arm/mach-omap2/mux.c                            |    6 -
 arch/arm64/kernel/entry.S                            |    1=20
 arch/arm64/mm/flush.c                                |    3=20
 arch/ia64/include/uapi/asm/fcntl.h                   |    1=20
 arch/unicore32/mm/alignment.c                        |    1=20
 arch/x86/include/asm/kvm_host.h                      |    4=20
 arch/x86/kvm/x86.c                                   |    2=20
 block/blk-cgroup.c                                   |    7 -
 block/blk-cgroup.h                                   |   17 +--
 drivers/block/rbd.c                                  |   19 +++
 drivers/block/zram/zram_drv.c                        |    5=20
 drivers/clk/qcom/clk-rcg2.c                          |    2=20
 drivers/clk/qcom/mmcc-msm8974.c                      |   13 +-
 drivers/cpufreq/intel_pstate.c                       |    5=20
 drivers/gpu/drm/drm_drv.c                            |    3=20
 drivers/gpu/drm/i2c/tda998x_drv.c                    |    2=20
 drivers/gpu/drm/i915/i915_debugfs.c                  |    2=20
 drivers/gpu/drm/i915/i915_gem_gtt.c                  |    7 +
 drivers/gpu/drm/i915/i915_gpu_error.c                |    3=20
 drivers/gpu/drm/i915/i915_irq.c                      |   18 ++-
 drivers/gpu/drm/i915/intel_bios.c                    |    6 -
 drivers/gpu/drm/i915/intel_panel.c                   |    5=20
 drivers/gpu/drm/i915/intel_pm.c                      |   55 ++++++++--
 drivers/gpu/drm/i915/intel_ringbuffer.h              |    2=20
 drivers/gpu/drm/i915/intel_sdvo.c                    |    4=20
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c      |    8 +
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c        |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c        |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c        |    2=20
 drivers/gpu/drm/nouveau/nouveau_display.c            |   17 ++-
 drivers/gpu/drm/radeon/atombios_crtc.c               |   48 ++++----
 drivers/gpu/drm/radeon/atombios_dp.c                 |   17 ++-
 drivers/gpu/drm/radeon/atombios_encoders.c           |    5=20
 drivers/gpu/drm/radeon/cikd.h                        |    2=20
 drivers/gpu/drm/radeon/cypress_dpm.c                 |    2=20
 drivers/gpu/drm/radeon/ni_dpm.c                      |    2=20
 drivers/gpu/drm/radeon/radeon_connectors.c           |    2=20
 drivers/gpu/drm/radeon/radeon_vce.c                  |    1=20
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                   |    1=20
 drivers/gpu/vga/vga_switcheroo.c                     |    3=20
 drivers/hwmon/ina2xx.c                               |    7 -
 drivers/iio/adc/twl4030-madc.c                       |    1=20
 drivers/iio/inkern.c                                 |    6 -
 drivers/iommu/intel-iommu.c                          |    9 -
 drivers/irqchip/spear-shirq.c                        |    2=20
 drivers/md/dm-era-target.c                           |    3=20
 drivers/md/dm-thin.c                                 |    3=20
 drivers/md/md.c                                      |   13 ++
 drivers/mmc/host/rtsx_pci_sdmmc.c                    |    3=20
 drivers/mtd/nand/fsl_elbc_nand.c                     |   14 ++
 drivers/mtd/nand/omap2.c                             |    2=20
 drivers/mtd/nand/pxa3xx_nand.c                       |    4=20
 drivers/net/ethernet/allwinner/sun4i-emac.c          |    1=20
 drivers/net/ethernet/mellanox/mlx4/fw.c              |    2=20
 drivers/net/ethernet/mellanox/mlx4/main.c            |    2=20
 drivers/net/wireless/b43/xmit.c                      |   10 +
 drivers/net/wireless/iwlwifi/pcie/trans.c            |   26 ++--
 drivers/net/wireless/rt2x00/rt2500pci.c              |    7 +
 drivers/net/wireless/rt2x00/rt2x00.h                 |    1=20
 drivers/net/wireless/rt2x00/rt2x00dev.c              |   24 +++-
 drivers/net/wireless/rt2x00/rt2x00mac.c              |    2=20
 drivers/regulator/tps65218-regulator.c               |    3=20
 drivers/scsi/ibmvscsi/ibmvscsi.c                     |   13 ++
 drivers/scsi/scsi_error.c                            |    8 -
 drivers/scsi/sd.c                                    |    5=20
 drivers/scsi/virtio_scsi.c                           |   26 ++++
 drivers/staging/iio/adc/ad7291.c                     |    4=20
 drivers/staging/tidspbridge/core/tiomap3430.c        |    6 -
 drivers/tty/n_tty.c                                  |   19 +--
 drivers/tty/serial/8250/8250_core.c                  |    2=20
 drivers/tty/serial/altera_uart.c                     |    6 +
 drivers/tty/serial/amba-pl010.c                      |    2=20
 drivers/tty/serial/amba-pl011.c                      |    2=20
 drivers/tty/serial/atmel_serial.c                    |    2=20
 drivers/tty/serial/bcm63xx_uart.c                    |    2=20
 drivers/tty/serial/bfin_uart.c                       |    2=20
 drivers/tty/serial/dz.c                              |    2=20
 drivers/tty/serial/efm32-uart.c                      |    2=20
 drivers/tty/serial/fsl_lpuart.c                      |    2=20
 drivers/tty/serial/ip22zilog.c                       |    2=20
 drivers/tty/serial/m32r_sio.c                        |    2=20
 drivers/tty/serial/max310x.c                         |    2=20
 drivers/tty/serial/mcf.c                             |    6 +
 drivers/tty/serial/mfd.c                             |    2=20
 drivers/tty/serial/mpsc.c                            |    2=20
 drivers/tty/serial/msm_serial.c                      |    2=20
 drivers/tty/serial/mxs-auart.c                       |    2=20
 drivers/tty/serial/netx-serial.c                     |    2=20
 drivers/tty/serial/pmac_zilog.c                      |    2=20
 drivers/tty/serial/pnx8xxx_uart.c                    |    2=20
 drivers/tty/serial/pxa.c                             |    2=20
 drivers/tty/serial/sb1250-duart.c                    |    2=20
 drivers/tty/serial/sccnxp.c                          |    2=20
 drivers/tty/serial/serial_ks8695.c                   |    2=20
 drivers/tty/serial/serial_txx9.c                     |    2=20
 drivers/tty/serial/sirfsoc_uart.c                    |    2=20
 drivers/tty/serial/st-asc.c                          |    2=20
 drivers/tty/serial/sunsab.c                          |    2=20
 drivers/tty/serial/sunsu.c                           |    2=20
 drivers/tty/serial/sunzilog.c                        |    2=20
 drivers/tty/serial/ucc_uart.c                        |    2=20
 drivers/tty/serial/vr41xx_siu.c                      |    2=20
 drivers/tty/serial/zs.c                              |    2=20
 drivers/usb/chipidea/udc.c                           |    7 +
 drivers/usb/gadget/f_fs.c                            |   12 +-
 drivers/usb/host/xhci-ring.c                         |    9 +
 drivers/usb/host/xhci.c                              |   10 +
 drivers/usb/musb/musb_am335x.c                       |   23 +---
 drivers/usb/musb/musb_cppi41.c                       |    2=20
 drivers/usb/musb/ux500.c                             |    1=20
 drivers/usb/serial/ftdi_sio.c                        |    7 -
 drivers/usb/serial/option.c                          |   26 +++-
 drivers/usb/storage/scsiglue.c                       |    4=20
 drivers/usb/storage/unusual_devs.h                   |    7 +
 drivers/video/fbdev/fb-puv3.c                        |    2=20
 fs/btrfs/disk-io.c                                   |    3=20
 fs/cifs/cifs_unicode.c                               |    7 -
 fs/cifs/link.c                                       |    2=20
 fs/ext4/indirect.c                                   |   20 +++
 fs/nfsd/nfs4proc.c                                   |    9 -
 fs/nfsd/nfs4xdr.c                                    |   13 ++
 include/drm/i915_powerwell.h                         |    5=20
 include/linux/usb_usual.h                            |    4=20
 include/scsi/scsi_cmnd.h                             |    2=20
 include/scsi/scsi_device.h                           |    1=20
 include/uapi/linux/usb/functionfs.h                  |    7 +
 kernel/sysctl.c                                      |    3=20
 kernel/trace/trace.c                                 |    2=20
 kernel/trace/trace_uprobe.c                          |   40 ++++---
 mm/hugetlb.c                                         |   71 +++++++-----
 mm/memory.c                                          |    3=20
 mm/mempolicy.c                                       |   46 +++-----
 mm/nommu.c                                           |    2=20
 mm/page_alloc.c                                      |   56 +++++++---
 net/bluetooth/hci_conn.c                             |    7 -
 net/bluetooth/hci_event.c                            |   11 +-
 net/bluetooth/l2cap_core.c                           |    8 +
 net/bluetooth/l2cap_sock.c                           |    5=20
 net/bluetooth/mgmt.c                                 |  104 ++++++++++----=
-----
 net/bluetooth/smp.c                                  |    9 +
 net/mac80211/debugfs_netdev.c                        |    6 -
 net/mac80211/ibss.c                                  |    1=20
 net/mac80211/sta_info.c                              |    1=20
 net/netfilter/nf_conntrack_netlink.c                 |   14 +-
 net/netfilter/nf_nat_core.c                          |   35 ++++++
 sound/pci/hda/hda_i915.c                             |   67 +++++++++++-
 sound/pci/hda/hda_i915.h                             |    6 -
 sound/pci/hda/hda_intel.c                            |   57 ++--------
 tools/usb/ffs-test.c                                 |    4=20
 159 files changed, 913 insertions(+), 470 deletions(-)

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error=
 legs

Alan Stern (1):
      usb-storage/SCSI: Add broken_fua blacklist flag

Alex Deucher (9):
      vgaswitcheroo: switch the mux to the igp on power down when runpm is =
enabled
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon: add missing vce init case for hawaii
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet

Alex Elder (1):
      rbd: use reference counts for image requests

Andrew Morton (1):
      ia64: arch/ia64/include/uapi/asm/fcntl.h needs personality.h

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

Ben Widawsky (1):
      drm/i915/bdw: Only use 2g GGTT for 32b platforms

Bj=C3=B6rn Baumbach (1):
      fs/cifs: fix regression in cifs_create_mf_symlink()

Bj=C3=B8rn Mork (1):
      usb: option: add/modify Olivetti Olicard modems

Brian King (2):
      ibmvscsi: Abort init sequence during error recovery
      ibmvscsi: Add memory barriers for send / receive

Chen Gang (1):
      arch/unicore32/mm/alignment.c: include "asm/pgtable.h" to avoid compi=
ling error

ChiaHao (1):
      arm64: Bug fix in stack alignment exception

Chris Wilson (4):
      drm/i915: Reorder semaphore deadlock check
      drm/i915: Disable FBC by default also on Haswell and later
      drm/i915: Hold the table lock whilst walking the file's idr and count=
ing the objects in debugfs
      drm/i95: Initialize active ring->pid to -1

Dan Carpenter (1):
      staging: iio/ad7291: fix error code in ad7291_probe()

David R. Piegdon (1):
      ARM: OMAP2+: Fix parser-bug in platform muxing code

David Rientjes (1):
      mm, pcp: allow restoring percpu_pagelist_fraction default

Doug Smythies (1):
      intel_pstate: Correct rounding in busy calculation

Emmanuel Grumbach (1):
      iwlwifi: pcie: try to get ownership several times

Ezequiel Garcia (1):
      usb: musb: Fix panic upon musb_am335x module removal

Fabio Baltieri (1):
      hwmon: (ina2xx) Cast to s16 on shunt and current regs

Felix Fietkau (1):
      mac80211: fix a memory leak on sta rate selection table

Florian Westphal (2):
      netfilter: nf_nat: fix oops on netns removal
      netfilter: ctnetlink: fix refcnt leak in dying/unconfirmed list dumper

Greg Kroah-Hartman (1):
      Linux 3.15.5

Gregory CLEMENT (1):
      ARM: mvebu: Fix the improper use of the compatible string armada38x u=
sing a wildcard

Guido Mart=C3=ADnez (1):
      drm/i2c: tda998x: move drm_i2c_encoder_destroy call

Hugh Dickins (1):
      mm: fix crashes from mbind() merging vmas

Ilia Mirkin (1):
      drm/gk208/gr: add missing registers to grctx init

Ilya Dryomov (1):
      rbd: handle parent_overlap on writes correctly

Imre Deak (1):
      drm/i915: fix display power sw state reporting

J. Bruce Fields (1):
      nfsd: fix rare symlink decoding bug

Jack Morgenstein (1):
      mlx4_core: Fix incorrect FLAGS1 bitmap test in mlx4_QUERY_FUNC_CAP

Jan Kara (2):
      ext4: Fix buffer double free in ext4_alloc_branch()
      ext4: Fix hole punching for files with indirect blocks

Jani Nikula (3):
      drm/i915: set backlight duty cycle after backlight enable for gen4
      drm/i915: default to having backlight if VBT not available
      drm/i915: provide interface for audio driver to query cdclk

Jiang Liu (1):
      iommu/vt-d: fix bug in handling multiple RMRRs for the same PCI device

Joe Thornber (1):
      dm era: check for a non-NULL metadata object before closing it

Johan Hedberg (8):
      Bluetooth: Fix incorrectly overriding conn->src_type
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Refactor discovery stopping into its own function
      Bluetooth: Reuse hci_stop_discovery function when cleaning up HCI sta=
te
      Bluetooth: Fix setting correct authentication information for SMP STK
      Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Josef Bacik (1):
      btrfs: only unlock block in verify_parent_transid if we locked it

Jukka Taimisto (1):
      Bluetooth: Fix deadlock in l2cap_conn_del()

Keerthy (2):
      regulator: tps65218: Add the missing of_node assignment in probe
      regulator: tps65218: Correct the the config register for LDO1

Krzysztof Ha=C5=82asa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Mario Kleiner (4):
      drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.
      drm/nouveau/disp/nv04-nv40: abort scanoutpos query on vga analog.
      drm/nouveau/kms: reference vblank for crtc during pageflip.
      drm/nv50-/mc: fix kms pageflip events by reordering irq handling orde=
r.

Martin K. Petersen (1):
      SCSI: use the scsi data buffer length to extract transfer size

Mathias Nyman (2):
      xhci: Use correct SLOT ID when handling a reset device command
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Mengdong Lin (1):
      ALSA: hda - restore BCLK M/N value as per CDCLK for HSW/BDW display H=
DA controller

Michal Nazarewicz (4):
      usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
      usb: gadget: f_fs: fix NULL pointer dereference when there are no str=
ings
      mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER
      tools: ffs-test: fix header values endianess

Micky Ching (1):
      mmc: rtsx: add R1-no-CRC mmc command type handle

Minchan Kim (1):
      zram: revalidate disk after capacity change

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned=
 entry

NeilBrown (1):
      md: flush writes before starting a recovery.

Oleg Nesterov (2):
      tracing/uprobes: Revert "Support mix of ftrace and perf"
      tracing/uprobes: Fix the usage of uprobe_buffer_enable() in probe_eve=
nt_enable()

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Pablo Neira Ayuso (1):
      netfilter: ctnetlink: fix dumping of dying/unconfirmed conntracks

Paolo Bonzini (3):
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests
      KVM: x86: preserve the high 32-bits of the PAT register

Paul Kocialkowski (1):
      twl4030-madc: Request processed values in twl4030_get_madc_conversion

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Peter Hurley (2):
      serial: Fix IGNBRK handling
      tty: Correct INPCK handling

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Rik van Riel (1):
      mm/numa: Remove BUG_ON() in __handle_mm_fault()

Stanislaw Gruszka (2):
      rt2x00: disable TKIP on USB
      rt2x00: fix rfkill regression on rt2500pci

Stephen Boyd (2):
      clk: qcom: Fix clk_rcg2_is_enabled() check
      clk: qcom: Fix mmcc-8974's PLL configurations

Steve Capper (1):
      arm64: mm: Make icache synchronisation logic huge page aware

Steve French (1):
      CIFS: fix mount failure with broken pathnames when smb3 mount with ma=
pchars option

Steven Miao (1):
      mm: nommu: per-thread vma cache fix

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

Suman Anna (1):
      staging: tidspbridge: fix an erroneous removal of parentheses

Takashi Iwai (1):
      drm/i915, HD-audio: Don't continue probing when nomodeset is given

Tejun Heo (1):
      blkcg: fix use-after-free in __blkg_release_rcu() by making blkcg_gq =
refcnt an atomic_t

Thomas Gleixner (2):
      usb: musb: Ensure that cppi41 timer gets armed on premature DMA TX irq
      irqchip: spear_shirq: Fix interrupt offset

Thomas Hellstrom (1):
      drm/vmwgfx: Fix incorrect write to read-only register v2:

Thomas Petazzoni (1):
      mtd: pxa3xx_nand: make the driver work on big-endian systems

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Avoid div-by-zero when pixel_multiplier is zero

Vineet Gupta (1):
      ARC: Fix build breakage for !CONFIG_ARC_DW2_UNWIND

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Wei Yang (1):
      net/mlx4_core: Keep only one driver entry release mlx4_priv

Xiaoming Gao (1):
      kvm: fix wrong address when writing Hyper-V tsc page

Zhaowei Yuan (1):
      drm: fix NULL pointer access by wrong ioctl

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mm=
ap

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in=
 erased-page


--uAKRQypu60I7Lcqm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvZoJAAoJEDjbvchgkmk+024P/28z993NBvS+MlSF1DI8p/C8
BPcW3clwpWQQ9ViyOaEtbUPLt792fJNV/ux6Fm6ediJd0UjpMAuKwT8zYFc85+Ld
E1HZOlSwKXGA7w01RMgnTRzKKnjdbyiJcJY1LWS8wVB6M7UOT/iFiD8sN5s76lDK
ET83lihflWh7Zx50Vof+pN9bDyMAQwYnL+5zKBe4caqbaRb7aljBdgc4x968MM+4
GYUVINs6h8kFmGvFBqM0JDAg60uj506YUIEsSBk2a9NdCNZjwuyO2XNV+H7pLIyO
7kD1GlPMWAkEZ2niZ1WTb3Yz9hAV1kdWeh8NJOju0QWVBN02rVLAHMaExO9S+fuo
OOo7ZWSXxdLXU7vVvHv75AWZEtGYOLg+SFAjBuj6XrkiMqYNPTelTAEHD9+DGrfL
/Rwj0jWBaB6wNzxwWwxpfKj3/y1U81R1Wdc7eieLi3PNLrWZkeV0Q1S1Et9mgAtb
bZ2Cu2XVk1t2Zu7kMPnfVsiLrmiowJtajySxTSe1Iii/pMOFj/JVVrXYsNUGhS/c
kCQWJp6EhiOLLI76yZ7ZMeWDtJuEJlgi7OIvkS6pcR6s9P9paHrkO4VlDrHt+wlm
npcu1izv1xtqqrvYW7r2IZDTeNY8chJ9b/meCcGk/dIpZLxAV197fo6BOsYf+56e
0IMAA+LYSf0qpiggPNW6
=3o0v
-----END PGP SIGNATURE-----

--uAKRQypu60I7Lcqm--
