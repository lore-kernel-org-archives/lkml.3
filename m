Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaE0LHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 07:07:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44131 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaE0LH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 07:07:29 -0400
Date: Tue, 27 May 2014 12:07:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Message-ID: <20140527110709.GR12304@sirena.org.uk>
References: <1401169909.11231.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8lKPbAlXyF53WV6v"
Content-Disposition: inline
In-Reply-To: <1401169909.11231.1.camel@phoenix>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ltc3589: Fix module dependency
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8lKPbAlXyF53WV6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 27, 2014 at 01:51:49PM +0800, Axel Lin wrote:
> Make this driver depend on I2C and select REGMAP_I2C to fix build failure.
> Also allows this driver to be built as module.

Applied, thanks.

--8lKPbAlXyF53WV6v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThHHaAAoJELSic+t+oim9R0EP/iMFooZs8ZphDrMMEFtfnJfE
XN50N/6M3IT7dcIZ4QMwDJfUH6wIpufkZo3i5C3oPaA2Xn5PIiYZBQeGHZYrZ1cV
Q2fhrTL6CO5yFUG+Oa9U8tCbvHUT2WXaM9eb04SsgUwCBD5WOytj//8iZ1CsymFk
rLQKTdJJUVGslIVa8k8/uV7OTAfrtA8ScWHjV+lxaJmq9ShvLhA6TT2BqMrAdExQ
vBKXG8kcdREbXBE5+jhD07z/oAOAXx1SRGHYsnXqT0EoDRJsu2+unxdEcuF/PdoI
zSZu4tBa5HVs1TKzHZH8HunGGddLhV9aJLY8zMRG1Qbe1Rgb85vD5qMWcJ7/lWCV
ME0edwxH3rMQPq6NLw5hoX6f/eJcxM1uHg40jd6YsjVS1nfoG63xZlNKpDsAL7CI
4yAf7WeqWhBleg3c3xaXnBEHAhXo0z7xfVVcrFbAkelbAfm6tzIWUqcGckUwnqJi
7Z0qM87IP9VSPgkI5t2nSnNGR8lYhyE9A1jCjyhgTamkepYzCoFDqUNqEKtdNaJp
x2SDITmvVTOOrTDGfKOUTZFM8wpoO/acsZO1qc7gM3HfyZORLF+gVDwWFfWxKR0f
7u6oMSwp4X629OM8bWmNrrrJgnes+30ZNyrJ2vrJOmNExXGVFvJCOgPuF3SCaY4f
DWzU5IxKqubZiNNme4mT
=jl+k
-----END PGP SIGNATURE-----

--8lKPbAlXyF53WV6v--
