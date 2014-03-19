Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaCSTWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 15:22:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52732 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbaCSTWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 15:22:07 -0400
Date: Wed, 19 Mar 2014 19:21:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Jyri Sarha <jsarha@ti.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Jean-Francois Moine <moinejf@free.fr>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Message-ID: <20140319192157.GW11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <d054780a0edf4b2338a52e48bff9144e19aa614f.1394883134.git.moinejf@free.fr>
 <20140317164339.GR11706@sirena.org.uk>
 <20140318091728.1d2240ca@armhf>
 <53296CB7.1000909@ti.com>
 <5329E749.6070900@metafoo.de>
 <5329ECC2.7040803@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sctg3NRPI3j1J0DR"
Content-Disposition: inline
In-Reply-To: <5329ECC2.7040803@ti.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3 4/4] ASoC: simple-card: Add DT
 documentation for multi-DAI links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sctg3NRPI3j1J0DR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 19, 2014 at 09:15:14PM +0200, Jyri Sarha wrote:
> On 03/19/2014 08:51 PM, Lars-Peter Clausen wrote:

> >When does this make sense? Either the bitclock is inverted for all of
> >them or for none.

> Definition of clock signal and it's inversion varies between chip
> manufacturers and sometimes it may not be possible to get all the dai
> drivers to work identically in this respect. Because of this in some cases
> there may be a need to set the inversion bit only at one end of the link.

No, Linux has a definition of all the clock modes which applies to all
devices regardless of what the manufacturer documents in their
datasheet.

--sctg3NRPI3j1J0DR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKe5SAAoJELSic+t+oim9iCUP/1r3+A9s/XhXpLnEoxAoYjzx
jILm8CNuiPSIAQ+cv+NxbjQ4qXpM5ruRitl/jcUZBjSZ+QALhLrJbYdo/emRya+o
FYNjSsuUhqe2WhT6W2+OOjph9bN4pTRMGxvC8OG/BiIk6P6PLFcGoXM/EZRUTmHl
ZBaj3lMvSLitz0rW6DNK1R4/IxhwzFq4mraG4H04Um6EYoyRoWvsvyY9XutSGo/g
Lp9jL//MNZ1ntLmYOOzazbIlZNIaiZMIJG0CklIKcFUggk8T7ia6BKgs/TySBghc
qfjpIhnVbQ8BOG2VLH3E3jnEoCdEv8fwDR0Dj5hZiuKPrvfKmN1FynIkPfwqhNrK
jOcB7VK2KQdFXP0rd+Ng/H4dYA7lEGfHnGyytuRbr+xioXJ0Q2arwo+y3Af+/cGX
ITyB4yLnyuMObX5qkHWjyT6Z1GU96wiYjT2iAlxNaT39cp9fmLrn1vD4DiMLB+qB
aGaGhGID1IAXM85DXgb14mdBG4AHWmVNSs9oQgQ2L47SbPgcT8jqdYNTeyFAQyWe
JNlbYaGKf3GqyWeCT0f2LLdiOPToztXPosHMs0dGhQ7SSox0+E2uICRN2VqQXTqN
VTvfJOmlknOiGqlps2XzctJ7iVtmfCzZ9+XUr7kUdtl1/2LbCu9PTFhlNBLX9oyf
dZa0qJGoC2QYCrPEsMSX
=ITy2
-----END PGP SIGNATURE-----

--sctg3NRPI3j1J0DR--
