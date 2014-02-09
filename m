Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBISTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 13:19:18 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41221 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751646AbaBISTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 13:19:17 -0500
Message-ID: <1391969942.25202.76.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 056/185] mm: ensure get_unmapped_area() returns
 higher address than mmap_min_addr
From: Ben Hutchings <ben@decadent.org.uk>
To: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Kiyoshi Owada <owada.kiyoshi@jp.panasonic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 09 Feb 2014 18:19:02 +0000
In-Reply-To: <20140106191910.7155.38390934@jp.panasonic.com>
References: <lsq.1388282923.51724079@decadent.org.uk>
	 <1388723203.22017.36.camel@deadeye.wl.decadent.org.uk>
	 <20140106191910.7155.38390934@jp.panasonic.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-hjSZsR3kmrZ6DfQgRXkH"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hjSZsR3kmrZ6DfQgRXkH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2014-01-06 at 19:19 +0900, Akira Takeuchi wrote:
> On Fri, 03 Jan 2014 04:26:43 +0000
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > On Sun, 2013-12-29 at 03:08 +0100, Ben Hutchings wrote:
> > > 3.2.54-rc1 review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Akira Takeuchi <takeuchi.akr@jp.panasonic.com>
> > >=20
> > > commit 2afc745f3e3079ab16c826be4860da2529054dd2 upstream.
> > [...]
> > > [bwh: Backported to 3.2:
> > >  As we do not have vm_unmapped_area(), make arch_get_unmapped_area_to=
pdown()
> > >  calculate the lower limit for the new area's end address and then co=
mpare
> > >  addresses with this instead of with len.  In the process, fix an off=
-by-one
> > >  error which could result in returning 0 if mm->mmap_base =3D=3D len.=
]
> >=20
> > I'm dropping this as I have no good way to test the backport (it's not
> > used on x86) and I didn't get any confirmation that it's right.
>=20
> I'm sorry for delayed reply.
>=20
> Your backport seems right.
> Additionally, I've confirmed the problem is resolved by your backport pat=
ch.

Thanks, I've re-queued it for 3.2.55.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-hjSZsR3kmrZ6DfQgRXkH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvfGlue/yOyVhhEJAQpAQxAAkORDnuQmK0G1F9R6nwOH81520xW+h+hf
sc6Hbk4NXUAB0VIrrFk8ZlNiBEI9Hn+vlNKWCiKJ4CfB5C6ufXXGjXs9y3kfIyvV
B2miR2tORi1ZZYdbZ7WloaQJm/M1A/oxjHz1yvvCzLKxl+/uy0r2mA0+UH1jJ1pb
MNSY/Z4Q5fSL2GskdWjjAmCbYXyI54KRVCYcUiXfCf5sVZEFOGfMObpdosfm4/cU
eeuDET7Y+NRSuBZRh0hpsMkyBiuBfKSIZSrvPxOsoQfyDnmWcXynT77P5zMsu8Zo
sT0Fsuf5jYuAuhCeJ2j6Et4aMGtslpRUolRn7L98/ZTSipix8mSfzseApmm1grZ1
hKE0dBTxuZ2Nk/62Q5oVfRphDzuY1u0LIhkKLTThgKBeiWG8w5AQOb6NTOEk0XJ/
k3BQFETCWN0mNSfvaf9zhmeFPBeVHZ4Rznmxq+k+PLdIiEVD1bWbGqCFK6ZuOjDI
sLVMCKERhdXl+OxQDzltpHSbLyRrn2EWKxjOdfXjNroschMLAdhAmYd2sSL/xp8A
fF5NXOLoR7+wUPfHPsgfWnNCTfYgyzUSOq4mx3IZ/pba28vvBPzrMzGHAG25igKw
kvoqmMkEzYRbV04MIUCkZpFtDaN7BkFYd64EGFhLfTd2Cil8nekRXUvS6SeIrRaN
DNfdnBtZKMM=
=XvZB
-----END PGP SIGNATURE-----

--=-hjSZsR3kmrZ6DfQgRXkH--
