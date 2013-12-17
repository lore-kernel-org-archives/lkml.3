Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240Ab3LQFNo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 00:13:44 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35058 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab3LQFNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 00:13:42 -0500
Date: Mon, 16 Dec 2013 23:13:02 -0600
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-ID: <20131217051302.GB22740@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
 <20131209041152.GC20608@saruman.home>
 <20131217153625.744ebbe433f3d624d11af2bb@canb.auug.org.au>
 <20131217050822.GA22658@saruman.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7iMSBzlTiPOCCT2k"
Content-Disposition: inline
In-Reply-To: <20131217050822.GA22658@saruman.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7iMSBzlTiPOCCT2k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi,

On Mon, Dec 16, 2013 at 11:08:22PM -0600, Felipe Balbi wrote:
> > > On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > > >=20
> > > > After merging the usb-gadget tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >=20
> > > > drivers/built-in.o: In function `otg_set_state':
> > > > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> > > >=20
> > > > CONFIG_USB is 'm' in this build.
> > > >=20
> > > > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb:=
 phy:
> > > > Add OTG FSM configuration option")?
> > > >=20
> > > > I have used the usb-gadget tree from next-20131206 for today.
> > >=20
> > > I see what caused it, will fix it up with a patch which should probab=
ly
> > > be backported a few kernels back. Thanks for letting me know.
> >=20
> > I am still getting this error ...
>=20
> Fix is in Greg's queue, not sure if it has reached mainline, yet. Will
> check when I wake up.

just checked, it's not there. Pinged Greg.


--=20
balbi

--7iMSBzlTiPOCCT2k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSr91eAAoJEIaOsuA1yqRETnoP/0svIZHENns+4NkDYRyIjpQl
y8l7YvB4BIqZ7zbxP7EDRIjJfuS1QnX+Js80kWMx69i8TOxuLPHbXK2I3FQXCkZ9
NdB7Zd5Fbbast24+szlSvxiRm8y99tyi9hNiINkvyGpIIKdBzpJdt5HAnhXj/asT
OhoviDOl+Rty3jMJlSY5+ccsIeoGUjtOoETpKkjwhcKPj63fjG01571FNIz9SmI+
ffhAUNnpG9SbdIG2ox37vQIsU2Uc+r7srROXRvqMaOZ0TI1K/EE8+iIVFIdfSAaW
KueiVDTx6+05lOIfhaIxABZFAkKsupkJgMYvOiXT5z6wl52ibzdDLEhbJX6HaaWn
KGsvX7Cl8uhJi47UPWK1hMsSI12bH8Kz7LWmO5f/HXFGc3nhrvP7CjfrBaEWmHiC
PgOAwo+42LyqH+sfym+70SgvUp2vOh/ELgzDB3rZ+ZxFqB1NZ/C8W6ABGhAr+REk
DkCiuSN2FzNl0Dh0drLkvMfF4SDjoZo89jgePt4fTUsGTi3jmdENUo83QYVCx+hh
Av1BBUY3Cuu1bTrbbRS25I0+/voldeWE7OeO2zgMi6ZjFtRyELnGy+gMFdWamSoE
2TbjxV9fxfsEf9rlnWXa6DQ/Q8TPkk2fGYeam8pcFhZV+S/Wy4toOJX5mTvMqOVR
ioWL/BX+zdCBZeuFoArc
=94H5
-----END PGP SIGNATURE-----

--7iMSBzlTiPOCCT2k--
