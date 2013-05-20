Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab3EUR1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:27:40 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:45952 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754916Ab3EUR1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:27:38 -0400
Date: Mon, 20 May 2013 11:24:30 -0500
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Message-ID: <20130520162430.GY1627@sirena.org.uk>
References: <1369065275-32323-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e9ndEBTQFD7P4kUb"
Content-Disposition: inline
In-Reply-To: <1369065275-32323-1-git-send-email-lars@metafoo.de>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 144.188.69.1
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: topcliff-pch: Pass correct pointer to free_irq()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e9ndEBTQFD7P4kUb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 20, 2013 at 05:54:35PM +0200, Lars-Peter Clausen wrote:
> free_irq() expects the same pointer that was passed to request_irq(), otherwise
> the IRQ is not freed.

Applied, thanks.

--e9ndEBTQFD7P4kUb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRmk46AAoJELSic+t+oim9ecEP/3s+7/SnESrae3IdyLtW+mt3
CSJWqYhiDboOFBUi9l0pYMSSOSMzVTaZYfYX1+SRQVc2iNS9J7+80Aw0vRFEZrw/
JW4Td8X740gtYCFngrz5m1xI+3zwyCtEGyyTNSg07f5ae3XKkcegMM7t3h2ca/Xe
+C6/P+1fr1HXNkbMl7cffZlSWuC2qiv7Trmjwx4+MStwDP5flPPbwpnt7EF8qvSf
Kju8PaUdmPXWaYeuwvoHeljlVzSULTyBQ6mfAFJX2HW8ju0piSyr3BQcyYyzjVFq
XObqqPZvHlumKb/Fix7EPzTx6n1KK7Hy7bwwg7UDw+zWonoYcDbAL/fVhQUoOoim
yDj1AKOAUCH2E9XWyYPm+jL+uHeVXeuU/q5TFyZMLlFfb5ng9U5XiwEChaqIFFkn
fd+GdVAb9mySv9ZzRBbDaFm7aYORnAUyWWH5ENsyRRyTElE0GtrskXIT9XY9otS1
EPx08qrTsjv201NYTK/GhkLps3knOnh9CkFcZD3naOGpiPbi6WCWOpuIU1K6ERWd
VRGnsH3GrNMh/e8VTF7wOWmJLvrxO331RiLuvJ5//4AoZwT7FPflvTIO/mpN9g8F
5NvrsRoB24wCHCmSvwmdsUoOCoNNPTDM5HD8LV0N72GwklkTl6whOWJ7lkjh7jnu
FOCslF1XVmc45/CKcUne
=vI4P
-----END PGP SIGNATURE-----

--e9ndEBTQFD7P4kUb--
