Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931AbaBZOPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 09:15:19 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:57610 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbaBZOPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 09:15:15 -0500
Date: Wed, 26 Feb 2014 15:15:10 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Matt Porter <mporter@linaro.org>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robh+dt@kernel.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linux IIO List <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux PWM List <linux-pwm@vger.kernel.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 5/6] pwm: enable TI PWMSS if the IIO tiecap driver is
 selected
Message-ID: <20140226141508.GF29779@ulmo.nvidia.com>
References: <1391626901-31684-1-git-send-email-mporter@linaro.org>
 <1391626901-31684-6-git-send-email-mporter@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nYySOmuH/HDX6pKp"
Content-Disposition: inline
In-Reply-To: <1391626901-31684-6-git-send-email-mporter@linaro.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nYySOmuH/HDX6pKp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 05, 2014 at 02:01:40PM -0500, Matt Porter wrote:
> The IIO TI ECAP driver depends on the TI PWMSS management
> driver in this subsystem. Enable PWMSS when the IIO TI ECAP
> driver is selected.
>=20
> Signed-off-by: Matt Porter <mporter@linaro.org>
> ---
>  drivers/pwm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> index 22f2f28..bd3cc65 100644
> --- a/drivers/pwm/Kconfig
> +++ b/drivers/pwm/Kconfig
> @@ -219,7 +219,7 @@ config  PWM_TIEHRPWM
> =20
>  config  PWM_TIPWMSS
>  	bool
> -	default y if SOC_AM33XX && (PWM_TIECAP || PWM_TIEHRPWM)
> +	default y if SOC_AM33XX && (IIO_TIECAP || PWM_TIECAP || PWM_TIEHRPWM)
>  	help
>  	  PWM Subsystem driver support for AM33xx SOC.

Perhaps this module should move out of drivers/pwm if it's no longer a
PWM specific module.

Thierry

--nYySOmuH/HDX6pKp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTDfbsAAoJEN0jrNd/PrOhECAP/j2I0zpD7fFA5CK5JNLz4ZdF
Fxp0JEtEAPHhw/36hcUiillkwbnl3bmPGEsFLjIOmyL22LvMkmiOGsAgkQjcPvcJ
6cNwu/cn56t4L4k+jQAa0oSCqMIyQTASCUC13b+L/1tGUwBvoXnStarLcBQuWrTX
fcNs8PCHXqe59+/xL81eIgFMxJuWJ8XvuDWW8jrL9ffg9RH6s5VqZcu5u0WhISlf
jw+VJurPAZskB553Ve6QFMLAsf5xvfmu4R4Tm7U2vlDxzdYLbEQWCRf87HVipKQr
3MC3Rm9W2vAFKFFJFwx5oz1WnsCkH7BYt0MyfSn3Tt8WP6TXgS7dZRa85zt42E4P
4XdUaVTFJ3/ikuFQdVUlD3Hlp4fWZX1TxTBPHF7fiwUxSdkO+PtwYgdmAJvIjEIt
gFzhX+6de9xBAbj6ei/1VWx9CUPUaKC00GpB9UwuwjYiWAuzuSmc9yIke515Vg8f
fvtv+b9fgpeU3j5UZ2pXyZKsk2ONZfGQjavEZw99/rM/v+BKXs3PpiGKkOJex+s6
Cgn0KbhGtvQwKWj55lKLW52G6QHpJlmSE/UCQrcI0sVenrQZt/5nld4JuTKMmKrY
kSKE9dzozmTLVVHmufj2vojfIWLMXdwl7wGr+mOfxs/wb41Z7gDV1+uZZgpXZ/sT
Wivk3DjAFknD5cmFYupo
=gNT3
-----END PGP SIGNATURE-----

--nYySOmuH/HDX6pKp--
