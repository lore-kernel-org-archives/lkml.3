Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbaBSQcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:32:18 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55408 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037AbaBSQcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:32:16 -0500
Date: Thu, 20 Feb 2014 01:31:59 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163159.GR2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-9-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QVnmAtMQlEIhp+F+"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-9-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 09/15] regulator: da9063: Do not hardcode return values
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QVnmAtMQlEIhp+F+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:05PM +0530, Sachin Kamat wrote:
> Propagate the error values returned by the function instead.

Applied, thanks.

--QVnmAtMQlEIhp+F+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNx8AAoJELSic+t+oim9nA0P/3N5Vn4WWQZ6prekqmbv43xj
wY86o2Foyem1x4DfQ3wSH/blqWfoiaSAJUv7YVctxsj7n2DGwEtgp3sw6p+3tiA6
NVfTY3N6gNIIDSUAnrVXB0BZ9N/rqk1DOkxKiuycWO/GrgFr23wLnwQXexSjT9VH
0/VLNKD1lJDsUAr/wlrqBFkVHLZCdiw/spNHoEEKF+CXdfDM95+PD7ae6QwvJ4sM
E8LqIFpCupv3GutZ46pZnUZYjfDDPXyCmib0hc3qjW4ElGXCTZpNfqHiTvDid0l8
WSp2Io3Rdb+TKIFVFgTskqOFcUmknOJXiHOWLq+bOPoZk8lRBi1A7LvYj5RFdEOG
G9+79vbQeTfKCxAzsI/ZlmBlVyvwoRkXLdBADDaEdupt2IItX0hqh8tcqwBaCzQu
eCNnUk2yPKG8b8KnfA7sWZcwY1ORGl/Hn2flv4trIsCkIJH+ZsUT9M68r9CK6ecu
hcnZsAg7dAgjXjNT1/DSc5UbCzXLsIlxGWAojSR0BxVQzYAByLn52icysX29rNuX
8gzUCk50OcqH/v4mk2pwGlOiANJkK7bB1QFYXUfJ9MfHm3OZGzrqxo0po4Ca0bYp
jE+VBjd7oAkKTOPDuPdJJj5HwvShutRIg8WTXtfGS/DcJOlE/nTvMOAYF3Ti470/
Kuza/PxAtAP1B9sPRfCP
=/mgs
-----END PGP SIGNATURE-----

--QVnmAtMQlEIhp+F+--
