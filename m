Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935204AbaLLSNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:13:20 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57036 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935064AbaLLSNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:13:19 -0500
Date: Fri, 12 Dec 2014 18:12:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Andrew Jackson <andrew.jackson@arm.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lgirdwood@gmail.com>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141212181244.GQ11764@sirena.org.uk>
References: <cover.1418372910.git.Andrew.Jackson@arm.com>
 <a3b4a11dfe1688eea07471c6cfa27676cc9a58a8.1418372910.git.Andrew.Jackson@arm.com>
 <548AB75E.9030302@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DgyySQcJ59QCrNUU"
Content-Disposition: inline
In-Reply-To: <548AB75E.9030302@metafoo.de>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: dwc: Ensure FIFOs are flushed to prevent
 channel swap
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DgyySQcJ59QCrNUU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 12, 2014 at 10:37:34AM +0100, Lars-Peter Clausen wrote:

> This should probably go into the prepare callback. prepare is for example
> also called when recovering from a underrun/overrun. Whereas hwparams is
> only called during initial setup of the stream.

Indeed, that's a better place.

--DgyySQcJ59QCrNUU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUizAbAAoJECTWi3JdVIfQhV8H/i1tVDyivMVCJ2KEiemPRPh3
mx5oDLjdRbUVHCrPEyKS+Aur+mWJ7Jn0SVMKbkoajlRPzCp+ZvYsS7BNg7v3IV8E
ODg0WHetvCNnz/+O4ZDdgSSf9mGjRxv8vzKXsfqzSEuT0P5xRCUQ6tvO9OaWRHns
s/Lsdu3TBGkGF61qSsnuj97CJxgdGGuoWYjoJ5PLiQxKlVnzgiS5/UX0Az9mI2hA
DH0kjlVumQVFcmnTlm2S1iwfppPWHqKNFtxMN1miQRBSaOhyc4CCan5Fyeh88Slx
eY60zbLVE0FbUDpD/4pSHeHrG2MWgwUarz5JngUfokfa7HVLpH6DqxLc1UjXHA8=
=mSP6
-----END PGP SIGNATURE-----

--DgyySQcJ59QCrNUU--
