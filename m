Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382AbaGITc7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:32:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47544 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314AbaGITc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:32:56 -0400
Date: Wed, 9 Jul 2014 12:37:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.14.12
Message-ID: <20140709193721.GA16439@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.14.12 kernel.

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

 Documentation/sysctl/vm.txt                          |    3=20
 Makefile                                             |    2=20
 arch/arm/mach-omap2/mux.c                            |    6 -
 arch/arm64/kernel/entry.S                            |    1=20
 arch/arm64/mm/flush.c                                |    3=20
 arch/unicore32/mm/alignment.c                        |    1=20
 arch/x86/include/asm/kvm_host.h                      |    4=20
 arch/x86/kvm/x86.c                                   |    2=20
 block/blk-cgroup.c                                   |    7 -
 block/blk-cgroup.h                                   |   17 +--
 drivers/block/rbd.c                                  |   19 +++-
 drivers/clk/qcom/clk-rcg2.c                          |    2=20
 drivers/clk/qcom/mmcc-msm8974.c                      |   13 +-
 drivers/cpufreq/intel_pstate.c                       |    5 -
 drivers/gpu/drm/i915/intel_panel.c                   |    5 -
 drivers/gpu/drm/i915/intel_pm.c                      |   17 +++
 drivers/gpu/drm/i915/intel_sdvo.c                    |    4=20
 drivers/gpu/drm/nouveau/core/engine/disp/nv04.c      |    8 +
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnv108.c |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv50.c        |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nv98.c        |    2=20
 drivers/gpu/drm/nouveau/core/subdev/mc/nvc0.c        |    2=20
 drivers/gpu/drm/nouveau/nouveau_display.c            |   17 +++
 drivers/gpu/drm/radeon/atombios_crtc.c               |   48 +++++-----
 drivers/gpu/drm/radeon/atombios_dp.c                 |   17 +++
 drivers/gpu/drm/radeon/atombios_encoders.c           |    5 -
 drivers/gpu/drm/radeon/cikd.h                        |    2=20
 drivers/gpu/drm/radeon/cypress_dpm.c                 |    2=20
 drivers/gpu/drm/radeon/ni_dpm.c                      |    2=20
 drivers/gpu/drm/radeon/radeon_connectors.c           |    2=20
 drivers/gpu/drm/radeon/radeon_cs.c                   |    6 +
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                   |    1=20
 drivers/gpu/vga/vga_switcheroo.c                     |    3=20
 drivers/hwmon/ina2xx.c                               |    7 -
 drivers/iio/inkern.c                                 |    6 -
 drivers/irqchip/spear-shirq.c                        |    2=20
 drivers/md/dm-thin.c                                 |    3=20
 drivers/md/md.c                                      |   13 ++
 drivers/mmc/host/rtsx_pci_sdmmc.c                    |    3=20
 drivers/mtd/nand/fsl_elbc_nand.c                     |   14 ++
 drivers/mtd/nand/omap2.c                             |    2=20
 drivers/mtd/nand/pxa3xx_nand.c                       |    4=20
 drivers/net/ethernet/allwinner/sun4i-emac.c          |    1=20
 drivers/net/ethernet/mellanox/mlx4/fw.c              |    2=20
 drivers/net/wireless/b43/xmit.c                      |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/sdio_chip.c  |    5 -
 drivers/net/wireless/iwlwifi/pcie/trans.c            |   26 +++--
 drivers/net/wireless/rt2x00/rt2500pci.c              |    7 +
 drivers/net/wireless/rt2x00/rt2x00.h                 |    1=20
 drivers/net/wireless/rt2x00/rt2x00dev.c              |   24 ++++-
 drivers/net/wireless/rt2x00/rt2x00mac.c              |    2=20
 drivers/scsi/ibmvscsi/ibmvscsi.c                     |   13 ++
 drivers/scsi/scsi_error.c                            |    8 -
 drivers/scsi/sym53c8xx_2/sym_hipd.c                  |    4=20
 drivers/scsi/virtio_scsi.c                           |   26 +++++
 drivers/staging/iio/adc/ad7291.c                     |    4=20
 drivers/tty/n_tty.c                                  |   19 ++--
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
 drivers/usb/host/xhci.c                              |   10 +-
 drivers/usb/musb/musb_am335x.c                       |   23 +---
 drivers/usb/musb/musb_cppi41.c                       |    2=20
 drivers/usb/musb/ux500.c                             |    1=20
 drivers/usb/serial/ftdi_sio.c                        |    7 +
 drivers/usb/serial/option.c                          |   26 ++++-
 drivers/video/fb-puv3.c                              |    2=20
 fs/aio.c                                             |   36 ++++++-
 fs/cifs/cifs_unicode.c                               |    7 -
 fs/cifs/link.c                                       |    2=20
 fs/ext4/indirect.c                                   |   20 +++-
 fs/nfsd/nfs4proc.c                                   |    9 -
 fs/nfsd/nfs4xdr.c                                    |   13 ++
 include/uapi/linux/usb/functionfs.h                  |    7 +
 kernel/auditsc.c                                     |    2=20
 kernel/sysctl.c                                      |    3=20
 kernel/trace/trace.c                                 |    2=20
 mm/hugetlb.c                                         |   71 +++++++++------
 mm/memory.c                                          |    3=20
 mm/mempolicy.c                                       |   46 ++++-----
 mm/page_alloc.c                                      |   56 ++++++++---
 mm/slab.c                                            |   89 ++++++++++++++=
