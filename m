Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161117AbaJ3RsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:48:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56667 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760507AbaJ3RsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:48:06 -0400
Date: Thu, 30 Oct 2014 12:47:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <Peter.Chen@freescale.com>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v7 1/7] usb: move the OTG state from the USB PHY to the
 OTG structure
Message-ID: <20141030174734.GA6652@saruman>
Reply-To: <balbi@ti.com>
References: <1414514141-31767-1-git-send-email-antoine.tenart@free-electrons.com>
 <1414514141-31767-2-git-send-email-antoine.tenart@free-electrons.com>
 <20141030163148.GF10130@saruman>
 <20141030163513.GI10130@saruman>
 <20141030174254.GA6764@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <20141030174254.GA6764@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 06:42:54PM +0100, Antoine Tenart wrote:
> Hi Felipe,
>=20
> On Thu, Oct 30, 2014 at 11:35:13AM -0500, Felipe Balbi wrote:
> > On Thu, Oct 30, 2014 at 11:31:48AM -0500, Felipe Balbi wrote:
> > > On Tue, Oct 28, 2014 at 05:35:35PM +0100, Antoine Tenart wrote:
> > > > Before using the PHY framework instead of the USB PHY one, we need =
to
> > > > move the OTG state into another place, since it won't be available =
when
> > > > USB PHY isn't used. This patch moves the OTG state into the OTG
> > > > structure, and makes all the needed modifications in the drivers
> > > > using the OTG state.
> > > >=20
> > > > Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> > > > Acked-by: Peter Chen <peter.chen@freescale.com>
> > >=20
> > > Acked-by: Felipe Balbi <balbi@ti.com>
> >=20
> > Please rebase on my testing/next and I'll take the series. When
> > rebasing, then add Peter's Tested-by/Acked-by where they're missing.
>=20
> I just re-sent the series, rebased on your testing/next branch.

Thanks, I put them on my testing/next and I'm running build tests.

--=20
balbi

--vtzGhvizbBRQ85DL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUnm2AAoJEIaOsuA1yqREv2QP/jFfBv4RUhLAxEF2oGpOsBAU
jXAbO0L3jkxANVumYiJpupShLxD6tnd0HAar5cEDVKpxyBS7TDtgj8EJsq4TfLGx
wporp9b7BdWSr7XFwH2AaL4tsrNpmTJ6ddvOdWbbKVuUTmXn2BgBwJU4fKVYrtuc
Nilrcc8Ecn3ohh2d6u3r6FdL/4ROsHxCUEzG3qa2kElGRuU1Ha/E2SIsyXOJ/kk3
Pac9H80ssgVWXMHvKOrMZbNk5gW4r1CKaro+hO3zGYtFUNDbI1GaFN2qpY1OxZi7
bKCqmwSImfMqg+eosx0s80LXToWc+hPDeMa/d+f3jmu3wOfAa+ZydeJ0HhXm13/B
ItdRYHOIN1LPoZdIJfrjzM1Ra5b7WIDl93PsADStrG4zHS//18Q397dyx2hw+MZ+
6L+rG2msE7LOm9k5uDQntflN4J29b9YXDrf19yd6GPsXiCu12e7mdJAzxyQwAOk/
8xO302I6KYMFBq83d1YaWU3soihSEB/RqGVnce5WlREftMRrkhKnFXAzEyrnua3X
jJrUcIWWXjn9jICqjioM8ITl/N1lKaZdFTrUgWteUCtlFZpOpS1+7tV7BwajMUXy
tHK/YjdPWTQCZzazcWUKt/c9Jub08iWUjuOQ6yGdI3y+DAJwIgiIkLzeXOUei7f5
pcNTbtyETVMVoH/HU6PW
=K0SU
-----END PGP SIGNATURE-----

--vtzGhvizbBRQ85DL--
