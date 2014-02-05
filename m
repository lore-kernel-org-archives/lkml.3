Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaBELSi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 06:18:38 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35961 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaBELSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 06:18:37 -0500
Date: Wed, 5 Feb 2014 11:18:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jean-Francois Moine <moinejf@free.fr>, alsa-devel@alsa-project.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20140205111814.GF22609@sirena.org.uk>
References: <cover.1391274627.git.moinejf@free.fr>
 <1b15025671d9099863a3091346536e45891e4a26.1391274628.git.moinejf@free.fr>
 <20140204180625.GM22609@sirena.org.uk>
 <20140205101134.4591e5c3@armhf>
 <52F2021A.9020804@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+10PrBpSX62Koh6T"
Content-Disposition: inline
In-Reply-To: <52F2021A.9020804@metafoo.de>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH v3 4/5] ASoC: tda998x: adjust the audio hw
 parameters from EDID
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+10PrBpSX62Koh6T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 05, 2014 at 10:19:22AM +0100, Lars-Peter Clausen wrote:
> On 02/05/2014 10:11 AM, Jean-Francois Moine wrote:

> >So, in the CODEC, I don't see how I could update the parameters
> >dictated by the EDID otherwise in changing the DAI driver parameters.

> The startup function is the right place. But instead of modifying
> the DAI use snd_pcm_hw_constraint_mask64(),
> snd_pcm_hw_constraint_list(), etc. to setup the additional
> constraints that come from the EDID.

Right.

> Bonus points for making this a generic helper function that takes a
> runtime and a EDID and then applies the EDID constraints on the
> runtime.

...as previously requested.  I know there was some discusion of broader
moves to factor this stuff out but it'd still be good to keep it
separated out even prior to a final non-EDID based solution so it's
easier to refactor.

--+10PrBpSX62Koh6T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8h3zAAoJELSic+t+oim9svIP/1jM8AW7hzSB522fS5oa9v4d
9ChYj+KVIrRCWNqJQOjVzwU4airwaDO0XEdPrxjjRAYR12a1qSqDEjPGf+JEMj9c
jOtdJlf5kCUEujDpLMFvUiYUKH5Y0vzGpWI3NMWzO3Y2b5nt+0mhxFLkg/jo6cpv
YnfPGkSekBLYMtgz/4RNWrryxnnV9JFJMd/cj1wQJ8zUcbr9u0LhcMr8n1/q6dqX
MKfA1mcIlg8V+fgi/ZO63/VAzEPLtZKyNW4xmEEFZOAuoFW6vKbwzBmXTMaMBLUL
/XRcKv6g7Ewz/X1XXjMsIOHdXfvvSaE0X60K5wk4BNUvWE/d2zYioM49UnMfRiOs
Qo/iNZy4fOnLxp979CAp7dSBylz+rcZlCFY9sO1CEPuyeBBcK/JTeKaPAbgf7J6x
E3Z9+657s727DymwnNF8/nxhg875BiaBch8ItTZNwE+iJOJu4+NGo8QUbPhyh4DU
E+qOmwO+tYbS3hQBWpceuZwwjvP6DVUb+L028oaUVt7X9MJWs6qS95Twp7XVwWYX
0HmExiQXtsHXMeUCknQrPWqg48tIEQdmtTSRfEoaKiRUr4QiD3ZZxx3BVigjSJGG
JoHO/wrTlHzcp3pAfTOQpVFbmvFHf2s929438wRcdscme1eUH5fGK/d5XHcKAGME
8pj/efUbiqe4CVN/eFXr
=00nn
-----END PGP SIGNATURE-----

--+10PrBpSX62Koh6T--
