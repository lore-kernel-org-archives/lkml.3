Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaLDLeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:34:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48062 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaLDLeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:34:13 -0500
Date: Thu, 4 Dec 2014 11:33:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Message-ID: <20141204113346.GT7712@sirena.org.uk>
References: <547F3CAC.9050105@arm.com>
 <2240364.fL8B0EDbFB@wuerfel>
 <20141204110746.GR7712@sirena.org.uk>
 <2090131.rL6S1lx8Ky@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SQKdhnb/5YOpdZ6f"
Content-Disposition: inline
In-Reply-To: <2090131.rL6S1lx8Ky@wuerfel>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SQKdhnb/5YOpdZ6f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 12:17:15PM +0100, Arnd Bergmann wrote:
> On Thursday 04 December 2014 11:07:46 Mark Brown wrote:

> > It's relatively common with newer companies - it's like UARTs, any
> > company that's been around for a long time will have a homebrew IP
> > already but places that don't (or get fed up with their existing IP)
> > will tend to buy something in.

> I see, but are any of the newer designs going to use platform_data?
> My general feeling was that the only places that still depend on that
> are legacy platforms and architectures.

And x86 which does have things like PCI cards.

--SQKdhnb/5YOpdZ6f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgEaZAAoJECTWi3JdVIfQ6oAH/j7/+GnToU54d8lUYEOk7/BK
3fmMJ7FjjgTy7OUqlnvoGFgz6e6tj2CIiDT/QAH+u9Nifw3ZqndaByf9Shs021gv
MaUlSPjdMQ4F6AO3Wb7ft4J+fCa2N5sRDAlMQXWRWHGr9r3sOuuUe/aYtYhDNX0m
qS8mJ+oCDRgtb9YqD+RMknc+9vY9hzc4Sab445FzghosWVvwnEuYgrhAIyNaixNG
zv685ysEeQD4vFbwzDQBd8R2s+ENWNbpUBSg5d7otfdszd9Qf5RGrZf4ZQeYK5+I
H6bKOC9t21pGJKexMWgv6/KlHuEfzSQn7k7MYHzwKPy13rXE0cWyXg9H9iA60dc=
=HDXC
-----END PGP SIGNATURE-----

--SQKdhnb/5YOpdZ6f--
