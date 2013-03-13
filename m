Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab3CMJPD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:15:03 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47599 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754051Ab3CMJPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:15:01 -0400
Date: Wed, 13 Mar 2013 11:14:53 +0200
From: Felipe Balbi <balbi@ti.com>
To: Vivek Gautam <gautamvivek1987@gmail.com>
CC: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        Vivek Gautam <gautam.vivek@samsung.com>
Subject: Re: [PATCH] usb: dwc3: Set DWC3 context's mode based on selected
 mode.
Message-ID: <20130313091453.GE6270@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
 <1362230724-21017-1-git-send-email-gautam.vivek@samsung.com>
 <CAFp+6iFjiOPbZhdpWCq0agWBeSC+Vc19Ff++_3vxa6r-MburWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Uwl7UQhJk99r8jnw"
Content-Disposition: inline
In-Reply-To: <CAFp+6iFjiOPbZhdpWCq0agWBeSC+Vc19Ff++_3vxa6r-MburWg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Uwl7UQhJk99r8jnw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 02:42:22PM +0530, Vivek Gautam wrote:
> Hi Balbi,
>=20
>=20
> On Sat, Mar 2, 2013 at 6:55 PM, Vivek Gautam <gautam.vivek@samsung.com> w=
rote:
> > Now that machines may select the mode of working of DWC3 (HOST only,
> > GADGET only or DUAL_ROLE), lets set DWC3 mode based on that
> > rather than fixing it to whatever DWC3 hardware says.
> > This way we can skip initializing Gadget/Host in case
> > we are using Host-only/Gadget-only mode respectively.
> >
>=20
> Hope this patch if fine, and mainlinable ?

yes, it's in my testing branch, you will receive mail soon

--=20
balbi

--Uwl7UQhJk99r8jnw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRQEONAAoJEIaOsuA1yqREO1AP/iWzK04jsNRlofrqJno/gU8t
mMZoFPyus/rmkI4z1PU/HHukkK1+Tc3tGuVDlfYQc3gJVAf6SP9c+q/PggzGTY/I
8a4Gg6SlDLPQsrVAFnGApJltreLKx2L73T2m5VNFXpLGF3UliEwRnpMXWPomcltJ
T0TvKKes1vhSQI1MzWplOQcFfZJzy4qapk7xq4Czg1k4+J/ZmEuvEUDmCPvWaqPI
7ly1jjvwJ3QwLkowtZmwg85UgZoYZT5vVp3WQ3cvdqiIKcR1GIBN5seeL2LdAwVd
OdMuZB9nvmXH2MzFmIak/TrRgVoYdy+BCQ4Ok8cOkafM6MBrCxr63n5WC+IttW64
avmyYgjIkqklayCLC50qDaDFsXa079YhBx1KECns0dCORQySrLlkaizA5jtk56kP
ILxS2hYeQX65nv3QIQW6QZLHLuNxX5aIU1CRBwPL/vJbeHZvSEEQkh4xO9PTYLw7
aBF+pmQHd3XPU9OlyY+zySb2+1TmRMkspAew3aTroYSXoIxoowrBdlcp7Ld+59ym
zycyodkj5o4YvL/cWn4ClH4XFLAiG9/ecNK5UPJ6+AMeZ3pZPK/1ieDSWcHGZslM
3T4d3zWPoTvtPM4xGyvo2vA/U2tiwTQr74SmSYtk+1hO8FwHa332VciVNu/JKHTf
9O9uOGcKT+32XWLIeRaX
=fDGj
-----END PGP SIGNATURE-----

--Uwl7UQhJk99r8jnw--
