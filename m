Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754057AbaCaOuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46272 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbaCaOuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:50:04 -0400
Date: Mon, 31 Mar 2014 16:46:17 +0200
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-pwm@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/4] pwm: sunxi: document OF bindings
Message-ID: <20140331144617.GH26751@lukather>
References: <1396267649-18009-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1396267649-18009-3-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCwQ2Y43eQY6RBgR"
Content-Disposition: inline
In-Reply-To: <1396267649-18009-3-git-send-email-alexandre.belloni@free-electrons.com>
B1;3406;0cFrom: Maxime Ripard <maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
From: maxime.ripard@free-electrons.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rCwQ2Y43eQY6RBgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 31, 2014 at 02:07:27PM +0200, Alexandre Belloni wrote:
> This is the documentation for the Allwinner Socs PWM bindings.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Cc: devicetree@vger.kernel.org
>  Documentation/devicetree/bindings/pwm/pwm-sunxi.txt | 19 +++++++++++++++=
++++
>  1 file changed, 19 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
>=20
> diff --git a/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt b/Docume=
ntation/devicetree/bindings/pwm/pwm-sunxi.txt
> new file mode 100644
> index 000000000000..e295a50813af
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/pwm/pwm-sunxi.txt
> @@ -0,0 +1,19 @@
> +Allwinner PWM controller
> +
> +Required properties:
> +  - compatible: should be one of:
> +    - "allwinner,sun4i-pwm"
> +    - "allwinner,sun7i-pwm"
> +  - reg: physical base address and length of the controller's registers

You also seem to need a clocks property.

> +  - #pwm-cells: should be 3. See pwm.txt in this directory for a descrip=
tion of
> +    the cells format.
> +
> +Example:
> +
> +	pwm: pwm@01c20e00 {
> +		compatible =3D "allwinner,sun7i-pwm";

Like Emilio pointed out, the compatible pattern is <family>-<soc>-pwm,
so: sun4i-a10-pwm and sun7i-a20-pwm.

> +		reg =3D <0x01c20e00 0xc>;
> +		clocks =3D <&osc24M>;
> +		#pwm-cells =3D <3>;
> +		status =3D "disabled";
> +	};
> --=20
> 1.8.3.2
>=20

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--rCwQ2Y43eQY6RBgR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTOX+5AAoJEBx+YmzsjxAgcMwQAL9jdwAz3kZSdoJjR9ZAPwkE
xh/ngt3FZiQm88wsmHhn/bB/Sk+9QYqMkSEIoHdZjlm8HdN9CxUYIoE2El1hAbnJ
n4KntRzJ2Q5LoT5gLJgAhvjCg3boUmqlwnjg7zPBWErw2YQXVoVndCHUgiAwAiG4
i6F6X2jeFxfAYIvuaRyjrDcIw85Af9hc1aIO1eTtp0yyExSNJnrZ6DNAQoyLdahk
gMI+Sm1/iOhohazagWJ6xN8d4y5Hr4bg8jBBKM1jAB8WdJlcVnIc9FnJxUiYOAdO
QxNsFyP7l2lQXRRs5+xPTrMbCibVGQC1IcWjKBe7IJVmkzeoJ1ZTiDeECL31f3Gy
x5Ep6+XnRun0GvjhYKjvmNF0Tn1TCo9FO8DDzSuszRsgWt3Ks5fswCelFKFAg2P5
FLuW1CRKiZ9Mx/VSsPnKQg5vZ5uCGwdQ9MDFgWKcfUoQfD6+YluOzJJ7yiC56Kcg
8bp8m+B8uGi/wx6z3lqczZBkwVmSVPZw6w3lDpBdbup6gbERy/9FL8F7UoqMyIo9
3++Q0oK+a77tYhSfmSzSnmtzNy4jV96Xu6C55U6vAVO2rrQsZxX99vI0+ZR42lpP
Ras8WQGLgtAUvQsM6e2B+eAIrPC6JTLO4Hyhatf/z1mpcbZDYVOIuk5pmhsUMuja
G/4y7fP7/D6ScMGxFgTW
=cKF0
-----END PGP SIGNATURE-----

--rCwQ2Y43eQY6RBgR--