-----
 net/bluetooth/hci_conn.c                             |    2=20
 net/bluetooth/hci_event.c                            |   11 +-
 net/bluetooth/l2cap_sock.c                           |    5 -
 net/bluetooth/mgmt.c                                 |    7 +
 net/mac80211/debugfs_netdev.c                        |    6 -
 net/mac80211/ibss.c                                  |    1=20
 net/mac80211/sta_info.c                              |    1=20
 net/netfilter/nf_nat_core.c                          |   35 +++++++
 sound/usb/pcm.c                                      |    3=20
 tools/usb/ffs-test.c                                 |    4=20
 126 files changed, 726 insertions(+), 328 deletions(-)

Adam Thomson (1):
      iio: of_iio_channel_get_by_name() returns non-null pointers for error=
 legs

Alex Deucher (8):
      vgaswitcheroo: switch the mux to the igp on power down when runpm is =
enabled
      drm/radeon: only apply hdmi bpc pll flags when encoder mode is hdmi
      drm/radeon: fix typo in radeon_connector_is_dp12_capable()
      drm/radeon/dp: fix lane/clock setup for dp 1.2 capable devices
      drm/radeon/atom: fix dithering on certain panels
      drm/radeon/dpm: fix typo in vddci setup for eg/btc
      drm/radeon/dpm: fix vddci setup typo on cayman
      drm/radeon/cik: fix typo in EOP packet

Alex Elder (1):
      rbd: use reference counts for image requests

Anatol Pomozov (1):
      aio: block io_destroy() until all context requests are completed

Arik Nemtsov (1):
      mac80211: don't check netdev state for debugfs read/write

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

Florian Westphal (1):
      netfilter: nf_nat: fix oops on netns removal

Greg Kroah-Hartman (1):
      Linux 3.14.12

Hans de Goede (1):
      brcmfmac: Fix brcmf_chip_ai_coredisable not applying reset bits to BC=
MA_IOCTL

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

Jani Nikula (1):
      drm/i915: set backlight duty cycle after backlight enable for gen4

Johan Hedberg (4):
      Bluetooth: Fix SSP acceptor just-works confirmation without MITM
      Bluetooth: Fix check for connection encryption
      Bluetooth: Fix indicating discovery state when canceling inquiry
      Bluetooth: Fix locking of hdev when calling into SMP code

Johan Hovold (1):
      USB: ftdi_sio: fix null deref at port probe

Joonsoo Kim (1):
      slab: fix oops when reading /proc/slab_allocators

Krzysztof Ha=C5=82asa (1):
      mac80211: fix IBSS join by initializing last_scan_completed

Linus Walleij (1):
      usb: musb: ux500: don't propagate the OF node

Lukas Czerner (1):
      dm thin: update discard_granularity to reflect the thin-pool blocksize

Marcin Kraglak (1):
      Bluetooth: Allow change security level on ATT_CID in slave role

Marek Ol=C5=A1=C3=A1k (1):
      drm/radeon: don't allow RADEON_GEM_DOMAIN_CPU for command submission

Mario Kleiner (4):
      drm/nouveau/kms/nv04-nv40: fix pageflip events via special case.
      drm/nouveau/disp/nv04-nv40: abort scanoutpos query on vga analog.
      drm/nouveau/kms: reference vblank for crtc during pageflip.
      drm/nv50-/mc: fix kms pageflip events by reordering irq handling orde=
r.

Mathias Nyman (2):
      xhci: Use correct SLOT ID when handling a reset device command
      xhci: correct burst count field for isoc transfers on 1.0 xhci hosts

Maxime Ripard (1):
      net: allwinner: emac: Add missing free_irq

