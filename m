Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149AbaFGRAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 13:00:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38199 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752939AbaFGRAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 13:00:53 -0400
Message-ID: <1402160437.23860.17.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/92] 3.2.60-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Sat, 07 Jun 2014 18:00:37 +0100
In-Reply-To: <20140607163344.GA2575@roeck-us.net>
References: <lsq.1402104388.385007124@decadent.org.uk>
	 <20140607163344.GA2575@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-+VtNs+GPn8uzk9GMrmwa"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+VtNs+GPn8uzk9GMrmwa
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2014-06-07 at 09:33 -0700, Guenter Roeck wrote:
> On Sat, Jun 07, 2014 at 02:26:28AM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.2.60 release.
> > There are 92 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon Jun 09 01:26:28 UTC 2014.
> > Anything received after that time might be too late.
> >=20
> Build restults:
> 	total: 133 pass: 98 skipped: 25 fail: 10
>=20
> Qem tests all passed.
>=20
> No unexpected build failures; results are as expected.
>=20
> Details are available at http://server.roeck-us.net:8010/builders.

Thanks.

Ben.

--=20
Ben Hutchings
Knowledge is power.  France is bacon.

--=-+VtNs+GPn8uzk9GMrmwa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5NFPee/yOyVhhEJAQrC5xAAo692NAtaD5uWtiqedoLNjQGHLAq0ALL3
dePYIFseYaPV3/h94UXHi30WmQuFx5RiFF+p8QtGwWRu3iHgC4f4Lc2ONZEiYBi4
jYoKHV1UF42YK6uaYb9fX+V0N4qyq+R8YNoA2o37yqK99nHgt9SpYPyxq08WbXh2
uZyh4jk12AD9BPq2WvOrnNZVz5vh+ahdgz01ZdKh/86vIhfRcMBLWeS0bXlVkuDC
zgogmyWfCWaO9sQNF9P3dDermBHfrNTMqwXrl9o3VnuObUJoUa0PvkK03BUtRCBH
+ua4uWyTHWYL+Fb/ksfttBo7mnt3OTBHKinDk4+u+QK1TMYX0VwCAZ1qmEG61T0/
t2KEqGgoNmhYJneDqx006jGXqLd3Hvr/lJM5o7MNnx7ZoeJ/aiXAxMNqbxqNzFjU
ouifPpbkLzbFRBlMGJi0/52lVlbS07axpR5Wdg1QskW2D+o2d/UZFywFj6yX78nu
k+JhAsAHxQdOK1qXS+tnE9dwpKL5qREToGQ5/VjaAndzRZED+kCEcjxciubMq3eU
AYQej/hneJ3+l7h8OwxqeMgpzsJtZRRkrxfzHSMmJCAflyYoljLtQZ/bwiyrOx5J
Kop1jlTduaZMY5gDJM/f0TxY5eSvOfit/bhffzFCfjGSb0UFLtvT5TQvHgqTv9gl
0zk27Sn8zTQ=
=+RJr
-----END PGP SIGNATURE-----

--=-+VtNs+GPn8uzk9GMrmwa--
