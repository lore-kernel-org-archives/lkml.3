Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaA0OZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:25:07 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50583 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753329AbaA0OZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:25:05 -0500
Date: Mon, 27 Jan 2014 15:24:00 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC 4/6] net: rfkill: gpio: add device tree support
Message-ID: <20140127142400.GI3867@lukather>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
 <1389941251-32692-5-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <1389941251-32692-5-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jan 17, 2014 at 02:47:29PM +0800, Chen-Yu Tsai wrote:
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>
> ---
>  .../devicetree/bindings/rfkill/rfkill-gpio.txt     | 26 ++++++++++++++++=
++++++
>  net/rfkill/rfkill-gpio.c                           | 23 ++++++++++++++++=
+++
>  2 files changed, 49 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rfkill/rfkill-gpio.=
txt
>=20
> diff --git a/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt b/D=
ocumentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> new file mode 100644
> index 0000000..8a07ea4
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/rfkill/rfkill-gpio.txt
> @@ -0,0 +1,26 @@
> +GPIO controlled RFKILL devices
> +
> +Required properties:
> +- compatible	: Must be "rfkill-gpio".
> +- rfkill-name	: Name of RFKILL device
> +- rfkill-type	: Type of RFKILL device: 1 for WiFi, 2 for BlueTooth
> +- NAME_shutdown-gpios	: GPIO phandle to shutdown control
> +			  (phandle must be the second)

Can't it be handled by a regulator?

> +- NAME_reset-gpios	: GPIO phandle to reset control

And this one using the reset framework?

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS5mwAAAoJEBx+YmzsjxAgPZwP/iX6u84lb83QdNWM8d3+KCD/
SWxJR9LuvniuU9sEEnAdo5VbsNi4oQiLhe8xHbrmtyv73Pvl5OZ53rL731unXT0n
d4C3FVApJuLuXW+U1sLqctNUQFCxWCLSJbW+58U/JPUgnpGKJa3kfWNa3cDz99WX
9L4fjz/X8EptLs28NUILjDTESKFpHZC5ModW/9eoxI/wcZt6L7ojsFZ7wk0wJe4w
OewXIx4SDVoqy6dB6aAR4esZDmF16gmcycfoljpyGkqboILw6Eo7CvWfKrEH+7Sm
Sc7cMDmH5nd98l+lqzIJzEVDxX7yHP20OfB+YWOCuP9WvAPhgWpmr3WF2knADOhc
vaGd66ED5fvhYEdEhNxXE0eKSQqJIsldC8LLrc8oMPm39ddC8/IPBVlV+WGfUwOx
iJ6PItgg6K0Wa96fkULMKwTt5lG8V0PCMOjUqaXMocKLTzGqm9f8doxHMRRfpt43
Enw39v3njYHHlzBZzYH6Mj2wOFNQm0ge8MWy+VIA44mkQgib6XBRaspwsP8qTsbI
PJylAftoU8O0U8fqG0cG6Xhk+kneeu+iAKK4yh+JkyqW18UflRTawQr8g8O6ftGm
3/pOFn0kY2UMMdoUqU2YpN6Fz9xWLmoNPBeg1wfLXrSVycopSspZnMMk7K6YNLyO
0QmPdpd4KZrLlrzi8D0F
=zNdg
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
