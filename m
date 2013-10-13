Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab3JMWQ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 18:16:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:54852 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755277Ab3JMWQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 18:16:54 -0400
Message-ID: <525B1BC5.20800@ti.com>
Date: Sun, 13 Oct 2013 18:16:37 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wendy Ng <wendy.ng@broadcom.com>
CC: Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Markus Mayer <mmayer@broadcom.com>, <eduardo.valentin@ti.com>
Subject: Re: [PATCH v2 2/3] ARM: bcm281xx: Turn on Thermal and HWMON drivers.
References: <1380321454-16216-1-git-send-email-wendy.ng@broadcom.com> <1380321454-16216-3-git-send-email-wendy.ng@broadcom.com>
In-Reply-To: <1380321454-16216-3-git-send-email-wendy.ng@broadcom.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="pUClwgUHaNHLQEkL88dqOFfqK1vdHl7KN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--pUClwgUHaNHLQEkL88dqOFfqK1vdHl7KN
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Wendy,

On 27-09-2013 18:37, Wendy Ng wrote:
> This enables the thermal and HWMON drivers for Broadcom bcm281xx SoCs.
>=20
> Signed-off-by: Wendy Ng <wendy.ng@broadcom.com>
> Reviewed-by: Markus Mayer <mmayer@broadcom.com>
> Reviewed-by: Christian Daudt <csd@broadcom.com>
> ---
>  arch/arm/configs/bcm_defconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/configs/bcm_defconfig b/arch/arm/configs/bcm_defc=
onfig
> index 6e49310..1474661 100644
> --- a/arch/arm/configs/bcm_defconfig
> +++ b/arch/arm/configs/bcm_defconfig
> @@ -83,7 +83,8 @@ CONFIG_SERIAL_8250_DW=3Dy
>  CONFIG_HW_RANDOM=3Dy
>  CONFIG_I2C=3Dy
>  CONFIG_I2C_CHARDEV=3Dy
> -# CONFIG_HWMON is not set
> +CONFIG_THERMAL=3Dy

Maybe you also wanted to
CONFIG_BCM_THERMAL=3Dy
?

> +CONFIG_HWMON=3Dy
>  CONFIG_VIDEO_OUTPUT_CONTROL=3Dy
>  CONFIG_FB=3Dy
>  CONFIG_BACKLIGHT_LCD_SUPPORT=3Dy
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


--pUClwgUHaNHLQEkL88dqOFfqK1vdHl7KN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlJbG8sACgkQCXcVR3XQvP0RFQEA18QZylU4efSfLyagZ15PrrH8
3XJRrEN9Z0WUZJE5q6UBAICSfUUanYWyU1Zxlfpo0I0iRtxF0phr6fkWMEmO4E9g
=dEKI
-----END PGP SIGNATURE-----

--pUClwgUHaNHLQEkL88dqOFfqK1vdHl7KN--
