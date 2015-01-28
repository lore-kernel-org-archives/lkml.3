Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbbA2BZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38385 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbbA2BZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:16 -0500
Date: Wed, 28 Jan 2015 19:14:30 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Peter Rosin <peda@axentia.se>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Lars-Peter Clausen <lars@metafoo.de>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150128191430.GG21293@sirena.org.uk>
References: <1422454572-7847-1-git-send-email-peda@lysator.liu.se>
 <1422454572-7847-6-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2BwlnJGNAaT6vtF0"
Content-Disposition: inline
In-Reply-To: <1422454572-7847-6-git-send-email-peda@lysator.liu.se>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/7] ASoC: pcm512x: Support mastering BCLK/LRCLK using
 the PLL
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2BwlnJGNAaT6vtF0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 03:16:10PM +0100, Peter Rosin wrote:

> community pages (1). The clocking functionality is also much better
> described in the datasheet for the chip PCM5242, which seems to be
> register compatible with PCM512x and PCM514x (which both have severely
> lacking datasheets).

If it's register compatible we should add the device ID...

--2BwlnJGNAaT6vtF0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyTUVAAoJECTWi3JdVIfQJA8H/1JMOC9ysco6niND7VNkQtzc
gRnWml3LLWeyB96tE2XvzfIzrvZ57EiGlOVMYVzM8orVrKgd9/DjCOzCzk9z89Pl
+fAuHe46XNa+Kmuycv2s9SXbnArAfXe1dtpyoN7V4dqUEH9497RQv6pcq2lZ6IjL
kSzBdiMzWvYF5sDKzi0bdcnQ9nFdnBkp+gR0ZZNxrzZ/BXPSC0bbk1WAy+YBTtji
pcCo4EKMRU5531uxHFtHPIGf0WUPDBwZaZO7r9P9nB+7MO7IjCHCKdJZDA9YCcZ2
FJ11EEyr0YvYEIf4yORKgNpFZKnz6MI89nyFsMV89i2mACtej0z8Ja+XLRhKHB0=
=473B
-----END PGP SIGNATURE-----

--2BwlnJGNAaT6vtF0--
