Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3FQQUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:20:36 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52596 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752354Ab3FQQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:20:33 -0400
Date: Mon, 17 Jun 2013 17:20:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, thierry.reding@gmail.com, patches@linaro.org,
        sachin.kamat@linaro.org, alsa-devel@alsa-project.org,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20130617162010.GJ1403@sirena.org.uk>
References: <20130617102000.GB1403@sirena.org.uk>
 <1371465657-22981-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A6/RaK8Cbiy3x9M4"
Content-Disposition: inline
In-Reply-To: <1371465657-22981-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V3 12/15] ASoC: spear: Convert to use
 devm_ioremap_resource
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A6/RaK8Cbiy3x9M4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 17, 2013 at 04:10:57PM +0530, Tushar Behera wrote:
> Commit 75096579c3ac ("lib: devres: Introduce devm_ioremap_resource()")
> introduced devm_ioremap_resource() and deprecated the use of
> devm_request_and_ioremap().

Applied, thanks.

--A6/RaK8Cbiy3x9M4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvzc3AAoJELSic+t+oim9e0EP/0UhBdVI8dyz8+Avw6xsx6G+
NvByUFwaLyw4qWx3PvREyAFuwI+VYFa3eG6LGJtFOTXT92B08BX5phYKa/EEH+6/
lfuHLiuD88ksJDFiCCtRYoYD++7P5DHhR2trz3qgSMNWTUQRowKWyYjMhZhtrdcJ
ScG1djObnBeHsAHAtYvICfcQgbaCjSzbnvtieNsnBpnwpz5Th0jMwxq5BoZDJKUi
cpcpEcGJkxJwWaJcd8+T//OrbFHamNbBQ+fWibU3+wCqtDlNyKu+hSIA9Pgt5H7l
ltVYCwZfzVytUUk7FMtkRc+4UDr8oXIQj9Z/SyZQZWRCAFRqAHDRt5u+gWPgkNmY
nPeODbTCBJtoK2Keoysa+bnle4oxOJPx+8MPRSQ5S0Vgym7fohAJhgitdEMGIWDM
+prJmN9sfT/s+2qMali/eARk5gkXWbxN4SJCjRPeNhPXkG/F5EqmeLOaIMjhJfx7
rHRNXXheUvUsEciUFWFpXSlT1R/bMAavXXYegbeAmSR+CHxju7GOfiMTZRuNCyHb
llzaELdm9fhOqSprCsghex+zcEyEJdGnfPaPbPrjpZrepIU0z2yyEgI81EE7qbi3
dpae+OqDGbhtHi9ybEUXQUbkMXUzO5UDHNCRAzpAmeD7guo1iDXISsWZRO2xvPBt
1DAW/An9QYnlzDdW81Gx
=yL2B
-----END PGP SIGNATURE-----

--A6/RaK8Cbiy3x9M4--
