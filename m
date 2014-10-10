Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbaJJSKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:10:11 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38735 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaJJSKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:10:09 -0400
Date: Fri, 10 Oct 2014 13:08:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Johan Hovold <johan@kernel.org>
CC: Alessandro Zummo <a.zummo@towertech.it>, Tony Lindgren <tony@atomide.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Andrew Morton <akpm@linux-foundation.org>, Felipe Balbi <balbi@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, Guenter Roeck <linux@roeck-us.net>,
        Colin Foe-Parker <colin.foeparker@logicpd.com>, <nsekhar@ti.com>,
        <t-kristo@ti.com>, <j-keerthy@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 11/12] ARM: dts: am33xx: update rtc node compatible
 property
Message-ID: <20141010180849.GY31348@saruman>
Reply-To: <balbi@ti.com>
References: <1412881594-25678-1-git-send-email-johan@kernel.org>
 <1412881594-25678-12-git-send-email-johan@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0rEjiS+nMGFQ7Kkj"
Content-Disposition: inline
In-Reply-To: <1412881594-25678-12-git-send-email-johan@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0rEjiS+nMGFQ7Kkj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 09, 2014 at 09:06:33PM +0200, Johan Hovold wrote:
> Enable am33xx specific RTC features (e.g. PMIC control) by adding
> "ti,am3352-rtc" to the compatible property of the rtc node.
>=20
> Signed-off-by: Johan Hovold <johan@kernel.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/boot/dts/am33xx.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index 3a0a161342ba..098e53602d5c 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -411,7 +411,7 @@
>  		};
> =20
>  		rtc: rtc@44e3e000 {
> -			compatible =3D "ti,da830-rtc";
> +			compatible =3D "ti,am3352-rtc", "ti,da830-rtc";
>  			reg =3D <0x44e3e000 0x1000>;
>  			interrupts =3D <75
>  				      76>;
> --=20
> 2.0.4
>=20

--=20
balbi

--0rEjiS+nMGFQ7Kkj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUOCCxAAoJEIaOsuA1yqREKIQP/1hlg2cIWRHlDxYhSvG+0lSd
eK2Gl+PwZNahLVM2AUKuPbwqkFfFphl/EbNy0C8DjUTT4ccatmyS1m0xOq3+ucli
OrZPdLslnEkz6SV08GfYfbyRHdQUdhAKhxdXm5/+xYYtU2TvTEOcZQHYMYxSuTfQ
OThGr7v9NwO9WqvhImtlAqqF9QU9dMC6athhMb6SsS1CKxxEek4yHityiIl4iedN
KKqTNuFTaRT+wDq3G7TkB14ZLKLqV4YUKF0VdXzx/p2JoZizY5ie8JTSBUKI8U0h
PFpQzfLWX9B3GikqMrU3j2QiRFfs3p5pPhukaY43Ovhv8xco/Ep5Mp6sz3a/B5iX
XZT0IayyAj/TTI3epxcwMyw86xI/y7GTXllrTcGqSCS4vR4sWoU9pSwrKmE2dIXO
5y2eQGkydglZm5Yy7a4vXYTUXVpsrxMHRjKD4oyzCBvppWjr74s8pYiSYaCkknyG
9sYkwIySoTbmMEv7Y3PFVJvOe9U1kIUzHfLy8cF8l1WEF0XBeyOW1h5n+oXugOnd
dl/5esgr+CKRBLyo/WLOrO4iNQ4dR6/5Un8lFJFmcDq+GsXkMJjBp3fffbHJNXTp
C2fINuabfS4YLgxpzgSRE2d62MdGbN4sjweHLCIV2e/AwZaPyq2wRmRy1EQgI/NF
QOiXwCQ2cPXbvP0GbwLL
=/b2k
-----END PGP SIGNATURE-----

--0rEjiS+nMGFQ7Kkj--
