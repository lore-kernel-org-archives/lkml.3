Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaBXFkQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 00:40:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50601 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbaBXFkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 00:40:14 -0500
Date: Mon, 24 Feb 2014 14:40:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Nenghua Cao <nhcao@marvell.com>
Cc: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140224054010.GY25940@sirena.org.uk>
References: <1392969970-28037-1-git-send-email-nhcao@marvell.com>
 <20140222025204.GM25940@sirena.org.uk>
 <530AB6EA.7090807@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5SrAdi84GtkM3Hw"
Content-Disposition: inline
In-Reply-To: <530AB6EA.7090807@marvell.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 121.174.50.227
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] asoc: soc-core: fix coccinelle warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5SrAdi84GtkM3Hw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 24, 2014 at 11:05:14AM +0800, Nenghua Cao wrote:
> On 02/22/2014 10:52 AM, Mark Brown wrote:

> > type changes.  What coccinelle was suggesting here was to replace with a
> > simple assingment statement rather than change the argument within the
> > memcpy(), I think this stops the warning showing because of that issue

>       I am not familiar with coccinelle. But it isn't reasonable and
> convenient to use simple assignment instead of memcpy() here. So let's
> retain it. I will submit another patch to fix "Assignment of bool to
> 0/1" issue. How do you think about it?

Well, the two should be separate patches anyway but it's totally
reasonable to do an assigment - what it's telling you is that with
modern C "a = b" is valid even if a and b are structs.

--O5SrAdi84GtkM3Hw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCtswAAoJELSic+t+oim9IpkP/0VmKYMVce1HFd6t2d6BZucR
CvhOgeHEjvj1NEt21RZ7i5VvfKDw0V2CYmp+spL3G7CPNQkVyjY7IM1iKAI+PDr8
j8lRqvX7T71njwGowJW3WboiWgirD4T45DfKNEYWku6PtoTJBLrQtJETs1Ery8HW
qy7XfcDolnOAroMsbj6BQnDrzLSES/xyGoKJnkbCOBf1ubY+SV4n6Pzbxmhn9uAJ
umL5I2J2aAQF9SDKNv52usYIRz3v8YmDwfqaZ2Y9CVUtoKlE50YIBMZmJZCp0dGe
6zGQRlhEcXytCiUcyufqjtfSn+joKnAIrwTvVjC1faIaprqI4IeKJQThTczkY/iO
K8jR+RZwkvkpWATmBfpoo5QqPA4dkgu0F/P+ec+ijxifjtYioAtG9xUA6H03yWXi
mDxSv1XF5BsU0by3HBjgizK0lSWPjGao3yd3sLYV32h8M4PQvfv0Mq97A536r9Ad
BelUYZRlbGLNaWATsOk4VxVigy5rxJmlj3AMOqFTKnkXXTzTcb9TuTNnw6BE04gg
eQWhdO/dwNFIzn55hMMHTLKrYQdLh08R0iOTUy7AmY59hPQeXpqmWfFHIybLDwd1
wZZSu5XXCeRk2RnuGg875mXqueiHYYHfapO2bn4c8YrLPpDymcCqvM0J7yYicgUA
bP2mdzFJk4OTKrRHvX4n
=1gVo
-----END PGP SIGNATURE-----

--O5SrAdi84GtkM3Hw--
