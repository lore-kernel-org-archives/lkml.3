Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaI1KXB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 06:23:01 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50020 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184AbaI1KW7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 06:22:59 -0400
Date: Sun, 28 Sep 2014 11:22:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Stefan Wahren <stefan.wahren@i2se.com>
Cc: lgirdwood@gmail.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Message-ID: <20140928102202.GM27755@sirena.org.uk>
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com>
 <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YGQsgxOP0v8GKjPA"
Content-Disposition: inline
In-Reply-To: <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.249.138
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YGQsgxOP0v8GKjPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 27, 2014 at 12:59:47AM +0000, Stefan Wahren wrote:
> This patch adds the Device tree bindings for the Freescale MXS
> on-chip regulators.

Use subject lines matching the style for the subsystem.

> +Required regulator properties:
> +- compatible: Must be "fsl,mxs-regulator"
> +- reg: Absolute physical address of the register set for the regulator
> +
> +Any regulator property defined as part of the core regulator
> +binding, defined in regulator.txt, can also be used.

While this should be using compatibles to identify which regulator is
being supported note that the binding doesn't document the fact that the
code makes regulator-name mandatory or what values are required.

--YGQsgxOP0v8GKjPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUJ+FJAAoJECTWi3JdVIfQKWkH/07JDU+MbOO0709bg6SPkhl/
AEOdpHTku5FHYJ7DSRUEmijpqjw+1s4YR2CYs1UmNseHUeFpKtkKrBBtpjrNsFnE
/ahHfCQPPy4JnLQpwpsD0lTB56bLV0z+NHTLRQPb3cuiBXyZykQTx9tNwcuD0ThH
WKa6hJm+3aYMtaE78sNPmUcDUjCzNbDHqopGvr1uJeMiuYIJdamHNGZp7fSWF3yR
7bMHnvoq7qBFcwVBOfI6HjvMfvybzURfan/hWaNTVGhA0FZx0r62Rd+x/2PeI9OF
UttFSaQerzOhoumc44DOXn62J6e3LZD7A6CNJ56A+wNHw3/Yvf0S63vWrkpFWn4=
=7ewL
-----END PGP SIGNATURE-----

--YGQsgxOP0v8GKjPA--
