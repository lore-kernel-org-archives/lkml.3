Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3IWKQR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 06:16:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34137 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab3IWKQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 06:16:15 -0400
Date: Mon, 23 Sep 2013 11:15:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130923101551.GY21013@sirena.org.uk>
References: <1379846854-11746-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="b4c2lVEA12mfheYj"
Content-Disposition: inline
In-Reply-To: <1379846854-11746-1-git-send-email-lars@metafoo.de>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: of_get_regulation_constraints: Use node name
 as fallback
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--b4c2lVEA12mfheYj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 22, 2013 at 12:47:34PM +0200, Lars-Peter Clausen wrote:
> If the "regulator-name" property is not present use the name of the devicetree
> node as a fallback.

You're not supposed to use the node name for anything, the goal is that
it's entirely ornamental noise.  Which is a bit annoying but there we
are.

--b4c2lVEA12mfheYj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSQBTUAAoJELSic+t+oim9PrQP/jwRlzHsXPkEYA5zR9pe15SD
g/CLN1u3C6UYkj3r8L161YZfvzNkjUEiR90eryplciV7HlyUy5Y1z7XO6jyoHztc
UHIxeS/BESXl4kMDVx2LPHUxLmVHueUCZiUOgopyGTyMhJQaNrt5R5q+GI0m+0gM
1fO6fiURUpQ7hNgOjDadFtOxzEip7WII5FN7kT3K5zmnIcxc44vgPH/saoonx8zG
oLMMhvH1l6PgRwwQ7RnxPi5shw9dJKLG/C9s2huA116715KbRaJ+xJq+wJ2i+Scw
w60hHpBmI1mGkP+535MHicbQye3sAhdGVJuIki+QhyhmDqHqdnqJlEXom2Zusx1u
y7FDC3kmnx2iMVQ4qm5R7hdiFClIoJazkMiU1W7UL6etzTiPFB9WfcDEtO53kLIm
Rx7L9EqKZBmYUEoHm5fJ8RaVsq2vSCVEo6LhexCokOrM23LSGthY3TP4gViS5SEG
vlSiIZDqHgAMgOchKXyRvIC+j6uTkvtWLo3YtOyQX3VoZIj6CbNtFxtk+KYEBWTG
NNDKt7aBMpVZqWsaSlmWWVONmPI4UiLtIfPFppVLnbLrzkEiDaDHwK0I7nPqdEfn
Mp0e/v5AFAZYdJe1PM0L1AGMv83Sq4fz3AIVK0vtdK/1WtnlLwYBYb0oxs63mIPr
y6GlRyQs9EZ+GY9QG/uu
=oIot
-----END PGP SIGNATURE-----

--b4c2lVEA12mfheYj--
