Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224AbaCJJhE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 05:37:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50170 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752022AbaCJJhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 05:37:03 -0400
Date: Mon, 10 Mar 2014 09:36:57 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140310093657.GL28112@sirena.org.uk>
References: <1394440371-29588-1-git-send-email-k.kozlowski@samsung.com>
 <1394440371-29588-8-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JBmVoN0GeLJFe550"
Content-Disposition: inline
In-Reply-To: <1394440371-29588-8-git-send-email-k.kozlowski@samsung.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/8] regulator: max8973: Remove unused field from 'struct
 max8973_chip'
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JBmVoN0GeLJFe550
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 09:32:51AM +0100, Krzysztof Kozlowski wrote:

> The 'struct regulator_dev *rdev' of 'struct max8973_chip' isn't used
> anywhere in the driver so it can be removed safely.

Applied, thanks.

--JBmVoN0GeLJFe550
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHYe1AAoJELSic+t+oim91v0QAJrqiEUcpM84PXDB5kRHqGKr
ykX07cF/XYuVxi5nimfSHaE38OQp+TwHpmjmmyvFjQfwUQa217IhB6rzeWQWNJM7
5YeAHfVu1FexyYlHD4vM7UjSel8jfKyuRfqpiav2cJOqtdrLvYb17nbXtx2uwSki
f2ijexxkLFovkOeGejws89h3k3U6+4lIIR1z38LsF0rTIRsUtf2UhoM3RZoYO4IR
bWSQCZLdQOpLRvSobuXz3qYpJ++FyQJ1POhbJd3I9GAsfjkWhIaDaopg/oGUOKnE
/MqYHnjHLYlKitfMopqFJHo/+cdQmdoRzRLpXfS1GxCeF5/kkrSsBHn4NH7sR+Yf
vx8pSIC7D9HsMXMmCRvX717XqmuCm8uA6ZHQHAT1OUDmKwuvDQeWSE0PHPG45/ef
EBFSrEdpu4eXh1xO2KftH5fV8pDM2DKOTNybGqE6eoTbmtxATe8f/+5V/5cK1w9X
bIXimHu5AlZBNEzE8ytwhJXV8SAZrBhUJhOEEx5C2Ll5vHQVDkJSvSfeiQXbTxAV
Lw/EMpDHthCeRt5Y9RnHbZsvskbhjEmO5RxjW8O5KIqqQVH/oPBoQUodf4yNgout
P3QEKTTsm2966nEblQtOr07wip8f6wRbwJlr02ZOPISjAZEeEK6DavPscBckcQeM
SqCea5G3/S4IhTIe+1jT
=nODh
-----END PGP SIGNATURE-----

--JBmVoN0GeLJFe550--
