Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab3HAJmc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 05:42:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:35195 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3HAJma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 05:42:30 -0400
Date: Thu, 1 Aug 2013 10:42:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Marek Belisko <marek.belisko@gmail.com>
Cc: perex@perex.cz, tiwai@suse.de, grant.likely@linaro.org,
        rob.herring@calxeda.com, lgirdwood@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        zonque@gmail.com, Marek Belisko <marek.belisko@streamunlimited.com>
Message-ID: <20130801094225.GJ9858@sirena.org.uk>
References: <1375348498-2941-1-git-send-email-marek.belisko@streamunlimited.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NlM66YnIYV0xathf"
Content-Disposition: inline
In-Reply-To: <1375348498-2941-1-git-send-email-marek.belisko@streamunlimited.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: Add PCM1681 codec driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NlM66YnIYV0xathf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 01, 2013 at 11:14:58AM +0200, Marek Belisko wrote:
> PCM1681 can be controlled via I2C, SPI or in bootstrap mode (no control mode). This code add
> support only for I2C mode.

Applied, thanks.  One thing:

> +	if (val != -1) {
> +		regmap_update_bits(priv->regmap, PCM1681_DEEMPH_CONTROL,
> +					PCM1681_DEEMPH_RATE_MASK, val);
> +		enable = 1;
> +	} else
> +		enable = 0;

The style is to have braces on both sides of the else if it's one one.

--NlM66YnIYV0xathf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR+i1+AAoJELSic+t+oim9/+kQAIuMRwNqlRDr/MLyfbQVoFUl
Ups4ZAs8mblqDuWYIogYvkQdzWQKQhdoNoi73pXrkcUlcZ4DlJ4LGH+PI2HvH6ZH
5Eia9NBnsxIOv11w6EtcD7P2Ob87AzljcRn0yrnPeLQb4aA8+ic0qkfGRSsob075
+iSYv5ziHLL8jxQ/RTMEF3w6VwaNwpHxxUtgiiBe83jHG+fmL5/BvEN+HSjTMYhn
BU4vIMEQ4UG6LZfe9Sl+MTqvkFoTh6DLjtBZuju2cDkXdmHVjsAQ9hW2+ottAXAk
0kjJP9kXf4ZumNtlKDyvjhd76gzqbnzYLYAZiUkISjNJG7T3KhHddnIn6JgG54yP
oULn1ou/21ogASqhqbqA1X784mK2RTIDnDtPHAwbFp9ixxc62JjYwN1Y6LZU8Wlc
JrOiMOI1LU3G5DrsMGKf/ACNoIp9b04QIl5PA/DMubBU+KG0D+Ao8KVPuWQia0jr
HQRQ6IwTGY9FDwAgGU0cMJPlqjOXsXYTbB0qNC3D+BBgpZIBNpIsixoAzHAkchLR
Rs9bvWpnDcKRpMJnlyVZGGiC6RG92sLzy66QTO4rcC70AsoNClYOwQdZ2R186xY8
Z9Uh6fIg9ChfuKsHKRey8AkAm6qKNfV8wMBD20Xp7LuEX99iZTnnDS2OpNRHLjcs
51yUiZ7JE9LkzFTMNkrw
=yObF
-----END PGP SIGNATURE-----

--NlM66YnIYV0xathf--
