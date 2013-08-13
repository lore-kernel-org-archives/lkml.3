Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab3HMKUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 06:20:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33981 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab3HMKUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 06:20:36 -0400
Date: Tue, 13 Aug 2013 11:20:13 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Steve Twiss <stwiss.opensource@diasemi.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130813102013.GU6427@sirena.org.uk>
References: <1376233486.13932.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cX6v06kgJwdgCvne"
Content-Disposition: inline
In-Reply-To: <1376233486.13932.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: da9210: Remove redundant MODULE_ALIAS
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cX6v06kgJwdgCvne
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Aug 11, 2013 at 11:04:46PM +0800, Axel Lin wrote:
> The modalias is set by the MODULE_DEVICE_TABLE, thus remove redundant
> MODULE_ALIAS.

Applied, thanks.

--cX6v06kgJwdgCvne
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCghZAAoJELSic+t+oim9JUgQAIUl/eYlaelOiWowzywm2fhu
GqTA4syKTXj+cJfAfr7HflkABqvAjBqWpM9f8Zo4+ew/xLarN5etqvpspJmYb5z4
Rm6ezk7WZZ70oitQQpJ44mitARRgAGl0RF+AvCPZpqHN6PMAL57YBQH6BOiqgTt5
bAbCQLB+GJthXdDNuLactZRT04r0CYLwaigVas6Ic4FGnkn+bhAxC8xkoEf50nq3
Z7WkfHjPZVQQFuTylB7FZblMZv0qWiiiqeKu/ra2L9Tc/Pm31G6AM/6R2G1p00zN
9MYq0TATXU56IsYj7jg2u0n0A9ptP6ta64frNNk4hESoee7GMANMIIp0BPChKlnv
Sf+wGaU7FCz/mDKpSE/fGMgJ1G6xcR8gJAz7OooiGCi2iHQnYxuwVh7I1eVPbmQ7
Ro4WAUo87g57d9ECvacvlp0XQJyQqa92S89XNOhYz6ysc9liK9b70e78yb7338Vo
bQsADtS1Ln+zV5R+XF8+RzHjo4DBvCLNB8wNgoOFomaLSMbFagx9WJVndwlWgtAR
fqi2d5xxyd7Cp1nVc6BvwWxSEEXBfInpHIy6lk/JNruuQroOGX0+SWWsswByKBzu
6VY+ohY2C0nruGiytP0KSrIu25kHyYgAC96YRdhP7ikdLZltcHATC740tXgCSYAv
j6QuQv6fRcXsUjpOaxhf
=5D0d
-----END PGP SIGNATURE-----

--cX6v06kgJwdgCvne--
