Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933257Ab3LDTw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 14:52:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34761 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932971Ab3LDTw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 14:52:26 -0500
Date: Wed, 4 Dec 2013 11:52:25 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.72
Message-ID: <20131204195225.GA28713@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.72 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linu=
x-3.4.y
and can be browsed at the normal kernel.org git web browser:
	http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3Dsu=
mmary

thanks,

greg k-h

------------

 Documentation/sysctl/kernel.txt               |   25 ++++++---
 Makefile                                      |    2=20
 arch/arm/mach-integrator/integrator_cp.c      |    3 -
 arch/arm/mach-sa1100/assabet.c                |    3 +
 arch/avr32/boot/u-boot/head.S                 |   35 +++++++++++--
 arch/avr32/kernel/entry-avr32b.S              |    3 -
 arch/avr32/kernel/head.S                      |   20 -------
 arch/powerpc/kernel/signal_32.c               |   16 ++----
 arch/powerpc/kernel/signal_64.c               |    6 ++
 drivers/ata/ahci.c                            |    2=20
 drivers/ata/libahci.c                         |   16 ++++++
 drivers/ata/libata-core.c                     |    1=20
 drivers/ata/libata-transport.c                |   16 +++---
 drivers/block/loop.c                          |    4 +
 drivers/block/xen-blkback/blkback.c           |    3 -
 drivers/gpu/drm/i915/intel_display.c          |    4 +
 drivers/gpu/drm/nouveau/nouveau_gem.c         |    3 -
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |   28 ++++++++++
 drivers/gpu/drm/radeon/sid.h                  |    2=20
 drivers/gpu/drm/ttm/ttm_bo_util.c             |    4 +
 drivers/hid/hid-apple.c                       |   22 ++++++++
 drivers/hid/hid-roccat-kovaplus.c             |    4 +
 drivers/infiniband/hw/ipath/ipath_user_sdma.c |    7 --
 drivers/input/serio/i8042-x86ia64io.h         |    2=20
 drivers/md/dm-table.c                         |   18 ++++++
 drivers/md/md.c                               |    1=20
 drivers/mtd/nand/gpmi-nand/gpmi-nand.c        |    4 -
 drivers/mtd/nand/nand_base.c                  |   15 ++++-
 drivers/net/can/flexcan.c                     |   12 ----
 drivers/net/wireless/mwifiex/sdio.c           |    3 +
 drivers/net/wireless/prism54/islpci_dev.c     |    7 +-
 drivers/net/wireless/rt2x00/rt2400pci.c       |    2=20
 drivers/net/wireless/rtlwifi/rtl8192cu/mac.c  |    6 +-
 drivers/net/wireless/rtlwifi/rtl8192cu/trx.c  |    8 +--
 drivers/net/wireless/rtlwifi/rtl8192de/trx.c  |    2=20
 drivers/net/wireless/rtlwifi/rtl8192se/rf.c   |    2=20
 drivers/net/wireless/rtlwifi/rtl8192se/trx.c  |    2=20
 drivers/pci/pcie/portdrv_pci.c                |    1=20
 drivers/s390/net/qeth_core_main.c             |    6 +-
 drivers/staging/media/lirc/lirc_zilog.c       |   12 ++++
 drivers/staging/tidspbridge/Kconfig           |    2=20
 drivers/staging/vt6656/baseband.c             |   11 ++++
 drivers/staging/vt6656/rndis.h                |    1=20
 drivers/target/iscsi/iscsi_target_auth.c      |    5 +
 drivers/target/iscsi/iscsi_target_nego.c      |    2=20
 drivers/video/backlight/atmel-pwm-bl.c        |    4 -
 fs/devpts/inode.c                             |    1=20
 fs/ext4/xattr.c                               |    1=20
 include/linux/mtd/map.h                       |    4 -
 include/trace/ftrace.h                        |    5 +
 kernel/audit.c                                |    5 +
 kernel/cpuset.c                               |    8 ++-
 kernel/power/snapshot.c                       |    6 +-
 kernel/time/alarmtimer.c                      |    4 -
 kernel/trace/ftrace.c                         |   68 +++++++++++++--------=
