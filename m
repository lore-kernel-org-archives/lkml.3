Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752049Ab3LQFJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:09:07 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34923 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942Ab3LQFJF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:09:05 -0500
Date: Mon, 16 Dec 2013 23:08:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: <balbi@ti.com>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131217050822.GA22658@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
 <20131209041152.GC20608@saruman.home>
 <20131217153625.744ebbe433f3d624d11af2bb@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20131217153625.744ebbe433f3d624d11af2bb@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 17, 2013 at 03:36:25PM +1100, Stephen Rothwell wrote:
> Hi Felipe,
>=20
> On Sun, 8 Dec 2013 22:11:52 -0600 Felipe Balbi <balbi@ti.com> wrote:
> >
> > On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the usb-gadget tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/built-in.o: In function `otg_set_state':
> > > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> > >=20
> > > CONFIG_USB is 'm' in this build.
> > >=20
> > > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: p=
hy:
> > > Add OTG FSM configuration option")?
> > >=20
> > > I have used the usb-gadget tree from next-20131206 for today.
> >=20
> > I see what caused it, will fix it up with a patch which should probably
> > be backported a few kernels back. Thanks for letting me know.
>=20
> I am still getting this error ...

Fix is in Greg's queue, not sure if it has reached mainline, yet. Will
check when I wake up.

--=20
balbi

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr9xFAAoJEIaOsuA1yqREcykP/iR8dN8BP37hPgPpwIYQJlq1
IeZWwgANcXxC4JRlNfXtUZrT+I9Fe/Z2XOTYZPpWx3+yw6OAFSgt5bztnDROIJaU
4U8A10t08w9LM5xhH/Rco+Dn5xLGkPVre3ljHvRYomWKawMbtPTFTOEuYFzLb0Yh
Ryokm3SXFHiI8wySx16dNnqc0nOCgMmXBeEx8nW8LpotWXt/ZvujZUTXoe2mCmXS
NIUCE5XvCOpgRHKMzAcmJ7W/JofaHe1yPPAMooooIiz0AM6ZkbKE2WFZy5DKtVsS
eJkeUR/9Ux7RKwPmQcV41bdfSpqBLQyAMPqQ0yiOQuRamDMFDiKSyIkQ/jS25lxJ
rqRpds45W9im9QkIs0unBxU6KlFqYj0EhbOoAXjTerVTlgn6IRNMpxnzQQVP9CVR
sulkIIyppA2cZXJpxajj0SrIkw5UBAUDXfs2kNcPjpXBbYxMfAuCZv0p0WVtsMKi
A1XK4mMYgvu6VEDuJrfc6aWezARxaEU8n7C3BlMJ0ESS0kNHq7d4H3fMtd7Xk+iR
Nw0YZHoYnGLPJKWq6uRYbAbHOQM16UcLTJRfsiA8/IuX1+/7/8ly5iUWF7PlA4yi
IEbErU+wrlCjvz0OGdX/Xa8UCqo5h+tjsRGNxoxrr27Bq9SNrYQWHWH0Gk5EbWr6
oPXpSnI4mLnsrPpJUqY3
=/wBt
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
