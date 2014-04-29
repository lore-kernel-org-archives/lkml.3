Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758375AbaD2SiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 14:38:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49630 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756766AbaD2SiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 14:38:14 -0400
Date: Tue, 29 Apr 2014 11:37:58 -0700
From: Mark Brown <broonie@kernel.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>
Message-ID: <20140429183758.GH15125@sirena.org.uk>
References: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lrvsYIebpInmECXG"
Content-Disposition: inline
In-Reply-To: <1398705774-12361-1-git-send-email-maxime.ripard@free-electrons.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.133.115.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Force the registration of the spidev devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lrvsYIebpInmECXG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 28, 2014 at 10:22:54AM -0700, Maxime Ripard wrote:

> spidev device registration has always been a controversial subject since the
> move to DT.

Why can we not handle this by using sysfs to bind spidev to the device?

--lrvsYIebpInmECXG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTX/GDAAoJELSic+t+oim9OO4P/A0v999A839gFBUtIPsjaZfX
fnwlIoUDAfj/yS7P9TkW71a2f3NmObpKsCp3dmphQVLG1il+HgSkGH/qihaDruZw
AvcIoFWE8tnwPRSget1UykDzkMuYzMqBc3TeyR02yihiEt7nUHDesEQtfwCfSq/j
2yq+Rvw4UGyCVJ08Zi5hbrGbzSB+XDjNX1vY/jRRNjKZXepNbqrPuDyhfZ+XyZbz
ijTv/V1MU36oTP1aA5JNm11GMjD3/8GQ/wCq0CsoCRJiaPnZpgvSUXgAuXTIHP+H
d4Rm5yn8xe6EzAJn88kUjVLpbTbq+DxGVtXRMGMlFgkIBphI3G48QoU6ojW9jqzT
c9lzJy+cmqbvB3typBNk/AbgYLKrkl3sYBl/k/FjVbkPRAINkKreOkLCuCw5ZdxR
44b0xsaH2TvT9yml0Xj0y+7STBbTXGvX+t5+mipG+Ridx0a5lQ+NAcjzEt6or04c
q86GOgvSjmTSA6JzhFLTlu+Y8kYYT4wKW1jblnvLCLe6pigNXF2oqKWlWn6ohtAp
+PZKBwcbvuCXCU+0gMF6tVHGzTRu37xzD5pGNp/wMNN4hV8oLzWh5I//fYhj0ngg
xZKZ+WfwKv9VchoTiTyVMfLGMf4Ri0AGAbaAh3vR/qoWiACIFw0vWL4RxZjsnbu8
0CniKFUtrfu7BCF37IEg
=omHj
-----END PGP SIGNATURE-----

--lrvsYIebpInmECXG--
