Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935608AbaH0SU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 14:20:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36395 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413AbaH0SU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 14:20:27 -0400
Date: Wed, 27 Aug 2014 19:19:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: nicoleotsuka@gmail.com, timur@tabi.org, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org,
        galak@codeaurora.org, mark.rutland@arm.com, robh+dt@kernel.org,
        pawel.moll@arm.com, linux-kernel@vger.kernel.org
Message-ID: <20140827181947.GM17528@sirena.org.uk>
References: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8iK8UQkFE3H/Ua9u"
Content-Disposition: inline
In-Reply-To: <1408937462-18727-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 0/4] ASoC: Convert to use regmap framework's endianness
 method.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8iK8UQkFE3H/Ua9u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 25, 2014 at 11:30:58AM +0800, Xiubo Li wrote:
> Changes in V3:
> - Delete 'ASoC: fsl-sai: rename big_endian_data to is_msb_first.' patch.

Applied all, thanks.

--8iK8UQkFE3H/Ua9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/iFAAAoJELSic+t+oim9Px0QAIuxI78XTEl5AhdZMeQEYr1O
606noDxdp4t2+L2dqeJJZHVKva8TJEtjODNCOSZNYdEboyME9c7NkK2VrNeF4C/V
sGC+tR4zcjEQRVSB2xB8XsXiYaQJ1t5o2S0CIzJvuVyPf98Shnyih1g1eVUPzxjU
A6cXkdGeGOIsm5c2qRSasZjVfSLgyZxrTYrkH3PcPYdCVN5vzypME6DKwtIu8UiK
BdshEi+gi/wpkj9Pj3IIVyhYgb0t1CcbpgPCUG/kiNLSR3QGFxkueNwW4368aof/
8HTB+c5bT+tLL8w8HgzYnteOfchC72kqk1q3guU3WkwBuod+fbc2l6T7ro7Xk0lr
LvUc51DqXPFigXToyUg2yUCd3qarq82tuHFiAuJ658ExznIvR290wp5s1wR3RCOx
vx0/Nexde3W4QKRYE6GGIu0hoCwfoGCQkhteDHhjqD3AOz/V2Fd4aUZABLFJ+Q/y
KlQ/dUQNEiJDNqwVSXCWwP6DOp4Ghwwoz4+TRdWYLUCWnoA9O9juHGra9UzkE9RK
OZrsAEM/OmKpXnNUNNyMU7AUaLgzfAY1AYa2+loymrhmF5yBZ1e7dY+CDpSHoxOj
UtrqrYzV+BBXoQxRLFlwmkCiwvLyeO4d1IRA4P4L5SmcxiAZbofzrTR7USl1+hoe
HiPnKun75r50+W5a4d3H
=c8Hg
-----END PGP SIGNATURE-----

--8iK8UQkFE3H/Ua9u--
