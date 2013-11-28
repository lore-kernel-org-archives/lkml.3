Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889Ab3K1OBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 09:01:24 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40912 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751271Ab3K1OBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 09:01:22 -0500
Message-ID: <1385647262.23855.76.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 00/87] 3.2.53-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Date: Thu, 28 Nov 2013 14:01:02 +0000
In-Reply-To: <87eh6023yw.wl%satoru.takeuchi@gmail.com>
References: <lsq.1385387069.559528559@decadent.org.uk>
	 <1385563504.23855.64.camel@deadeye.wl.decadent.org.uk>
	 <878uw9bg9s.wl%satoru.takeuchi@gmail.com>
	 <87eh6023yw.wl%satoru.takeuchi@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-gcmpryjxAfLi4VuuDL2v"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.213
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gcmpryjxAfLi4VuuDL2v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-11-28 at 19:52 +0900, Satoru Takeuchi wrote:
> At Thu, 28 Nov 2013 08:01:51 +0900,
> Satoru Takeuchi wrote:
> >=20
> > At Wed, 27 Nov 2013 14:45:04 +0000,
> > Ben Hutchings wrote:
> > >=20
> > > [1  <multipart/mixed (7bit)>]
> > > [1.1  <text/plain; UTF-8 (quoted-printable)>]
> > > This is the combined patch for 3.2.53-rc1 relative to 3.2.52.
> >=20
> > This kernel can be built and boot without any problem.
> >=20
> >  - Build Machine: debian jessy x86_64
> >    CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
> >    memory: 8GB
> >=20
> >  - Test machine: debian jessy x86_64(KVM guest on the Build Machine)
> >    vCPU: x2
> >    memory: 2GB
> >=20
> > Building a kernel with this kernel is now testing.  I'll be able to
> > report the result after 12 hours since I should go to my office now :-)
> > If you'd like to release 3.2.53 asap, please go ahead.
>=20
> Building a kernel with this kernel also works fine.

Thanks for confirming.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-gcmpryjxAfLi4VuuDL2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUpdMnue/yOyVhhEJAQoc1A//WXCtuJnMgFtss4DyW4C0PRX1CiAR74pk
c+TMm1SmoK3uaiznfOuoQr8ya/83rxrurTjYg4nYrTelBmCqYe/gXKDHPNcfFYwb
cpQp7NuP8RRBeIKciS8g3w2+Vs530zeSgKDVbeY3y5u8qq2gYcLOT69+tFfScFeB
/rSmFIN8Euturb5BK2tMn4oRyup3iqNuOOLjsAQQvpBqpyVOXnxHaxhg4dfNyQBu
RoMlfcpf/G/A5jkh57OH2Dp8xb/J8Ic5Z+A2ILl7J0MFH7LeAnO3GpDfFkBxTiif
xphi/NdKCdlojg1cEkyKvnB9phcDL7UOgU1YXAZ7ccciDwA0XUcYh14hDra0RK85
A8ilun0v2lZID9YD3JM/BCQrIvxyO7GAkw7HKpwoXmBN3cjFUMa8q7cplKUe2+Dr
x/glgYNVmzD0/XfmWfo+4WKMFAwO5EYBcX1FX8c3asLqzE76q82phAGE2xhlD5hz
VOLkSFmwuRDkCvaD+XnGcYNmiH02gMWi+N24S0xAjip1cg9xvE1nAuBqrViJRqZ8
3iJFq2SZS3uKIYE9eanEHfDCi7B/Lh8UhYeDGPqwLCB5Cv/vkUJVBYtwEOsDrgqQ
zqpl/cSx6J4cuHua1f+5YS0nVAWp8sdevNAdcs4tgZ6La5y4Cc50JkK+rVTzxqSh
Qzl+Ruig10c=
=l9Q1
-----END PGP SIGNATURE-----

--=-gcmpryjxAfLi4VuuDL2v--
