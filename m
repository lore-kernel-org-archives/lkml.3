Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab3FBKdY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 06:33:24 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46360 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753440Ab3FBKdT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 06:33:19 -0400
Date: Sun, 2 Jun 2013 11:33:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130602103308.GC16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
 <51A88C3F.5080109@metafoo.de>
 <20130601190328.GL16790@sirena.org.uk>
 <CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
 <20130601211045.GV16790@sirena.org.uk>
 <CAMuHMdWN6Ur47fBu3oZpah4fTaV+mV4Y_Q=SvV_jet-3FiZEUQ@mail.gmail.com>
 <20130601220627.GW16790@sirena.org.uk>
 <CAMuHMdWuQRi2PeFT2BeuRkZacvtfkgfe8ebgOS+kRCEt8X71rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GD+uNaHYxbVPHaQt"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWuQRi2PeFT2BeuRkZacvtfkgfe8ebgOS+kRCEt8X71rw@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GD+uNaHYxbVPHaQt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 02, 2013 at 10:04:42AM +0200, Geert Uytterhoeven wrote:

> But in this case, the commit was commited with a SoB using your old
> email address, only 5 days ago. So you may still have a stale
> .gitconfig somewhere:

No, this is correct.  I only finished working at Wolfson on Friday and
start at Linaro on Monday.

--GD+uNaHYxbVPHaQt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqx9hAAoJELSic+t+oim9jIYP/1R07yekbnwff5bw9f41Ygj1
G221/FYd4Py6EtCkpnawICkBnSEYAugIynHITacFkMhVOrrmVi6Stg5rCG6sSyko
wXZ75EudVXQp9fkisQeetA7Y8rVexV5nlhoeEu/eVrXgENUyhGu7oodWh++J90ZP
QHyIf7j4YE9YutvgQ+gjmn3QO0taVeUstmsX3Dpx4bIZfn5/N4EoaZ7oMMLBBvsT
oqjsk0KhawjdEBLyplY4znThH8f6lUaxiVtgm4cp4+tCa2kh4iIQBPYpSFOGTumw
pkS9+BwOpnxZCDiNTk9TzAbT3Xnue1534QgsnKyLN13yX0BdyvNfNY+wkbFzxF3N
zhxBP27QaHEMXNeEZSx4RBR+BXfXZdUMzJMcK9Qzs513tqxP3DKK17zCsS0DGhyn
s9CzOgQ7dO6DLVOoeEAItXMhELWPZ1EmTyqgsbh3ceALds1H9kmFZyf1iEgqty4G
pz4LQRoMvS13dsE3Rxe3jJwtDkslBbPj4Z3R2WuINWq1d8+mavw3GuO8UpvSZnQR
1Czle+rE+76sJGFGbRKqS3Yd2Fj7fzDiDGX4crQMyVEO/KxX1IMHHamle0Ew2YRU
UeOLtfLnH2l5KksYM2dwVEsddl0SXyejsF31QcswMP2YGz7v4lf8iGClJmVEcRSh
7bfNx4H/lsQUyZV1M6/n
=dkxO
-----END PGP SIGNATURE-----

--GD+uNaHYxbVPHaQt--
