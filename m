Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbaA1QTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 11:19:14 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60660 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753866AbaA1QTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 11:19:13 -0500
Date: Tue, 28 Jan 2014 16:19:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Message-ID: <20140128161900.GP11841@sirena.org.uk>
References: <1390911522-28209-1-git-send-email-k.kozlowski@samsung.com>
 <1390911522-28209-2-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tM4JT05YTZGJchhT"
Content-Disposition: inline
In-Reply-To: <1390911522-28209-2-git-send-email-k.kozlowski@samsung.com>
X-Cookie: O.K., fine.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/18] regulator: max14577: Remove unused state container
 definition
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tM4JT05YTZGJchhT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 28, 2014 at 01:18:25PM +0100, Krzysztof Kozlowski wrote:
> Remove the "struct max14577_regulator" because this is not used
> anywhere. It should be removed earlier along with changing the driver
> after review on the mailing lists.

Applied, thanks.

--tM4JT05YTZGJchhT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS59hxAAoJELSic+t+oim98tsQAJq2xETvZExdHnB2ti3spmy/
qBMRBkpB858T30XcTxo3EY0bvf4a1jmwhL/gQYCG4ckiJa4cb+qeB/SN+n7Anfa2
nhBSZa0kWvco/k7F8OS4Llh8uHgdvY+X8HLzAcyxxeuZ2qB+bnvjpnU07DrpTILZ
tXNb7nvIqWSfeh4bZ3aLA/yOBkjtfOy/Ly0cXZKXZ9T0hM5JqeUj1RbsxxoSxidL
1pqKVVE3gLuQxGnBOGqzW48ZdgRf5mZve+4TeZhVgIVaFetZoTEU6vaBbErxd301
iKJ/a1jcr0eJWFI/CDgpA4VZw7y95Y5Aaha7dgWyAyYtbIc/T/LNZduQVBKGhNW+
6ni4bxBN2LydVlZCyMzf3trZMd0Qut60vO5VLylMx9hdb0Cvj37/Y+Rb4zFNz68l
CoSjKa/0PYmlOMeIHGGQqwij/CyC0mtvpHABs9rZKpTPd1uuO4pV+cND0D52SF2p
9VxtSzZCMCaOgOfDDB6hRJIN4J3OcS5ww2GkxbhntxH1eXzB9kTTGM/9Oj/ksdS7
Srun6I66UOJv4wOsTsPnjTtUBqgeziEEflF+qc61v7D2TJ4/X91+PfHN8GH3xQl3
dmu4eD4jxPBOxyI/ynuZ2xNOleL4zaWFY53scg+lW3YArbCafkpjFA+XXVd+JZu8
420xCjUfMY4IUQomySSg
=vwXe
-----END PGP SIGNATURE-----

--tM4JT05YTZGJchhT--
