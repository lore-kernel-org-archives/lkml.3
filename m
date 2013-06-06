Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab3FFJuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:50:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38153 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473Ab3FFJuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:50:10 -0400
Date: Thu, 6 Jun 2013 10:49:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "luke.leighton" <luke.leighton@gmail.com>,
        Linux on small ARM machines 
	<arm-netbook@lists.phcomp.co.uk>,
        devicetree-discuss <devicetree-discuss@ozlabs.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        debian-arm@lists.debian.org, "jonsmirl@gmail.com" <jonsmirl@gmail.com>,
        debian-kernel@lists.debian.org
Message-ID: <20130606094932.GN31367@sirena.org.uk>
References: <CAPweEDx3mAy40BZrzrKPRbvg7vKMj7KevDQ3m_v4p6Yo50eSGg@mail.gmail.com>
 <1370475609.20454.44.camel@localhost>
 <CAPweEDwS3tR=wh-bZJb3vqR8fVQra=3XxDitowGRdH9c7WRfmQ@mail.gmail.com>
 <1733666.lHUBcfUXq9@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5vxz5YoITinLs0qm"
Content-Disposition: inline
In-Reply-To: <1733666.lHUBcfUXq9@flatron>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [Arm-netbook] getting allwinner SoC support upstream (was Re:
 Uploading linux (3.9.4-1))
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5vxz5YoITinLs0qm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 06, 2013 at 02:01:14AM +0200, Tomasz Figa wrote:

> I don't see any other solution here than moving all the Allwinner code to=
=20
> DT (as it has been suggested in this thread several times already), as=20
> this is the only hardware description method supported by ARM Linux.

Well, the server guys are working on ACPI - people could contribute to
that effort instead if they preferred (though I can see that they might
not!).

--5vxz5YoITinLs0qm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsFsoAAoJELSic+t+oim9GjEQAJT+tHVIRENdSTOdCMUrwjWf
leW7rvKEvns8wQ4KhMO7w0pnIABxAc6ZniX8X/MjawpXVSBDOpN5H422PnS8zAPV
A9gZL6uvnuuUa9nLb64a5YAl4Gc4BP2V/KyS8k7cXnYPvKBOdQLBZRd5H/cWdhBV
J3dR3N00vR17qoO/kGsjUGotdqyRG83fCm4xrsbkZ3Sl7C0CU9UQma/rPuIZ5qzR
YLZ0BHJFrZ21x9CSrPaQsPYC18ajaEHCP6BpGhev0iqyNHZJz2y+kdC2Rr1qZeek
Rul5YjWk998U9AnfO9EQeqbQy4UdKwSK5kFBx/IXcXtI3gNT2eTfxXpXFa2BARLu
nWwY4cqhuP8MxT42aFVNYjGQdDDmdYYzf2wQCV8bjSycGMz6JibFUvHQF/gMFk3w
qkAONnIaekxtixATQg7vl/Va+wZvGlEBNvHQN6TvwdhaVjjDw/OTlDIGLcle138z
8O2ygNxbgVY7iw17iLzkwIivPkM7xTSfQsLW685WWUnjXgr/xjJ4qyq6ow5t9isI
hGZxc6yIOiOme8Vvn+jxKKe/uN6IkRf4PuV/LqqHTrdtNHX7vfLxsTIEpc5y/Vs8
EYUzeVT1+Pnz7b1rGxs1LRtm1POt6VRuL/8+5e64G+CXsJ5VJdiWDlLYPusaVzEo
aF38P8FQ2r272NbSedfi
=fs+B
-----END PGP SIGNATURE-----

--5vxz5YoITinLs0qm--
