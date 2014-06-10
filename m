Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaFJXO0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 19:14:26 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48413 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408AbaFJXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 19:14:16 -0400
Date: Wed, 11 Jun 2014 00:14:11 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT PULL] x86 platform driver updates for 3.16
Message-ID: <20140610231411.GA20869@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Very little of excitement here - the most significant is a new driver=20
for detecting device freefall on Dells, other than that it's pretty much=20
entirely minor fixes for specific machines.

The following changes since commit 963649d735c8b6eb0f97e82c54f02426ff3f1f45:

  Merge tag 'for-linus-3.16-merge-window' of git://git.kernel.org/pub/scm/l=
inux/kernel/git/ericvh/v9fs (2014-06-08 14:35:19 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus=20

for you to fetch changes up to f82bdd0d77b6bf0dea08a1d957ab45d503f328b1:

  hp-wmi: Enable hotkeys on some systems (2014-06-10 19:11:11 -0400)

----------------------------------------------------------------
Andreas Utterberg (1):
      asus-wmi: Set WAPF to 4 for Asus X550CA

Axel Lin (1):
      platform-drivers-x86: intel_pmic_gpio: Fix off-by-one valid offset ra=
nge check

Hans de Goede (2):
      ideapad-laptop: Blacklist rfkill control on the Lenovo Yoga 2 11
      thinkpad_acpi: Add mappings for F9 - F12 hotkeys on X240 / T440 / T540

Himangi Saraogi (2):
      ix86/mid/thermal: Introduce the use of the managed version of kzalloc
      ideapad_laptop: Introduce the use of the managed version of kzalloc

Ismael Luceno (2):
      Documentation: Add list of laptop models supported by the Compal driv=
er
      platform x86 Kconfig: Refer to the laptop list in the Compal driver h=
elp

Jean Delvare (1):
      platform/x86: Fix run-time dependencies of OLPC drivers

Kyle Evans (1):
      hp-wmi: Enable hotkeys on some systems

Mario Limonciello (2):
      alienware-wmi: Update WMAX brightness method limit to 15
      alienware-wmi: For WMAX HDMI method, introduce a way to query HDMI ca=
ble status

Pali Roh=E1r (1):
      platform: x86: dell-smo8800: Dell Latitude freefall driver (ACPI SMO8=
800/SMO8810)

Rickard Strandqvist (1):
      platform: x86: asus-wmi.c: Cleaning up uninitialized variables

Scott Thrasher (1):
      platform/x86: samsung-laptop: Add support for Samsung's NP7[34]0U3E m=
odels.

Takashi Iwai (2):
      toshiba_acpi: Add alternative keymap support for Satellite M840
      pvpanic: Set high notifier priority

 Documentation/platform/x86-laptop-drivers.txt |  18 ++
 drivers/platform/x86/Kconfig                  |  31 ++--
 drivers/platform/x86/Makefile                 |   1 +
 drivers/platform/x86/alienware-wmi.c          | 121 +++++++++----
 drivers/platform/x86/asus-nb-wmi.c            |   9 +
 drivers/platform/x86/asus-wmi.c               |   4 +-
 drivers/platform/x86/dell-smo8800.c           | 233 ++++++++++++++++++++++=
++++
 drivers/platform/x86/hp-wmi.c                 |  18 ++
 drivers/platform/x86/ideapad-laptop.c         |  31 ++--
 drivers/platform/x86/intel_mid_thermal.c      |   7 +-
 drivers/platform/x86/intel_pmic_gpio.c        |   4 +-
 drivers/platform/x86/pvpanic.c                |   1 +
 drivers/platform/x86/samsung-laptop.c         |  38 +++++
 drivers/platform/x86/thinkpad_acpi.c          |   4 +-
 drivers/platform/x86/toshiba_acpi.c           |  30 +++-
 15 files changed, 485 insertions(+), 65 deletions(-)
 create mode 100644 Documentation/platform/x86-laptop-drivers.txt
 create mode 100644 drivers/platform/x86/dell-smo8800.c


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOXkUMACgkQ7Hkv8l1YiTv98gCdFKKMlSJrXtcI/sA9uBC0yRyW
oXgAn0D9HjXdjDxcAjNwwDGf3wjm+CBW
=zxL0
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
