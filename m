Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965233AbaCULur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 07:50:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58873 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119AbaCULup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 07:50:45 -0400
Date: Fri, 21 Mar 2014 11:50:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: "'open list'" <linux-kernel@vger.kernel.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>
Message-ID: <20140321115040.GL11706@sirena.org.uk>
References: <000001cf44ad$a8e2f1b0$faa8d510$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sre54N+byDQwqJQI"
Content-Disposition: inline
In-Reply-To: <000001cf44ad$a8e2f1b0$faa8d510$%choi@samsung.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Reduce busy-wait looping
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Sre54N+byDQwqJQI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 21, 2014 at 11:31:25AM +0900, Jonghwan Choi wrote:

> Commit 5df529d440("regulator: core: Reduce busy-wait looping")
> can also be used in regulator_do_set_voltage.

This is good as a change but please factor it out into a function so we
don't have the same problem again with future changes (I'm surprised
there isn't one in the generic code somewhere but if not we can do that
as a second stage, regulator only is fine for now) and make sure that
the lines are less than 80 columns.

--Sre54N+byDQwqJQI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTLCeNAAoJELSic+t+oim9OeIP/0w6b71DcYy2WHzDyXg6QRLG
xnEbgLmORAC2i2l0k+eLNe7Z/It/VGG/1IIK9PJRLTp2Ba9kR+nC7hKwVzuJjGeA
b4oUP8oWvng6Izssk/Z/NNPuy+2vdM1KDm5pJX8o31psBAi2JFa5fuMusNGUUQ9Q
Lrx8TCmBw/rkQvQRwhaAeZdbJYubLhFEam84YwlzJbFJIv05ZUiP5QeIHigX2mbg
Mtl5glmUGnd5FaoDHCmQizqROswUNPciPGZLwW2aKdcstsH6bUD/r+cxxXZm+SHY
2pss4LJiBhzhnw6VYGZpthjS8QzDuvwUL9ftIkUrxHx1O5sBQOsw3s6kkoZCCpBy
PdHEm5e+o5uiVdAOFULe2YdqgaB1bD4GBCuF8ta9gAbWB5hM0nhrjoJGbzM7+cCh
cth00e8QnTZ7VH/iDcAQkyP4ifsI5STvgJMrVDLJgEYIsCN03nyO2O5IU9uRDPtK
clv5k6yK65VUNkemnWkhxJULIVXPPefsil7E6BMeBhkybR+WMkOXxslvoQVtUuEm
Lw5HPnceHGR0vmcL6mdYvnzhXWRaC/6RKZMWZNOhzbTqmD0/sDHS2VEGRMG17ktS
HJT1WFoxbkjSOzC3PEpJJQyS5cT2tjc/pYeLrWE5zSPZAfQJgAU6h4YvoJ3+MGlP
GM3RmjeLVlvzHcvyHHQ2
=pAJP
-----END PGP SIGNATURE-----

--Sre54N+byDQwqJQI--
