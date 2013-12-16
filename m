Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453Ab3LPKzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 05:55:40 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50868 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab3LPKzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 05:55:38 -0500
Date: Mon, 16 Dec 2013 10:55:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Stephen Engelman <stephen.engelman@gmail.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20131216105528.GA3185@sirena.org.uk>
References: <CAJuevmB0hsfvoQcEoRUrFd9iW5kAbpGpqpTDX00tdOH4rAV+dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ew6BAiZeqk4r7MaW"
Content-Disposition: inline
In-Reply-To: <CAJuevmB0hsfvoQcEoRUrFd9iW5kAbpGpqpTDX00tdOH4rAV+dA@mail.gmail.com>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] REGULATOR: s2mps11: fix reference to regmap_pmic field
 for sec_pmic_dev struct
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ew6BAiZeqk4r7MaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Dec 15, 2013 at 11:14:02AM -0800, Stephen Engelman wrote:
> Change iodev->regmap to iodev->regmap_pmic.

One of the Samsung guys already sent a patch for this (sadly covering
all subsystems).

--ew6BAiZeqk4r7MaW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSrtwWAAoJELSic+t+oim9aWAP/jngjzeckA3Z4tiAX/G5Inzf
FmB8XAagcnLuRY3oe9vz6T6VsD+yL+EWbXnvgW4VU8bNd4yXoLf+qLBbFjtaOGcy
MZs09oB86abQB2JyBX8ErCZKGP/hEHA0c1z+RaLnATDOdP3ge9ySaFrnifHdhjLf
txgTUofzw7aojrr4W67o2FPC4ssf/NF4rblqrWGmrTmw1ZAsDZDuJQ/eFU5rojtf
KN6uFFu+3rpaMejHHZw4zeACNA0Xxo8bWhkRbWG1IfIHqy+WPw5nvOw68sOX5cmL
KQnboM7q7g4NqZek4Bl32yT5j8tWJR0cbviTqAoqiddkAqCDoe/75qm/9sSZNM/J
EkNedXpGPUAh9DNNFZAPphesTWOnwymwNgNX/EmxGEc+XDg7WL4sZdLYNn8sut+h
bA5BRJrppHKgjTTaTn2kpx7JAERndlyiH5MqkTs3G8C6e1mly7jhT1mweRt82Okb
dsYCvpnk2sx/1og7fDU7cyOTCCodMZkF15/t2UuNI+5q0QAfSmtltFSO8U0UB7v5
v9eDBfhUXXlWB+rZyzYbbbPs3MMwGYc5qsiuFzh2B9tnbAFk1k4uKx+XD+QENHrL
Y67QgpNk9Yicx8W7aAOt5zdkB2cUubfR0prjqBQzw/SXX2JU+ycDp3lnvwY+HYkX
G0zBBsxOdhIJV1LtxSJ6
=zf9G
-----END PGP SIGNATURE-----

--ew6BAiZeqk4r7MaW--
