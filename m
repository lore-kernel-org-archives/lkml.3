Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaAMRjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:39:06 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53627 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaAMRjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:39:01 -0500
Date: Mon, 13 Jan 2014 17:38:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: lgirdwood@gmail.com, kuninori.morimoto.gx@renesas.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140113173849.GG29039@sirena.org.uk>
References: <1389604088-16536-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QwltuPJOutxmIGiQ"
Content-Disposition: inline
In-Reply-To: <1389604088-16536-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: May I ask a question?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: use snd_soc_card_set/get_drvdata
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QwltuPJOutxmIGiQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 13, 2014 at 05:08:08PM +0800, Xiubo Li wrote:
> Remove asoc_simple_get_card_info macro and use snd_soc_card_set_drvdata
> and snd_soc_card_get_drvdata instead.

Applied, thanks.

--QwltuPJOutxmIGiQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1CSmAAoJELSic+t+oim9GvIP/iBaJyJZ9FQ3x3fhyqe9yFL2
bSoqLHQPIHRLrG8y070L/3Ojx/aRDy3JhzHa6jvrA94XzgTjnuLxcCmxePd8g0Wz
+1XRcR1plYlsucT9x23oZr/VbeIZSl5HbD2sjyJY708x19C/sSqm7BbtBG+QG/5i
XNhonJ6LPWGW2EnKIldpDptvOJifdeiYQOF0bGKirpToGfNc8RNFdEiQlqFIeme6
8gDrPvLrNoqYxaDtHijhZ/L9KpbDuaZP0i6w6zWzFOyICfJiSJzn8MB87pi2Ujn1
5WwVLX61WIPwhENlYtSNYsgzQP1U8xsxIU39C/BrEkBIJ+pq/9cIDw1Symlz3gyD
lQws/h6ZJkwVvH+SRsWbxJWAE3xPMlKu8uDjuWZv+hEoFFHe78PALimJk2fNbsIG
Ra72W/Usl+mZGlEF25AG9StktaOQMZoKn56u+b5lri3eLk9cgmnUPMeSJqsLxSTV
e3BVQfHBDX0kXDP27S/ue6EM0gkNt3iBmONpSGgO5TcDb3ga8hmfQ4C8lJQy6psd
M5jllw8gO4TfAv3DytgSJRATR0vAIMyuHXetu0Cp+dNUnLgBVc/XP6VZ18xMATTr
6GbnxF+5DsxMLVXJgoWpULGTj46j5SbwxaJqQzowM8hbLIxOKILVwulL2kixzei6
zLFUMmbV/4MM5uRp1BlV
=WLlD
-----END PGP SIGNATURE-----

--QwltuPJOutxmIGiQ--
