Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbaBTMCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 07:02:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47331 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124AbaBTMCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 07:02:50 -0500
Date: Thu, 20 Feb 2014 21:02:43 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com,
        Laxman Dewangan <ldewangan@nvidia.com>
Message-ID: <20140220120243.GM2669@sirena.org.uk>
References: <1392886403-10640-1-git-send-email-sachin.kamat@linaro.org>
 <1392886403-10640-19-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zMxPFfwyjSN7AMOh"
Content-Disposition: inline
In-Reply-To: <1392886403-10640-19-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.156.234
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 19/23] regulator: tps80031: Remove redundant error message
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zMxPFfwyjSN7AMOh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 20, 2014 at 02:23:19PM +0530, Sachin Kamat wrote:
> kzalloc prints its own OOM message upon failure.

Applied, thanks.

--zMxPFfwyjSN7AMOh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBe7fAAoJELSic+t+oim92hYP/0cz3IUauOqESCOIzZ3cPuP/
MAp+Z+Eht/TXhZSrMKUBF2wCp3e5LD/7pKB+jBFfiJpm+4nBobyPM+hmRgws4ZzP
RNrkNtg1JiojVCqodIjm8TgB18uKN1/le/h2v7KW1Q4Sqpx523qX7cWrwTsDj4uR
6rZTW+bhKsowzddMiarosS42ZL1iwg5xEBGY8SjWJbnSVtvmxtWEIhNrDYXC+snI
PL1CdtbptimHuC8SuLl6FL6/k4NeHKxgh85gRx28O5361xHpCGUNhqmUhD7z29qR
XWu8IL1g53WFkFatfT5TrqDzxLCU1GisADITUH2ukZ2IBa8nOZN9U7OGLC3Gan4+
46ptq0nwOkY6JBvehYR7Y/azH6skhTT0r84R3aBKTm7+3hlyKQXJu0F2IT8tHU4z
9TZX5zhlUZTZIoYvV1Je6pkIyvODophCph2Poh7ujbCN0H2vxAt4XSiFUGXXQevU
v7kBTczUWUK70CQhdboX9VvhXHTuiBmJlBQzt/cYqfme1Lq9ihWFd+n5I+OsStzc
yJgvost/FvMChFDevjvKsD9ELaebGc1f3R5Bq+1ZrVjRomyEpuq6p3+9cLtPjHcu
AC7MTgZHyv1CBs+G4aPu9DvPniRpIhyL1qXztwGoXID0WJghylmimyrXFpHrVI+V
Q+5ZPLFbB7OREJcUtlZV
=lcCB
-----END PGP SIGNATURE-----

--zMxPFfwyjSN7AMOh--
