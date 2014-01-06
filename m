Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAFH3w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 02:29:52 -0500
Received: from ozlabs.org ([203.10.76.45]:41647 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaAFH3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 02:29:51 -0500
Date: Mon, 6 Jan 2014 18:29:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <dongas86@gmail.com>, Chris Ball <cjb@laptop.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-Id: <20140106182939.32468378e51c5ab1b45e90bd@canb.auug.org.au>
In-Reply-To: <20140106064406.GD26128@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
	<CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
	<20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
	<20140106064406.GD26128@S2101-09.ap.freescale.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__6_Jan_2014_18_29_39_+1100_4wB..y9ZMx0RyWTi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jan_2014_18_29_39_+1100_4wB..y9ZMx0RyWTi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Mon, 6 Jan 2014 14:44:08 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> Okay, I missed your point.  The resolution needs the additional changes
> as below.
>=20
> Shawn
>=20
> diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> index 91e5dd4..8b05648 100644
> --- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> +++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
> @@ -356,6 +356,10 @@
>                 pinctrl_usdhc3: usdhc3grp {
>                         fsl,pins =3D <MX6QDL_USDHC3_PINGRP_D8>;
>                 };
> +
> +               pinctrl_usdhc4: usdhc4grp {
> +                       fsl,pins =3D <MX6QDL_USDHC4_PINGRP_D8>;
> +               };
>         };
>  };

Thanks, I will add this as a merge resolution patch tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__6_Jan_2014_18_29_39_+1100_4wB..y9ZMx0RyWTi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSyltnAAoJEMDTa8Ir7ZwVR+sQAImsIedAAVBCuzgYaIwSAPd2
DGNOMC+x6BEPJW8I5PlhNWhd+ssVwp6DCBc+PflaZ8nA+q0ak5cNoA8l+3BEalMz
tWjg9oR1dr+/kqjpIOQWAQrEy9pxxoVeJSpWWKGVIVFrcXq+uy5TxS6f9P6QRwwD
f96+Wz+BUyr2GelThfdMoFki0MyYJYoeCMF6LYxxMpfEzhblTeziWE7X17rzG7RA
SWtjacwwBbVNzc2P6IQTnA1KcWoP4fHG+/gO2MIXFTLUl8kq9gFabofpSVvRoxgf
2XhEbZs5/PlyQRjQHHH8W89lqUdKeDv2wpAbEIxhBSuzIWj3FGU3P2t1J52+gzru
2QYRim8FX9Nn6fk7L6zRlxGuSPtLVlgrqhzA8lZeEapO6aqyJ8JOs36XBXqPeirw
LQT5IC+n84W4E/LVYtMMx0I7UDxl2qv2KINROglOGktQ51TyUJQ6M5pDs1xpfeqK
3BJh4uDGMihS6rpWx/HOeojWLe9q872nacYBTYpKYa+fXClA4OZRmm0V3D3eOMKT
rTe1QyukJyeSd1PIMsmLaaUsJPr62hCkGtcRviD9gJYAk4ZJhRlqYDCnoQnf4A67
5RVFzKmg1Q1EwA8QFOtcaR5+5HwyE6OJcDI4dfz4KtsFO+dFGX2uvfyBwfzQQdmR
+lJweFf2GXw1gmT2lB9B
=EeWA
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jan_2014_18_29_39_+1100_4wB..y9ZMx0RyWTi--
