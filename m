Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031Ab3BDEcz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 23:32:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:50653 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753771Ab3BDEcy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 23:32:54 -0500
Date: Sun, 3 Feb 2013 20:35:00 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.29
Message-ID: <20130204043500.GA14912@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.29 kernel.

All users of the 3.4 kernel series must upgrade.

The updated 3.4.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.g=
it linux-3.4.y
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git=
;a=3Dsummary

thanks,

greg k-h

------------

 Makefile                                              |    2 -
 arch/arm/mach-at91/setup.c                            |    2 +
 arch/arm/mm/dma-mapping.c                             |   18 +++++----
 arch/arm/vfp/entry.S                                  |    6 +--
 arch/arm/vfp/vfphw.S                                  |    4 +-
 arch/x86/kernel/msr.c                                 |    3 +
 arch/x86/kernel/setup.c                               |    2 +
 arch/x86/platform/efi/efi.c                           |    2 -
 arch/x86/platform/efi/efi_64.c                        |   22 ++++++++---
 drivers/edac/edac_pci_sysfs.c                         |    2 -
 drivers/gpu/drm/radeon/radeon_cursor.c                |    3 +
 drivers/gpu/drm/radeon/radeon_display.c               |    2 -
 drivers/iommu/amd_iommu_init.c                        |   34 +++++++++++++=
++++
 drivers/iommu/intel-iommu.c                           |   21 +++++++---
 drivers/net/can/c_can/c_can.c                         |    4 +-
 drivers/net/can/pch_can.c                             |    2 -
 drivers/net/can/ti_hecc.c                             |    4 +-
 drivers/net/wireless/ath/ath9k/beacon.c               |    1=20
 drivers/net/wireless/ath/ath9k/htc_hst.c              |    2 +
 drivers/net/wireless/ath/ath9k/recv.c                 |   10 +++--
 drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |    7 ++-
 drivers/net/wireless/iwlegacy/common.c                |   35 +++++++------=
-----
 drivers/net/wireless/mwifiex/pcie.c                   |    2 -
 drivers/target/target_core_fabric_configfs.c          |   11 ++---
 fs/cifs/cifs_dfs_ref.c                                |    2 +
 fs/nfs/namespace.c                                    |   20 ++++++++++
 fs/xfs/xfs_aops.c                                     |    2 -
 kernel/smp.c                                          |   13 ++++++
 net/bluetooth/hci_event.c                             |    2 -
 net/bluetooth/hidp/core.c                             |    2 -
 net/mac80211/cfg.c                                    |   12 +++++-
 net/mac80211/ieee80211_i.h                            |    6 +--
 net/mac80211/offchannel.c                             |   17 +++-----
 net/mac80211/scan.c                                   |   15 ++-----
 net/mac80211/work.c                                   |    4 +-
 sound/pci/hda/patch_realtek.c                         |    1=20
 sound/soc/codecs/wm2200.c                             |    3 -
 sound/usb/mixer.c                                     |   17 ++++++--
 38 files changed, 208 insertions(+), 109 deletions(-)

Alan Cox (1):
      x86/msr: Add capabilities check

Anderson Lizardo (1):
      Bluetooth: Fix incorrect strncpy() in hidp_setup_hid()

Avinash Patil (1):
      mwifiex: fix typo in PCIe adapter NULL check

Chris Rattray (1):
      ASoC: wm2200: correct mixer values and text

Clemens Ladisch (1):
      ALSA: usb-audio: fix invalid length check for RME and other UAC 2 dev=
ices

Cong Ding (1):
      fs/cifs/cifs_dfs_ref.c: fix potential memory leakage

Dan Carpenter (1):
      EDAC: Test correct variable in ->store function

Daniel Vetter (1):
      iommu/intel: disable DMAR for g4x integrated gfx

Felix Fietkau (2):
      ath9k: do not link receive buffers during flush
      ath9k: fix double-free bug on beacon generate failure

