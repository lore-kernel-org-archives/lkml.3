Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985AbaCJJfW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:35:22 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49956 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaCJJfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:35:21 -0400
Date: Mon, 10 Mar 2014 09:35:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093515.GI28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-5-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="K0AQBF1xgSW5nubf"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-5-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 5/8] regulator: max8907: Remove regulator_dev array from
 state container
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--K0AQBF1xgSW5nubf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:48AM +0100, Krzysztof Kozlowski wrote:
> Don't store array of regulator_dev returned by devm_regulator_register()
> in state container. It isn't used anywhere outside of
> max8907_regulator_probe() function.

Applied, thanks.

--K0AQBF1xgSW5nubf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYdPAAoJELSic+t+oim9ieIP/0T92LbPWa4uhB5kUEJnIQaD
TppYgoca/UyOdQfutXgBz/+/jCVKvAiUvI8qPfczUUa/qikJClKXfbvxdo+5+Zcz
r2/ySTSOiJ0qSQO/ekm2DJcB/mt+bsZNK62Y2sllqmy5Oe0mrn1obbHygtzPgili
/0soAUvts4PwdfWmQnK+WGVQOZR00HDXzchyWIQmcGOXh1BgoIpojaSJnO3K83LC
0Dx6mvH2eouk3KXcrYF30SWbxdkiNB04Xg9DzVzidzfyYQs3jmNLJIJ7jwBccaCN
iaUS6K9NW6hZ5IyxO1Jf469dMB39oRKDa9aimiEGb72nA4dvzsRRjnuAZKU3Qq6K
6yza8cXljNRo4wwNo+IN45W1UDxK69Z107NjY4D7e/aTW8pDSpblnNmPppM0tlCF
QpP8NjXF6oCn9+4iZXJLdX1K1OoWBYQkQ0We5Lhy5Y90vf0i2gwwP31nlhkPeLvW
KtaMa0yNfNgiBoZTw475UndlQXwvoAR45IDvP7LN3H0Gv5n3eHLrvl+PAdiA5a4l
Eo8em4yYSD2dFilM6B208MsnOMtb/SsZ30QYTufVUR77hkbaacxT8Czzu0egJJlS
8/cDCCifMf8BUg5aH2SXUAusaEKr7dnyrLDF0SYtTRcBgkNLdAec4w5+IUJFoHOu
uWoY3SmxBt+eIJxhi6B2
=5tXb
-----END PGP SIGNATURE-----

--K0AQBF1xgSW5nubf--
