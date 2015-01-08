Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbbAHQ6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:58:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:55778 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755204AbbAHQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:58:00 -0500
Date: Thu, 8 Jan 2015 10:57:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: sundeep subbaraya <sundeep.lkml@gmail.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: query on DWC3
Message-ID: <20150108165722.GG31926@saruman>
Reply-To: <balbi@ti.com>
References: <CALHRZuotPpSoX9bnQin=93k0Hr7tEp_HZDaaBvfKaPfmoi_EBQ@mail.gmail.com>
 <A2CA0424C0A6F04399FB9E1CD98E03048450126C@US01WEMBX2.internal.synopsys.com>
 <CALHRZupFbTxTn9KiUCmvcmgYxUUcNfvAoMqOq=Drq0gZ+H246w@mail.gmail.com>
 <20141222161123.GE12815@saruman>
 <20141222161218.GF12815@saruman>
 <CALHRZuqq5Cc+WsQDzOjKOcF6HNH+OKw_7Pkkp3qssuu7kpSeLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L+ofChggJdETEG3Y"
Content-Disposition: inline
In-Reply-To: <CALHRZuqq5Cc+WsQDzOjKOcF6HNH+OKw_7Pkkp3qssuu7kpSeLw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--L+ofChggJdETEG3Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jan 06, 2015 at 12:39:55PM +0530, sundeep subbaraya wrote:
> >> On Sun, Dec 14, 2014 at 08:39:18AM +0530, sundeep subbaraya wrote:
> >> > Hi Paul,
> >> >
> >> > As per my understanding, for BULK OUT we do queue a request with 512
> >> > bytes length since we do not
> >>
> >> sometimes we _do_ know the size. In case of Mass Storage, we _know_ th=
at
> >> the first bulk out transfer will be 31-bytes (CBW), if we were to start
> >> a 31-byte transfer, we would't receive anything.
> >>
> >> > know the length of the transfer Host is going to send. For Control O=
UT
> >> > we know the length in wLength of
> >> > Setup packet, hence I assumed there is no difference in programming
> >> > model of Control IN and OUT.
> >>
> >> there is _no_ difference. It's just that it was agreed that for anythi=
ng
> >> other than control ep, the function drivers would take care of it. See
> >> the uses of quirk_ep_out_aligned_size.
>=20
> got it..:)
>=20
> >
> > btw, why are you reimplementing the driver when there's a perfectly good
> > driver to use in mainline kernel ?
>=20
> I am writing a bare metal driver and it didn't work without alignment
> check mentioned above.

just make sure you don't copy GPL code into your bare metal driver,
otherwise your bare metal driver will be GPL by definition. Also, since
you're not using Linux at all, you should be asking support from
Synopsys instead, not the Linux USB mailing list.

--=20
balbi

--L+ofChggJdETEG3Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrrbyAAoJEIaOsuA1yqREJJcP/R3REsBR0qbdBWn2/souQ0SX
EB4E3sgsML6Vlr27LHUvs98ez0yBEkyl373Uytg/XuhNTfekqcExzrC0ijHgaE0C
mPxqqI1Dpzg5/588s5fZTMHkd3yl/Jzmhy8jgYwm9U8SRM4PLsXSKgKC99Vb3K+K
CUGUWd2Vqrv2eAaaY+YBzishfmo+oa7ejc/M6ct4KA/HbTXFsqWY6VnTw87WHH+x
gJE8jRFp7aju2Dod+LWQdTH/b07sw28kNC+bNRZ3Qruw0UHBCCQhZnJiyDNqg2Vw
nzNKF+flzne4Z8RoxTCffTlIyIDTqsmaXCLguXu9+K+f0tHaLOU8Sh404KpppPxy
zO6Lsddu581TvdPYK9TAAkOd6OhIdLId0bcWWyPK/ZXv4Oo2hL/gHLkwQRcf3beJ
wDbe8RmdzGNI8zZ3pUlNUFnqllLU95+0nUodxyP5imrWqQQji4DyOoJKEpTRuCzM
X9phYeENzcdzWK03TSHYXFopBQASAxxGnSiZeFr2YveYUdha9QvxGl5C75PgK9dp
T7PTyXinpXgfO2BUw7OzGyusZF0cN0EqHJLKdS+hrO80AIb6QpI3IkXi3EGlQajE
7NFK+p3B/kSdwWweAhV6Qy/22OsflmY5Njgs+WDeBqgOJRiTmow8J6HkGonRJ8Wj
gDJXlIh2M+2K7GSf6Wmr
=OZS1
-----END PGP SIGNATURE-----

--L+ofChggJdETEG3Y--