Greg Kroah-Hartman (1):
      Linux 3.4.29

H. Peter Anvin (1):
      x86/Sandy Bridge: Sandy Bridge workaround depends on CONFIG_PCI

Jan Kara (1):
      xfs: Fix possible use-after-free with AIO

Jean-Christophe PLAGNIOL-VILLARD (1):
      ARM: at91: rm9200: remake the BGA as default version

Jerome Glisse (1):
      drm/radeon: fix cursor corruption on DCE6 and newer

Johannes Berg (1):
      mac80211: fix FT roaming

Matt Fleming (1):
      x86, efi: Set runtime_version to the EFI spec revision

Nathan Zimmer (1):
      efi, x86: Pass a proper identity mapping in efi_call_phys_prelog

Nicholas Bellinger (1):
      target: fix regression with dev_link_magic in target_fabric_port_link

Olivier Sobrie (3):
      can: c_can: fix invalid error codes
      can: ti_hecc: fix invalid error codes
      can: pch_can: fix invalid error codes

Piotr Haber (1):
      brcmsmac: increase timer reference count for new timers only

Russell King (1):
      ARM: DMA: Fix struct page iterator in dma_cache_maint() to work with =
sparsemem

Stanislaw Gruszka (2):
      iwlegacy: fix IBSS cleanup
      mac80211: synchronize scan off/on-channel and PS states

Stephen Boyd (1):
      ARM: 7627/1: Predicate preempt logic on PREEMP_COUNT not PREEMPT alone

Sujith Manoharan (1):
      ath9k_htc: Fix memory leak

Suravee Suthikulpanit (1):
      IOMMU, AMD Family15h Model10-1Fh erratum 746 Workaround

Szymon Janc (1):
      Bluetooth: Fix sending HCI commands after reset

Takashi Iwai (1):
      ALSA: hda - Add a fixup for Packard-Bell desktop with ALC880

Trond Myklebust (1):
      NFS: Don't silently fail setattr() requests on mountpoints

Wang YanQing (1):
      smp: Fix SMP function call empty cpu mask race

xueminsu (1):
      radeon_display: Use pointer return error codes


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRDzp0AAoJEDjbvchgkmk+9d4QAJUIcT557fkrQSSxk9WUfcq3
8p8YqfWX0n5sAqLGrBP5E+XaWMtgSpr60dj0NTj74ljaq5qPzChb0OOCJC1B1ViY
RjAiWvX036mFXA3zQntamObWCqte4buFpVkexmiEJ53Th70j7vVLqe2eEOiRci1M
RppPW5eSNBbDBk1dyxww/+8aqdPSyUBaoTIX7rGK0ounNUHptozShWeNWLaprLWp
POGF/xDwlV6yOMhOacZjBaF+46tg4zS0MlAh/BAVDWs0XrSpJRQ7r6AJft9r/tOr
X4HrNqM6+excT80oQlAhj2BANuM0qGuXqFOWfRq7rsa9iHzMx8PDBZyETObJ+yKv
kQ3qAp1I3zewQmq4e6r2vf5wKzrTGhEYmVvlsCPJqXdZBd4Sy08q9/QfeMzQyf4h
FJZ3/h1OCqfnOMsmk9NflnboVJlgPhiSJHTOxwJNrJnjhvNggaSuUAYlvyqESuIM
WXFv4k96XSAFL0uvcSvp1GXxcMGmueGnbe4mvvKp8onfq1OQzWdjZHtYBq9yHRFQ
TTVxexrveFRJfIoVtdUgPLhkJ5EaAxqxTAHieoVjjOIBF8HTvWOQz39/jvpgLx3Z
uJx7EVwItNfBq4edQ7yOdIqb7ob0tHJ7rsYlNTUjCY//sLnx0UBlGFKIm7XFo1s/
fuD6EsRDD+C6RYD0JBnf
=imr3
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
