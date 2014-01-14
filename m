Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662AbaANNNk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:13:40 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:51522 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342AbaANNNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:13:38 -0500
Date: Tue, 14 Jan 2014 07:12:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Suman Anna <s-anna@ti.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, Mark Rutland <mark.rutland@arm.com>,
        Tony Lindgren <tony@atomide.com>, Kumar Gala <galak@codeaurora.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv4 7/7] hwspinlock/omap: enable build for AM33xx, AM43xx &
 DRA7xx
Message-ID: <20140114131207.GB10818@saruman.home>
Reply-To: <balbi@ti.com>
References: <1389658764-39199-1-git-send-email-s-anna@ti.com>
 <1389658764-39199-8-git-send-email-s-anna@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tjCHc7DPkfUGtrlw"
Content-Disposition: inline
In-Reply-To: <1389658764-39199-8-git-send-email-s-anna@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--tjCHc7DPkfUGtrlw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 13, 2014 at 06:19:24PM -0600, Suman Anna wrote:
> HwSpinlocks are supported on AM33xx, AM43xx and DRA7xx SoC
> device families as well. The IPs are identical to that of
> OMAP4/OMAP5, except for the number of locks.
>=20
> Add a depends on to the above family of SoCs to enable the
> build support for OMAP hwspinlock driver for any of the above
> SoC configs.
>=20
> Signed-off-by: Suman Anna <s-anna@ti.com>
> ---
>  drivers/hwspinlock/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/hwspinlock/Kconfig b/drivers/hwspinlock/Kconfig
> index 70637d2..3612cb5 100644
> --- a/drivers/hwspinlock/Kconfig
> +++ b/drivers/hwspinlock/Kconfig
> @@ -10,7 +10,7 @@ menu "Hardware Spinlock drivers"
> =20
>  config HWSPINLOCK_OMAP
>  	tristate "OMAP Hardware Spinlock device"
> -	depends on ARCH_OMAP4 || SOC_OMAP5
> +	depends on ARCH_OMAP4 || SOC_OMAP5 || SOC_DRA7XX || SOC_AM33XX || SOC_A=
M43XX

how about just using ARCH_OMAP2PLUS ?

--=20
balbi

--tjCHc7DPkfUGtrlw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJS1TenAAoJEIaOsuA1yqRE+VgQALE9r2Dqeir+0xEAU6E1BRpv
lLFxrhyN0hiTfJ92MsMeu3XSobXZZwQgsCWyc+vsIUm6CiE7sE8rd/J6FPGO8zaN
z33lMBWM+xjfdt7ePuJk6xE/Z9gXtvUUI5K3KTROq0mVEzWD4cOKfxZNoE9/z+lp
WIzHUVD+zO7xpVJI2daNpwKj7lUdUpVEcpEve9IHUITEjqhZzPwXpR8l3laXV7Bd
3ta+qWCOOH1fP0QQfhp62fHZeX/a3cVkieUWGNjTfmvqQ3ofkpWPfNB4p2LBluwN
pYAkA8fw2PRdnNSRMkXbgT6Dj2UBdPwZLoupetLGqJ/LwSO2h+szvjdXPZuyasiH
ZrmI67wh2lwlCGPw/e7E+XAq+UkmiTE4XTzeavpeolfH2MVq6ApPxJMKGsbPUtmf
w+VXY2RsPu+cNPu2UfWuMKVjHkOe0NWc6C0p99xKncvh7W2WeseuMlrLaxHWU75P
slWzq7o9tWNB1EdmOvQjIJvNkv+loWOCV/olylopQxy/wrCjmDHeee74ZDhY9qRa
cH7FpGKW2Ul3TO6aKcREjgfN/x8myD2pdBQzSm+0d6GKXYORxCucCIY9lXAKQM/6
HGdxYOPxG+rb2Etp0luHBWy091cq9R+blLygd7XEjJQGVbhv9ZGXsVgaZRmtH8sJ
R0NKHjHSafswgdTVzrm6
=hMUH
-----END PGP SIGNATURE-----

--tjCHc7DPkfUGtrlw--
