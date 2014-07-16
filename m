Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965265AbaGPPCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:02:43 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55219 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591AbaGPPCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:02:40 -0400
Date: Wed, 16 Jul 2014 10:02:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
CC: Felipe Balbi <balbi@ti.com>, <gregkh@linuxfoundation.org>,
        <Peter.Chen@freescale.com>, <kishon@ti.com>,
        <stern@rowland.harvard.edu>, <alexandre.belloni@free-electrons.com>,
        <thomas.petazzoni@free-electrons.com>, <zmxu@marvell.com>,
        <jszhang@marvell.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: move the OTG state from the USB PHY to the OTG
 structure
Message-ID: <20140716150205.GD1365@saruman.home>
Reply-To: <balbi@ti.com>
References: <1404901036-27682-1-git-send-email-antoine.tenart@free-electrons.com>
 <1404901036-27682-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140710134023.GJ15340@saruman.home>
 <20140710134758.GA32462@kwain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NtwzykIc2mflq5ck"
Content-Disposition: inline
In-Reply-To: <20140710134758.GA32462@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--NtwzykIc2mflq5ck
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 10, 2014 at 03:47:58PM +0200, Antoine T=E9nart wrote:
> Hi Felipe,
>=20
> On Thu, Jul 10, 2014 at 08:40:23AM -0500, Felipe Balbi wrote:
> > On Wed, Jul 09, 2014 at 12:17:13PM +0200, Antoine T=E9nart wrote:
> > > Before using the PHY framework instead of the USB PHY one, we need to
> > > move the OTG state into another place, since it won't be available wh=
en
> > > USB PHY isn't used. This patch moves the OTG state into the OTG
> > > structure, and makes all the needed modifications in the drivers
> > > using the OTG state.
> > >=20
> > > Signed-off-by: Antoine T=E9nart <antoine.tenart@free-electrons.com>
> >=20
> > This looks good to me. I'm interested in what will be the best way to
> > merge this series :-)
>=20
> I was asking myself the same question :) If splits or squashes are needed
> please ask. At least, I'll split the s/phy/usb_phy/ and the generic PHY
> addition in two patches as Alan asked.

if I get enough Acks, i'll queue it myself, I guess it's best that way.

--=20
balbi

--NtwzykIc2mflq5ck
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTxpPtAAoJEIaOsuA1yqREO/4P/RJgb0k8TmbdJw0Jil/4S397
N3Ye2jjQ2uEBe5EWZSqzNBVLnhnRbneEER/ytOVpj+urIYyWhbJ4uKH3ImPUa5zH
II+9gPUpusYKp6kOQisJLYb5AjJVw5JFYaJSDdnOYdApffSgvjmve+t64RRebT8n
dvxgUTOqI52l1zsuTI9S0iNuKF3YRZP7PIC4iNcKzjLrobf5l6vMSkK06x1ww0f3
oC5yjeuXB7M83OwagfxvRzCGwwDVMkQ9dD5KZC0RObTh8TVOL4jgmtT7J8Npv6I4
uFVtjLhfKiJ9ijREAOfhPtKw6hzb60f8BE36pMraUCXF2VRNhpq6CdBbipvHDCPu
I31XKOWCizENWzYgMuHnSrcodVTcjr9dWzxlXU7j/nzDNxdCf+45Y0s247FF4jyv
OYyIjU7M6GA5JBN49oxOlR5hlm9GLCX972VWLgN1qJpSqdX9WnJJZSaDRUiXfFiD
d3KyJ1rFTBD7V33S0tIcKHW/RIntgl6tV+S9lewXPppYFPlh7KILeKE7vn9Yjict
3/jKrvEElTfeH+KrfByFy8M5/SGZcBZpVKYZUJzbtgiKsNtfz8H+R29yc7V/Ph0l
6uy+CTEHw2g5CoQlw+KAR1p8aXWAil/ElsgjrFPTbV3ZKW8dIYzvHf0rxvYNPoaD
NrrOEq0w37O4to7fYqla
=PgFL
-----END PGP SIGNATURE-----

--NtwzykIc2mflq5ck--
