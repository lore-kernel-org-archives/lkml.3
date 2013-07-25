Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755197Ab3GYJQy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 05:16:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56534 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3GYJQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 05:16:51 -0400
Date: Thu, 25 Jul 2013 10:16:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Robin Gong <b38343@freescale.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net, lgirdwood@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, s.trumtrar@pengutronix.de
Message-ID: <20130725091642.GT9858@sirena.org.uk>
References: <1374723198-9716-1-git-send-email-b38343@freescale.com>
 <20130725084042.GA19368@S2101-09.ap.freescale.net>
 <20130725085809.GA10765@Robin-OptiPlex-780>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B/Lq21QA8i0npSXU"
Content-Disposition: inline
In-Reply-To: <20130725085809.GA10765@Robin-OptiPlex-780>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5] regulator: pfuze100: add pfuze100 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B/Lq21QA8i0npSXU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 25, 2013 at 04:58:10PM +0800, Robin Gong wrote:

> Shawn, I notice there are the same descriptions in the many docs of regul=
ator
> drivers, can we consider the 'regulators' child node as one of special pr=
operty
> ? Sorry for missing the information in the last mail..=20

No, it's just people using the wrong language to refer to them.

--B/Lq21QA8i0npSXU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8Oz3AAoJELSic+t+oim9pl0P/0ziiHxb3VVKALnnVHZ9wboR
hZSj4fFsRHRg96NdExXIsTweGVa7HanQRNjPQC0Ww1tJjJDvHpQK21gMuNtM9Pdb
nzoAAsMd42oxinTorwgT6eVfSYcQs5qV8EeNILJp6LnYXOZCB9B2lVYwZO0zi9vy
5D9XFO+jO/svAsaz2IkIrbl7EftUqJT/JD0nSk+GBta4B4rRNZxW93eLJXSN0gH7
RA+bs84Cma3Ceg0lRExN4ENECf32T5Rvzi1PiXjSYCr7F6qkCY4kJhNUywvmbUpz
udYBea4fuY+aHXTBKGBp6WmDZOHc25cd5bggr9eUjUIBvARAvs/AooqDwqm3o6Z1
cJvEC/cWEQSWk5DJzWwdqDYaoWpOfTL1y82uHx97sygrgHmlp5T4mYKq1Ta6YRJu
VtOyIhZLZQkpgB1wwNLYYqGXhVNuzGFyQA6UMC8C/Q5K7PCTYJegxhp7ffRIetmL
RNu8aQMRRz6CuZksbqvyxrf+XqdNcaFjxW+dOpY1sZcvZFxUAYF/3Te+FE//IRwb
5X4J0Z/WprWLY+LLRY4piUrSt2/Nx06G9ubB+wgCAiDMRk8G3FIFNfQMZFdQ0MBl
Oh9U192t1FjepPb2pVYTkaVRD2eNIgEhW6wA2XSqLI/WgP0Z5cHYivRrKsbYq+gH
ocgu5Z9fqgje7gEB7g0N
=f0sI
-----END PGP SIGNATURE-----

--B/Lq21QA8i0npSXU--
