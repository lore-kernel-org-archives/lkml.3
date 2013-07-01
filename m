Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab3GAIm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 04:42:27 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54640 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab3GAImZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 04:42:25 -0400
Date: Mon, 1 Jul 2013 09:42:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20130701084202.GR27646@sirena.org.uk>
References: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2D9EG7COLye/vM78"
Content-Disposition: inline
In-Reply-To: <20130701141827.8f9122f0b6ca860fa5fd11a5@canb.auug.org.au>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the regulator tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2D9EG7COLye/vM78
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 01, 2013 at 02:18:27PM +1000, Stephen Rothwell wrote:

> Caused by commit 07a02e0b1a4f ("regulator: palmas: model SMPS10 as two
> regulators").  Clearly not build tested at all :-(  Grep is your
> friend ...

That's odd, it's also not been caught by Fengguang's system which
generally gets this sort of stuff...

--2D9EG7COLye/vM78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR0UDWAAoJELSic+t+oim9vJsP/3+u3bJm45rGXI9Xqh6uxpJB
idUrIlPNlIxhuZfAnh8CCTy5QuptMW+cG8mrYfx2ZWmJOe/O1MBXPiDDGdMuVN7+
Xcgk6dy630YzEcWNShK4KVRSyGYtzFM1wOFxJ8fMQuYDYHtts+zP7U83cymOn4bE
mQNLXOkMkjwnTgdY7L9RjiGmvnDAXP6V6iUqxAG+m2ZgkjC1mWzR9x+is0abYybw
2inGlARJCNwlgheFCywkjNSUI1cvWFNNRB54RxDWLJDWITSG6Glhr6/CvCPgFHQO
GdvYMa6dy8IUVMWdzXdMCTaIVb+xYaropRBPhrKUoMGCDuqoN8GjXxO9CBiXzJy3
m9fUMGSHysWMorXS6/Y50ViP6Np8FvBOkZIvh7z2q0tnNDF2Zr6DYnu4KAIk8AEr
kwSb8RUKRe+prRdB9hahY87/cqLZlleNZibYaWt7543ICIIHwIIWP2q5RgPsX8LN
ej5NgBXuqCZDogsLOl6iFKAOFjTYvF9iNKAqP4YihbOPcJsIYAZDuYK9UEe6Y+tg
CUV0RmkGfDl8wXltqroRaMursfrdLl309aAGcqepvucnOBr3g0xiSwAnQAi133kr
z8auQYHCi8Ir+YmlqDnU9PbkVxxYHxNGMkNI6ghxy2QDZcg+nOWv5gGk66w2ka0I
Rb478fBF+dM7zJwXltAY
=4rJJ
-----END PGP SIGNATURE-----

--2D9EG7COLye/vM78--
