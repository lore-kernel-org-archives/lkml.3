Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758904Ab3HMT5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:57:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:37746 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177Ab3HMT5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:57:11 -0400
Date: Tue, 13 Aug 2013 14:56:38 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sedat Dilek <sedat.dilek@gmail.com>
CC: <balbi@ti.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: linux-next: build failure after merge of the final tree
 (usb-gadget tree related)
Message-ID: <20130813195638.GD11075@radagast>
Reply-To: <balbi@ti.com>
References: <20130813181719.e2dea691c1e3c19bd6306983@canb.auug.org.au>
 <20130813194803.GA11075@radagast>
 <20130813195133.GC11075@radagast>
 <CA+icZUUse7BHLQWZYAq1znr8XbiiFyxrCN1YxiR+z=cUH+D6jQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C+ts3FVlLX8+P6JN"
Content-Disposition: inline
In-Reply-To: <CA+icZUUse7BHLQWZYAq1znr8XbiiFyxrCN1YxiR+z=cUH+D6jQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--C+ts3FVlLX8+P6JN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 13, 2013 at 09:52:53PM +0200, Sedat Dilek wrote:
> On Tue, Aug 13, 2013 at 9:51 PM, Felipe Balbi <balbi@ti.com> wrote:
> > On Tue, Aug 13, 2013 at 02:48:03PM -0500, Felipe Balbi wrote:
> >> Hi,
> >>
> >> On Tue, Aug 13, 2013 at 06:17:19PM +1000, Stephen Rothwell wrote:
> >> > Hi all,
> >> >
> >> > After merging the final tree, today's linux-next build (powerpc ally=
esconfig)
> >> > failed like this:
> >> >
> >> > drivers/usb/phy/phy-am335x-control.c: In function 'am335x_control_us=
b_probe':
> >> > drivers/usb/phy/phy-am335x-control.c:117:2: error: implicit declarat=
ion of function 'IS_ERR' [-Werror=3Dimplicit-function-declaration]
> >> >   if (IS_ERR(ctrl_usb->phy_reg))
> >> >   ^
> >> > drivers/usb/phy/phy-am335x-control.c:118:3: error: implicit declarat=
ion of function 'PTR_ERR' [-Werror=3Dimplicit-function-declaration]
> >> >    return PTR_ERR(ctrl_usb->phy_reg);
> >> >    ^
> >> >
> >> > Caused by commit 3bb869c8b3f1 ("usb: phy: Add AM335x PHY driver") fr=
om
> >> > the usb-gadget tree.  Forgot to include linux/err.h.
> >> >
> >> > I have reverted that commit for today.
> >>
> >> damn, I didn't catch that. Sebastian, can you send a patch ?
> >
> > nevermind already patched it myself.
> >
>=20
> Sebastian sent some hours ago this one:
>=20
> [PATCH] usb: phy: am335x: include linux/err.h

will replace with that.

--=20
balbi

--C+ts3FVlLX8+P6JN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSCo92AAoJEIaOsuA1yqRE67gQAJMjflfC1vX23VY7x097ias4
zAsYRhJM3dY53MFsK7dCTKLtXjnvWKn89cTCwjiRflnWPOpx9OjvvJiokC+/pkGc
nOU9IAcUtq4SRFjdlzxQP1OqwJbhtSoHbLDHbwRHzE5UolVQHahPmbi0Ic9o6201
3/p8663inyOL4JFJXHDXjcrRCGAW1DTY89Y0c2Hu7q05H6McBQefEDocZkqXXwn3
OXtAqNALOiyq3JhGAPxHFnRa73m62RIADDt1PJ+sMQLxoMSXb/HBGpadtT/UhZqe
h1FYtFR1I14h0laVzjfLppkKrwHmT9Yp6DX+clstRYQ7/MXFPZk+m88xvg18p6MM
7SRNEo2yTMFsXuaiig8/+KPVVHMw7xqjYevw6kRopL1tY8F2v9utVtrBspjAcGGV
QiKxOEbA/U1fFhLVYdSQWyyblKf7yGwELsP6TNegVaT8HOmCPpLZmCPc8ELV3HU8
ZaUTQ6fnZY4Im6P31bfxLrDMFY0Q6QHPsENI3AKShs/uzQEUAKwvtjGVwq1aRJR1
fCUB9+Q6OweKJsb0S7+C0Fg+QpBtmg8kX3BdEgoDYpTnxtF4+1BWk6Bh6ANLUA9T
uFAqm+YrFzRJHGWfIyeLovl16i0cuZERpzLTi/V95fFBCX/KX97adl2iNAUaEX0E
Xz98cv0zkl1M1ncs8aiA
=5MNQ
-----END PGP SIGNATURE-----

--C+ts3FVlLX8+P6JN--
