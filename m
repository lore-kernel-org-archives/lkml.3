Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbaAWTkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 14:40:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58730 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaAWTkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 14:40:52 -0500
Date: Thu, 23 Jan 2014 19:40:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org,
        kuninori.morimoto.gx@renesas.com, moinejf@free.fr,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140123194038.GI11727@sirena.org.uk>
References: <1390453370-29194-1-git-send-email-Li.Xiubo@freescale.com>
 <1390453370-29194-9-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="STPqjqpCrtky8aYs"
Content-Disposition: inline
In-Reply-To: <1390453370-29194-9-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/8] ASoC: simple-card: add off-codec widgets supports.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--STPqjqpCrtky8aYs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 01:02:50PM +0800, Xiubo Li wrote:

> +	/* off-codec widgets */
> +	if (of_property_read_bool(node, "simple-audio-card,widgets")) {
> +		ret = snd_soc_of_parse_audio_simple_widgets(&priv->snd_card,
> +					"simple-audio-card,widgets");
> +		if (ret)
> +			return ret;
> +	}

Again, needs documenting.

--STPqjqpCrtky8aYs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4XAzAAoJELSic+t+oim9sM0P/2fm0zF8Q0EAw8WMECZQvFDj
SKrjtmFFaJcMNQ/EBEQoFNF2b++5HnDQVJ2qD7cqeyOhW4BKeM5ZWGTxyKRHHPsc
0TdNrubpM2R+uUY8yawzUnmXcvXNLwO6eIK1Urs+9URA6XH2VFPrWb1CVmxiMaH1
GbuGVLJakf/E7DvZtahdA8cnAiPs0WMmgunPwZAQm6AINLmh6j/TT6rmboc8Dgat
sjjFp43ZiPvq3fIDQpm6o8ycWMBWwYhEm4A6J9VhZc1waIKjJyGGFi6fnQERw/Br
M+sMwJAtve1V+8W4YP3NIFtN7C3rY7YllN8DeKWLMHoAFPYlouDOIQb0XPO8odz3
/237rOaukIKKFwvBhyHcmygRzxM49MpA8DqGfPJ/4LfQOoEmGvMnmb9VL3slyc6H
7sTbqzUATkjh9Ruzxj7N2yVHGwrP74LV5Bgl6giFDbzc08JfRZzY4anXsR6n9WOj
D7hQ0tXiR/YrKTxTXX7e4gN5odZ4flPsDVU4+oZJJmSw2OK3cMTwXFZbVRGsp13X
kbPVi+kl++JQ6WZWdYv/RVCMUDRbiZcJNxCap0JnPoMR7xluzEyf509WhQDiWywO
6cAJCuhfU+U81A2XWvCYd/pM1B2jBtsTciOblinBbeIz2+mT9BJYluyVVEEQrebu
cwYGUGc2EHMKxOsttYEx
=63u1
-----END PGP SIGNATURE-----

--STPqjqpCrtky8aYs--
