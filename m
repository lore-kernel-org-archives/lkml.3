Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3HVUWR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 16:22:17 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45796 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab3HVUWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 16:22:14 -0400
Date: Thu, 22 Aug 2013 21:22:12 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: platform-driver-x86@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT] x86 platform driver fixes for 3.11
Message-ID: <20130822202212.GA8602@srcf.ucam.org>
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
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Let's try this again. Simple reversion of a patch that's still breaking=20
some systems (I'll try to figure out what the right fix is for 3.12) and=20
a couple of trivial fixes for sony-laptop.

The following changes since commit 50e37ccea06ca8846ceb60dbfbe056012c60d71b:

  Merge branch 'for-3.11-fixes' of git://git.kernel.org/pub/scm/linux/kerne=
l/git/tj/cgroup (2013-08-18 08:51:28 -0700)

are available in the git repository at:


  git://cavan.codon.org.uk/platform-drivers-x86.git linux-next

for you to fetch changes up to 41c8bd1c75ef8e8566eca6b1c7bc273bc282f495:

  Revert "hp-wmi: Enable hotkeys on some systems" (2013-08-18 13:23:31 -040=
0)

----------------------------------------------------------------
Daniel Serpell (1):
      sony-laptop: Fix reporting of gfx_switch_status

Matthew Garrett (1):
      Revert "hp-wmi: Enable hotkeys on some systems"

Wei Yongjun (1):
      sony-laptop: return a negative error code in sonypi_compat_init()

 drivers/platform/x86/hp-wmi.c      | 16 ----------------
 drivers/platform/x86/sony-laptop.c |  8 ++++++--
 2 files changed, 6 insertions(+), 18 deletions(-)

--=20
Matthew Garrett | mjg59@srcf.ucam.org

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlIWcvQACgkQ7Hkv8l1YiTuJQQCePjNSjM6GJAGayAY/yjhPypeo
B7AAn1m/svD4P0y+j2yg1uuk8n+yhFwV
=Ibb/
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
