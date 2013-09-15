Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932580Ab3IOReY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 13:34:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41762 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3IOReW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 13:34:22 -0400
Date: Sun, 15 Sep 2013 18:34:17 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org
Subject: [GIT] x86 platform driver updates for 3.12
Message-ID: <20130915173417.GA11116@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Nothing amazing here, almost entirely cleanups and minor bugfixes and=20
one bit of hardware enablement in the amilo-rfkill driver.

The following changes since commit cb3e4330e697dffaf3d9cefebc9c7e7d39c89f2e:

  Merge branch 'x86-mm-for-linus' of git://git.kernel.org/pub/scm/linux/ker=
nel/git/tip/tip (2013-09-04 09:39:26 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to 5c07eae979dfb596141c6885e5f5ecf1cd22cad3:

  platform/x86: panasonic-laptop: reuse module_acpi_driver (2013-09-05 08:5=
2:46 -0400)

----------------------------------------------------------------
Adam Lee (2):
      thinkpad_acpi: return -NODEV while operating uninitialized LEDs
      thinkpad_acpi: add the ability setting TPACPI_LED_NONE by quirk

Andy Shevchenko (1):
      platform/x86: panasonic-laptop: reuse module_acpi_driver

Dan Carpenter (1):
      wmi: parse_wdg() should return kernel error codes

Frederick van der Wyck (1):
      platform samsung-q10: use ACPI instead of direct EC calls

Jerome Meinke (1):
      amilo-rfkill: Enable using amilo-rfkill with the FSC Amilo L1310.

Jingoo Han (2):
      platform: replace strict_strto*() with kstrto*()
      platform: x86: remove unnecessary platform_set_drvdata()

Kirill Tkhai (1):
      hp_wmi: Fix unregister order in hp_wmi_rfkill_setup()

Randy Dunlap (1):
      samsung-laptop: fix config build error

Wei Yongjun (2):
      x86: smartconnect: use module_acpi_driver to simplify the code
      x86: irst: use module_acpi_driver to simplify the code

 drivers/platform/x86/Kconfig              |  3 +-
 drivers/platform/x86/amilo-rfkill.c       |  7 ++++
 drivers/platform/x86/classmate-laptop.c   |  2 +-
 drivers/platform/x86/compal-laptop.c      |  7 ++--
 drivers/platform/x86/hp-wmi.c             | 16 ++++----
 drivers/platform/x86/intel-rst.c          | 13 +------
 drivers/platform/x86/intel-smartconnect.c | 13 +------
 drivers/platform/x86/intel_mid_powerbtn.c |  1 -
 drivers/platform/x86/intel_mid_thermal.c  |  1 -
 drivers/platform/x86/panasonic-laptop.c   | 25 +-----------
 drivers/platform/x86/samsung-q10.c        | 65 ++++++++++-----------------=
----
 drivers/platform/x86/thinkpad_acpi.c      | 23 ++++++++---
 drivers/platform/x86/wmi.c                |  4 +-
 13 files changed, 66 insertions(+), 114 deletions(-)


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlI175kACgkQ7Hkv8l1YiTtPcwCeKYoio1mW6nzgiINwbzPlygj/
N0gAn00lSrVkfjERGeEQ1KwQ0MfoHqyf
=Yi0h
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
