Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab3I3RMK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:12:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33989 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab3I3RMG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:12:06 -0400
Date: Mon, 30 Sep 2013 18:12:00 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Linus Walleij'" <linus.walleij@linaro.org>
Message-ID: <20130930171200.GF19304@sirena.org.uk>
References: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yuedfix5hmtMJRO4"
Content-Disposition: inline
In-Reply-To: <007401cebd77$0652a340$12f7e9c0$%han@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4 01/14] regulator: ab3100: use devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yuedfix5hmtMJRO4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 30, 2013 at 09:50:14AM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

Applied all, thanks.

--yuedfix5hmtMJRO4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSSbDdAAoJELSic+t+oim9J3wP/0EgwlE+/3iJOPsNtGxvuN1K
a77LmNxjrpj4gABiTS6NiO2TJxEriFgNK9nQP9X//4w5drWYDAw7s03Vfzj7aJxB
td7LrVdXZ7Zlr80DErG12Y4vCK24WNKH7JnbAJXw0ck/HzOAtI80SxHz+INgsjhx
XXDUxh6+F8IOR1T8VMHTmT5bQgvuOT9t3z1iEhdJkv5+JDPGTD2xwgqMcBVAxbuF
UujNBT6GlSBzwUlU/qWAN5+PFnIMC/Lki8vajLHiq5aTrrHGtpu3aX2J+OShlqpJ
mf2DB566/8kGKynt+HnVwISLld4HVy3zOYv2pcaIV28lhtvMuAligMrRv92zzn4x
QaRLg5RP7AMY0Jn00UYUN5S0hpdLoUZpaaoYPDIbBYH8idJfe5mfzTs9kSe3nAFS
Me3pVd1sGISPXJfvkYv3z8ja7eloj9mOHoV+1aiDhPMbQbXF/SBmBaB2jKGtpyFl
rN3OQZa+U1WMIyKzMmqo5KbBNz0q9KvP5uZEuncgrCWsRBrvsWNaUrlmSC+pkggB
qqyq7iRr5QAHLh/cjWsIARhYVz/lDEFmAWWOAuAcrtqWzXg3jlsrnuyvU2oS9KH/
jsQ3BFUyPFZCMJ/Y17/ZTwdH9aQTsC8ze3EK303Q6MCza88Zarwht7yYVKg+HwjZ
ApmAsXmqkMPXMTMgYsCs
=h+27
-----END PGP SIGNATURE-----

--yuedfix5hmtMJRO4--
