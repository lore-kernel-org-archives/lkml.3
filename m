Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbaJHL12 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 07:27:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40438 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaJHL11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 07:27:27 -0400
Date: Wed, 8 Oct 2014 12:27:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Gyungoh Yoo <gyungoh@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141008112710.GU4609@sirena.org.uk>
References: <1412733463.8255.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YgseLHR9uOh11QTZ"
Content-Disposition: inline
In-Reply-To: <1412733463.8255.1.camel@phoenix>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: sky81452: Remove module version
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YgseLHR9uOh11QTZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 09:57:43AM +0800, Axel Lin wrote:
> The module version is unlikely to be updated, use kernel version should be
> enough.

Applied, thanks.

--YgseLHR9uOh11QTZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNR+OAAoJECTWi3JdVIfQ9ooH/iD6oe8j6HjhIr8rsmgE8Wx8
ZD8gp4cUx9vyks08HZA7lstJghCY1C/Qs0P7I3R+voj1CT+5aKxQTUyZIYTFp4vi
hfMoln2Bb3sscRvn4C+sW1s2uVn2aZ6ytxeX1htMf5P5qXWlAd3PDK589RZzxqcC
v7iGH+rEiOhkS7mNLj//A9r4MB62nrtCBfA/EcT/FFAO73FV5q6Xue9pm16LlUK+
mwKPoWqvfunSqk7hD5zkES3qy1L5pMGRWWbkjwExTE3K4tOibGnIU2oeIF6mPJYB
wpMsQyW7sIEgAzdcRR2Wudjnf7Y+XflxOQQo1V9FH4lGSW9odcy8vQ4OHFr7GSY=
=HzHK
-----END PGP SIGNATURE-----

--YgseLHR9uOh11QTZ--
