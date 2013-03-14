Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214Ab3CNSrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 14:47:53 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63787 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3CNSrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 14:47:51 -0400
Date: Thu, 14 Mar 2013 11:47:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Linux 3.4.36
Message-ID: <20130314184747.GA20495@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9amGYk9869ThD9tj"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9amGYk9869ThD9tj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm announcing the release of the 3.4.36 kernel.

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

 Makefile                                   |    2=20
 arch/arm/kernel/perf_event_v7.c            |    2=20
 arch/arm/mm/alignment.c                    |   11 -
 arch/arm/vfp/vfpmodule.c                   |    2=20
 arch/x86/pci/xen.c                         |    9 +
 arch/x86/xen/enlighten.c                   |   10 +
 crypto/ablkcipher.c                        |   12 -
 crypto/aead.c                              |    9 -
 crypto/ahash.c                             |    2=20
 crypto/blkcipher.c                         |    6=20
 crypto/crypto_user.c                       |   22 +--
 crypto/pcompress.c                         |    3=20
 crypto/rng.c                               |    2=20
 crypto/shash.c                             |    3=20
 drivers/ata/ata_piix.c                     |   25 +++-
 drivers/char/hw_random/core.c              |   19 ++-
 drivers/cpufreq/cpufreq_stats.c            |    1=20
 drivers/firmware/dmi_scan.c                |    5=20
 drivers/gpu/drm/radeon/radeon_combios.c    |    9 +
 drivers/hid/hid-logitech-dj.c              |   22 ++-
 drivers/hwmon/pmbus/ltc2978.c              |   30 ++--
 drivers/hwmon/sht15.c                      |    8 +
 drivers/md/md.c                            |    7 +
 drivers/md/raid0.c                         |    5=20
 drivers/net/ethernet/intel/e1000e/netdev.c |    2=20
 drivers/net/wireless/ath/ath9k/common.h    |    2=20
 drivers/net/wireless/ath/ath9k/hw.c        |    4=20
 drivers/net/wireless/mwifiex/pcie.c        |    2=20
 drivers/scsi/dc395x.c                      |    2=20
 drivers/scsi/storvsc_drv.c                 |    1=20
 drivers/target/target_core_pscsi.c         |    1=20
 drivers/usb/core/hub.c                     |  178 +++++++++++++++---------=
-----
 fs/btrfs/volumes.c                         |    1=20
 fs/cifs/cifsfs.c                           |    5=20
 fs/compat.c                                |   15 +-
 fs/nfs/unlink.c                            |   20 ++-
 fs/pipe.c                                  |    3=20
 kernel/trace/Kconfig                       |   24 ++-
 mm/process_vm_access.c                     |    8 -
 net/sunrpc/xprt.c                          |    6=20
 security/keys/compat.c                     |    4=20
 security/keys/process_keys.c               |    2=20
 sound/core/vmaster.c                       |    5=20
 sound/pci/hda/patch_hdmi.c                 |    3=20
 sound/pci/ice1712/ice1712.c                |    2=20
 45 files changed, 310 insertions(+), 206 deletions(-)

Al Viro (1):
      vfs: fix pipe counter breakage

Alex Deucher (1):
      drm/radeon: add primary dac adj quirk for R200 board

Asias He (1):
      target/pscsi: Fix page increment

Avinash Patil (1):
      mwifiex: correct sleep delay counter

Ben Hutchings (1):
      dmi_scan: fix missing check for _DMI_ signature in smbios_present()

Benjamin Tissoires (1):
      HID: logitech-dj: do not directly call hid_output_raw_report() during=
 probe

Dan Carpenter (1):
      SCSI: dc395x: uninitialized variable in device_alloc()

David Howells (1):
      keys: fix race with concurrent install_user_keyrings()

Felix Fietkau (2):
      ath9k: fix RSSI dummy marker value
      ath9k_hw: improve reset reliability after errors

Greg Kroah-Hartman (2):
      Revert "ALSA: hda - hdmi: Make jacks phantom, if they're not detectab=
le"
      Linux 3.4.36

Guenter Roeck (2):
      hwmon: (pmbus/ltc2978) Fix peak attribute handling
      hwmon: (pmbus/ltc2978) Use detected chip ID to select supported funct=
