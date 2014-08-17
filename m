Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaHQIFN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 04:05:13 -0400
Received: from top.free-electrons.com ([176.31.233.9]:47534 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751028AbaHQIFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 04:05:05 -0400
Date: Sun, 17 Aug 2014 10:02:04 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/12] ARM: dts: sun8i: Add i2c controller nodes
Message-ID: <20140817080204.GY15297@lukather>
References: <1408247538-16950-1-git-send-email-wens@csie.org>
 <1408247538-16950-12-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2MC+DK0smzICZJ/6"
Content-Disposition: inline
In-Reply-To: <1408247538-16950-12-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2MC+DK0smzICZJ/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Aug 17, 2014 at 11:52:17AM +0800, Chen-Yu Tsai wrote:
> Add nodes for the 3 i2c controllers found on A23 SoCs to the sun8i DTSI.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun8i-a23.dtsi | 36 ++++++++++++++++++++++++++++++++++=
++
>  1 file changed, 36 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun8i-a23.dtsi b/arch/arm/boot/dts/sun8i-a=
23.dtsi
> index 4658998..53ef350 100644
> --- a/arch/arm/boot/dts/sun8i-a23.dtsi
> +++ b/arch/arm/boot/dts/sun8i-a23.dtsi
> @@ -387,6 +387,42 @@
>  			status =3D "disabled";
>  		};
> =20
> +		i2c0: i2c@01c2ac00 {
> +			compatible =3D "allwinner,sun6i-a31-i2c";
> +			reg =3D <0x01c2ac00 0x400>;
> +			interrupts =3D <0 6 4>;
> +			clocks =3D <&apb2_gates 0>;
> +			clock-frequency =3D <100000>;

It's the default, you don't need to set it.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--2MC+DK0smzICZJ/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT8GF8AAoJEBx+YmzsjxAgeksP/A1kpP1zaH3PbRXdXumA4GCx
z+iqpzd5TgAMFZ7Ud9JqzFjkjqc3AgAt/a6ZDavV8ImOwr0if3rDy3enkVB6IWqh
A2YO39vJU2QondqZ2APoFyUQqhUPQudEn3OyDdowNj2DOmCPGlFjh+mBIchWaRDe
YqBNBQRqtqcHw4lfj8jK3vvBWG4Y1QuitLaumfIEy9I/+MhusSyGwWVuDXX/N3H3
TG1Cx0k6Ls1rrZ74O9hV1ddmuX27HtcJt2yftbDem8yGDGZommfYgEfFu4uahrzU
GQFYgDNpBYugt0UbKj/p+vM3RL1PdLXJeU56RUo0uZq3FZl1jjcoNa4shar0eW+N
3V4tRCXFocj18Rc5LLQkUtPfm+tbIdL0MdckNMeYq4yEy5GkH5EXPL3CBsnbrl5x
O8ilsEB32jpPDbz0LS4iUS4nuK4w26rScqOp42+FE3zWTTTDqu1CkwscXURnvkAv
LsLE6TMdCvDZWE6XWdSSGJbldmcfp3KZk7h3LhS1yGxpJoAizunbKtlLBgi7sLTA
Eo6hL4c0OfWQUigl1DmteMg1b/Gvyb62vfNZHfIlruP57TFDgV5cn5zWQTv74CCa
i1RmQFCJZ4Iymy3ibAEC1DOt/6Irh/k+Gd6NWmeXQBlEkvfJaE+HjNVXGtJroHJ/
Ygg6pfQyTHFGw/ZcQF1w
=lqSa
-----END PGP SIGNATURE-----

--2MC+DK0smzICZJ/6--
