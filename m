Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870AbaHVSf7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:35:59 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55676 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410AbaHVSf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:35:58 -0400
Date: Fri, 22 Aug 2014 13:35:34 -0500
From: Mark Brown <broonie@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Support Opensource <support.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140822183534.GZ24407@sirena.org.uk>
References: <1408699513-7318-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g1M0U3R/ia+9V6wa"
Content-Disposition: inline
In-Reply-To: <1408699513-7318-1-git-send-email-linux@rasmusvillemoes.dk>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 208.59.64.2
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] sound: soc: da732x.h: Fix typo in include guard
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--g1M0U3R/ia+9V6wa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 22, 2014 at 11:25:13AM +0200, Rasmus Villemoes wrote:
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied, but please use subject lines matching the style for the
subsystem - if your commit log looks different to others for the same
files  try to avoid that.

--g1M0U3R/ia+9V6wa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT941zAAoJELSic+t+oim9ywAP/1ZoFPJfEA0hgNEZJ8l9nR2Y
H20YS+jn9UnknuME/wqarCMyYLNcsj7EjQt+ETUwswUa2VY41mge0q3RH/ZnD60C
SGnDUEj8hJTJF9b9mnZI1NtdtXCj3LjoaVcjQT4CmnXiWQmJ1ZXwqsPHeNbfE1fG
i7YUKDWyFdsyccmQJFVJw9BUGl7yscvCPRrGO2JqHoSWEYkVmZDkKy7NCuBBfyGz
nmpfikXzoPd10ZIjeZgTjh/7f276CItUBvkNMSffKEqDjhKqz3WuDDS47ys6qRFp
1LCgCRwVv6cT+3OrhJD8FtxwTj8ZzYMMm5IM5epUMXOMuDK4rF0JPhEteGcY5Sjy
RG+iHuXKuZWdm1FCbjydODh+BmiDZcFssJwfjJHkg2EqRRi2ux4I3PXMwxemLwSL
p3V/0QLFNcM/mZcayHH1DvygA0MPoMSb7zSL827xAq/7je9Mynyv7NFEz9xYqD+W
b3BobcJfAuSonglYpyLcf173R/umMNmJuQrvFfN73ExWQxWilPqFEyWtpb9z8WyM
oT3bsp9wwEGJK411u2/W652xiXOvsNrqZRF8VkAsvCBWivv8JX9LuCE1EOEgIP/H
hH+avS9AGbvkxgMopEaccvCvkWvvKiaCDDPyTBzVuPgHsJQ30RBvanNRrJ/6J2Zr
4JUY0JUnWEiztL3BoEWb
=l/vg
-----END PGP SIGNATURE-----

--g1M0U3R/ia+9V6wa--
