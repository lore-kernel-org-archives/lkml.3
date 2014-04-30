Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964833AbaD3MVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 08:21:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52676 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933271AbaD3MVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 08:21:22 -0400
Message-ID: <1398860461.11833.2.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/94] 3.2.58-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Wed, 30 Apr 2014 13:21:01 +0100
In-Reply-To: <535F2416.3060809@roeck-us.net>
References: <lsq.1398647481.453080089@decadent.org.uk>
	 <535F2416.3060809@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hxQC/33pmF6X7l4eBBbA"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hxQC/33pmF6X7l4eBBbA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-04-28 at 21:01 -0700, Guenter Roeck wrote:
> On 04/27/2014 06:11 PM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.58 release.
> > There are 94 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Apr 30 08:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >
>=20
> Build results:
> 	total: 116 pass: 85 skipped: 22 fail: 9
>=20
> Qemu tests all passed.
>=20
> There are two new failures, i386:allyesconfig and i386:allmodconfig.
>=20
> Error in both cases is:
>=20
> drivers/cpufreq/powernow-k6.c: In function 'powernow_k6_cpu_init':
> drivers/cpufreq/powernow-k6.c:218:22: error: 'struct cpufreq_frequency_ta=
ble' has no member named 'driver_data'

Right, this member is named 'index' in 3.2.  I'll fix that up.

Ben.

--=20
Ben Hutchings
Life would be so much easier if we could look at the source code.

--=-hxQC/33pmF6X7l4eBBbA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU2Dquee/yOyVhhEJAQqXAhAAkYWFHY5MbK5eUyBttmQw6YzJGyX9Y2K3
lALEACwujI5qHr5frR1H5oJm61fKSw+GRLtIlShSl0D3aqbg8zKfGSV5IU7ZhRka
yRXjoeyDwNORSB+FV5OZwrcP1njyzUVGqaYyXZb4AXvpwYKknhul/3GG8RXdvy2H
KerVLNvjp7Uik3MxYh4GQ6cFzDXjui24cJEzxRGLm6UxJlxSlosKKOq5lGtB56AZ
t0uu1bcKewvyYy3bfVBXdGLtglRwmQuPcHD4yzJ5KmfuMTWF2Oe1HLFil6SGrVxb
PPBw/436mb4bvPECdTMgNpxXAFfXEvLDaa7AoUdgEhaH4Cpkh0oVwlwUoTtK+U8g
dp8BARUgxFvPh8IGjqVsF2CTzJNRJWwbUhqAoR/dyP4oj8F6LtMXfr09VoiE6m/s
3OE9yJ9ah8DzZMI+IaCX7jpfu9yZPBA4D0oyF3iZUfPa5qtsha4R13ycQ/pY80yY
kb243Wc/Y1r3RC9OvFSJA1mjvxhMAn0vjyyvgJCG44+cQbZOeosz6YlM98XIexUk
QZTZSbpY7iSmf9YjBDowcrlrbRlv3IrxV78OX0oXxpJbzGBUNueUfT3bobU943/u
nF3Om1ncKj5uJxKrEerDxN1Vczy9U/+f8i9+raB/nGSXVYNO1T/GK3FAbZUBOTnN
Gug7noNIX8U=
=BBNG
-----END PGP SIGNATURE-----

--=-hxQC/33pmF6X7l4eBBbA--
