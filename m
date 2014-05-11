Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817AbaEKEud (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 00:50:33 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52152 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbaEKEuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 00:50:10 -0400
Date: Sun, 11 May 2014 06:49:53 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-kernel@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rdunlap@infradead.org, linux@arm.linux.org.uk,
        daniel.lezcano@linaro.org, tglx@linutronix.de,
        thierry.reding@gmail.com, florian.vaussard@epfl.ch, jic23@kernel.org,
        jason@lakedaemon.net, andrew@lunn.ch, silvio.fricke@gmail.com,
        heiko.stuebner@bq.com, olof@lixom.net, sebastian.hesselbarth@gmail.com,
        sboyd@codeaurora.org, gregory.clement@free-electrons.com,
        arnd@arndb.de, robherring2@gmail.com, marc.zyngier@arm.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/4] dt-bindings: add mtk-timer bindings
Message-ID: <20140511044953.GR7047@lukather>
References: <1399772463-859-1-git-send-email-matthias.bgg@gmail.com>
 <1399772463-859-3-git-send-email-matthias.bgg@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="htVlOAOs/VIaEhiC"
Content-Disposition: inline
In-Reply-To: <1399772463-859-3-git-send-email-matthias.bgg@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--htVlOAOs/VIaEhiC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 11, 2014 at 03:41:01AM +0200, Matthias Brugger wrote:
> Add binding documentation for the General Porpose Timer driver of
> the Mediatek SoCs.
>=20
> Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
> ---
>  .../devicetree/bindings/timer/mediatek,mtk-timer.txt    | 17 +++++++++++=
++++++
>  1 file changed, 17 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/timer/mediatek,mtk-=
timer.txt
>=20
> diff --git a/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.t=
xt b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> new file mode 100644
> index 0000000..a36eb0f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/mediatek,mtk-timer.txt
> @@ -0,0 +1,17 @@
> +Mediatek MT6598, MT6577 and MT6572 Timers
> +---------------------------------------
> +
> +Required properties:
> +- compatible: Should be "mediatek,mtk6589-timer"
> +- reg: Should contain location and length for timers register.
> +- clocks : phandle to the clock source, normaly a 13 MHz fixed system cl=
ock
> +		and a 32 KHz fixed RTC clock.

If you don't want to use clock names for this, you should put the
order that you require them to be.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--htVlOAOs/VIaEhiC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJTbwFxAAoJEBx+YmzsjxAgjTUP/07b10LNYrPUaf4TqIJdiDEf
M2dYE/eTkAZ5LQQWvKEBDU/aExFY+m8qFvCQ4Mkvldg3Uxofi+ZYpFlqyVHfo2sP
BaMxm5DIry9ENM62JCTo6giRRZL+gwc97uEvSO26wO4A6HtdRJIiIcAmE1Dk/Bou
Da/kB4P/ueYbMOEuLxGNmQS7xttrV1bGHj125mZU93gqZwoPlyeikLEHuvj4EoNh
9tQCDIPrmiToH2wlIu62nG6KJid/fxW7fJHomRcD2YJnRUt970mb9blfJkWPQAKm
sR9qTb+5YB2ooFBohajyyT8JCmGNHoiWHY1ukO5uLHKHIqFA03aMkl1dc+VlWxZY
pLesLn/jg1LjsmK3/5BCIggCpOtzY5GxenidwJ5PrYP2tGFxX5dYLswQkQ0wM/QB
LDV0LQ7ahmEh1/vA25eeAHqF0Jipw4tmfyIi5jsOxerI9Nph9f+Ahd/mZYuD/b2x
shskvkl+v4VXdxtHjzNE61L0i6x3XRy+wqanWC6sLdf2UC8dGWgWac8PNZ4i5qlZ
ijOKmxRW9j1IXz39L7jIpsYnAW7DN3EZCczIqLjAKNmXbeTQmH8mpzIn0f+76rHK
VT1ToDV6ToXidjYbJmjy9d9jiEOxCxxfDxwWCNjpq8Qo/r1CtUt++9kPVkMA/ego
0PW7ndeCb/WpaFp7poJq
=lO9e
-----END PGP SIGNATURE-----

--htVlOAOs/VIaEhiC--
