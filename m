Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab3CEOkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 09:40:05 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:54199 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab3CEOkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 09:40:00 -0500
Date: Tue, 5 Mar 2013 16:39:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <grant.likely@secretlab.ca>, <rob.herring@calxeda.com>, <rob@landley.net>,
        <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <balbi@ti.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 8/8] ARM: dts: omap5: add dwc3 core dt data
Message-ID: <20130305143934.GB12123@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1362494223-14151-1-git-send-email-kishon@ti.com>
 <1362494223-14151-9-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <1362494223-14151-9-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Mar 05, 2013 at 08:07:03PM +0530, Kishon Vijay Abraham I wrote:
> Add dwc3 core dt data as a subnode to dwc3 omap glue data in omap5 dt
> data file. The information for the entered data node is available @
> Documentation/devicetree/bindings/usb/dwc3.txt
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  arch/arm/boot/dts/omap5.dtsi |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/omap5.dtsi b/arch/arm/boot/dts/omap5.dtsi
> index c4eb2ec..24dd69f 100644
> --- a/arch/arm/boot/dts/omap5.dtsi
> +++ b/arch/arm/boot/dts/omap5.dtsi
> @@ -514,6 +514,13 @@
>  			#size-cells =3D <1>;
>  			utmi-mode =3D <2>;
>  			ranges;
> +			dwc3@4a030000 {
> +				compatible =3D "synopsys,dwc3";
> +				reg =3D <0x4a030000 0x1000>;
> +				interrupts =3D <0 92 4>;
> +				usb-phy =3D <&usb2_phy>, <&usb3_phy>;
> +				tx-fifo-resize;

I think this should be merged with previous patch. Also, we need to
check whether tx-fifo-resize is needed with ES2 or not ;-)

--=20
balbi

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRNgOmAAoJEIaOsuA1yqREhvAP/1WxhkKskft5voUhBdSFBhXr
4TWmn8lziRHiye04Qee5xhNFf6aXfT7KQ376UM6H78ZGpPpAt1v8fqHqVje87ZM+
3Fi2Vi09dbggC/1MXhDlkEpjYaxe4mJPxbFQl9OFwkC3gkDyXhjuiUf+3P9zhnr3
6dth3yXemC1xcPtidwjwMOs2P+c23wZ5GrjV4vOJiHZ3+/ldKVa2SR52uLTV+H/4
FQspiqVS9cVTifL6UPGmRkkAobHPB9EA0lmluxn8ELobL9M2YoYyAztXNf3BcJ7M
LgpGm4Rd2Np572a9e5BgJN15WbGrALdJzfhAQugNxnq012yZSzgM2ng2qhf9aEWV
Cfudnx0sOdTYG4WSucxAxKDaaRU03+Fp6L+zrr55ixG2YcXDqFGsj20YY+W0C2Sf
FzykW+LGRijcjurCMt5MoeNS5nhHjkLYbuMYiwPEKi4BwakhbwL7CzIUZSevSrsI
MmAnQnMxaI2x7bwbyLuv/kDsa5FEPuvqPW4nW+ulTKKveeYlwXO2cHVPh462hVXd
32rVRQnxnZDVrbwwGHZHMVZgkXkXqYX4HaZZP28vbITY0MobYhSlCMDfwfJzHi06
dLF3RTEwckoZgTdLbrQYHVaOl9f2aZS7rExK1nLwqF5UrEkc/Gv14JOsN3N68x5o
e977oaSz9w0kn9uUuHAS
=Z+cH
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
