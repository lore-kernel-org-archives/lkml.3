Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371AbaCFQC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:02:58 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:48572 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbaCFQC4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:02:56 -0500
Date: Thu, 6 Mar 2014 10:00:58 -0600
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <kishon@ti.com>, <tony@atomide.com>, <balbi@ti.com>,
        <george.cherian@ti.com>, <balajitk@ti.com>, <hdegoede@redhat.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-ide@vger.kernel.org>
Subject: Re: [PATCH v2 03/13] phy: omap-control: update dra7 and am437 usb2
 bindings
Message-ID: <20140306160058.GF25648@saruman.home>
Reply-To: <balbi@ti.com>
References: <1394116729-28811-1-git-send-email-rogerq@ti.com>
 <1394116729-28811-4-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gneEPciiIl/aKvOT"
Content-Disposition: inline
In-Reply-To: <1394116729-28811-4-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--gneEPciiIl/aKvOT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 06, 2014 at 04:38:39PM +0200, Roger Quadros wrote:
> The dra7-usb2 and am437-usb2 bindings have not yet been used.
> Change them to be more elegant.
>=20
> Signed-off-by: Roger Quadros <rogerq@ti.com>
> ---
>  Documentation/devicetree/bindings/phy/ti-phy.txt | 4 ++--
>  drivers/phy/phy-omap-control.c                   | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/Documentation/devicetree/bindings/phy/ti-phy.txt b/Documenta=
tion/devicetree/bindings/phy/ti-phy.txt
> index 5c5b1b0..28e674b 100644
> --- a/Documentation/devicetree/bindings/phy/ti-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/ti-phy.txt
> @@ -9,9 +9,9 @@ Required properties:
>                          e.g. USB2_PHY on OMAP5.
>   "ti,control-phy-pipe3" - if it has DPLL and individual Rx & Tx power co=
ntrol
>                          e.g. USB3 PHY and SATA PHY on OMAP5.
> - "ti,control-phy-dra7usb2" - if it has power down register like USB2 PHY=
 on
> + "ti,control-phy-dra7-usb2" - if it has power down register like USB2 PH=
Y on
>                          DRA7 platform.
> - "ti,control-phy-am437usb2" - if it has power down register like USB2 PH=
Y on
> + "ti,control-phy-am437-usb2" - if it has power down register like USB2 P=
HY on
>                          AM437 platform.
>   - reg : Address and length of the register set for the device. It conta=
ins
>     the address of "otghs_control" for control-phy-otghs or "power" regis=
ter

I can take the Documentation part (which I've just done) but...

> diff --git a/drivers/phy/phy-omap-control.c b/drivers/phy/phy-omap-contro=
l.c
> index 17fc200..a7e2d7f 100644
> --- a/drivers/phy/phy-omap-control.c
> +++ b/drivers/phy/phy-omap-control.c
> @@ -228,11 +228,11 @@ static const struct of_device_id omap_control_phy_i=
d_table[] =3D {
>  		.data =3D &pipe3_data,
>  	},
>  	{
> -		.compatible =3D "ti,control-phy-dra7usb2",
> +		.compatible =3D "ti,control-phy-dra7-usb2",
>  		.data =3D &dra7usb2_data,
>  	},
>  	{
> -		.compatible =3D "ti,control-phy-am437usb2",
> +		.compatible =3D "ti,control-phy-am437-usb2",
>  		.data =3D &am437usb2_data,
>  	},
>  	{},

I don't have this file in my tree ;-)

--=20
balbi

--gneEPciiIl/aKvOT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTGJu6AAoJEIaOsuA1yqREJHsQAIdE6lepQy3cPj9YxxRzLHb+
e21dBEuVFMspabt0VWWvb0bSdQqHUAa1VpPNAXlun/ybgauo0VnXDoxCFI3GM2nc
0kwhgGflXwMO3mgklh+W/OeAGrNEsRTTTPecuPhST8OsYRgARODpODljKvx+YumF
rB0vh5t0XlOBwzb6Wl0blyMb78W6fkFr0VsFTlh3pVxitnkf+YIB1xWAaoVb4bT9
qs4S26rtiEW3r+0gltYtsKiZOUIRmApIOW/N+7cobJMWhKwdlWHCqaCZ4bgM0ukc
5dhfNTovDSB1Upkw/2zDFvQ/I0tcOYAD8mGEt0WFB+FpQA7oU/rEWju0rd8Fq9uZ
mCdrwrG8zAM0YV74EEHPTy2pNSz22a2JRkCMetF+GJ5Xz74TVbEvU4brska5KNys
WKv8JSCP75vlzqxXwW/60mF/nVp5Oq06W7eV6OP5g5KEuPPCdgf1N02d0MCPlHtA
HynhtZ/j5FvReUvqbEb415nsjdDcpAwX87hOJmry5T3118Gnrh1ISNyeBsir1UHx
21o6L8T95WB3zMtEydLsV2Fa+ZUQS0NP4CurQMwTY19Xr/6aCUPI2ghgQfMYmQIA
B9q/1Z2Sc3+pxkAcw1KISiBMeI1mFOzLxz6SoidQdLAdRqHbMoI7GR39/h32XVNp
S/LVx2EpnlUfItTx+vQ5
=a5A3
-----END PGP SIGNATURE-----

--gneEPciiIl/aKvOT--
