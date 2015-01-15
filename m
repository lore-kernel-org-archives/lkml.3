Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbbAOLyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 06:54:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32952 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbbAOLyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 06:54:45 -0500
Date: Thu, 15 Jan 2015 11:54:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        Alexander Morozov <linux@meltdown.ru>
Message-ID: <20150115115425.GX3043@sirena.org.uk>
References: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="6yuPXOSZRpyw7iEV"
Content-Disposition: inline
In-Reply-To: <1418614273-2303-1-git-send-email-voice.shen@atmel.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/3] ASoC: codecs: wm8904: add dt ids table
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6yuPXOSZRpyw7iEV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 15, 2014 at 11:31:11AM +0800, Bo Shen wrote:

> +#ifdef CONFIG_OF
> +static enum wm8904_type wm8904_data = WM8904;
> +static enum wm8904_type wm8912_data = WM8912;
> +
> +static const struct of_device_id wm8904_of_match[] = {
> +	{
> +		.compatible = "wlf,wm8904",
> +		.data = &wm8904_data,

Does this end up in the i2c_driver_id driver data or do we need some
extra code when devtype is assigned to check for an of_node and look at
the DT data instead?  That certainly used to be the case...

--6yuPXOSZRpyw7iEV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt6pwAAoJECTWi3JdVIfQh+8H/ib4WL9KSjhvO9zXpnMqeY/X
TAJjHOQqTKvXArE068aE33rnHqpCTG1whnbFmVcT7XQE3weP9njbBRSCThLg+w7w
Yk+EqB7v3p8CA2moY7+AFLi+427awZLVwxw7i3f0PqwPMLCFB0dcqehZNB+ryYL4
ra+0lBmFsDnUGHuAHRbIcWQ8IDgz2bBNVZzGyKiy4vL4KThAb/HzXiJd1WqFdz26
BcXoGDjKsej3j/2FAK1FYrck5CIxHIfqwS9ujMuoNUphXqiV6F+FoMI2mylvkE+x
64barcbq5zlR8SajQ8accrPLzTQ07/aAYgPCBkBfjOpbe7Li+4J/G+zuAfnsIx8=
=T1j7
-----END PGP SIGNATURE-----

--6yuPXOSZRpyw7iEV--
