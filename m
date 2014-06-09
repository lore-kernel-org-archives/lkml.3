Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933878AbaFIXsc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 19:48:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45131 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933234AbaFIXsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 19:48:30 -0400
Message-ID: <1402357697.23860.90.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/92] 3.2.60-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 00:48:17 +0100
In-Reply-To: <87ioo964yz.wl%satoru.takeuchi@gmail.com>
References: <lsq.1402104388.385007124@decadent.org.uk>
	 <20140607163344.GA2575@roeck-us.net>
	 <1402160437.23860.17.camel@deadeye.wl.decadent.org.uk>
	 <87ioo964yz.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-CUM1v1dw8RqeSDP1tKD5"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CUM1v1dw8RqeSDP1tKD5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-06-10 at 08:25 +0900, Satoru Takeuchi wrote:
> Hi Ben,
>=20
> At Sat, 07 Jun 2014 18:00:37 +0100,
> Ben Hutchings wrote:
> >=20
> > On Sat, 2014-06-07 at 09:33 -0700, Guenter Roeck wrote:
> > > On Sat, Jun 07, 2014 at 02:26:28AM +0100, Ben Hutchings wrote:
> > > > This is the start of the stable review cycle for the 3.2.60 release=
.
> > > > There are 92 patches in this series, which will be posted as respon=
ses
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >=20
> > > > Responses should be made by Mon Jun 09 01:26:28 UTC 2014.
> > > > Anything received after that time might be too late.
> > > >=20
> > > Build restults:
> > > 	total: 133 pass: 98 skipped: 25 fail: 10
> > >=20
> > > Qem tests all passed.
> > >=20
> > > No unexpected build failures; results are as expected.
> > >=20
> > > Details are available at http://server.roeck-us.net:8010/builders.
>=20
> Although it's too late, I tell you that it passd my test just FYI.
[...]

Thanks.  Generally I try to avoid running a review cycle at a weekend.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-CUM1v1dw8RqeSDP1tKD5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU5ZHxue/yOyVhhEJAQpuCw/8CFj/LdrQk1deu2K8WXsKiosnEemoSvXc
POcgBhjBK9vceblAxg2dUxneUL67bUcYB3IyVKaA251uxSjDQnhud4epwJAFsKkI
MIFM5azw7rvAUlBgvPFUHGcQ+A5z/l60+BEfFBtxaw+sH/DQoXB8mMk5QFrj/fTa
g7YOzXXmHkTS7vrPyZSbGGFKxsy6bMswkprAKMD/0rGyufOduMklq8a7ylWnbLzF
6YQJlfOPLJx89IX0fn8q70avp5VfKdrXTpzjAl8n2tVhauH/8gjW4PVB8J49bTWe
xH2H6vivSE6H0vN03xtWWY8xB5qbahvDDBESPsWy9D4L70+WI0f714Jn30j80JHi
5XEQkzp5zM8Xsn9j5Wz53XA5TVenfvtUZ42ENu6C5bUjr5VuNQPq11pSbVZngkhh
WA1m6cRulP1NXrojZxrD57nlEUY8UJ68TrQ/TjBY5T7fioh7Vbkll2idU1eDIuwo
3MSn7q7rKKkyF6wA3OnsoFeSIiPx4JDJKoAlC9iE6rbqtbI0jQbzqESmNaJ7NqCt
6CyDJmfJMarPbIk18n9n2HTC5bInZVmXgM74CU0LbC19+JLFY64D8uQl9z0h9cqo
zbqFDA+4d3rM9cvHFv82eQjHIXhFqpQvPtFB1fds4BaqqNkH6x0eiFPSiZhrh4Qy
+qQfPA1unxk=
=8+m9
-----END PGP SIGNATURE-----

--=-CUM1v1dw8RqeSDP1tKD5--
