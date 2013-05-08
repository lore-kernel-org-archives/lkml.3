Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab3EHMjw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 08:39:52 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:42508 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab3EHMju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 08:39:50 -0400
Date: Wed, 8 May 2013 13:39:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508123936.GM7478@sirena.org.uk>
References: <20130508080448.GG3102@gmail.com>
 <1368002354-15471-1-git-send-email-fabio.baltieri@linaro.org>
 <20130508103401.GX7478@sirena.org.uk>
 <20130508120449.GA18323@balto.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ByWDhVrfOLxO82cA"
Content-Disposition: inline
In-Reply-To: <20130508120449.GA18323@balto.lan>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/6] ASoC: ux500: Do not clear state if already idle
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ByWDhVrfOLxO82cA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 02:04:49PM +0200, Fabio Baltieri wrote:

> Anything on the patch itself?

I didn't really look at it TBH.

--ByWDhVrfOLxO82cA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRikeFAAoJELSic+t+oim9YekP/AlsseYdHOju1kjBW5MTS6Y8
V219aiSPsgvB1TC/JFQRsZrd5cNuvGX4GZpFEZFv0T4hNFviPld4fM5lG1otktzX
uVgQ5+i9avpevRLRP6gUlniGo+fuljoaKsnYnKnHSNw2MUlBW6Z7sGGdw81B6+2G
mhDJEXPETyZgFt4vuAslNeTmJ4UDqpkJuXlEWpiDRJKzWFLMEdQsGbGuvUGjSqoy
WisQGUC9zJmh5+YpSoRLgnXXoyOemlmpcJCYTGdcvijlklcMxfiJz3YHl0lpS4HV
JVy1a8bFfWMECNMDqJfhaamkKk8KRf+c+1zBNF6HJg7QhgzPNU6qsRKc6smzU2k1
6nspLcW1TA9Vre4RWuImO4bJru10fCmPQkqkXgqYoQbTNIe9XZXjGzEaUFSdoda7
bo8IguiC1CiKmpHEot+58BuzOJmbvevgFTCdKa0x8OsrAIJ1aDK1FFWAVI4JNrei
XJe6i8ve1f9h1UIYZlIEpi6uuA/4pX0P63Bmnrszx7tP4jwUh0ClbWY6AC8nRHi+
KgXUbudjOWwJRxyki+b8/CQnhtyRB7IcI4pJK8Oj7yMIcl6JLXo0vWdvPXyLEHxl
SnfCWkp4vdE5Oc8FO6R+jTEX9vayOq1QWUS4U6tn5vEmDYs3aXpHuIPxajuq3Apm
4++VoV/GqPiIlnc7SCyh
=4sXc
-----END PGP SIGNATURE-----

--ByWDhVrfOLxO82cA--
