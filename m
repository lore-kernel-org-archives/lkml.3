Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932237Ab3AQIl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 03:41:56 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37986 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3AQIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 03:41:54 -0500
Date: Thu, 17 Jan 2013 10:41:36 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: <balbi@ti.com>, Alan Cox <alan@linux.intel.com>, <arve@android.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 03/10] goldfish: tty driver
Message-ID: <20130117084136.GC10814@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165902.15183.60134.stgit@bob.linux.org.uk>
 <20130116170122.GB6377@arwen.pp.htv.fi>
 <20130116182520.64b1fe6a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pk6IbRAofICFmK5e"
Content-Disposition: inline
In-Reply-To: <20130116182520.64b1fe6a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Pk6IbRAofICFmK5e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 16, 2013 at 06:25:20PM +0000, Alan Cox wrote:
> On Wed, 16 Jan 2013 19:01:22 +0200
> Felipe Balbi <balbi@ti.com> wrote:
>=20
> > Hi,
> >=20
> > On Wed, Jan 16, 2013 at 04:59:03PM +0000, Alan Cox wrote:
> > > +static int goldfish_tty_probe(struct platform_device *pdev)
> > > +{
> > > +	struct goldfish_tty *qtty;
> > > +	int ret =3D -EINVAL;
> > > +	int i;
> > > +	struct resource *r;
> > > +	struct device *ttydev;
> > > +	void __iomem *base;
> > > +	u32 irq;
> > > +
> > > +	r =3D platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > > +	if(r =3D=3D NULL)
> > > +		return -EINVAL;
> > > +
> > > +	base =3D ioremap(r->start, 0x1000);
> >=20
> > missing request_mem_region(), in fact you could just use
> > devm_request_and_ioremap().
>=20
> Actually the reservation is already done by the bus driver. If it sees
> the goldfish interface it reserves the entire chunk and the emulator then
> tells it which is in each chunk of that range.

a bit unusual, but fair enough.

cheers

--=20
balbi

--Pk6IbRAofICFmK5e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ97lAAAoJEIaOsuA1yqREMrcQAIt4t8mvJuBTlBFPxu6E/s5L
BpgPRK8UgbopRbwO/7mDny4kPe7dHilQXN6HhxB9aWiIFUab+2cwQwd6m/o4zwuh
16qB7pfyWXZnQhywINKlacbDPImllRe2FTWjCHCCCxc4hyooCULGoo6528HPi1b2
agi13IARMxB0rWDyouaOwsrCTIbPWi5rZ9g5bshK3ZSNSIOU840jfW/goLlHxH6W
o5/1qLogYkbTkWLVoppz0MecYQFVsLW1QOrsAufIzYP5O1bsKmkLH80K0qL/pJHp
XFVhMGyjIrmNKAszVmlp95iWCqii6YafRvfR4cDvadaXSbOHNyFz1Axc3TEu98Qm
5ypAbsDuDyKmTmImywu76OIadniEPKZvx4GAoHdoX/rEYYf8WY3Y9fnOgArgCFnV
ytR84K5UHx0zRdpjoRCKBJ9S+KJ6hLPHNQtBsom9PC7iqQZjGciFy4s0GTP9wsp8
OewLb83TOHBmRBVrgm+tpSA5plqYPtee9w0wzeHYuAuzJ2iMpwPblHTh48bdpxz3
CcKgtWVJNjUq+Pdkd8NUY5m1ijuzJ1zV0JI1PkjbjN+jRgoNiafjBUFowrLNNsvz
09q/IphN2f7unW08mBu3pL6R1k1ZrOu7nmoIEk8+pg3CMR3ao1AbnHllm4KILWcI
1W/UFZ+eQyyOa8hS+Dj3
=lmhF
-----END PGP SIGNATURE-----

--Pk6IbRAofICFmK5e--
