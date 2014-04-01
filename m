Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751865AbaDAOPQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:15:16 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38196 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbaDAOPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:15:11 -0400
Date: Tue, 1 Apr 2014 09:13:08 -0500
From: Felipe Balbi <balbi@ti.com>
To: Roger Quadros <rogerq@ti.com>
CC: <tony@atomide.com>, <kishon@ti.com>, <balbi@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/1] ARM: dts: omap5: Add clocks to USB3 PHY node
Message-ID: <20140401141308.GB4717@saruman.home>
Reply-To: <balbi@ti.com>
References: <1396348647-11545-1-git-send-email-rogerq@ti.com>
 <1396348647-11545-2-git-send-email-rogerq@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VrqPEDrXMn8OVzN4"
Content-Disposition: inline
In-Reply-To: <1396348647-11545-2-git-send-email-rogerq@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VrqPEDrXMn8OVzN4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 01:37:27PM +0300, Roger Quadros wrote:
> The USB3 PHY driver (ti-pipe3) was updated so that the relevant
> clock phandles are expected in the DT node.
> Provide the necessary clocks.
>=20
> Reported-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Roger Quadros <rogerq@ti.com>

Great!!!

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/omap5.dtsi | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index 757f0b9..4df1e7a 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -794,6 +794,12 @@
>  				      <0x4a084c00 0x40>;
>  				reg-names =3D "phy_rx", "phy_tx", "pll_ctrl";
>  				ctrl-module =3D <&omap_control_usb3phy>;
> +				clocks =3D <&usb_phy_cm_clk32k>,
> +					 <&sys_clkin>,
> +					 <&usb_otg_ss_refclk960m>;
> +				clock-names =3D	"wkupclk",
> +						"sysclk",
> +						"refclk";
>  				#phy-cells =3D <0>;
>  			};
>  		};
> --=20
> 1.8.3.2
>=20

--=20
balbi

--VrqPEDrXMn8OVzN4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTOsl0AAoJEIaOsuA1yqREmMEP/RI8II5WwMI1H4LkOnOUQn8E
2tzg+sL7bGa/IV7GLkyEb6zDAZTzUDsscKNoqu4jfeCAT0Kqs2HOuTXmjIxqTQXU
L9xoINA0bFuD6lHJpy6fPqM/oKsKMdLkRetcojGD2sCt251TG3Kfjs5czqRtdv6D
JbEmRpHbocLbNgBJLm0EIXto6IP9MkFugaA6hDDL5H2X0Hoir/ZkqauoYYHiniwL
KUsf/nDsZ6kSUIMiQsCH8uV7VZWaAAp85aTfJWcjMQ0RyXLw/gK8lTsncQ+th2aJ
4VN5JZrqVkFgACzJVlwDYkVivWWRd71PUXYyYsyLeV6XINzEr23GEXENwykQd7aM
anJjmbylXYoOqLPEmgAKAm/Ph/iUS+iRfKcEZV9LOj1Jjs3TRwycpedrB3gI7nrr
eePp1yBb/rS6AaXkgJYS0SzZ+oHATCFtRsyvweezlp8f6ZIcx+ZAyDX89cSN9/0n
kKJ0cfyYE6ras1eS59CUZHghaJwfXZeAtiWnMvW79DorK/II9hAy0zj1SXE/WIu8
rSpT9/hDtuWIhO0VDmPsCDo8Eomu42MbDrcXmPsdRUc1weLSb8UWJ5AT7+gkeVpj
ShZvxqF6r3bPJl+DduSn1Sy4eOosn3tzSvfKzD08kBJi9hdCIlHOrYJMybgbMsWy
OKN4rMClzn1kOtjLmaLB
=rdv8
-----END PGP SIGNATURE-----

--VrqPEDrXMn8OVzN4--
