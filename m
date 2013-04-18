Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936657Ab3DRV5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 17:57:34 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:33706 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab3DRV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 17:57:32 -0400
Date: Thu, 18 Apr 2013 22:57:26 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: torvalds@linux-foundation.org
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] X86 platform driver update for 3.9
Message-ID: <20130418215726.GA27006@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

It turns out that one of the hp-wmi patches this cycle breaks some other=20
HP laptops. I think we have a good idea how to work on it for 3.10, but=20
it's safer to just revert it for now.

The following changes since commit 445e8d007c29d7f4d497c7912236b69f608340c6:

  ideapad-laptop: Depend on BACKLIGHT_CLASS_DEVICE instead of selecting it =
(2013-02-27 08:30:47 -0500)

are available in the git repository at:

  git://cavan.codon.org.uk/platform-drivers-x86.git for_linus

for you to fetch changes up to c857b7f45b1f9fb7bad1eaa42b8ad68327738232:

  Revert "hp-wmi: Add support for SMBus hotkeys" (2013-04-18 14:53:10 -0700)

----------------------------------------------------------------
Matthew Garrett (1):
      Revert "hp-wmi: Add support for SMBus hotkeys"

 drivers/platform/x86/hp-wmi.c | 4 ----
 1 file changed, 4 deletions(-)

--=20
Matthew Garrett | mjg59@srcf.ucam.org

--0OAP2g/MAC+5xKAE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlFwbEYACgkQ7Hkv8l1YiTv6IACePamsBOuEnw3KK2cyWwHIbx6n
920An0E3oJz18bE6A+c61BP79xx+KKBL
=Bsv4
-----END PGP SIGNATURE-----

--0OAP2g/MAC+5xKAE--
