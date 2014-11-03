Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKCMrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:47:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35353 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaKCMrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:47:18 -0500
Date: Mon, 3 Nov 2014 12:45:49 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@axentia.se>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141103124549.GL3815@sirena.org.uk>
References: <544A1121.6080900@atmel.com>
 <1414178759-7252-1-git-send-email-peda@axentia.se>
 <1414178759-7252-2-git-send-email-peda@axentia.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hTKW8p8tUZ/8vLMe"
Content-Disposition: inline
In-Reply-To: <1414178759-7252-2-git-send-email-peda@axentia.se>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: atmel_ssc_dai: Match the CMR divider only in full
 duplex.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hTKW8p8tUZ/8vLMe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 24, 2014 at 09:25:59PM +0200, Peter Rosin wrote:
> The CMR divider register is shared by playback and capture. The SSC driver
> therefore tries to enforce rules so that the needed register content do
> not conflict during simultaneous playback/capture. However, the
> implementation also prevents changing the register content in
> half-duplex scenarios, which is needed when using the OSS API.

Applied, thanks.

--hTKW8p8tUZ/8vLMe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUV3j8AAoJECTWi3JdVIfQcegH/A8sAVhYsXhlnnPdW08UxLRW
uue4tn1WLmPI0WJd7XUqrFsO2w2ueloPZZrxMSL+8kuNdhd1mFFGuhe51vAlTuhR
7IQkTb4Fy+bxKZJ4c7QqwJjYmKw8IU9qrXJ4B4f33TdA++V+ofAQEpAoaDOCCgKf
9tqiqo6glP8qJYTfEUky2FU02AIu8dSNlPuDtbzbLznuC9Lg4gDPPcZX/K7d/kkS
x/a565WlLqtxAYfpFaO53RY+IygL3L5lGoqAyZSLfvFasz3Q+wbaBXDXfSCGWIbB
fTHYTMq1l9GRV3zhhTchbypys0tgkzajmDLGT1kTAv+GROZkgpiYEH7k6boxUcE=
=z+FE
-----END PGP SIGNATURE-----

--hTKW8p8tUZ/8vLMe--
