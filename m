Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaJALic (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:38:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56389 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaJALia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:38:30 -0400
Date: Wed, 1 Oct 2014 12:38:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Pramod Gurav <pramod.gurav@smartplayin.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-gpio@vger.kernel.org
Message-ID: <20141001113809.GT4273@sirena.org.uk>
References: <1412142466-14932-1-git-send-email-pramod.gurav@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ia6OAXuaU8F3AWLD"
Content-Disposition: inline
In-Reply-To: <1412142466-14932-1-git-send-email-pramod.gurav@smartplayin.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: remove use of gpiochip_remove() retval
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ia6OAXuaU8F3AWLD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 01, 2014 at 11:17:46AM +0530, Pramod Gurav wrote:
> Get rid of using return value from gpiochip_remove() as it returns
> void with a new change in kernel.

Applied, I'm assuming that the API change is going to be introduced in a
future kernel version since obviously it'll break the build otherwise.

--Ia6OAXuaU8F3AWLD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUK+egAAoJECTWi3JdVIfQVBEH/0Ndu/7QPL4a04KoTt2tQ/3j
kAFA2UYyA07bvFUdnFlYm+nAm+hle8dMvChm3zgTGNnvzYCPfGOpwwL+cuY8GaZb
Iz7d5Ly2kPS5SY0obDngc1Vh/6TQWTx3sYg5W5mVdPynw9PcNi44Eq3ulNFuhaE9
XviJe72jbt440BMQQSHrTLlY8+Tmtl8XiU69gNXxVLd+lguV9DmAHwwZ9ficXP0R
TXYkN+bb7mtEXuGHKJVEodYNuu1RCH0Un72ve9Mya8Ce0eqf7euMJUPcVtDyEYvH
UTq3nXc8iB4/OaJSGWFMq8k9R8CYGtkSo8DbmQ3ttFZbFVNbocI0j7kA6YHOm1g=
=nkg+
-----END PGP SIGNATURE-----

--Ia6OAXuaU8F3AWLD--
