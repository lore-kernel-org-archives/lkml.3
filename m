Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025Ab3B0NeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 08:34:12 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:41423 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3B0NeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 08:34:10 -0500
Date: Wed, 27 Feb 2013 13:34:06 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.krenel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver updates for 3.9
Message-ID: <20130227133405.GA3662@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Mostly relatively small updates, along with some hardware enablement for=20
Sony hardware and a pile of updates to Google's Chromebook driver.

The following changes since commit 9e2d59ad580d590134285f361a0e80f0e98c0207:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git=
/viro/signal (2013-02-23 18:50:11 -0800)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 445e8d007c29d7f4d497c7912236b69f608340c6:

  ideapad-laptop: Depend on BACKLIGHT_CLASS_DEVICE instead of selecting it =
(2013-02-27 08:30:47 -0500)

----------------------------------------------------------------
AceLan Kao (6):
      asus-wmi: update wlan LED through rfkill led trigger
      asus-laptop: correct a touchpad hotkey mapping
      asus-nb-wmi: correct a touchpad hotkey mapping
      asus-laptop: add all video switch keys
      asus-wmi: add display toggle quirk
      asus-nb-wmi: add all video switch keys

Benson Leung (11):
      Platform: x86: Add Chrome OS Laptop driver
      Platform: x86: chromeos_laptop - Rename setup_lumpy_tp to setup_cyapa=
_smbus_tp
      Platform: x86: chromeos_laptop - Add Acer C7 trackpad
      Platform: x86: chromeos_laptop - Add Taos tsl2563 device
      Platform: x86: chromeos_laptop - Add Taos tsl2583 device
      Platform: x86: chromeos_laptop - Add HP Pavilion 14
      Platform: x86: chromeos_laptop - Add Pixel Trackpad
      Platform: x86: chromeos_laptop - Add support for probing devices
      Platform: x86: chromeos_laptop - Add a more general add_i2c_device
      Platform: x86: chromeos_laptop - Add isl light sensor for Pixel
      Platform: x86: chromeos_laptop - add i915 gmbuses to adapter names

Corentin Chary (4):
      asus-laptop: map some new keys
      asus-{nb-wmi|laptop}.c: sync keymaps
      asus-wmi: always report brightness key events
      asus-laptop: always report brightness key events

Dan Carpenter (1):
      sony-laptop: leak in error handling sony_nc_lid_resume_setup()

Dmitry Torokhov (1):
      hp-wmi: fix handling of platform device

Ike Panhc (1):
      ideapad: depends on backlight subsystem and update comment

Kyle Evans (1):
      hp-wmi: Add support for SMBus hotkeys

Lee, Chun-Yi (4):
      msi-laptop: merge quirk tables to one
      acer-wmi: support Lenovo ideapad S205 10382JG wifi switch
      acer-wmi: support Lenovo ideapad S205 1038DPG wifi switch
      acer-wmi: avoid the warning of 'devices' may be used uninitialized

Manoj Iyer (1):
      thinkpad-acpi: enable loading module with new B-series Lenovo BIOS

Matthew Garrett (1):
      ideapad-laptop: Depend on BACKLIGHT_CLASS_DEVICE instead of selecting=
 it

Mattia Dongili (3):
      sony-laptop: fully enable SNY controlled modems
      sony-laptop: allow reading the status of gfx switch
      sony-laptop: support basic functions for handle 0x14B and 0x14C

Maxim Mikityanskiy (11):
      msi-laptop: Use proper return codes instead of -1
      msi-laptop: Work around gcc warning
      msi-laptop: Add MSI Wind U90/U100 support
      msi-laptop: Add missing ABI documentation
      msi-laptop: Disable brightness control for new EC
      msi-wmi: Fix memory leak
      msi-wmi: Avoid repeating constants
      msi-wmi: Use enums for scancodes
      msi-wmi: Make keys and backlight independent
      msi-wmi: Introduced quirk_last_pressed
      msi-wmi: Add MSI Wind support

Richard Hartmann (1):
      drivers/platform/x86/thinkpad_acpi.c: Handle HKEY event 0x6040

Shuah Khan (1):
      asus-wmi: Fix unused function build warning

Trep=E1k Vilmos (1):
      Platform: hp-wmi: add rfkill support for integrated GPS

Yufeng Shen (1):
      Platform: x86: chromeos_laptop - Add Pixel Touchscreen

 .../ABI/testing/sysfs-platform-msi-laptop          |  83 +++++
 drivers/platform/x86/Kconfig                       |  15 +-
 drivers/platform/x86/Makefile                      |   1 +
 drivers/platform/x86/acer-wmi.c                    |  21 ++
 drivers/platform/x86/asus-laptop.c                 |  85 +++--
 drivers/platform/x86/asus-nb-wmi.c                 |  76 ++++-
 drivers/platform/x86/asus-wmi.c                    | 108 +++++-
 drivers/platform/x86/asus-wmi.h                    |   9 +
 drivers/platform/x86/chromeos_laptop.c             | 371 +++++++++++++++++=
+++
 drivers/platform/x86/eeepc-wmi.c                   |   2 +
 drivers/platform/x86/hp-wmi.c                      | 117 ++++---
 drivers/platform/x86/msi-laptop.c                  | 374 ++++++++++++++++-=
----
 drivers/platform/x86/msi-wmi.c                     | 224 +++++++-----
 drivers/platform/x86/sony-laptop.c                 | 145 +++++++-
 drivers/platform/x86/thinkpad_acpi.c               |  17 +-
 15 files changed, 1375 insertions(+), 273 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-platform-msi-laptop
 create mode 100644 drivers/platform/x86/chromeos_laptop.c

--=20
Matthew Garrett | mjg59@srcf.ucam.org

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlEuC00ACgkQ7Hkv8l1YiTtX/wCcCgK9rdWFxKcdZfZvaOvvAqnu
JXQAn0gsMvJqmogYtxuDQNRV4TvQ5p+/
=cxIm
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
