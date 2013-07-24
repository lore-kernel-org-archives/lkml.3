Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723Ab3GXOsi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:48:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39763 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXOsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:48:37 -0400
Date: Wed, 24 Jul 2013 15:48:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130724144816.GL9858@sirena.org.uk>
References: <1374310605.30336.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FfXVnwzHaJ+SBUCn"
Content-Disposition: inline
In-Reply-To: <1374310605.30336.2.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: tps65912: Convert tps65912_ops_ldo to use
 linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FfXVnwzHaJ+SBUCn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 20, 2013 at 04:56:45PM +0800, Axel Lin wrote:
> The ldo voltage table is composed of linear ranges.

Applied, thanks.

--FfXVnwzHaJ+SBUCn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+ktAAoJELSic+t+oim9XfkP/iR7IE1Jg+JQ0Tvz6SJcvnz0
U/uwKnZV7y50rSc/aN4vylkbhkfuOKZxubEDg+/tXoS2hy2PbNkfkLWgF03UuuhP
UAC/VjUo2VXcyC8jgAyVjX3kblMZQnmDkhhifX3lZU4jsjUIOqXr60/7twAE47dY
lK5hq4lYj5Ri0KnwpxPJkstECM7FpdBh0gR/DKpE3tAy8sb9PMQa5Ayt0WDt+hI3
HNbLg6DSRTBF6WAhM/B8AcXwmboxVQUMH8pfG+zrCxeHndBzHyxfKMcS64yWXqP1
BF1RrDra0HzVVJkcT/n1j9yrrc2GHG0RieNgpD+OGEl9RmOiKouNNh3lsLRE7Lih
dpRbF4hJ0bigfzcH60qbjNX8QUEM/DYvYiDJKdV9kOjryFvtdLRuDjvzpTaiLnOM
kPxxMe/cg/Q9Zml+haieV2gkYYCifNPswSW9RQAhGHsq3VJ1O4I43K8FaofTY5S+
dn6exhVzQjjE+kCLWsdx7IXqlk4uT0OkQ+tYpe05kjkBuVcoWw8D0pdZ12N4MVvK
R7IqMo8enkAR2znApxT+uBq2rWXv6FDrT8PNNJ8BpAn34t7asiYOxPmMK88nix+w
WZUwDbUB4uMUDb/0IPitpTFfXqwMl2k37MWafuR78QsOH0qKUCCfvuJmxZTh6xu/
qn7xuy5jfu2MeOop4ya8
=gHQA
-----END PGP SIGNATURE-----

--FfXVnwzHaJ+SBUCn--
