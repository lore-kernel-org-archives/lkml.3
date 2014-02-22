Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100AbaBVCyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 21:54:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48769 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbaBVCyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 21:54:43 -0500
Date: Sat, 22 Feb 2014 11:54:31 +0900
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Sachin Kamat <sachin.kamat@linaro.org>
Message-ID: <20140222025431.GN25940@sirena.org.uk>
References: <1392984758-10127-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YuJye9aIuN0w6xGV"
Content-Disposition: inline
In-Reply-To: <1392984758-10127-1-git-send-email-k.kozlowski@samsung.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.103.222
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] regulator: max14577: Fix invalid return value on DT
 parse success
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YuJye9aIuN0w6xGV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 21, 2014 at 01:12:38PM +0100, Krzysztof Kozlowski wrote:
> This fixes bug introduced in 667a6b7a (regulator: max14577: Add missing
> of_node_put). The DTS parsing function returned number of matched
> regulators as success status which then was compared against 0 in probe.

Applied, thanks.

--YuJye9aIuN0w6xGV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTCBFkAAoJELSic+t+oim9gtcP/38shfjTib5dMCawqYLAXlNr
DhYciPXmz4h/i8tKwaeIMdn8yNtuLuknfyMpA/KbGiirb6+M2zG9s3SEasIXA8GA
aUdLSZZ21rd9w10mFRJMRwlleqz+xuaX4oqFnuFCdswd4vu2oDQD1VyXLZnQ12me
nJ4qmZtK22Xojk2mHd9UudWBwizBjIu7bbgnwiUX4wrfpbl3HPceIMPz/PkAffQ0
ER8oWQ9487755KjdfMkHCbsJ/ITguZiG2nMAy+aKIWa5EJVJs5rClRuzEOCXAV5G
SlfzknvPDneLxp6u/tJ1qlWS/CrB489qcCql6q8Dvx3TR7lR+1I8RTOif5CKeMUw
lXOGVYzBr+pQgehVD6AZvqSpIlaVK/3MbfStf9QHGiryG/n69/xh8cNzmZZOkuB3
uVg5BoZ8wuTZZF/JhgC0KGkEww8Doe0TRFd2agmxnKTuZtmj7zHzoHXgOyZujFaS
G4QC/x4PbOI5lEALqSK0SJjYv3w/pJscjPJ+umqZJ3bVxYRChg9JYjNGFR4nP04p
kUMOnXhyqHgseYsiQfn2+R0B0W3VI4vnoGyv9Hno16yCFxx351vib52rLr1qnB9V
WLmribNq1nZQGUe2rSXNtQcwOuQ8mM/FXxyvjFv+/HaPvxdDDdVXt06p9H3I83kO
XiIJeGBxD0BdoIbpmkYr
=4pLi
-----END PGP SIGNATURE-----

--YuJye9aIuN0w6xGV--
