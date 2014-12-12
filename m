Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967933AbaLLNXx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:23:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56748 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967664AbaLLNXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:23:51 -0500
Date: Fri, 12 Dec 2014 13:23:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        Alexander Morozov <linux@meltdown.ru>
Message-ID: <20141212132321.GI11764@sirena.org.uk>
References: <1418267681-4091-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sqSKez5rJqaWrTl+"
Content-Disposition: inline
In-Reply-To: <1418267681-4091-1-git-send-email-voice.shen@atmel.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: codecs: wm8904: add dt ids table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sqSKez5rJqaWrTl+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 11:14:39AM +0800, Bo Shen wrote:

> +static const struct of_device_id wm8904_of_match[] = {
> +	{ .compatible = "wlf,wm8904", },
> +	{ .compatible = "wlf,wm8912", },
> +	{ .compatible = "wlf,wm8918", },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, wm8904_of_match);
> +
>  static struct i2c_driver wm8904_i2c_driver = {
>  	.driver = {
>  		.name = "wm8904",
>  		.owner = THIS_MODULE,
> +		.of_match_table = wm8904_of_match,

I'm not seeing anything here that ensures that devtype is set correctly
when probing using the OF IDs - currently we rely on i2c->driver_data.

--sqSKez5rJqaWrTl+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUiuxJAAoJECTWi3JdVIfQa/EH/3sImuPwqYCbtDH6kGYmchW8
4go5oQrdon2GmMjCI7y9W7lx/Yvnp/MoH4eoxQWnk+d0PSqxRAK1Rpwir1Cb8V9G
Y9VvUChbGJQIkDwmaNdoCGd0CNsXDLCA4sNq8BGcyjocwjozCx7oFmd2XmOorHPn
NvCpvZoXz6T3bg2CEqkrO61zAqS8n9wfVpfvfDfkM+J6MCGg+ptjJo2CwEgE2WOY
JpcjjM8MeDCttK06bYfk7xdbKbP9GAgdGVEgchOtYG4K+XSVOoKTf88cglpJ3fNT
JSxIdxkfbGkv1e1qDPSVVV9f711U/smhgB44fAEgS9Hk+8zpHTKKPncPUkDTkmc=
=DvjI
-----END PGP SIGNATURE-----

--sqSKez5rJqaWrTl+--
