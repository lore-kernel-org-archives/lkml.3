Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab3GJTo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:44:27 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54733 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300Ab3GJTo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:44:26 -0400
Date: Wed, 10 Jul 2013 20:44:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver updates for 3.11
Message-ID: <20130710194420.GA14945@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Nothing overly exciting here - a couple of new drivers that don't do a=20
great deal, along with some miscellaneous fixes and a couple of small=20
feature enablement patches.

The following changes since commit d2b4a646717153a1a180b64d4a8464054dbd700e:

  Merge branch 'for-linus' of git://git.infradead.org/users/vkoul/slave-dma=
 (2013-07-07 11:11:43 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to fef8ce166b2d5cdba8bbf85fa48c4cb8d75ffec4:

  x86 platform drivers: fix gpio leak (2013-07-10 15:09:35 -0400)

----------------------------------------------------------------
AceLan Kao (2):
      asus-wmi: control wlan-led only if wapf =3D=3D 4
      asus-nb-wmi: set wapf=3D4 for ASUSTeK COMPUTER INC. 1015E/U

Alex Hung (1):
      hp-wmi: add supports for POST code error

Ben Hutchings (1):
      amilo-rfkill: Add dependency on SERIO_I8042

Libo Chen (4):
      x86: msi-laptop: fix memleak
      x86: asus-laptop: fix invalid point access
      drivers/platform/x86/intel_ips: Convert to module_pci_driver
      x86 platform drivers: fix gpio leak

Matthew Garrett (3):
      hp-wmi: Enable hotkeys on some systems
      Add support driver for Intel Rapid Start Technology
      Add trivial driver to disable Intel Smart Connect

Seth Forshee (1):
      toshiba_acpi: Add dependency on SERIO_I8042

Viktar Vauchkevich (1):
      asus-nb-wmi: ignore ALS notification key code

Wei Yongjun (1):
      dell-laptop: fix error return code in dell_init()

vic (1):
      asus-wmi: append newline to messages

 .../ABI/testing/sysfs-driver-intel-rapid-start     |  21 +++
 drivers/platform/x86/Kconfig                       |  28 +++
 drivers/platform/x86/Makefile                      |   2 +
 drivers/platform/x86/asus-laptop.c                 |   1 -
 drivers/platform/x86/asus-nb-wmi.c                 |  19 ++
 drivers/platform/x86/asus-wmi.c                    |  21 ++-
 drivers/platform/x86/dell-laptop.c                 |   5 +-
 drivers/platform/x86/hp-wmi.c                      |  63 +++++++
 drivers/platform/x86/intel-rst.c                   | 209 +++++++++++++++++=
++++
 drivers/platform/x86/intel-smartconnect.c          |  90 +++++++++
 drivers/platform/x86/intel_ips.c                   |  13 +-
 drivers/platform/x86/intel_pmic_gpio.c             |   6 +-
 drivers/platform/x86/msi-laptop.c                  |  24 +--
 13 files changed, 462 insertions(+), 40 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-intel-rapid-start
 create mode 100644 drivers/platform/x86/intel-rst.c
 create mode 100644 drivers/platform/x86/intel-smartconnect.c


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlHduZQACgkQ7Hkv8l1YiTtY5wCfTH2ukEOtSmD2kP7yW6yjBBLZ
ycEAoIvDgP26as+GJncncyH88prjIxd0
=EG9X
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
