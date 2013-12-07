Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758153Ab3LGKUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 05:20:15 -0500
Received: from top.free-electrons.com ([176.31.233.9]:57163 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754119Ab3LGKUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 05:20:11 -0500
Date: Sat, 7 Dec 2013 11:15:10 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>, netdev@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: Re: [PATCH 10/10] ARM: dts: sun7i: Add ethernet alias for GMAC
Message-ID: <20131207101510.GJ24519@lukather>
References: <1386350983-13281-1-git-send-email-wens@csie.org>
 <1386350983-13281-11-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibvzjYYg+QDzMCy1"
Content-Disposition: inline
In-Reply-To: <1386350983-13281-11-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibvzjYYg+QDzMCy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chen-Yu,

On Sat, Dec 07, 2013 at 01:29:43AM +0800, Chen-Yu Tsai wrote:
> U-Boot will insert MAC address into the device tree image.
> It looks up ethernet[0-5] aliases to find the ethernet nodes.
> Alias GMAC as ethernet0, as it is the only ethernet controller used.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 64b1391..f7c57c6 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -16,6 +16,10 @@
>  / {
>  	interrupt-parent =3D <&gic>;
> =20
> +	aliases {
> +		ethernet0 =3D &gmac;
> +	};
> +

Actually, it conflicts with
http://lists.infradead.org/pipermail/linux-arm-kernel/2013-November/211695.=
html

Please rebase accordingly.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ibvzjYYg+QDzMCy1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSovUuAAoJEBx+YmzsjxAgvMIQAIBr6N5CEE/hLLvaOCmGRG1f
WV2nQRBAK/Dh0wHLoUnp3S56Y+mysG1dRfpcnKKP0o2ifWJAMsRxQ0TdFvSJBd0Y
qB5HE+s4tVolm84p1gixEp2JTGed32PbnFTxrXK5EE2ZeAYPx/p87Pqq6pook4o8
X1spQwB6HxMKKGEo3sTYjnnfvHfwqSHClhc4hAcmlmrXAiyPCPM2WmiU+RL3Bymf
y2PCh0JELtgL5HtWZX00XXUW/youAXvwHEWEGgQpB1qm3kztCtifQFztmoPwKyUd
D6SvcsG40yodT9l8PYz8bBl8CJ3ytr/YoqwbdfSfMTB+KTECCntVoFY2fgCPlrEq
q4e8RSxCW/jeg1WcnT7bVuIBBBO9n/MsZ4JeXlXdd8gqEXtV+YUUq3RKSuTfw1DQ
uKYc3Ogu73jkcQnSWG8ptwiKeC2tBVlf5g/9g9G46jpzJBuhexc387/446EkEQxQ
lYxR49c/H21rtOxC/ylJr4BNbDDf4ZNXyt3u7nhEf9JvcEiwT8fgF6MCNadPNF3Z
TBdEkeetniferveBKdgkLtX1Bi3aQ4ueBrm0hvtnN7Eqj3pVowhYqmwZN9zDSVSd
y+LlJWdjjkw7uiEvXS64z4YYRPNFM8IgnFixJysDg439x43blwv4jOP8W7b8eWfh
FzXsolQI1HwltrjOQD7U
=oxlm
-----END PGP SIGNATURE-----

--ibvzjYYg+QDzMCy1--
