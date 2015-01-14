Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753350AbbANTAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 14:00:24 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57387 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbbANTAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 14:00:22 -0500
Date: Wed, 14 Jan 2015 19:00:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <20150114190000.GB3043@sirena.org.uk>
References: <1421152046-20069-1-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="eAbsdosE1cNLO4uF"
Content-Disposition: inline
In-Reply-To: <1421152046-20069-1-git-send-email-alexandre.belloni@free-electrons.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Asoc: sam9x5_wm8731: depend on ARCH_AT91 instead of
 SOC_AT91SAM9X5
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eAbsdosE1cNLO4uF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 01:27:26PM +0100, Alexandre Belloni wrote:
> The SOC_AT91SAM9X5 option is going to be removed, only depend on ARCH_AT91 like
> for the other drivers.

Applied, thanks.

--eAbsdosE1cNLO4uF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtryvAAoJECTWi3JdVIfQpxwH/jiLAJJ0eyk7/jw8sbEpng3d
tBOzl9BLc6HtYksH+YJ5IQTuKGv6YlvnzbXYHTYad9IYymRCgwyyfxGCu4EXUAHP
6BGP+8m1hJmvBwRNwuzbbVSXNFeYUwYUzcNWcSC9jz2HqczS9NsbE79nYEurTlnT
q9chwf5tF9Dpf19efjcsBLOgt9txYytWkkCQUvC3nS2aH3FHthHsbXkGJ8neUfVR
AJpy4jqSHNDm9FJlYvYCibuT4SFVo3UgTLpdAsNrCaxNLBhOOjj4OjqhabE/omrS
AYOR6KFrQgVYoTJBWaSIgTUwV9qmL03KBJQsB40edNvpEFgFTITL9txZUlhxt5g=
=jwo0
-----END PGP SIGNATURE-----

--eAbsdosE1cNLO4uF--
