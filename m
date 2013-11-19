Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab3KSUKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 15:10:22 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48185 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3KSUKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 15:10:21 -0500
Date: Tue, 19 Nov 2013 20:09:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        alsa-devel@alsa-project.org
Message-ID: <20131119200957.GS2674@sirena.org.uk>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-9-git-send-email-lee.jones@linaro.org>
 <20131119184829.GF2674@sirena.org.uk>
 <20131119193341.GC19953@lee--X1>
 <528BBE90.4020802@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Wty5iWagpjJlozQq"
Content-Disposition: inline
In-Reply-To: <528BBE90.4020802@metafoo.de>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/10] ASoC: ux500_pcm: Differentiate between pdata and
 DT initialisation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Wty5iWagpjJlozQq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 08:40:00PM +0100, Lars-Peter Clausen wrote:
> On 11/19/2013 08:33 PM, Lee Jones wrote:

> > Despite the '+'s, I'm not actually adding these parameters, I'm
> > duplicating the pdata version and removing the stuff I 'know' that's
> > not required. I don't know what happens when/if these two parameters
> > are removed. I can add this to my TODO when I rip out platform data
> > support, which will happen when this stuff lands.

> I think the patch is fine for now. Once non-DT support has been removed for
> ux500 we should be able to remove the whole ux500_pcm.c file (Assuming that
> the ux500 DMA engine driver gains dma_slave_caps support).

Yeah, it shouldn't break anything but I'd rather at least have a comment
on any new code that specifies these things by hand explaining why the
automatic stuff doesn't work, it's much nicer to not have to specify the
magic numbers by hand and this will help encourage new code to do the
right thing.

--Wty5iWagpjJlozQq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSi8WSAAoJELSic+t+oim9AfwP/A5T/uMCQuIbPFnlv+KB5IxG
cwcrjQiGBWZAD7i97nGnc8WjFFbSK+aLiUSfVpOLJB2P6X80+yUapaC9Tb1Sa1aX
LLghUl+o5a8su/OSkyDsVC8vzug5fjzZdavbcPVP79WWYnQusqVvxmDqafkQ10GL
O+XvGcRfssNBJf7AWZ82sTfaVUydbiHz6qaShGhLvI5ptK10l7AS1AnlwT4V2CK4
wRrRiKr2qfS2U8JWtrrALqvTWJwbgqtVCEMcHj9UQCVLHBJNlvbPZyYUu9qeniz6
NRLZEgorbV1EbYCrcSmXREpWQHcxdmYaUe56toagNFmQnSHNJOppMUwjcDeM6HAJ
ZmRV+zVpkoSrab2Jtx2Q2I4hS86u+BUKENLNRZR2kLRugdA+jbOdGZYWPcolZNdW
SItGM4mdSzFneAubFZzOAPATDam4wANVd12HOwSzk5VjEZhqZpe7VH8BoiP23AL5
vJWHPOm0iLSBRIRajXw+Xu1+06GoAytLFi215XIK1rh1UbKPu4sfSlZUGmZnyWbk
sAdlDfSvXTKvV8eKWL+vB0JNAvYXeMm7GkVmbxItmu3MyfjU/1RnHCBiLAZhe/dB
MwZlej3vA5e+a4joA3COGAh2ILVL/AF1vz6rx6sxwFvE4RTvNGEMomE6y8rB7DmV
68OUPq3jg6ZFr72x4g9j
=+bhE
-----END PGP SIGNATURE-----

--Wty5iWagpjJlozQq--
