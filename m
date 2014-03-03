Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150AbaCCCKT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 21:10:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54534 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbaCCCJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 21:09:37 -0500
Date: Mon, 3 Mar 2014 10:09:33 +0800
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Yadwinder Singh Brar <yadi.brar01@gmail.com>
Message-ID: <20140303020933.GA2411@sirena.org.uk>
References: <1393581710-17754-1-git-send-email-k.kozlowski@samsung.com>
 <1393581710-17754-4-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MRlEjvj2/M31Nfs"
Content-Disposition: inline
In-Reply-To: <1393581710-17754-4-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] regulator: s2mps11: Copy supported regulators from
 initconst
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3MRlEjvj2/M31Nfs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 28, 2014 at 11:01:50AM +0100, Krzysztof Kozlowski wrote:
> Add __initconst to 'regulator_desc' array with supported regulators.
> During probe choose how many and which regulators will be supported
> according to device ID. Then copy the 'regulator_desc' array to
> allocated memory so the regulator core can use it.

Applied, thanks.

--3MRlEjvj2/M31Nfs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTE+RaAAoJELSic+t+oim9KxQP/RqpbAJ9udNypZfZxXXG5eoJ
NsK8wBrz7NS1mp3ab1dMkmNXPzrax9ZPQOkRsFZv3O0Q5tGCS+xh7LdvZ5VYwgxN
PlQi5FcBxOrr9eudwPTELeQ3eNoEX3OWCAsFW3+SSORbCqp744sNQWSGnRAkMCvC
ygR9sn5vhQ7JN1zpO63dN4veoM9FfttpbAYiJnlhmQgtLxO/cwajnIo8J/EuyDgh
dGveRW+kGv+WsN7b/Z6OpXveFTFEd1TatSdY3fQXBU0YP8Ja4hbz0bBUJItzVy2n
pAkyBrmiwRGOEX7ku9pfl0K9S8G0AoX02srZbQIBHFfm/KqcbZdDdmjpvAH+TAwg
FaRKfJzPTpH8e68PF5EQGQiTQUi2qNAZWdpAGej98gXZOMm/SwBFMPtuU/rvx3M4
oDMy1uDqQe17Wm4b6rraHJhiW8vNUkLNTFf9BokzqWj/NNl4OFRqN1ImkvTFtzIY
c95bL7upD/2CwV9silN+HJsIRAa1/ED0Aara1+xMgOnU9Eusd2Jv4H7zVENnAqVz
3j8fb9zFts9hvaw+jI2WlNFWHnBkuMZUdbv5cidwujJNjEu9TZxrCSVImm5NE/id
5ycyycc25EVGLeLKxoivaNpp3QO5p4lkbIcbjOv4GgQQOvaKplyNdJ6WxhNbRR2h
O9oABlhyYhWUmp6M7EZU
=XC9a
-----END PGP SIGNATURE-----

--3MRlEjvj2/M31Nfs--
