Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3F2HNg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:13:36 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35066 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab3F2HNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:13:35 -0400
Date: Sat, 29 Jun 2013 09:13:33 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 2/8] ARM: mxs: dt: Add Crystalfontz CFA-10056 device
 tree
Message-ID: <20130629071333.GH2593@lukather>
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372424577-8279-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Gk0KcsbyUMelFU1"
Content-Disposition: inline
In-Reply-To: <1372424577-8279-3-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Gk0KcsbyUMelFU1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 03:02:51PM +0200, Alexandre Belloni wrote:
> From: Brian Lilly <brian@crystalfontz.com>
>=20
> The CFA-10056 is a breakout board for the CFA-10036, and is
> basically a CFA-10037, with a 4.3" screen.
>=20
> Signed-off-by: Brian Lilly <brian@crystalfontz.com>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
>  arch/arm/boot/dts/Makefile           |   1 +
>  arch/arm/boot/dts/imx28-cfa10056.dts | 120 +++++++++++++++++++++++++++++=
++++++
>  2 files changed, 121 insertions(+)
>  create mode 100644 arch/arm/boot/dts/imx28-cfa10056.dts
>=20
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 641b3c9..da75139 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -143,6 +143,7 @@ dtb-$(CONFIG_ARCH_MXS) +=3D imx23-evk.dtb \
>  	imx28-cfa10037.dtb \
>  	imx28-cfa10049.dtb \
>  	imx28-cfa10055.dtb \
> +	imx28-cfa10056.dtb \
>  	imx28-cfa10057.dtb \
>  	imx28-evk.dtb \
>  	imx28-m28evk.dtb \
> diff --git a/arch/arm/boot/dts/imx28-cfa10056.dts b/arch/arm/boot/dts/imx=
28-cfa10056.dts
> new file mode 100644
> index 0000000..0f66c40
> --- /dev/null
> +++ b/arch/arm/boot/dts/imx28-cfa10056.dts
> @@ -0,0 +1,120 @@
> +/*
> + * Copyright 2013 Free Electrons
> + *
> + * The code contained herein is licensed under the GNU General Public
> + * License. You may obtain a copy of the GNU General Public License
> + * Version 2 or later at the following locations:
> + *
> + * http://www.opensource.org/licenses/gpl-license.html
> + * http://www.gnu.org/copyleft/gpl.html
> + */
> +
> +/*
> + * The CFA-10056 is an expansion board for the CFA-10036 module, thus we
> + * need to include the CFA-10036 DTS.
> + */
> +/include/ "imx28-cfa10037.dts"

The comment is wrong here. You say that you need to include the 10036
DTS, while you actually include the 10037 one.

> +
> +/ {
> +	model =3D "Crystalfontz CFA-10056 Board";
> +	compatible =3D "crystalfontz,cfa10056", "crystalfontz,cfa10036", "fsl,i=
mx28";

Adding the cfa10037 compatible here would probably make sense as well.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--/Gk0KcsbyUMelFU1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzokdAAoJEBx+YmzsjxAggA0QALOQ50Sxkb7A+xQybgmvA2kZ
VASKHzcdV78BvruOnbrA6osqccPURtO6PiZ35SshdK5nDzsLuDfEdeOM3GsnK9/Q
1aPQlCZGvl8ht9K816haML1rrMkMC+PMwhg+n/BvJ4GJYIE2Tfe3GZocOWzfz963
5SqZDeXxxyrbPc4M4UNgXZmbSJ57ONRL4Ixre5ugnCtMdTRfBrv/D9gvmZs9VY2T
bdLH3IXjBo7BAyq4W6FybcEFObuRbCA/5T5o6hfXPGDYgdAwqiKireyfeLBKGRUt
wIMTsL1aMJ2i9ubrw5T4sqBjsQow/nNr10xzTnqUtX/EqkY7x3aeGXa97P85MRo9
5xdtSrcFbdospyAA8ZvxwciWN19pjobUujfJUcur3YOK48+7KcZBRPn+j2vkK4XT
gYFCnHSlbMMEiBXtE/SCWLE9lRi/+39sDDxS4K36KrJuOV+PaqucZ/4cEQTzEKYN
cWAz0nBpkDDDwXVQFmzb/mlmBMnjr8OS5xvTfvB1nqd28GUK9C+zrIXWkYC3BYyg
WyLMZR5hZ8+fp+Gbn6ppIyWuoIS3wx+5C5m7P/e1Wz5n/l2+nG1D/aMeb0hNRCqM
IkOFPIcZP/guvwK8T1DxNKW3vbXryObb5o8l3LCvFZ2dzv63/RuDzg8AtaemN2/O
6xKGGSHYUum1GHsUrQEe
=SLlX
-----END PGP SIGNATURE-----

--/Gk0KcsbyUMelFU1--
