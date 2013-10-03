Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640Ab3JCPue (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 11:50:34 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45961 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753814Ab3JCPud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 11:50:33 -0400
Date: Thu, 3 Oct 2013 16:50:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Florian Lobmaier <florian.lobmaier@ams.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131003155002.GT27287@sirena.org.uk>
References: <1380718076.7307.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCKkSrrNUaKEhaIQ"
Content-Disposition: inline
In-Reply-To: <1380718076.7307.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] regulator: as3722: Fix equation to calculate
 max_uV in regulator_lin_range macro
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lCKkSrrNUaKEhaIQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 02, 2013 at 08:47:56PM +0800, Axel Lin wrote:
> Fix off-by-one in the equation to calculate max_uV and also adjust the _min_uV
> setting accordingly.

Applied both, thanks.

--lCKkSrrNUaKEhaIQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSTZInAAoJELSic+t+oim9FbUP/RWq0ZdOoBsnITBcOQ1kTOea
KZOVwNkOL0l2W1KGJDMME8TBrOKYjVQkvS/tQzMB4LQnb6BVG1fROmeONJv06Vsr
zvdlmuRhx9gaiYYw9gCS0gXJy9Ii9CnL4VSK8eKWSiJt7kzJ7RWVNJjkW6oXoXu8
fgC0CCDCC8MJC1F1kSFn+HAaZ1YR9yaaNkrmvkmHlF8LkmTws02bbsTbDD0J/QAI
zUCI5IRsdlgqgdyCBFIq7/e7yzMuEln+vqioGPHZY1GF5SEbfhb2ksoT/YIYuBS/
dMuUzckUaOhR/Wg7ps+iHWM6Wq7PitfN2GhrwvuyQwH1bd5Rb31Efcz4TNtc0r+J
qq2NFBUSGjjssKXn36fN78Pp9ZL3nQkERg+DL0zCF1VPzPxFTK3KcFPvw9wTGNtq
M2bUuIbJBbf0lQDcKbKQzqeRXeAmvC/+IzfS1plCXpr2ltZ+AXi5hcfqGYwgCdyw
lYiRnF7ngAc+eiy196/Lp9jdO/WWUOW3+SKJXnhYD9UAgaVfOqKcbAxGlm3nxkfJ
OHJ+ukKui9bW06qwmxejO28v5vL+8fD/DJ2opkSqyeUQcuBQOAY4pLrzlRTQDeM6
C3zQz5Op8mQGWWSUZ0A+/pUykhgAwTBqhYcM+YCgVy07vPvt8KSRScl29YvIqqu+
+29k2ydCnZxyns1VmzJw
=HLhb
-----END PGP SIGNATURE-----

--lCKkSrrNUaKEhaIQ--