-----
 lib/vsprintf.c                                |   33 +++++++++++-
 security/selinux/netlabel.c                   |    6 --
 sound/pci/hda/patch_realtek.c                 |    1=20
 sound/soc/blackfin/bf5xx-i2s.c                |    1=20
 sound/soc/codecs/ak4642.c                     |    2=20
 sound/soc/codecs/wm8962.c                     |    2=20
 virt/kvm/kvm_main.c                           |   25 +++++----
 62 files changed, 362 insertions(+), 167 deletions(-)

Aaron Lu (1):
      PM / hibernate: Avoid overflow in hibernate_preallocate_memory()

Alex Deucher (1):
      drm/radeon/si: fix define for MC_SEQ_TRAIN_WAKEUP_CNTL

Alex Williamson (1):
      KVM: Fix iommu map/unmap to handle memory slot moves

Andreas Bie=DFmann (2):
      avr32: setup crt for early panic()
      avr32: fix out-of-range jump in large kernels

Avinash Patil (1):
      mwifiex: correct packet length for packets from SDIO interface

Ben Skeggs (1):
      drm/nouveau: when bailing out of a pushbuf ioctl, do not remove previ=
ous fence

Brian Norris (1):
      mtd: nand: hack ONFI for non-power-of-2 dimensions

Dan Williams (1):
      prism54: set netdev type to "wlan"

Daniel Vetter (1):
      drm/i915: flush cursors harder

Eric Seppanen (2):
      iscsi-target: fix extract_param to handle buffer length corner case
      iscsi-target: chap auth shouldn't match username with trailing garbage

Felipe Pena (1):
      rtlwifi: rtl8192se: Fix wrong assignment

Greg Kroah-Hartman (2):
      Staging: tidspbridge: disable driver
      Linux 3.4.72

Gwendal Grignou (1):
      libata: Fix display of sata speed

Huang Shijie (1):
      mtd: gpmi: fix kernel BUG due to racing DMA operations

Ilija Hadzic (1):
      devpts: plug the memory leak in kill_sb

Jakob Bornecrantz (1):
      drm/ttm: Handle in-memory region copies

Jan Kara (1):
      IB/ipath: Convert ipath_user_sdma_pin_pages() to use get_user_pages_f=
ast()

Jerome Glisse (1):
      radeon: workaround pinning failure on low ram gpu

Johan Hovold (1):
      backlight: atmel-pwm-bl: fix reported brightness

Jonathan Austin (1):
      ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD

KOSAKI Motohiro (1):
      alarmtimer: return EINVAL instead of ENOTSUPP if rtcdev doesn't exist

Kailang Yang (1):
      ALSA: hda/realtek - Set pcbeep amp for ALC668

Larry Finger (4):
      rtlwifi: rtl8192cu: Fix more pointer arithmetic errors
      rtlwifi: rtl8192de: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192se: Fix incorrect signal strength for unassociated AP
      rtlwifi: rtl8192cu: Fix incorrect signal strength for unassociated AP

Malcolm Priestley (1):
      staging: vt6656: [BUG] Fix for TX USB resets from vendors driver.

Marc Kleine-Budde (1):
      can: flexcan: fix flexcan_chip_start() on imx6

Marcelo Tosatti (1):
      KVM: perform an invalid memslot step for gpa base change

Mathias Krause (2):
      audit: use nlmsg_len() to get message payload length
      audit: fix info leak in AUDIT_GET requests

Mauro Carvalho Chehab (1):
      media: lirc_zilog: Don't use dynamic static allocation

Michael Neuling (1):
      powerpc/signals: Improved mark VSX not saved with small contexts fix

Mikulas Patocka (2):
      loop: fix crash if blk_alloc_queue fails
      dm: allocate buffer for messages with small number of arguments using=
 GFP_NOIO