Michal Nazarewicz (4):
      usb: gadget: f_fs: resurect usb_functionfs_descs_head structure
      usb: gadget: f_fs: fix NULL pointer dereference when there are no str=
ings
      tools: ffs-test: fix header values endianess
      mm: page_alloc: fix CMA area initialisation when pageblock > MAX_ORDER

Micky Ching (1):
      mmc: rtsx: add R1-no-CRC mmc command type handle

Mikulas Patocka (1):
      sym53c8xx_2: Set DID_REQUEUE return code when aborting squeue

Nadav Amit (1):
      KVM: x86: Increase the number of fixed MTRR regs to 10

Naoya Horiguchi (1):
      hugetlb: fix copy_hugetlb_page_range() to handle migration/hwpoisoned=
 entry

NeilBrown (1):
      md: flush writes before starting a recovery.

Oliver Neukum (1):
      USB: option: add device ID for SpeedUp SU9800 usb 3g modem

Paolo Bonzini (3):
      virtio-scsi: avoid cancelling uninitialized work items
      virtio-scsi: fix various bad behavior on aborted requests
      KVM: x86: preserve the high 32-bits of the PAT register

Pekon Gupta (1):
      mtd: eLBC NAND: fix subpage write support

Peter Chen (1):
      usb: chipidea: udc: delete td from req's td list at ep_dequeue

Peter Hurley (2):
      serial: Fix IGNBRK handling
      tty: Correct INPCK handling

Rafa=C5=82 Mi=C5=82ecki (1):
      b43: fix frequency reported on G-PHY with /new/ firmware

Richard Guy Briggs (1):
      audit: remove superfluous new- prefix in AUDIT_LOGIN messages

Rik van Riel (1):
      mm/numa: Remove BUG_ON() in __handle_mm_fault()

Sander Eikelenboom (1):
      ALSA: usb-audio: Prevent printk ratelimiting from spamming kernel log=
 while DEBUG not defined

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

Steven Rostedt (Red Hat) (1):
      tracing: Remove ftrace_stop/start() from reading the trace file

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

Tim Gardner (1):
      ALSA: usb-audio: Suppress repetitive debug messages from retire_playb=
ack_urb()

Ulrich Obergfell (1):
      scsi_error: fix invalid setting of host byte

Ville Syrj=C3=A4l=C3=A4 (1):
      drm/i915: Avoid div-by-zero when pixel_multiplier is zero

Wang, Yu (1):
      xhci: Fix runtime suspended xhci from blocking system suspend.

Xiaoming Gao (1):
      kvm: fix wrong address when writing Hyper-V tsc page

Zhichuang SUN (1):
      drivers/video/fbdev/fb-puv3.c: Add header files for function unifb_mm=
ap

pekon gupta (1):
      mtd: nand: omap: fix BCHx ecc.correct to return detected bit-flips in=
 erased-page


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTvZnxAAoJEDjbvchgkmk+IkYP/1hDzbt6YCMDdmuG+oSPZKt4
7UgArMiWJDz5a88ATEe6MMTOvqYODO/h/YP61o3uEkBSJH572eIITlAfC+/p0FRz
p/tU4f5Sj81/ta0DUwWJswe6iZKb7jzCV9qsvjFldbSJsPIxOzt64t52vT50gEyI
IfB8ptFnLfeDYQ7E4HuE3wrNRzawKMJDPhQDFa3FrP+9iO5OC3JZ5ZCsZOiz1xJd
XITKLXj1AbFGRx9bqBq4jb01Y6eqJ6+yR7Jpmsxe8M8+J7u7+0f8cbesTXVPDjpk
Cvd8IueIJc+gysODD18bkXtfNafv+H/fkOOW/oDPu0tcu7A08NOYDw5oTWMhg91O
NICjw9nSvxFupjYZAVAwAPuGt2g6OHwdAhzOx8aPUzeZ5T1EhamQeCrrqqwf7iM0
mFl+GdmZP6G5jMvVvdY6UTksNGDywcAeDBACt+ZEjxQnGieDSsNJldlzYfBWsbVY
dpaP409liZuSaV/RTtQHHazdjdHogyMV+ZMhMacy0BnMqPEz3OfwBjOWNaMUCl2W
vwA7WImADZu6sGbJ5do9G23vkb0oCdGaMCtWlC23jdWMmy9eAzmqJFsBW8Es6mPa
NVyebrjyVkqvFUYXJqtMpoockz34du0rF8EBTvj3jQcXirfTjOate+LV6lJ9E+H8
AsQxEhpXVJAWoBkg/x00
=Yfwv
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
