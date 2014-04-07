Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbaDGMaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 08:30:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32904 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753510AbaDGMau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 08:30:50 -0400
Message-ID: <1396873835.8206.27.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/18] 3.2.57-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Mon, 07 Apr 2014 13:30:35 +0100
In-Reply-To: <53422195.9060108@roeck-us.net>
References: <lsq.1396827347.462803115@decadent.org.uk>
	 <53422195.9060108@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Lgxb4n4mc8f2xMMMP8rA"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Lgxb4n4mc8f2xMMMP8rA
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2014-04-06 at 20:55 -0700, Guenter Roeck wrote:
> On 04/06/2014 04:35 PM, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.57 release.
> > There are 18 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed Apr 09 00:00:00 UTC 2014.
> > Anything received after that time might be too late.
> >
>=20
> Build results:
> 	total: 116 pass: 87 skipped: 22 fail: 7
>=20
> qemu tests all passed. Results are as expected.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks for checking, Guenter.

Ben.

--=20
Ben Hutchings
Sturgeon's Law: Ninety percent of everything is crap.

--=-Lgxb4n4mc8f2xMMMP8rA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAU0Kaa+e/yOyVhhEJAQoZ3hAAt9nTWC5HCkFopBf8FWUHJpiu3H0TcyYo
VHxOUwG9KRVe2irzDLqjyOEx2tGcSMPzn17hM17+Ttev6aLV53PF9/Ek2YDNoa8S
wdc10sGemozNVK+oh3oHIFolBXTFgORYh94BPC2POVJRG0XrJlDZfBkySCoAKR4g
5i/qGqsghQuwTA6SvBlfBNDvdSLqSFIR9iKTVDynF7t4I7/GG/ZT58ynWGXAwwEd
p/0+j293zniV0rG/PupmipuWtCsSD87rK6cZQ5hM2/leAw5booPD3p0KI44MC1LM
TuKKFdY3t8klx++MrdeU9fJ/EKllu1DQaJsZQSQXzM5X265C46ciENT4XyvBN+lc
0OVXh973fBzepn8IPUiOgNNeoyiM1uQei/E786wrpvuE1GVx6JjUaa1Y+4n4wT0e
9MCwNFWbS6NH/Whaxo/FYHIqcjUNS6cz/MFNv+QXNCU1QAaDLho+YHlND8X9GRt4
UQkLKN0PWMq/N/Hn4ZjXo0wRgK5lBDYQaXZAfLBdKhygCeH2mffr+Su72c6BU6RP
fsa+pVd9QTjQ8Cfko59xo+ACsyqLiio/bdGwccZ/Ay/YEVmK+0DHQNi3tB+ycJLU
9/YXsmgGINky++K+m0BCNGYaDFFwx2rIocEk81/7t3f1NKYOT0tWF+5j4K4OzlW0
6r8K3VWntZg=
=00jU
-----END PGP SIGNATURE-----

--=-Lgxb4n4mc8f2xMMMP8rA--
