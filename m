Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760192Ab3LIRjR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 12:39:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58314 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab3LIRjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 12:39:15 -0500
Date: Mon, 9 Dec 2013 17:38:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Liam Girdwood'" <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        "'Lee Jones'" <lee.jones@linaro.org>,
        "'Bengt Jonsson'" <bengt.g.jonsson@stericsson.com>,
        "'Axel Lin'" <axel.lin@ingics.com>
Message-ID: <20131209173851.GE29268@sirena.org.uk>
References: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ftjCgYj7ABv2ooUJ"
Content-Disposition: inline
In-Reply-To: <000a01cef251$c79ea9e0$56dbfda0$%han@samsung.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/6] regulator: ab8500: use devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ftjCgYj7ABv2ooUJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 06, 2013 at 04:07:09PM +0900, Jingoo Han wrote:
> Use devm_regulator_register() to make cleanup paths simpler.

Applied, thanks.

--ftjCgYj7ABv2ooUJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSpgAoAAoJELSic+t+oim9m74P/iFEZ5P66Z6dV+gpbxT2KFf6
BJKn9rRBj6ex0jj0lc4JW7qZMVcoLfLqK/p0JVyzxe80g7hFferPccrFoNg9zpoW
fTaIRKNCSpoq1nFeKRiRzN2UfQWHHOA9iZ5ubHCa+d4dlceyEX0lgm/v5kP0BZtQ
Iznw5rl3Ff7mOmeVU9jWxqRduBqKYaQxaQtppVeWt52tMKc+RD+zrYKQXTAIGJLK
d0QfUFdkKv1z6V4qHPr49wE/Qe6yL8crOk970V//Rm6+8Co49FSam3c9g/qDnwFK
OorjuY79DzvT7a+g0V93usc1OdIk8mcHnKsVXRmuxGozJ+cAiVkZw0cm5/Dv1d2w
+XknOZPdT3K8jkLx6E/ghinBSlAdUFVH/t2zhwVmgwJOLn2/ZpBx90SBkKpB52UL
P8V62Ycxh+T3pzqEhJP5Yn8HzJeEoCGh2JEacVlFK/OvNeaKXRMSAkAfHKptMjlJ
vYq32mAv0afyTwWQHP+Cwf5vH8xgA39hyWkkVXoPGioqWGe3uGrQhSUSqGuljo6Z
2tPx1lUqK1/MbqTIqgfAYYQb06yN17MqAm0W0EvGYWoI80I50L87n9gimeYpBFc5
ygiiRfT/MmniFZyhtGuptvvDFs7MK+SGlxFmr8udwoHYP9qzQlxSLmoIZrPuSK1Z
mbvKR0XZC0ATvP2YX0fL
=d6tH
-----END PGP SIGNATURE-----

--ftjCgYj7ABv2ooUJ--
