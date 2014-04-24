Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337AbaDXMhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 08:37:19 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43843 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757251AbaDXMhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 08:37:08 -0400
Date: Thu, 24 Apr 2014 13:36:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Miao <realmz6@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net, linux-spi@vger.kernel.org
Message-ID: <20140424123650.GV12304@sirena.org.uk>
References: <20140423224035.1de64093@gandalf.local.home>
 <20140424103329.GL12304@sirena.org.uk>
 <20140424113346.GM12304@sirena.org.uk>
 <20140424083432.70c80f64@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z5xxnjJtmRtsM6EM"
Content-Disposition: inline
In-Reply-To: <20140424083432.70c80f64@gandalf.local.home>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi-bfin: Add missing gpio.h include
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z5xxnjJtmRtsM6EM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 24, 2014 at 08:34:32AM -0400, Steven Rostedt wrote:

> It's just annoying when my tests break on something that I'm not
> testing ;-)

With something like this clearly you are testing it, even if you didn't
mean to!

--z5xxnjJtmRtsM6EM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIbBAEBAgAGBQJTWQVeAAoJELSic+t+oim9jgQP+JmKG2RwMl13u1IThaWgXoNB
OGQCPOGosVSLzU6svyzmQMKs8gnybVyfuH9tFnnX4rvJb7rOI8fgLTT+5TnwIxHE
ePJeOVWynGgoejoq6OU2qNe7TA9wDi4SxpJF4IMPW10XAlRXMT8ZZLpzYYVA1pAs
MkENlcK34tzXlFaXer1aaxEzXMKqEY0wsiJ5iqm/BzlWWbOXA4bMukVwG3X+YMUm
CdHonA/zDIDrndYXBf8s1iVZrdcBh/yAqaL1M6vQj+PvbJm6LUxGfHcGpvuchkHW
YFwEdUl13Py0xcOE2m2+jY7VoYUzR9zHgX2JDAJHyMM4+QSIycXu/z77lk2fSxV0
tHk7aTNJmLigOYH/s+E+h2MWToMm3mxVR2y7vvympabJ2KJFE+xw2qJCoAFNIsz1
LKou5gI9UmgOuqUw0ysfA6zMrA5woFcT6AAvwqt9rPK/JN7zUuSKlFS8blhVPwRB
g5rxaoM6doHXO+mjs7nDA9SqQpcZQAwYRsz2u/PVgqXLkw7LVW8v/JcX1+5vaEYR
30dGqn3z+r8WBHLAPgKSC8Vjz/oe90a2KG9aZTxS+mvhg5WflnK+SW9NP6BpCT3S
hEsMMiW/rR2q18xHhFKzRDZ7Zx0jacTijTQIEGLmPDVUIIMHrwPpMd0iRbI8OClm
q/lSGjqvdsUVAqYOroA=
=tcdd
-----END PGP SIGNATURE-----

--z5xxnjJtmRtsM6EM--
