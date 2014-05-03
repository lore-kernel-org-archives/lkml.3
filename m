Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160AbaECRuI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 13:50:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:60484 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752193AbaECRuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 13:50:06 -0400
Date: Sat, 3 May 2014 10:45:20 -0700
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexander Bersenev <bay@hackerdom.ru>
Cc: linux-sunxi@googlegroups.com, david@hardeman.nu,
        devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        pawel.moll@arm.com, rdunlap@infradead.org, robh+dt@kernel.org,
        sean@mess.org, srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH v5 1/3] ARM: sunxi: Add documentation for sunxi consumer
 infrared devices
Message-ID: <20140503174520.GA15342@lukather>
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
 <1398871010-30681-2-git-send-email-bay@hackerdom.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <1398871010-30681-2-git-send-email-bay@hackerdom.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 30, 2014 at 09:16:48PM +0600, Alexander Bersenev wrote:
> This patch adds documentation for Device-Tree bindings for sunxi IR
> controller.
>=20
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>
> ---
>  .../devicetree/bindings/media/sunxi-ir.txt         | 23 ++++++++++++++++=
++++++
>  1 file changed, 23 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/media/sunxi-ir.txt
>=20
> diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Docum=
entation/devicetree/bindings/media/sunxi-ir.txt
> new file mode 100644
> index 0000000..d502cf4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/media/sunxi-ir.txt
> @@ -0,0 +1,23 @@
> +Device-Tree bindings for SUNXI IR controller found in sunXi SoC family
> +
> +Required properties:
> +- compatible	    : should be "allwinner,sun7i-a20-ir";
> +- clocks	    : list of clock specifiers, corresponding to
> +		      entries in clock-names property;
> +- clock-names	    : should contain "apb0_ir0" and "ir0" entries;
> +- interrupts	    : should contain IR IRQ number;
> +- reg		    : should contain IO map address for IR.
> +
> +Optional properties:
> +- linux,rc-map-name : Remote control map name.
> +
> +Example:
> +
> +ir0: ir@01c21800 {
> +       	compatible =3D "allwinner,sun7i-a20-ir";
> +       	clocks =3D <&apb0_gates 6>, <&ir0_clk>;
> +       	clock-names =3D "apb0_ir0", "ir0";

Most of the time, we use something like "apb" and "ir". The names
being generic, if there ever comes a time where you have a second
controller, you don't have to do anything confusing or inconsistent.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTZSswAAoJEBx+YmzsjxAg5gYP/2lsQUHZgbQkji8OwT4EDdzy
JSsE8bmWB+YZjkD0GHMKEn5RUqxt0VCNiNngpKAFwT0A8n3HFN5AlCo3ZZz70RyN
88l5R2pfq/ftzhDJE+Pp8Q5ToQ+XR2k4CmEA5UpdMsJ8+stxNRlaKOnYIPfnK1Wj
Hmi9xSyJZ1Nz6sdw7fxy051lmPiWWSvrmVjh6OqAxGte+Odw5lz0fiosNv9VpJo6
8luskf+PHPAk5clbTqd7RyZ//sGB9r6htc5ybeh5ql4OJ1Yp/ntWs/yhZ3Sn3iyA
V6vgGNEmdsJleWOeN0on3/cccTFLnDkWNQXYOQDPGx573WTtWoSwW94nJICFe0Hl
8P1ZTvwD3bVrAebdWEGa6yAJ1vETU5heTFCY2llO0JZLaeCL6DaSU2f8fjWHJOp+
7g2zAdISKm9qaPRdVF/K1Hdt2flp8TWAq4sxZUer7eTGab6NYGrGmG4cATpBhcDr
ZGcYmGjoC7kswPP5frVg7q+6r3RWu1r+BA9ZqdJGHHZjrHrINANLyn1uybKPTTgB
h2RuKVdfIm4DvMIMaiVE8x4dK/NjXa2Y4ptdG20eNVaxIuPQ9gAZN878Pdf4u7Iu
B/jAqkE4r3lVfjarMyHMSKx1yjXKgjBujhCj0J1eveiLWCOeg+MLIzUGNQoyjlPO
vfI/90NAa3X3SlyoQ8tY
=B/uK
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
