Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab3LaNGe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 08:06:34 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56664 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3LaNGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 08:06:33 -0500
Date: Tue, 31 Dec 2013 13:06:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: lgirdwood@gmail.com, nicolas.ferre@atmel.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131231130629.GY31886@sirena.org.uk>
References: <1388453272-5287-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bL2/s+BzS+0mqUOB"
Content-Disposition: inline
In-Reply-To: <1388453272-5287-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: act8865: register all regulators
 regardless of how many are used
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bL2/s+BzS+0mqUOB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 31, 2013 at 09:27:52AM +0800, Wenyou Yang wrote:
> v2 changlog:
>  1./ Rebased on the latest code of for-next branch.

Applied, but if you are including a changelog in your patch please
include it after the --- so it doesn't clutter up the git history.

--bL2/s+BzS+0mqUOB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwsFSAAoJELSic+t+oim9NTAP/AuWNB0k9FE9joVWjen1qQ2Y
nePxkj69SoEZM5Iu5JyPjsG3qGRbLdc/vZXtdy1EzN9HMZ7FmK0OPPNkngAKFX/g
plKmw5ykYWOAXqT0T6as/8ALJ9ewnQfxAtKGDp4DvBvMFZaYT2G35VDn/td2JjiE
ft6l5+vxFYD9ZxhnrLds2QWXsDsh3M2tnyEtfhLg3f3ZMwpSN2rXGm5qa6MwJR/5
nVAsSELsRdC8NQP16O6L/E5mxiCdv+TF4/Eu0TGcmPPMaoQ+kwU+NhMet0Uwi+aB
HbKu9rMy+zl56LH3L9GGQJaDTML0ZmfOiJXxI6DgbFib2MKtlHBKm00alxI4JH4p
DaPXpk7Y3fEn05TGR8lb6K9n5dE60HCj5/7glPVHvrAjsQcuCXUnyzkpvnKY2ROd
wbvvPevxfZfziXfHQaD1eaOtzwf6T/wNldBoga8M38nSS1C+azXuZ70YCVBNnzv9
5hWeG3P9IYcYFvtX89pPM1dh9ghkaghypUuJYiFgZZjaT+Kq4AELB1I74jtYnLzC
MtmBzBtJEuBqkRpMwgOlx1MtpClic+y05CBLDu+b3ooTccXSzA68Vs1YdOhoFlEy
HPxR7geD98DRJdQtEn8JrfGDnD4aBYJSAQ5R7OaMcOUGaynym/ZUhQdB6rTu2haI
NGjQoxUYS4HuS4lPII7G
=Taes
-----END PGP SIGNATURE-----

--bL2/s+BzS+0mqUOB--
