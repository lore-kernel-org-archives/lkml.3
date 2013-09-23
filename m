Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab3IWRD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:03:59 -0400
Received: from top.free-electrons.com ([176.31.233.9]:57374 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752540Ab3IWRD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:03:58 -0400
Date: Mon, 23 Sep 2013 20:03:55 +0300
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.co,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH V3: Add Smp support for Allwinner A20. 2/3] Add cpuconfig
 nodes in dts for smp configure.
Message-ID: <20130923170355.GP2779@lukather>
References: <1379852488-32147-1-git-send-email-cinifr@gmail.com>
 <1379852488-32147-3-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="l7GkBbkEatsaRqBf"
Content-Disposition: inline
In-Reply-To: <1379852488-32147-3-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--l7GkBbkEatsaRqBf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fan,

On Sun, Sep 22, 2013 at 08:21:27PM +0800, Fan Rong wrote:
> Signed-off-by: Fan Rong <cinifr@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 999ff45..f745e0b 100644
> --- a/arch/arm/boot/dts/sun7i-a20.dtsi
> +++ b/arch/arm/boot/dts/sun7i-a20.dtsi
> @@ -20,13 +20,13 @@
>  		#address-cells =3D <1>;
>  		#size-cells =3D <0>;
> =20
> -		cpu@0 {
> +		cpu0: cpu@0  {
>  			compatible =3D "arm,cortex-a7";
>  			device_type =3D "cpu";
>  			reg =3D <0>;
>  		};
> =20
> -		cpu@1 {
> +		cpu1: cpu@1 {

You still haven't replied on why you need these two changes.

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--l7GkBbkEatsaRqBf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQHR7AAoJEBx+YmzsjxAgzuUP/27W4ZjuHX944q54KxeDEK4I
ntq8auM+NfFzpq03cDr2URBg5T9w0VRoe3Ay/sElu0bo5LAUhAhJ01kmux6Jdb7a
MoKeqbWkj08ToYJydPbfw9BzJAh7JTFjgNDuzUTj3uJG1l6vTKsNBya7qp/dzHCl
WkDVTIsxLS0RXmIIOyb2WYvOq2T4XthBM/k9e3nICqSnpPpHHkY+clqP5/EwE1na
hKsReXxf6lIxRGLTXXY3oSs2c8E83/zHPh4CHm1B3YrgmoJ7GDIPNqR4dBKLG9rI
s6mnsMn/ceL2crRn39duB5TNhqkHOFVNBsjMmR8g6gdLpePUZB2E4cdLGxevA/An
nBbh/7J0+dqOzDBUj5mZuFF99oaWdN6hmhVfgrm4iFypXOrUoyIvnWIqplswNEBc
8LpCD0kSBBJe8CYy8lIBvQoZ0PCCqpQvgEbIrLCXNacodPzxCZTeEjdDb6XiyWRq
Wvzbvvw0t9+KnywRLPGBMTtagiwwzz5FqWSrHo5TSjTULpMWS/ysqdYKaROg9pTn
qHXrEVm7/QnZlsamXIYMo8tTEO3iLqqbDTzfSxnU86VIULjD90i2ySlCPCxekKb3
svMqZmOmxY0N4ghN8SGpULB9+FMRGOOjs4ctQYprneH8B3t9Kh4H36vUPd+q9b/i
lndhh9xkf3pt9yaOyU40
=BXqN
-----END PGP SIGNATURE-----

--l7GkBbkEatsaRqBf--
