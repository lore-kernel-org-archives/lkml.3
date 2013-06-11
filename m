Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716Ab3FKLu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 07:50:26 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48059 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab3FKLuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 07:50:25 -0400
Date: Tue, 11 Jun 2013 12:50:21 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Message-ID: <20130611115021.GZ1403@sirena.org.uk>
References: <1370621488-18130-1-git-send-email-lee.jones@linaro.org>
 <1370621488-18130-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p1zSJVlfBL7BTggM"
Content-Disposition: inline
In-Reply-To: <1370621488-18130-9-git-send-email-lee.jones@linaro.org>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/10] regulator: ab8500-ext: Register as a device in its
 own right
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p1zSJVlfBL7BTggM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 07, 2013 at 05:11:26PM +0100, Lee Jones wrote:
> Some platforms don't support the AB8500 external regulators, so instead
> of having a list of is_<platform>() calls prior to calling
> ab8500_ext_regulator_init() from ab8500_regulator_probe(), we can only
> register as a platform device on platforms which require them. It means
> we also have more control over them when booting with Device Tree.

Applied the rest of these, thanks.

--p1zSJVlfBL7BTggM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtw76AAoJELSic+t+oim9p9YP/R2ffUEmGBEXGW69eiQaxHsW
+SlU+pSYgWIRmyrA1fGUSKCUFTppmqbLO4ePg/3gp2b4JVK/pLzAY6menqpOX6i1
UDmotXwv9pIJKw2jpt7xQ/zZOJFYewCtBqlSlwKwIQOVa21VwfN2rS+VuxaFu18r
IpZi8uffr6WssyfnjJ3RN1T/TkuEwfbAZaf9kw8r3QzTLhDTDCHFKwJlxup3NIB6
QE3z1AfVSeVvtMEFOoNu0Qsnsn39roe+thMhJ8ZD8Ll2Hbnqwj0bMSBbrSOSBPG1
cBHcob5fhUavzMhuqXYdI5dtWvXh4HCmT3rGIE4cJip0plMiUUpwefsOKImw9d0K
Jc2Zk5QkLx19AGa60YSXi4l/V8l0KDykwmuTd1BjD6PYOK1jLOIhSxC6giMfI1HP
jeR20cHhEbNpjDPiq9gC2/62JXtDEe566TfuHjmZtLCEL2Fdrht2WwWTtA9mUuQ9
V9LqxqkCQblYDRBVZ02GCkZjMx3UlQ+JH1d4qeJrBtGrC/iKnVyPERsOf4+te4lZ
7MoGj17pvxt+QDYKYIgWipmkan6duAwAtG1ERF3SRd3zeVi9jwbzYXwF+ZHcZX5P
ItcuRWaqqnvnF9SaQZpHKML0q73XTKw6rx1JvNTBl7KT04ouhAHZArYvGkNDRPHD
5yyWVeBklubnu0lhfR+H
=F5zJ
-----END PGP SIGNATURE-----

--p1zSJVlfBL7BTggM--
