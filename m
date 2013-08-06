Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756462Ab3HFRcd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:32:33 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58547 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756250Ab3HFRcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:32:32 -0400
Date: Tue, 6 Aug 2013 18:32:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20130806173229.GP6427@sirena.org.uk>
References: <1374574562-29453-1-git-send-email-p.zabel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r/w8vo2lxBmCPGjQ"
Content-Disposition: inline
In-Reply-To: <1374574562-29453-1-git-send-email-p.zabel@pengutronix.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC] regmap: core: allow a virtual range to cover its own data
 window
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r/w8vo2lxBmCPGjQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 12:16:02PM +0200, Philipp Zabel wrote:
> I see no reason why a virtual range shouldn't be allowed to cover its
> own data window if the page selection register is in the same place
> on every page.

So, this feature is clearly sensible and in fact the thing that was
concerning me was what happened when we try to do the selection but
looking at the code I see that there's already handling of that so I'm
not sure why the validation stuff wasn't permitting it.

Applied, thanks.

--r/w8vo2lxBmCPGjQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSATMqAAoJELSic+t+oim9uU0P/0fyUGT1D1RQmO90Vs0SYcBH
XwMlEcFFNTJ/69sA0WXoEOstntPJ8Z0PFrRFdy/Z4+2YTeMqx/M2qLg3khnOpVg0
WgnwlnVQL93ikKeu36HzkFofqB3u69azXtjqeCnB+6mFI+VZybo1Bv7WViccy+SO
8biJByS7WZelWIkBRBmRkgRrOMcHcIexj/hJqAp18Wq/Uwpo8bFCvRvk6PXfiVKp
++A7BF0T9+di0XS70ZWkAtpoNUw28xigBkFsl608MGO9BFvjiAnpoV7plLjVOVho
+Yfeoygu4vEU35N6eXN/mWh7sCi7F9pNkN1nXY4fu4rBb6LxVixsqgoWVGt7e/eY
yItsTvA5U8YBGQkeOfeQO4MhncbnEM8fXmSRt5hDsRL21qHeb9i/gBdpcXrWOSXe
ix7mB/5s50InWiCkMlH9AS2thP8Uw8w9tNzN1HN8+F2NWmABvq5Ds70ncy4Amaw4
MnCAupYdfS3NrfR9t3kGsHkPXZ9llFseLQkTZIoUP8hmu9DAQedjEcVllIhlrwYU
npIANgqZWl+QfcQA4GoDHm9fxWn1P7XKkA11Q7PfSRJBPnZLZoD5Ytswbzf/D5x+
ON/o2ZxxtDoHMtEbAG4zkH5h1iT+QdEg9HOGIJVgMIRuJejo0+BP4GxYfEZ/PG1h
0gs0Y1tpt3dW5RTETBll
=HMVf
-----END PGP SIGNATURE-----

--r/w8vo2lxBmCPGjQ--
