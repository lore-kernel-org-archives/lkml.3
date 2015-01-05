Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbbAEPaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 10:30:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36358 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbbAEP37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 10:29:59 -0500
Date: Mon, 5 Jan 2015 15:29:18 +0000
From: Mark Brown <broonie@kernel.org>
To: Inha Song <ideal.song@samsung.com>
Cc: alsa-devel@alsa-project.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, s.nawrocki@samsung.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux@arm.linux.org.uk, kgene@kernel.org, sbkim73@samsung.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        grant.likely@linaro.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Message-ID: <20150105152918.GT11764@sirena.org.uk>
References: <1420457117-11030-1-git-send-email-ideal.song@samsung.com>
 <1420457117-11030-3-git-send-email-ideal.song@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QkB+3dXt7G8Wz8Uy"
Content-Disposition: inline
In-Reply-To: <1420457117-11030-3-git-send-email-ideal.song@samsung.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH 2/3] ASoC: samsung: Document Trats2 audio
 subsystem bindings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QkB+3dXt7G8Wz8Uy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 08:25:16PM +0900, Inha Song wrote:

> + - clocks : Reference to the codec master clock
> + - clock-names : The clock should be named "mclk"

This should be done in the CODEC driver, not in the machine driver - the
CODEC always needs the clock, it's not something specific to this
machine.  Even if we decide that for Linux the best thing to do is to
manage the clock in the machine driver it should be described in the DT
as being attached to the CODEC.

--QkB+3dXt7G8Wz8Uy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqq3NAAoJECTWi3JdVIfQ8cAH/2pVZixTXEAT+S4w4GyZmGNe
TzjisRZtOWzl+8G5QN5EEZqHsyXh9BZHz9hmNndCWUjZT96e4IKZPmriNK+rPbOF
QRYzloUrlTPhXsTIiBGOuoLWjam0MJqFoidhQ5wJ3TwuGZ6G18U9n9kPXcfCeJMD
2OO8uPei+xOy1UX95fZBeQAnrx25+ZgGscNZh6gZXtFNeXoGAMoCQFh8yk2VwL/T
qtO7yTjgQ4Ubis7MsJPmvUHtxxLU4faLhDD3b+j2WQ/NrDHC/p9500492EGR5Ze8
nx0tI6za/gewfzuMGzFWgXCROPVxMLt+eYLHdwmOCiEImZ+wz3Rlwi2WIQjA+a4=
=T/eS
-----END PGP SIGNATURE-----

--QkB+3dXt7G8Wz8Uy--
