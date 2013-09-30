Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab3I3LB3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:01:29 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50276 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754970Ab3I3LB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:01:27 -0400
Date: Mon, 30 Sep 2013 12:01:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20130930110125.GY19304@sirena.org.uk>
References: <1380531434-15875-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8MNCZdTuKvcKRZar"
Content-Disposition: inline
In-Reply-To: <1380531434-15875-1-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: ti-abb: Remove redundant of_match_ptr
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8MNCZdTuKvcKRZar
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 02:27:13PM +0530, Sachin Kamat wrote:
> The data structure of_match_ptr() protects is always compiled in.
> Hence of_match_ptr() is not needed.

It seems like good practice to include these even if they're not
currently doing anything - for example, if ACPI support were added to
the driver then you could get an ACPI kernel OF disabled.

Note that one of the things these macros are supposed to do (but don't
yet IIRC) is allow for dead code elimination to discard references to
things automatically even without the being ifdefed out.

--8MNCZdTuKvcKRZar
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSVoCAAoJELSic+t+oim9kZ8P/2xzpLa0XGJmf+V/77bv10v0
zum52l+1lJXdF6ZXqgayvG+qjSCdxQD1lbjp1Ufi6ni0WKTplkWxUZ8DN3HXFyTM
uXAq57knz9BbZoOBRHR/Y3pvKIDpPMACbXhIlMOhlwKNjpVxQy4/Abi5hfxnQ4sx
KQpn+x9hB0Z4yHoPx0uLCdZu5ua8X02TmGMStu4uanf23JU5Gw1RZGYFEE5US838
soSTa9g3aYJZl3NodctjU6XWFxLcJHx7yksF8Cx7/pQo+xEj2KXsrG1HumdhXXCl
tj634HdZYmlTni3JxA5glfENhlm52I5/9XrWthlcPINMArfC1FFmyIiYCCEvMFP0
vREeTD/cVI7Q8n9R1HC8ju/rKKBsO7iX5OGMC8bdcmAET3u29WaiQU3xjo9k7LpK
4S8O7q9ws1zD8gLnD7QBA+wSQOCaDswkMrHMa25dXaWVONcm+J0YkJLEsoaduvoy
c4FhyYuwoWYtIHbrQTmhHstAeJCqLBKJRMEQ8H0a76FxtjbPflHzIwGxxbCUIj/a
g1joCqVFJoCqKRqLVQPYRJBP9irTb8bSKgB7l3pEBRj3lvDIUwtAdow+i+dXI4jI
0vwojTTCzRwpytBWWRf4kSC36iafswguq4elrzygxB1Z2jxG35KTzWRuEfq9YOIs
dINilwxzESAaiKCpaOhX
=OaTE
-----END PGP SIGNATURE-----

--8MNCZdTuKvcKRZar--
