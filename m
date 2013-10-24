Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776Ab3JXMc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:32:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49441 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754052Ab3JXMc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:32:26 -0400
Message-ID: <1382617925.21018.0.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 000/149] 3.2.52-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Thu, 24 Oct 2013 13:32:05 +0100
In-Reply-To: <20131021152554.GA18317@roeck-us.net>
References: <lsq.1382345187.199780875@decadent.org.uk>
	 <20131021152554.GA18317@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o8+kNWciq8rD/fHlzY92"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 77.221.165.98
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-o8+kNWciq8rD/fHlzY92
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-10-21 at 08:25 -0700, Guenter Roeck wrote:
> On Mon, Oct 21, 2013 at 09:46:27AM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.52 release.
> > There are 149 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Fri Oct 25 08:00:00 UTC 2013.
> > Anything received after that time might be too late.
> >=20
> > A combined patch relative to 3.2.51 will be posted as an additional
> > response to this.  A shortlog and diffstat can be found below.
> >=20
> Build results look good:
> 	total: 100 pass: 78 skipped: 14 fail: 8
>=20
> which is four less failures than with 3.2.51 (m68k-nommu builds now all p=
ass).
>=20
> qemu build and load tests all pass.

Thanks for testing.

Ben.

--=20
Ben Hutchings
Teamwork is essential - it allows you to blame someone else.

--=-o8+kNWciq8rD/fHlzY92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUmkTRee/yOyVhhEJAQqwlA//Ynd8Ur89mDWLNzoxQ+YSkhOb3/xx2B/L
3ALlmHMZ6PR4HEptMfPtRjXukQj76kpCSsT1lVAwTHK1W+EcuW9cYyBzhQ3GrSw9
JCWSt+OaT2aRGRzsdVNWLiYUJUr28MP5sJEqqkb+SeXaPp0HPy00lEG2nAlyIqrQ
hL48F4FYOh2KjH/7usWJ8mHv4Cm9XQZWBKroJ7qhi1udHVpa8n7CEPvjKoyuMYsh
IXBN3gQtRWvHl6CBOLardF83/47QQu3+ri5mnVLLDHOZdTfeiHgeVu6imS9G9aVs
Nk9NKUcgvjsLXexZNIRylOj25YtlyMuVJ8nmNqxdfrYazONmJmkAi5uUwXDmM4XX
l81JjjVs1whuE/bqDy4oFX72hTj3tEN4wRGWi26nEdLQtGGDg2TBLXwHySDGAzvq
g394DQFdsUFbscBE1cu17daCyISI39g1BV54EEAEMvaCW+jI9zgRdoB1xgVs1/lV
72bX12m15YdAtdnxv5vo/KPtydLpyWRcm+D7TvdyGDW10xuE5TfuN+Zx4QLetwSY
LNRU90M5Py3nUcane5ypaqL2yvfkAu9buScs4uWRhzEX63Vj+Xacn5f8qLmNW8Fy
3Py0k0p9rIYY7A+vZHsDiidWI6OMUpag0k0boNZBnMtrsV0Go0nxML6u2qvlTfPW
gS6ZtQGufmY=
=Do6J
-----END PGP SIGNATURE-----

--=-o8+kNWciq8rD/fHlzY92--