Nanno Langstraat (1):
      HID: apple: option to swap the 'Option' ("Alt") and 'Command' ("Flag"=
) keys.

NeilBrown (1):
      md: fix calculation of stacking limits on level change.

Nicolin Chen (1):
      ASoC: wm8962: Turn on regcache_cache_only before disabling regulator

Paul Moore (1):
      selinux: correct locking in selinux_netlbl_socket_connect)

Peter Zijlstra (1):
      cpuset: Fix memory allocator deadlock

Phil Edworthy (1):
      ASoC: ak4642: prevent un-necessary changes to SG_SL1

Russell King (1):
      ARM: sa11x0/assabet: ensure CS2 is configured appropriately

Ryan Mallon (1):
      vsprintf: check real user/group id for %pK

Samir Benmendil (1):
      ahci: add Marvell 9230 to the AHCI PCI device list

Shan Hai (1):
      drivers/libata: Set max sector to 65535 for Slimtype DVD A DS8A9SH dr=
ive

Stanislaw Gruszka (1):
      rt2400pci: fix RSSI read

Stefan Achatz (1):
      HID: roccat: fix Coverity CID 141438

Steven Rostedt (Red Hat) (2):
      tracing: Allow events to have NULL strings
      ftrace: Fix function graph with loading of modules

Takashi Iwai (1):
      ASoC: blackfin: Fix missing break

Theodore Ts'o (1):
      ext4: avoid bh leak in retry path of ext4_expand_extra_isize_ea()

Tom Gundersen (1):
      Input: i8042 - add PNP modaliases

Tyler Hicks (1):
      audit: printk USER_AVC messages when audit isn't enabled

Ursula Braun (1):
      qeth: avoid buffer overflow in snmp ioctl

Vegard Nossum (1):
      xen/blkback: fix reference counting

Wang Haitao (1):
      mtd: map: fixed bug in 64-bit systems

Yinghai Lu (1):
      PCI: Remove duplicate pci_disable_device() from pcie_portdrv_remove()

xiangliang yu (1):
      ahci: disabled FBS prior to issuing software reset


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSn4f5AAoJEDjbvchgkmk+Jr0QAK4a1yY63qHBjc6QakEp87KI
+Px4F8tcLFTKBL1fbUHla0YMUIVX+cbJU3hdmRWjAFh4Hpi0D9xFLbZ2Ag+Uo40S
dPIE+g+sFIkGS0qzv3DLWBM6CRNSrs6+JidjEjWhNHhPvEX0ZIwN5xrb3CgwTJlE
QzceL0h/43avfaXCRJEQvc0KCx2xSnkoHNy4jD2YAry0qCn7KQaw7LBa6EG3smmN
KvvoMkUnFr7OcBWoyStNqa7ikacEPwgnXFnLdy6pd+p34x5rRGnfKC7nnEUrzyR4
1mRDSfTJoUmQWR0Bm1/vLHua+jGCHHlJsljxkeCN9loZlAjbuBjFKYGbOsb1xc7w
pIOWSY2HGX8pf7kDWklbXaRCvBKPo0rGrF2hXZ1+xabRfTmvFWrJR+APOtMoFuFu
Xwg+0ymiVB5fvxm2s2IX3GbZ5r/kh0ZRRMcUk4QDZI2x4td7IduQmDN/eynugWPC
AuOZHsGUtguA1BMRtQjb4sp4ZCl/sEExOnOf8+in8sqbfhrmLzIhthdEisMh0d3i
d70Jz7IEmoOtHyuscpHO0eximgZAu5wH3kXls2rN38XsvZG9SIpo20hfGNUntPt7
M93ubHDKe1nJFmY3tap0KJ24Twds8IVl4EMLIbX+R/zPvx100NLL/u17xBRP8Qch
ceg14Ce4VEJrAjLekSWL
=hI8Q
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
