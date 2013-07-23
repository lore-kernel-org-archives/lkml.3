Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934189Ab3GWTkB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 15:40:01 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54855 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933599Ab3GWTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 15:40:00 -0400
Date: Tue, 23 Jul 2013 20:39:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130723193937.GS9858@sirena.org.uk>
References: <1374506153-10092-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WiG3HOh2BFypK78Q"
Content-Disposition: inline
In-Reply-To: <1374506153-10092-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: irq: Allow to acknowledge masked interrupts
 during initialization
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WiG3HOh2BFypK78Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 22, 2013 at 05:15:52PM +0200, Philipp Zabel wrote:
> In case the hardware interrupt mask register does not prevent the chip level
> irq from being asserted by the corresponding interrupt status bit, already
> set interrupt bits should to be cleared once after masking them during
> initialization. Add a flag to let drivers enable this behavior.

Applied, thanks.

--WiG3HOh2BFypK78Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7tv2AAoJELSic+t+oim9+kEP/21ZfGhjIgLR9RfDsjym9TNs
Ri1Zi/VHFArjd82hQ//wCR760D+TgpwdxcQbpobcUomVIHSuUeBmh+B46yYHA6li
l6vq3vijwqca9VZET6ahOQS2DIvIUmM8TzlPNO70omY5dTmjO7NbnGefesdJ6WE8
pyhpepTYq29uQKG4atdFSovpWLJrwxGQYscbV9ftkFsbhg+CRJe7ILnbOSTNcM3Y
FVuyV9jbuTeYclxjFu4FHoZM2aZ2xTH7dzYqF6tt9OtABbZ51Fip24gg7YKotbHa
TRKqoCeVshJaBWE5sYtg8HTv2GEx7t9Qrcr17Qwfv+NkK33RCYhiCSGWQ0PlYb5P
1f0RwpTnST+G2WAcyeGJQs/y+SFAtAFZSebn7GTaVJCwLjw2hg2Huyto+kXOrTvg
LWRTHJmwqB9GXtznxCfKDr7he1nSFrUgohI2GEebUbdjXXgmgjOSID3UyDD4dCB7
TzSxaB26i9UlGmRuwfOH9pHyXmQHFlpr6ouhgI3+DeiHlB1vFXuebXsy4VvWABvi
e+HMRmXk2pEBTs8kmVy7ICmwyXAXHsq/vjukUgfxNASTCvGfXt83xktC/4xlaZB6
D8QzmfjMi6hNmdtL2IPys6Ry+5pZEp+h8iWZLSGZJTni/SowY34Rkc8CyP6k0Ncm
Zhv0u+rHmZQjWrh9xBps
=g+dT
-----END PGP SIGNATURE-----

--WiG3HOh2BFypK78Q--
