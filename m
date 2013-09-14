Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab3INLuQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 07:50:16 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50181 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751442Ab3INLuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 07:50:15 -0400
Date: Sat, 14 Sep 2013 13:50:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Fan Rong <cinifr@gmail.com>
Cc: coosty@163.com, daniel.lezcano@linaro.org, linux@arm.linux.org.uk,
        tglx@linutronix.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.co,
        rob.herring@calxeda.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/4] Add cpuconfig nodes in dts for smp configure.
Message-ID: <20130914115011.GA2746@lukather>
References: <1378968687-8200-1-git-send-email-cinifr@gmail.com>
 <1378968687-8200-3-git-send-email-cinifr@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7yLcY/JGxB8a0rD4"
Content-Disposition: inline
In-Reply-To: <1378968687-8200-3-git-send-email-cinifr@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7yLcY/JGxB8a0rD4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Fan,

On Thu, Sep 12, 2013 at 02:51:25PM +0800, Fan Rong wrote:
> Signed-off-by: Fan Rong <cinifr@gmail.com>
> ---
>  arch/arm/boot/dts/sun7i-a20.dtsi |    9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/sun7i-a20.dtsi b/arch/arm/boot/dts/sun7i-a=
20.dtsi
> index 999ff45..bfedcb2 100644
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

Both these changes don't seem really needed, are they?
>  			compatible =3D "arm,cortex-a7";
>  			device_type =3D "cpu";
>  			reg =3D <1>;
> @@ -167,6 +167,11 @@
>  		#size-cells =3D <1>;
>  		ranges;
> =20
> +		cc: cpuconfig@01c25c00 {
> +			compatible =3D "allwinner,sun7i-cc";

Please use the sun7i-a20 prefix, and I'd prefer cpu-config instead of
"cc".

Thanks for working on this!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--7yLcY/JGxB8a0rD4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSNE1zAAoJEBx+YmzsjxAgxmYQAKmbHN4RXXyHtzrfstxWohO8
WXMLkzvcg9eeO02NVRqLphwP4sy26X6XH5pQ02mYmU0QEqTg8JGki/cc1zgpK4hD
YWde618CH8B+s6v0+KmRB4wVEcmz1zZqHQsH/q4kF38ODmOWHG1sYsULgbtG8yr+
cDBjd3ZrBEtnidw8lD16YEYrKgXNK+RlPC2VZHVIuR21eZMhYDZGGE/9SOA7ICVv
gxKQKx0VWWYl5y7LqpjaZ/HbcGP7WCCp2PQuEh1Q7D68LKId1/RYsrqq3Xzy7rT6
bZ0SKjME068jkNh+Xvzact7BM3yBcx1/98drK+oNsWljJpxTOr2/YZQwj8O/0SKD
BWkK+Q/El/bkVscLahrTQ3Fj3ME2N7ZJWLid+USEmOUy39nydastQ1ailitD21qy
WQPE3pxvdlyKz0wYUTA4cKiwCiXdlouaYgmc5MeUJVXeYjgtQypkasUeRNlpyjUm
ixUISczHp/6lTtwwjp02iX48sfgsaOBaCJV7KADbVUM859pbv+eHu3XbFFmeJCCc
IN5xTK8zQFtqJ9Slm5WlWchPpV6jtCw4oJI5cw51PEK77jgiKrAZAWBscTglH07x
hTa1POSzWN/f5Ck/HVoITSW6Vi6X8cj/i5FFnCp5HXZIZaoDAi3w0NiyWtP6ypMr
zau/fQDRnNV8ET6tc+/n
=+NMs
-----END PGP SIGNATURE-----

--7yLcY/JGxB8a0rD4--
