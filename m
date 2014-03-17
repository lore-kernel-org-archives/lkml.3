Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaCQL2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 07:28:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48258 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932526AbaCQL2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 07:28:07 -0400
Date: Mon, 17 Mar 2014 11:27:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Axel Lin <axel.lin@ingics.com>, linux-spi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140317112757.GB11706@sirena.org.uk>
References: <1395020870-18107-1-git-send-email-linux@roeck-us.net>
 <CAFRkauDEBe+XStLJSiMzvNOxpFZ2iBGD36-Brq9oHN2RRa+rog@mail.gmail.com>
 <532671A5.5070302@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dTy3Mrz/UPE2dbVg"
Content-Disposition: inline
In-Reply-To: <532671A5.5070302@roeck-us.net>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: sc18is602: Don't be that restrictive with the
 maximum transfer speed
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dTy3Mrz/UPE2dbVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Mar 16, 2014 at 08:53:09PM -0700, Guenter Roeck wrote:
> On 03/16/2014 07:07 PM, Axel Lin wrote:

> >Now I'm thinking if it is ok to use master->max_speed_hz as transfer speed when
> >xfer->speed_hz > master->max_speed_hz. And it should be handled in spi core.
> >I'm sending a RFC patch now.

> That is an acceptable alternate solution for me.

That's what I'd expect, take the maximum possible given the available
constraints.

--dTy3Mrz/UPE2dbVg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJtw6AAoJELSic+t+oim9XlIP/2rl4+5ctY01zoEasGVQFCf9
4aLLt9Jq+dQTThwuFhba1ZIwriNtgJ+NNK7gvpSQBjK9kzLJ5pucHNN1dEdRRVg9
js813yzMJDYCDzcnAkYLFoOmCHJpZJxwr5VHG86dTzNEBXNZRJQW4x0f/RNISY03
FzbEIK7l0EdvrvYVPOg/aISL/a01e/eHwJ+F4ef7B8sj2hOacg7k6a33WWkks3jv
efIGsPLxsL/Kxc3evf8hUMCATqfBaS7azVMzr4ErEwgyZgVQ9fxSeYD55Mle0VmZ
JmmWqBEYZOmQO9j/lO0RYqmiRvBmmvh4l9nNIpnU03FKCTyzmVtkhm/RIj6QDjlH
nfiQ5bEnzZl94gGD6d9bFcVlOVKJ/pZKy8jsnYPegHfAfrCidoQOIf4eeuYhF0nt
+XzxYg5qnDb86QqXTLzgmwk3tLJN7XCS0H52kFRfQ1asOUcRt7rOXKHd0pjins+T
NgphI2AuvCe0uqDl00CmPoysPC6Q2sP3UFfx1dLcQqGjHStgUBBhovG6OkLPEjTf
7hevn6HFiwvTzq5Y2DNoG3uPcJ2/l9H3KRIxuJHbYfwBqfTmfasFClucrC+FPLW3
WxkduTuNeLRbR+ezotMuYkcHC+Wp025QWD8GmQtElysv357ETVoCKhYqef7hDBa5
TjnJ3q5DFA7XUmw9uzil
=OEms
-----END PGP SIGNATURE-----

--dTy3Mrz/UPE2dbVg--
