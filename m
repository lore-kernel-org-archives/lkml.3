Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836AbaJVKug (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:50:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42283 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaJVKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:50:34 -0400
Date: Wed, 22 Oct 2014 11:49:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Jianqun <jay.xu@rock-chips.com>
Cc: heiko@sntech.de, lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, huangtao@rock-chips.com,
        cf@rock-chips.com
Message-ID: <20141022104947.GP2344@sirena.org.uk>
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
 <1413946799-20834-1-git-send-email-jay.xu@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="THYEXwetZJOK3OLY"
Content-Disposition: inline
In-Reply-To: <1413946799-20834-1-git-send-email-jay.xu@rock-chips.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] ASoC: rockchip-i2s: add MAX98090 support to Kconfig
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--THYEXwetZJOK3OLY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 22, 2014 at 10:59:59AM +0800, Jianqun wrote:

> +config SND_SOC_MAX98090
> +	tristate "ASoC support for max98090 driver"
> +	depends on I2C && GPIOLIB
> +	help
> +	  Say Y or M here if you want to add support for max98090 codec.

No, you're missing what Lars was saying here - there's already a Kconfig
symbol for the CODEC in the codecs directory, you should add the help
text to that in order to allow the user to enable it.  Do this in a
separate patch to making your I2S driver selectable since it's not
directly related code wise.

Please also drop the "ASoC" -> "SoC audio" transition or at least make
it a separate patch.

--THYEXwetZJOK3OLY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUR4vKAAoJECTWi3JdVIfQlMAIAIQri6zPDRHfCYdcrAfNMCyx
Lp/16FsuxTcd4b3QXBq/PPItkGHpyHGQ8+U4buDBBxxshnaxoVTWtKr7fnfTGm/O
Hpz+133/zMkG16G4/KPVEOZ9GCazLCKKDYNNs6dIkijVwSR4JljXbDMCc6J6QYdd
jgEiVjI3i9/snfg7/7s5fcsWXFiN6GF2ch6uMcs8mC/21yzKx0EHIfQjmgCYcDt+
HgyushOCAYfSbdsCRsMzqJ523y3v0fVHOVxA7GvqiCgpMAN30Mu0w+JYBiUef04F
qiMvzhFzwjMnu2cjwuVk659c5oZuHWoTlovTboUhcm+U6L/4Nc7ibWRtEJoelH0=
=DRMk
-----END PGP SIGNATURE-----

--THYEXwetZJOK3OLY--
