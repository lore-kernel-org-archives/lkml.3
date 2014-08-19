Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaHSHW1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:22:27 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:64548 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbaHSHWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:22:25 -0400
Date: Tue, 19 Aug 2014 09:22:21 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Heiko Stuebner <heiko@sntech.de>, Caesar Wang <caesar.wang@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>, olof@lixom.net,
        Eddie Cai <eddie.cai@rock-chips.com>, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: dts: Enable pwm backlight on rk3288-EVB
Message-ID: <20140819072220.GE12859@ulmo>
References: <1408381749-14156-1-git-send-email-dianders@chromium.org>
 <1408381749-14156-5-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EXKGNeO8l0xGFBjy"
Content-Disposition: inline
In-Reply-To: <1408381749-14156-5-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EXKGNeO8l0xGFBjy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2014 at 10:09:09AM -0700, Doug Anderson wrote:
> The pwm0 is the PWM associated with the LCD backlight.  Enable it.

In the subject, s/pwm/PWM/.

>=20
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  arch/arm/boot/dts/rk3288-evb.dtsi | 53 +++++++++++++++++++++++++++++++++=
++++++
>  1 file changed, 53 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/rk3288-evb.dtsi b/arch/arm/boot/dts/rk3288=
-evb.dtsi
> index 2964370..242e1a9 100644
> --- a/arch/arm/boot/dts/rk3288-evb.dtsi
> +++ b/arch/arm/boot/dts/rk3288-evb.dtsi
> @@ -10,6 +10,7 @@
>   * GNU General Public License for more details.
>   */
> =20
> +#include <dt-bindings/pwm/pwm.h>
>  #include "rk3288.dtsi"
> =20
>  / {
> @@ -17,6 +18,48 @@
>  		reg =3D <0x0 0x80000000>;
>  	};
> =20
> +        backlight {

Indentation seems to be off here.

> +		compatible =3D "pwm-backlight";
> +		brightness-levels =3D <
> +			  0   1   2   3   4   5   6   7
> +			  8   9  10  11  12  13  14  15
> +			 16  17  18  19  20  21  22  23
> +			 24  25  26  27  28  29  30  31
> +			 32  33  34  35  36  37  38  39
> +			 40  41  42  43  44  45  46  47
> +			 48  49  50  51  52  53  54  55
> +			 56  57  58  59  60  61  62  63
> +			 64  65  66  67  68  69  70  71
> +			 72  73  74  75  76  77  78  79
> +			 80  81  82  83  84  85  86  87
> +			 88  89  90  91  92  93  94  95
> +			 96  97  98  99 100 101 102 103
> +			104 105 106 107 108 109 110 111
> +			112 113 114 115 116 117 118 119
> +			120 121 122 123 124 125 126 127
> +			128 129 130 131 132 133 134 135
> +			136 137 138 139 140 141 142 143
> +			144 145 146 147 148 149 150 151
> +			152 153 154 155 156 157 158 159
> +			160 161 162 163 164 165 166 167
> +			168 169 170 171 172 173 174 175
> +			176 177 178 179 180 181 182 183
> +			184 185 186 187 188 189 190 191
> +			192 193 194 195 196 197 198 199
> +			200 201 202 203 204 205 206 207
> +			208 209 210 211 212 213 214 215
> +			216 217 218 219 220 221 222 223
> +			224 225 226 227 228 229 230 231
> +			232 233 234 235 236 237 238 239
> +			240 241 242 243 244 245 246 247
> +			248 249 250 251 252 253 254 255>;
> +		default-brightness-level =3D <128>;
> +		enable-gpios =3D <&gpio7 2 GPIO_ACTIVE_HIGH>;
> +		pinctrl-names =3D "default";
> +		pinctrl-0 =3D <&bl_en>;
> +		pwms =3D <&pwm0 0 1000000 PWM_POLARITY_INVERTED>;
> +        };

And here.

Thierry

--EXKGNeO8l0xGFBjy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT8vssAAoJEN0jrNd/PrOhov4P/iRvUow7yTTU4K+H6PWihLGd
jeQLt5m11oFJJIZ1/e4rhIZEErfUSqxjF37tqXp9ro/NhNgd7LF7FuEowZguRLfP
UrnB/xcgpJ8zVHhzIVcjTzaaxvHDBPvZzMm7BMBQeh8f/Hmg9qnMpY5Z/yP/waAs
TjZ7Gj3uvjZozs9AX6QzLqYF56aUaoxSW8DdpFLTn0ceWQokOBsMBVw6U6emndH0
qb/wujfNYErE1beAsl96U39PAd5cH+QMItBU54saCMCFbQEiBoNU4jORv1SHTQSk
7ZxdlVB+eK4GS4cU8ZvDaIHt2dnhHN/K8BdLQjm0nNbKjEoMbe/V3P+ZjI8op2Zy
fCJIqZOWEenYT+bmFrTP33jzddr64msW4y/mqlamIgO9ngHs070MCVC3/rJbIkHw
RrH7pZ1p2Gw0Jp7MYQm+Ad6FqGEb7vL+KBclxznPaJ/arjSF2HgzlHSrIvSVxZry
kJXWdgA0mlMb26qc3OgXJutPFTJdsxF/kl9CIxMlWaqJJlD/aglrHz1JHPyd21zL
fY6gW34Io1kVnR19IoHKARCsm8+i/aucyAzLJOQP3Tb2PhfhUdVGddNtgzMcEoqg
p4/KuDMC6BzIc1WNH55ipmirIvCC8CWfdW/rLqIu6VQ4QjQHUDPwfhVp4Un1XTeQ
iI/4KJvsDs79WdDjg4p5
=VMuO
-----END PGP SIGNATURE-----

--EXKGNeO8l0xGFBjy--
