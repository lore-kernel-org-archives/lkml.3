Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752253AbaL3L3Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 06:29:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55571 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaL3L3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 06:29:15 -0500
Date: Tue, 30 Dec 2014 11:28:59 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <nicoleotsuka@gmail.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        alsa-devel@alsa-project.org, lgirdwood@gmail.com, a_bouin@yahoo.fr,
        timur@tabi.org, Xiubo.Lee@gmail.com, festevam@gmail.com
Message-ID: <20141230112859.GM11764@sirena.org.uk>
References: <1419898431-11336-1-git-send-email-nicoleotsuka@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wxsv2zsxQJemov+e"
Content-Disposition: inline
In-Reply-To: <1419898431-11336-1-git-send-email-nicoleotsuka@gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_esai: Fix incorrect xDC field width of xCCR
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wxsv2zsxQJemov+e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 04:13:51PM -0800, Nicolin Chen wrote:
> The xDC field should have 5 bit width according to Reference Manual.
> Thus this patch fixes it.

Applied, thanks.

--wxsv2zsxQJemov+e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoox6AAoJECTWi3JdVIfQCz8H/0X2DG9RkZpqduu3gEjXZDl8
qUeuoP1nXkh3Gv9Rft+mFvycXbwmwbWXRV81H/bwQFTDOg8JrsAxiOZw+oDBAkaA
UsrpzTXTmt7oCSHcxYqB9Bt46krvktOfAj0ii7VynbdhPEqBjVg9dQ4Sm+EdZiPd
kzMKLehlqDspWhIMEMlV6Nn2Tf8j1oXfIc6hcb1m5AI+VSds9uhvF9tQ1a7iaZB8
grvP1JB9IxngnvKmmwvynfavfcVfkc+cZHVbJac0ZUeBiB0aWTLKkecO9UWq7VZ5
8bULy361+1Ii5SnqN/d2d2IdML7WA3jn75/Wf+jWPL3crVCVCaeHd+V1pV2IYCY=
=2NqB
-----END PGP SIGNATURE-----

--wxsv2zsxQJemov+e--
