Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393AbaJ2KEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 06:04:16 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54874 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091AbaJ2KEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 06:04:14 -0400
Date: Wed, 29 Oct 2014 10:03:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141029100338.GS18557@sirena.org.uk>
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UiS4BJklFEZwuLgy"
Content-Disposition: inline
In-Reply-To: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UiS4BJklFEZwuLgy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 29, 2014 at 09:15:59AM +0100, Mike Looijmans wrote:
> This patch adds the LTC3562 I2C controlled voltage regulator to
> the kernel. The driver was tested and developed on a Topic Miami
> board where this chip supplies the IO voltages for the FPGA pins.

Please don't send cover letters for single patches, if there's anything
that needs to be added just put it in the changelog or after the --- if
it shouldn't go there.

--UiS4BJklFEZwuLgy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUULt5AAoJECTWi3JdVIfQvlIH/iGD5vp9JZRhthQc1XvmCi9U
9ObqBQHwua64ZPfeeanq43GhCwiYCJx1PDLGP3U7NejyPVOTAzqklYJ1ZfiUuMKb
WvuTHiMCPjFTgb1nXmko8XXl1TnvPDcXQYoaDLyftAjKf/W3/sV6C8lREA8b2bCb
YIWcuXPQ7M5/6QOO6SxUV4rlwLUOOPBY0EEnLomj8ako8/hgEDCQjMaQYpzwkvql
L+6Tan+mHogO/FOuTwXOExxV4qV1f0U+nXimof+N+mKPI8HFaE3BJug3uG00EMK8
Y1OptAhupo1FZFml78O+vQOYXcGIjbSpcb2/A2hSeRq8BZERo8vtBrrMWC2PFAA=
=9bLW
-----END PGP SIGNATURE-----

--UiS4BJklFEZwuLgy--
