Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab3JBK53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 06:57:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49315 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab3JBK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 06:57:28 -0400
Date: Wed, 2 Oct 2013 11:57:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>, linux-gpio@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20131002105723.GA27287@sirena.org.uk>
References: <1380635719-31171-1-git-send-email-zonque@gmail.com>
 <CAOMZO5Aq5-bdY3yTD3DqjUVVrTPHZodb7_vfLQcvxfJRXNok4w@mail.gmail.com>
 <524AD693.6000304@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zYM0uCDKw75PZbzx"
Content-Disposition: inline
In-Reply-To: <524AD693.6000304@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: misc: add gpio wakeup driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zYM0uCDKw75PZbzx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 01, 2013 at 04:05:07PM +0200, Daniel Mack wrote:
> On 01.10.2013 16:01, Fabio Estevam wrote:

> > Isn't it the same as the existing 'gpio-key,wakeup' ?

> Of course, I know the gpio-input driver can provide similar
> functionality. My intention was just provide a way to wake up the system
> without registering an input device for signals nobody is interested in
> eventually.

> Don't know if that's reason enough to add a new driver though.

It does seem somewhat sensible - the signal might not have a sensible
representation as an input device and the gpio-keys binding needs one.

--zYM0uCDKw75PZbzx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSS/wQAAoJELSic+t+oim90O4P/i90PuSF3MvjZ7Bp/BMERHIH
RGMQiwqCXGpjNKNpXb8WuBPJQM1QWYWkOO2CJjOB9u/IkdI9j039TOSbNlucnkrL
iE/H6ymOksi2jxnrWrSSra04gdBtTgvx8xBnnLfA4seTgiuvwcd4Zw1HwbTeLgHs
n+14YjMZOE7R6DfvHSww/Cn5aQFX+xN5vq5zmpE4I7S9EnOKavpBstrGONabqjBu
V8vH3jq/NjGcReAc6xrKGWpVCxlGO3oCJ0psFZQG0P09DthOemOyo90rc06+1YPb
eLWGAbs3oKlI+qhEqUfVOnQhMdMH/tdNXNLG2LW1q+Wu0L8KEWWG09Ey2Nuqt8bR
Hs41ic/bBSIqolrmCyzArtTMqQ/r/8yLUDMVmwjpg4wq/qPhzkPe/Jb8IP7x1L8Y
179JtnfQmRkEDh4N9yCPOEuZ4Krhd6Y4lPrpTLb0mlLD+1LBmU2l1Z1KCuR61S9J
JO2sGI/F3j2LA/YtJIrBp1oAja34gobz/ToGR6hBijfb6dLd3ghQ1z2MTtQwHjmG
T1AUcP63nuMZJ4Y3TH66m2QcEtiUTUlKELu0Yz9Cx2mZHnnj8XOwYVT0A8jmvQP7
m1dDi/8zH1AlL20meu1viJllKk+pT5ZjwcmdvGqbS2L2MgZpB6t6++dYVCZEL+y3
42iv4o5xJdi2UlE0nQea
=1poh
-----END PGP SIGNATURE-----

--zYM0uCDKw75PZbzx--
