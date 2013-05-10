Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab3EJNGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:06:07 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45906 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab3EJNGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:06:05 -0400
Date: Fri, 10 May 2013 14:05:57 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] x86 platform driver updates
Message-ID: <20130510130557.GA17300@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Small set of updates, mainly trivial bugfixes and some small updates to=20
deal with newer hardware. There's also a new driver that allows qemu=20
guests to notify the hypervisor that they've just paniced, which seems=20
useful.

The following changes since commit e0fd9affeb64088eff407dfc98bbd3a5c17ea479:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/g=
it/roland/infiniband (2013-05-08 15:29:48 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to a1ec56ed9f42fb5374cd2add373811c9527c0995:

  Add support for fan button on Ideapad Z580 (2013-05-08 20:00:50 -0400)

----------------------------------------------------------------
AceLan Kao (2):
      dell: add new dell WMI format for the AIO machines
      asus-nb-wmi: set wapf=3D4 for ASUSTeK COMPUTER INC. X75A

Alex Hung (1):
      hp-wmi: add more definitions for new event_id's

Alexandru Gheorghiu (1):
      drivers: platform: x86: Use PTR_RET function

Arthur Wirski (1):
      sony-laptop: SVS151290S kbd backlight and gfx switch support

David Woodhouse (1):
      dell-laptop: Fix krealloc() misuse in parse_da_table()

Hu Tao (1):
      pvpanic: pvpanic device driver

Maxim Mikityanskiy (1):
      Add support for fan button on Ideapad Z580

Shuah Khan (1):
      hp_accel: Ignore the error from lis3lv02d_poweron() at resume

 drivers/platform/x86/Kconfig          |   8 +++
 drivers/platform/x86/Makefile         |   2 +
 drivers/platform/x86/asus-nb-wmi.c    |   9 +++
 drivers/platform/x86/dell-laptop.c    |  10 +--
 drivers/platform/x86/dell-wmi-aio.c   |  53 +++++++++++++--
 drivers/platform/x86/hp-wmi.c         |  24 +++++++
 drivers/platform/x86/hp_accel.c       |   3 +-
 drivers/platform/x86/ideapad-laptop.c |   6 +-
 drivers/platform/x86/pvpanic.c        | 124 ++++++++++++++++++++++++++++++=
++++
 drivers/platform/x86/samsung-q10.c    |   5 +-
 drivers/platform/x86/sony-laptop.c    |  20 +++++-
 11 files changed, 248 insertions(+), 16 deletions(-)
 create mode 100644 drivers/platform/x86/pvpanic.c


--=20
Matthew Garrett | mjg59@srcf.ucam.org

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlGM8LUACgkQ7Hkv8l1YiTtYPwCdHeP9G617Y9SfUtK2fHN2jnPX
xqYAn2gDbmgKjse9pHkwAXK8BkXwaWvD
=Ni17
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
