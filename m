Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756165AbaCDE6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:58:54 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55121 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755985AbaCDE6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:58:52 -0500
Date: Tue, 4 Mar 2014 12:36:03 +0800
From: Mark Brown <broonie@kernel.org>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "lars@metafoo.de" <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140304043603.GI2411@sirena.org.uk>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
 <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
 <20140303045952.GO2411@sirena.org.uk>
 <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PXCmn3RzZ5puKDEC"
Content-Disposition: inline
In-Reply-To: <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PXCmn3RzZ5puKDEC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 07:24:36AM +0000, Li.Xiubo@freescale.com wrote:

> > >  	/* Default to using ALC auto offset calibration mode. */
> > >  	snd_soc_update_bits(codec, DA7213_ALC_CTRL1,
> > >  			    DA7213_ALC_CALIB_MODE_MAN, 0);

> > This one will fail.

> Sorry, I'm not very understand why will this fail ? Before the ASoC probe,
> the ASoC core will set the I/O.=20
> :)

OK, that's now been refactored.

--PXCmn3RzZ5puKDEC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFVgwAAoJELSic+t+oim9fDcP/1Qxk7IG1ZAYa7yhDoYlEpbZ
lKvQTuen9uToFzI1lgOOA0QX35vm25QkVxwNBHnvjSFmHgNwaXKNnbkih55Jjxca
36s8YgPh3qKL8lSn1Xtua0TbQu0HpTMYqhLs0gsgMZdSQHHYG++MWuEkYpicU1V5
SYle/z2wsW8j2fHejI0rGi7D6jzzBO0mR7/rTPH84YruV4EU0SSfp8r9CwA1fP68
/o0fiazHeFMlPNhCShHHw/dhDc2ICin/sTT4L88wmig15NT9Bs41pcNxQvEs7e3X
LnKvF81/cg0nguErxlfitNLdNFpnz7UbcgXMxPzIgIwPKEef0MqtNG3WUBeAjIkf
yt3z469ZZbEE4HZi6T1A3hgaUujWyEuWWzDF84maThISNxLy/OyMbOEWA8p5xcBb
6kN+jyPRvd+TNKEKvV74VpMjWAZ6Yt86WSvbWWfmN1UbYe16DVtLHRXSUhE/8Ki9
CccNREjN3/YsZAd6NN4B3BCvC5o5BO3JkhYh0XBef2WNX9v4GiqKUTVPcfL8hff9
UCpZJIwdaXTBorzFVKQ0gTT/E7aY36pTDyWF0ByryY8u5FthHDsAgdhEa/e0crbx
LcHxmtZu7ztlALLwbtTisdVW2tSCLbDXnTmJfPv9Z0P8TD9vjPtw4kcdSehN36fb
r6sONSnuOx6Pe12PnK7L
=Q2Si
-----END PGP SIGNATURE-----

--PXCmn3RzZ5puKDEC--