ionality

Jeff Layton (1):
      cifs: ensure that cifs_get_root() only traverses directories

K. Y. Srinivasan (1):
      SCSI: storvsc: Initialize the sglist

Konrad Rzeszutek Wilk (2):
      xen/pci: We don't do multiple MSI's.
      xen/pat: Disable PAT using pat_enabled value.

Konstantin Khlebnikov (1):
      e1000e: fix pci-device enable-counter balance

Mark Brown (1):
      hwmon: (sht15) Check return value of regulator_enable()

Mathias Krause (1):
      crypto: user - fix info leaks in report API

Mathieu Desnoyers (1):
      Fix: compat_rw_copy_check_uvector() misuse in aio, readv, writev, and=
 security keys

NeilBrown (2):
      md: fix two bugs when attempting to resize RAID0 array.
      md: raid0: fix error return from create_stripe_zones.

Olaf Hering (1):
      ata_piix: reenable MS Virtual PC guests

Russell King (2):
      ARM: VFP: fix emulation of second VFP instruction
      ARM: fix scheduling while atomic warning in alignment handling code

Rusty Russell (1):
      hw_random: make buffer usable in scatterlist.

Sarah Sharp (4):
      USB: Don't use EHCI port sempahore for USB 3.0 hubs.
      USB: Prepare for refactoring by adding extra udev checks.
      USB: Rip out recursive call on warm port reset.
      USB: Fix connected device switch to Inactive state.

Sean Connor (1):
      ALSA: ice1712: Initialize card->private_data properly

Sebastian Riemer (1):
      md: protect against crash upon fsync on ro array

Steven Rostedt (1):
      ftrace: Update the kconfig for DYNAMIC_FTRACE

Takashi Iwai (1):
      ALSA: vmaster: Fix slave change notification

Thomas Gleixner (1):
      btrfs: Init io_lock after cloning btrfs device struct

Trond Myklebust (2):
      NFS: Don't allow NFS silly-renamed files to be deleted, no signal
      SUNRPC: Don't start the retransmission timer when out of socket space

Tu, Xiaobing (1):
      Fix memory leak in cpufreq stats.

Will Deacon (1):
      ARM: 7663/1: perf: fix ARMv7 EVTYPE_MASK to include NSH bit


--9amGYk9869ThD9tj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQhtTAAoJEDjbvchgkmk+MG0P/Rx+vhhRlxzT4Gnin72AIYsJ
nlJLszbXEsd26FVbHIsxbVMP0cHgfXHiN4gfZl2k04x3eVUrVafDwq3R3/zHJP7M
ptLiSH8j9Ao+Xyu3GLC0Jf76mK9eOVUly58icY28rJlQTkFG1naxObslrO+aPgWD
ydu1rxyzXOb7+KRoVTgnt+ok57eVTxaS99bcry7VKz19hYmEJ4mu0HjmF96R2Xt3
+ujYUaCE39mQpY4fnnNw7hqg+6zAdoEuw/zCEgLo0Z7mApScpPOmwECVwlMCLOkj
OkbSJA1xzDzkAkPJfPlb6af9NVg+iaoMWmvGDuYGc/TGteSDzqBT4TZATDfLvQK0
Wc8ALbZTS3Unnkdlp7KxZzvxMWgNSj+Vp2nGdo+lJD+oNsLH9Yqinl8nJ2wOmCBR
4UfSQeIEzR4DkGugSRnsjztUHc6X7ctreEBZ2iUm6qNCYHU/6kM5ldPWjYhl1Uri
ylEvp+qTt4cF+IrPz16cDo2HtTh0CZokDRvO8N1ZTwnXxO/us1Gk2pgvMKAQWc8I
vCnhM/sDoeDXHKNqPme9KCkCKwtgtGfMUVddcxGUJQVb3CnYWihPSKovXXXoeNru
ek2v3hG/6P773G5sFZ8NcwDpWTwH36E6uFEWJneB8elI3KzEmVsbePiFgpiv7mzD
rMPR/nxLBaFD0bMwL5k/
=2fw0
-----END PGP SIGNATURE-----

--9amGYk9869ThD9tj--
