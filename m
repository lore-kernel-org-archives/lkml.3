Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbaDOMML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:12:11 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33839 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295AbaDOMMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:12:08 -0400
Date: Tue, 15 Apr 2014 13:11:43 +0100
From: Mark Brown <broonie@kernel.org>
To: Insop Song <insop.song@gainspeed.com>
Cc: Jane Wan <Jane.Wan@gainspeed.com>, grant.likely@secretlab.ca,
        Emilian.Medve@Freescale.com, kenth.eriksson@transmode.com,
        thomas.de.schampheleire@gmail.com, b48286@Freescale.com,
        jg1.han@samsung.com, sr@denx.de,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Message-ID: <20140415121143.GW12304@sirena.org.uk>
References: <1397328516-13260-1-git-send-email-Jane.Wan@gainspeed.com>
 <20140414205151.GH25182@sirena.org.uk>
 <20140414213853.GF14129@neon.local.cohere.net>
 <20140414234949.GH12304@sirena.org.uk>
 <20140415000059.GB16287@neon.local.cohere.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UTjKcilERHWBCdCp"
Content-Disposition: inline
In-Reply-To: <20140415000059.GB16287@neon.local.cohere.net>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Configure FSL eSPI CSBEF, CSAFT, and whether to send all
 received data to user
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UTjKcilERHWBCdCp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 14, 2014 at 05:00:59PM -0700, Insop Song wrote:
> On Tue, Apr 15, 2014 at 12:49:49AM +0100, Mark Brown wrote:

> > > We use scripts/get_maintainer.pl to get the mailing addresses.
> > > We will double check the mailing list from MAINTAINER file.

> > This will be part of not using a current kernel - if you're using a v3.8
> > kernel to check then that's over a year out of date.

> I think I sent too soon, you meant for the get_maintainer.pl script.

Yup, and for the MAINTAINERS file which it looks things up in - your
copies will be out of date if you're running them from the v3.8 kernel.

--UTjKcilERHWBCdCp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTSH8AAoJELSic+t+oim9TFwP/Aqs5JvZAIJwjEG+bc+fhb/m
kO3DUBy5blk07qV90C+KqmFp33IdvJaf33TCdFC/WgAcs0PDE+3TCtUbEfZICbNu
NurxefCs2yMckKqnSZfoLjQocOy37iD0CFZw1bxvFdFpouQb3gSPwEbFU7wPq+1V
UDY/r+GGUovoFByZpV6F4cEm6jz9bSyMxGJr2mbNlCOwWYTiVvbNi2+/405e8leI
ZftJfHoMd8MpkyII94ZmkW+rVV6NtTxJNGPVNAsIgRSqVUndnRxy+2Q+i1UnjkDB
ao40q/WoKYbDTyZn3zJ7yXSVQhL9u0rgRzIZLaLJk1jXEowPxRxwNPKdAgZFWxhO
sixZ4zUqsvOzqlB6SmhaGI5l9hKkKJkMcSyh30vhc6ToWfAtt9gNaPdtA62iNiyM
/lYkNmg9M/J2tYABiEeN6DHf8JtG6TCYr4kzpL36LGtcjvvrpVP5EQaEfZUeyhXb
S/PgDSLLQZGYmZ0DNcxtG4Df82HKMIygjRNI0ulWo0Mu1KsxJ7ZjZun3AA0Q7XW3
jPmET8uTgrLdJi8vzEfvO194LppPqnmmHxNhXao9GHIbhWiR8AgqzHsAFrf4OB56
oWgFv42uZXKkdCprabSuLrNfo0nObwlRwVQ8CzxggHdRg8BkhKEUzJK/kn2HHoAK
EVgMFrQBEjyk/FJ83+Ka
=1vg7
-----END PGP SIGNATURE-----

--UTjKcilERHWBCdCp--
