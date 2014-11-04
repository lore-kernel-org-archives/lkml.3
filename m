Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaKDUnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 15:43:51 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37940 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKDUnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 15:43:50 -0500
Date: Tue, 4 Nov 2014 20:42:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Message-ID: <20141104204234.GD3815@sirena.org.uk>
References: <1415090986-30623-1-git-send-email-k.kozlowski@samsung.com>
 <1415093122.2389.15.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tEHm/81IqsjXUEYk"
Content-Disposition: inline
In-Reply-To: <1415093122.2389.15.camel@AMDC1943>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 0/6] regulator: max77686/802: Cleanup
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tEHm/81IqsjXUEYk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 10:25:22AM +0100, Krzysztof Kozlowski wrote:

> Probably I should rebase it on newer next or regulator tree because
> yesterdays Javier's changes were applied. The merge conflict is trivial
> to solve (only removal of lines).

> Mark, let me know if you want me to resubmit because of the conflict.

Send me something I can apply, please.

--tEHm/81IqsjXUEYk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWTo5AAoJECTWi3JdVIfQj7IIAIXxHmOAzilb7YottRn546e/
d2kDF90j7TArECsPaYps8NerGsEmVJRpyUEeQJ/oLG4cAnbb3Xs9x2uiXRSp8o7t
PKFCLA1/u33ay9xj70dVkYi9uTZYd3qzq29yj3z2g6ceEOnJ9fLwdCJ40SHy5zW3
2N7HyrVMbbPwMy+utZJuc6zXc96edEI1W3iIYU7gvwaYqv8S62DReI/fdEy1534X
ZDN9+MvlmXd/4f2vCrzqAehocpn1hfbfvctcazyx77KevT0vO9cDMB0kpDA6escA
MfJ0pq6RPXbAA0rY6jhahOekNm3NajR329kLCA+AYVu8wfKhEIRvb5q43qNrzIE=
=8rit
-----END PGP SIGNATURE-----

--tEHm/81IqsjXUEYk--
