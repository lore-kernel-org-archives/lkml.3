Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753995AbbANRSy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:18:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57156 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137AbbANRSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:18:53 -0500
Date: Wed, 14 Jan 2015 17:18:38 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jean-Francois Moine <moinejf@free.fr>,
        alsa-devel@alsa-project.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20150114171838.GY4160@sirena.org.uk>
References: <1421179417-23698-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2+IDmuKgu0wSQZlt"
Content-Disposition: inline
In-Reply-To: <1421179417-23698-1-git-send-email-geert+renesas@glider.be>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Fix crash in asoc_simple_card_unref()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2+IDmuKgu0wSQZlt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 13, 2015 at 09:03:37PM +0100, Geert Uytterhoeven wrote:
> If asoc_simple_card_probe() fails, asoc_simple_card_unref() may be
> called before dev_set_drvdata(), causing a NULL pointer dereference in
> asoc_simple_card_unref():

Applied, thanks.

--2+IDmuKgu0wSQZlt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtqTuAAoJECTWi3JdVIfQSpEH/1dq2UiGyLtXhJQMMso1FSBf
SnjsqSpspcbV7bjMPJJWI/f92411NgMYKxcix0W9dTlma9qYYfqdNgaBIPYyq+T9
YHAqOCyLm44qJlnucGF+LCqPbrxUFo81y1LZjGGQDEHgSajqmmvA0CkxVzHEzCqH
QAbeAQkpDDShpbeDNlecZSx0YF4I1/hdnHGvthXNKIenT2NL+Zk9SOkSsFf0m2LP
s+PF8DbhyRbSR7o3I2IHIh7gWE+D/WhjqfrhQ9uSHY2T72PJOR6P1d+2SUER9wru
mANqDmJXZsk93Jm7b2wiHHyWiyKNxDQHNoVT4K+w1Nvo+0pRUsjFAyEpW8VFpms=
=gqwy
-----END PGP SIGNATURE-----

--2+IDmuKgu0wSQZlt--
