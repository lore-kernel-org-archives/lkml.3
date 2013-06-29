Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab3F2HFf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:05:35 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35005 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2HFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:05:30 -0400
Date: Sat, 29 Jun 2013 09:05:29 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 5/8] ARM: mxs: dt: cfa10037: make hogpins grabbed by
 respective drivers
Message-ID: <20130629070529.GD2593@lukather>
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372424577-8279-6-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KdquIMZPjGJQvRdI"
Content-Disposition: inline
In-Reply-To: <1372424577-8279-6-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KdquIMZPjGJQvRdI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexandre

On Fri, Jun 28, 2013 at 03:02:54PM +0200, Alexandre Belloni wrote:
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
With one minor comment, that applies to your other patches as well.

> ---
>  arch/arm/boot/dts/imx28-cfa10037.dts | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/imx28-cfa10037.dts b/arch/arm/boot/dts/imx=
28-cfa10037.dts
> index c2ef3a3..182b99f 100644
> --- a/arch/arm/boot/dts/imx28-cfa10037.dts
> +++ b/arch/arm/boot/dts/imx28-cfa10037.dts
> @@ -22,13 +22,19 @@
>  	apb@80000000 {
>  		apbh@80000000 {
>  			pinctrl@80018000 {
> -				pinctrl-names =3D "default", "default";
> -				pinctrl-1 =3D <&hog_pins_cfa10037>;

The pinctrl-name property isn't relevant since the 10036 patch. You
should probably have ordered them the other way around: first the
breakout board, then the 10036.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--KdquIMZPjGJQvRdI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzoc5AAoJEBx+YmzsjxAgGD0QAIqhrZ0YssWTt2JCyvwOc3Nf
t4dl7HhRDqyV0e3T7Q/RfaRAwSEpsaB/ZcQ2n2gwygCgwbT/1w1nG9Iu085M9VLG
vVJDrhaWLw3AoPQA/0u1JVMO6mNhCD5Zqpdww5JTPov+HxgWHO4oKMIPYX+JyGPZ
LF3+XT5lrcGIOGBcm8OfrNnXljvmRzq/MEWQ1pSg47OuyDAFswuXU29wWoiBTblY
e+1FrKNpD9da2H9/dvsBLSPJ6Tro7US91z77nWYuCl5QiMek2jDahhOML1wb1oTu
niTdUAumGv/Ug4qil+KkQjEA08l+KZ5WzdNDKqrMIDCyBjkQDTtkCZxZwi2MecaU
buTaeCXT3rF5UuknSI8LMDW0gedlEuYXxCgHHez0DkpPBX0GJQicUO5PvPcd5deT
WuyaO7rN+/HSUTvg6R1qqYoktVLZ3AgKkkUcrz6aNPP+FTObhp2z4T06KB6OOxGf
BD10jrPIQVe748bya5mZZY6ikh1Av2A5FilhO68vq2QWJCMmGsBPnjx7fcbAbjAZ
3rtk09H9Ks0ZVMfc6+KcTHnemGm5kJMlmCq+Z4oTwCpMTsbVHniB6T6JxYYfYMoz
V+DeNOOnWVQ45f2iGZH9IbrtlJCkaV1Ptk0UFGOPFobXgi9l93gy1YbxwXh7zWmy
Ebw8FOLVdiqUPtBcI8rX
=UoM7
-----END PGP SIGNATURE-----

--KdquIMZPjGJQvRdI--
