Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576AbaGRPnU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 11:43:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37103 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454AbaGRPnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 11:43:18 -0400
Date: Fri, 18 Jul 2014 10:42:32 -0500
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@infradead.org>
CC: Masanari Iida <standby24x7@gmail.com>, <sfr@canb.auug.org.au>,
        <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH/linux-next] Documentation:Docbook: Fix file locations in
 gadget.tmpl
Message-ID: <20140718154232.GP24914@saruman.home>
Reply-To: <balbi@ti.com>
References: <1405655169-23804-1-git-send-email-standby24x7@gmail.com>
 <1405655169-23804-2-git-send-email-standby24x7@gmail.com>
 <53C93AF8.5090407@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RtGa12sjXv8gVUZO"
Content-Disposition: inline
In-Reply-To: <53C93AF8.5090407@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--RtGa12sjXv8gVUZO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 18, 2014 at 08:19:20AM -0700, Randy Dunlap wrote:
> On 07/17/2014 08:46 PM, Masanari Iida wrote:
> > Because of file location changes by commit 5ed4ac73e5975,
> > make xmldocs failed because of missing files.
> > Fix file paths in gadget.tmpl file.
> >=20
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
>=20
> Hi,
>=20
> There was a patch for this on the USB mailing list yesterday
> from Andrzej Pietrasiewicz <andrzej.p@samsung.com>.
>=20
> Hopefully Felipe or Greg will apply one of them soon.

already in my tree, should be in linux-next already. If not today,
tomorrow.

--=20
balbi

--RtGa12sjXv8gVUZO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTyUBoAAoJEIaOsuA1yqREMq4P/35LKNZXo6G6/hp5MCboDvJ3
P/10dzpnGlGkfLj7djY9JhnJ7wqbK5gX+Et5WOMs4EmyuEtyA0NJscYSzSXhf2Ib
e9t0DQY5kuWKJ0HxQlpHq330Amu8yCVKTSDayyfm4pcn9Z4n50NPgiRaxY8aIVfy
vFi6dJ1jQqR1i1trw3Mwr3ZE4vqOwv1AL+ZcLbnym7D1SLAwBISl4oB7GWf1f0AZ
WaEDYGBDD53jBgOIOv3JYWEE1Y3uRSBI4qRjbKMn4fCutnTRsmCdFtd4S90LuQ/T
QbwPT9tciADkaDPj21ZadoPF1ggHhJQqm62CXyrQ/0RF7jdgcDvtpi1CpENb++XU
gP3me0fxOEBqdmoZZzQ12MAYqlaq9Srz5bZPGnbAKp3xra3UKuaGY5P/X9cpkqRr
2/DXkpBFJ+MBbQgk+1MDd+uoBMc8cvobcz3m+Dg5maAuwZDx4RSUBODHaysZtdHU
uzSbnXxvX3HFBohiYk0drrrY46XKC94pLHGpR5/gi735CI6tqcEk0qfNVEgZXIJg
/xybGkEf9UhZG3R3IDO/D9ko47tUSUWheWE2kX4nVunTl6Uz40fkVHLFjtBPyCO4
hduF3wZc+OQftlt/aNbyUdyhN9+DcR48CtwbY5qmPzhUmIXyA85G3Eup5IwbRt9i
gUk3gEL8nvXUhgZqxp5s
=87xk
-----END PGP SIGNATURE-----

--RtGa12sjXv8gVUZO--
