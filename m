Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562Ab3LEUm4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 15:42:56 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40573 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3LEUmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 15:42:55 -0500
Date: Thu, 5 Dec 2013 20:42:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20131205204252.GB29268@sirena.org.uk>
References: <1386270722-13962-1-git-send-email-broonie@kernel.org>
 <2371962.Qn6eVMpFgi@avalon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mDCy6lndoo077oG4"
Content-Disposition: inline
In-Reply-To: <2371962.Qn6eVMpFgi@avalon>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: gpio: Document regulator-type property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mDCy6lndoo077oG4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 09:08:59PM +0100, Laurent Pinchart wrote:
> On Thursday 05 December 2013 19:12:01 Mark Brown wrote:

> > +- regulator-type	: Specifies what is being regulated, must be either
> > +			  "voltage" or "current"

> What about adding "The type defaults to voltage if unspecified." ?

I was trying to think of a stronger wording for that - more like "if
specified at all should say "current", "voltage" is also supported for
legacy reasons and is the default.".  I'm not even sure about
documenting voltage here.

--mDCy6lndoo077oG4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoOVIAAoJELSic+t+oim9xbQP+QH1DKslBiMAMALbTM39qxBn
Nc/dX1phLgpMniXAlHcWc3kgxl5/7e0mmYCPBfP9UodPYKwa950oAYGiCKcSOGob
P7nTDmnO/L6HxRhz6HG5yy2xrc8LYgSgpRmLKQ59ezpxEMflU8tu/gc5AoHdpxd4
jkD7TUXiR8eqMM/stIxFLEXSvrJgjpuA66IRmcRGLvrrzuqBed6Wakv5HNC4NiL3
tIAqzdOEshBzDt4au6lSdQ5MdAQdaX86qw8txcOQHprxltQmnoVqOYJENYYY9g2Q
RrruPj3BXHoc0vzxVjJR753eOmdNuGVadpJX5IbwXzOy7vSNKn2uvxWtDnt0EEe9
0PVWSPrSzSf1uJ/I2LVm8MZpysTR5xXi4oc1iMIixPb3+BcMn4EcYA+dWBhGafvC
JX4w58Cp6Oes0FjwZg4nzqC7gWnyetSJno/EaDkLi1Sf06mHdwv4Cucl5bkewLye
rd02koYzPAmV/gxHgJVobMQ+3JkhmJDZPZSgyBRGymnb73tq1V0AZzp/6n07JZ8a
swyd70kEU3M025G/Yu4rJQ5A/pIXO6AumvvcEaEEEgJTe/QDzG40ej2FK86qRca7
DKL9iFcnpf19xr0w8OykB0Aj30d01EimtjZoCdltGdEAUsRa/qRvkrg0hNgmIvSi
uafkf4XT1Y7WH9BZhdVb
=I8HE
-----END PGP SIGNATURE-----

--mDCy6lndoo077oG4--
