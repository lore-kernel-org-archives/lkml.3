Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbaDAQuD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 12:50:03 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43969 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751477AbaDAQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 12:49:58 -0400
Message-ID: <1396370989.22689.7.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 000/200] 3.2.56-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Date: Tue, 01 Apr 2014 17:49:49 +0100
In-Reply-To: <8761mt893q.wl%satoru.takeuchi@gmail.com>
References: <lsq.1396221814.369444335@decadent.org.uk>
	 <20140331004857.GA10898@roeck-us.net>
	 <8761mt893q.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RsrVUU9N2iXXk0mcQKBm"
X-Mailer: Evolution 3.8.5-2+b3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RsrVUU9N2iXXk0mcQKBm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-04-01 at 22:36 +0900, Satoru Takeuchi wrote:
> At Sun, 30 Mar 2014 17:49:46 -0700,
> Guenter Roeck wrote:
> >=20
> > On Mon, Mar 31, 2014 at 12:23:34AM +0100, Ben Hutchings wrote:
> > > This is the start of the stable review cycle for the 3.2.56 release.
> > > There are 200 patches in this series, which will be posted as respons=
es
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Wed Apr 02 00:00:00 UTC 2014.
> > > Anything received after that time might be too late.
> > >=20
> > Build results:
> > 	total: 116 pass: 87 skipped: 22 fail: 7
> >=20
> > Qemu tests all passed. Results are as expected.
> >=20
> > Details are available at http://server.roeck-us.net:8010/builders.
> >=20
> > Guenter
>=20
> This kernel passed my test.
[...]

Thanks.

Ben.

--=20
Ben Hutchings
Computers are not intelligent.	They only think they are.

--=-RsrVUU9N2iXXk0mcQKBm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUzruLee/yOyVhhEJAQpRTg/+Ke56ewW4rniLeOLOi5k6X98w5HkOpB4n
5fdXjpnnVMZC2KVJP6tavL/BV3TyhMg1zf9WrF1Zovao4zdYX1RM2xtznzMM676I
OvRKVVIb3UfkTzC1JQ5vdy7hAAlPZG4e+tRTxXZBFZyCsUckXH49c3YOQhTAsWcd
7yesO0l9SSFBun0tZiiknUKh8Lv0x7AN7DcrEqm6YSf61HstmRevpNlndQGIB193
hxy6rgUwDZFeMsRc4u1a7lsOJX7aetuulgml72FdWLU3Ls+r8BqgZbNBePf7A0/K
VF1CWdeMm6LxfBPgxs2LLRjpekKgzs0ryV3/YRrv1yOJBtgEkEEGFpM6FxGMk9OJ
rNaYhV3qzmu6H+ACZlbr34CSEi4OaVGCvpeL8C7lJgFXq4KJ6D1sG1+he2FDTHG5
lDaljOitIEJwTr4j3AVjaXppDt+FCNA3K00vPpkzHyBctI8FmGAROM3K0CEIWu8Y
F5O54dIT9TPVG1/Mm/jFXh4YVbUd1FMR2UkONIBkKFpbjzx/6csSjDPaPbldwDT/
CfRMCxmtf97YwK5rgXI/+6AGB1cVNACz8WMp9NzHyhwN1n2Xl+rAlm5ZjO4qohu6
dOkO011YBxJoX/uaYsbV7a4fXJCegvVhycxabYLOqimiMe4t5iT9ZA/KenHNS37s
mn3pYyRDiT8=
=bBFv
-----END PGP SIGNATURE-----

--=-RsrVUU9N2iXXk0mcQKBm--
