Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3FGQvb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 12:51:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52558 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754981Ab3FGQva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 12:51:30 -0400
Date: Fri, 7 Jun 2013 17:51:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, broonie@linaro.org
Message-ID: <20130607165124.GY31367@sirena.org.uk>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <1370621488-18130-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="A/O/elEosBFxjD6K"
Content-Disposition: inline
In-Reply-To: <1370621488-18130-7-git-send-email-lee.jones@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/10] regulator: ab8500: Ensure AB8500 external
 registers are probed first
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--A/O/elEosBFxjD6K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 05:11:24PM +0100, Lee Jones wrote:
> This patch changes the order in which the AB8500 regulator drivers are
> registered and subsequently probed. It saves a lot of -EPROBE_DEFEER
> nonsense and bootlog noise, as some AB8500 core regulators depend on
> the external ones for supply voltage.

When CCing maintainers on patches please use the e-mail addresses they
advertise and generally use...  applied.

--A/O/elEosBFxjD6K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRsg+JAAoJELSic+t+oim9BlIP/iWuVAaxw/NdEWIdYAerOKD5
0i+1lx2j4mHHcEMvgQLL+26v6lyM4EEWOHfMjzCZRmvTruJRYj6tExOZya6VSkbv
CaDDZu68cu+p9xnxBxINFEUqjbJaVfz9tGhIFsaWnzjaiM4EqBCJHiq9XPnAEVvc
XITzrZInmIGGYnKHzCz3ig3HVx+6iNce4UhqBH3ATw5nepj/Sx0rT2rQ2RgC1Wkq
unJmOh1On4WjCwhhlPhRhw4Qi9aviLnSB83Zv9NQlWvHEZ2/FxXc57RoxApeSDXZ
TyhShZFC0hb6H7GLrpdlQdlh1O3IMhNUCx34UqNvt7TswPl9qQIMAYDi6g0HJcFj
Bdna2QsW4ihPqQBbgiWbTPAWAmMt9S1ZjgysC5yjnpOgRuWoux3p2LPMDJi4Gl1T
bQoKBEVf6mQcQV3FtwMJmfmr6um/FYcIm8RaJ5NHjuMMmQjUWYV/HPJ183JyKh16
XfzpCKMHMFaVwqCVyZBROWH+nkkG8BAw9iEjdhz7CXykAwMLmTrINKNR42ha/AVa
5hfTImTsYrb1ezER5w5ZUByFGFMH56s1h8CmCbDGdgyhXEY+Kd3Abq82Mo44oYci
vOsjvK46/pEzvW0IIVARH4tMsY8yb0CzY0aoutevIIUhkqe+Bgx4TXD+vMyTS4Hv
sY0vS5MbF7yDpCNNr8ti
=cRrl
-----END PGP SIGNATURE-----

--A/O/elEosBFxjD6K--
