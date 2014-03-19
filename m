Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759347AbaCSKRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:17:14 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44293 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758999AbaCSKRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:17:12 -0400
Date: Wed, 19 Mar 2014 10:17:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nicolin Chen <Guangyu.Chen@freescale.com>,
        "Jean-Francois Moine" <moinejf@free.fr>
Message-ID: <20140319101701.GU11706@sirena.org.uk>
References: <20140319121000.ccea7c0440649976ae722abd@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RuZRL+GX2sd4FWYD"
Content-Disposition: inline
In-Reply-To: <20140319121000.ccea7c0440649976ae722abd@canb.auug.org.au>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RuZRL+GX2sd4FWYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 19, 2014 at 12:10:00PM +1100, Stephen Rothwell wrote:
> Hi all,
>=20
> After merging the sound-asoc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Sorry, it's fixed already - your fetch must've raced with my fix last
night.

--RuZRL+GX2sd4FWYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKW6aAAoJELSic+t+oim9GSoQAJ2raYipevFF3PSU9S76DkJw
UHzppgubEAp8rDUoNIpxbgI65cg1TogLnlLxXynL/wks34f0dnt2458uuGZoSkkE
+TM0tBnYmai8TxPm8ExG86hI+RVlfwl0dxrt9sRPvPj6au837tmmzUwOTSgtXTGA
R4tB3FSjDnDQzf3LpeXQ7M2szhkL9uNyrAsMtmYBvkzrqwzw9e/Ez/dGWSiDsZG1
ROmRHBr9tP751ly6/SMyhhT843keeXI7xuJjPj5+N5B+CJ6PdNIZm/hWWreuTrol
hi59iCR3M3PkmAc5YGlSytdERbAOVZEOG6FZjNyqic6ak99xAhcDPu1xUX+uqrXK
CVKlf9dcHd/0DDTzkuZ84VH0KDI72GvMQ6NZ40kn9DKrC7Yl3Ml05Cks5m3FJyW2
5U6K6p2fOYJF9GRXj+a+D6PZE4OGYxj5g1C9E+h7ifkwdm2gfjWwIYxiVPTZeKaG
fDeEXX6iE7LRHmYNVX2jL4q7n1CvqIx7OTTVUhkcHD3OpjrQkL1Rk0xCjfjo1uPJ
9WLbF7D971jInVmwAxsIZHj++CZKuXPGOX1275g2apE/NhAaibneZ3mFGbeI71jz
Fadw4eZfWgbaXoB9j7Rdw08Mcof8C3A+aaA7W1pAGoVeND52mydtYbKXtCPgL759
G1pfGsR/Enh48JuOTkmK
=bHPC
-----END PGP SIGNATURE-----

--RuZRL+GX2sd4FWYD--
