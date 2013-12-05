Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933359Ab3LEAmR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 19:42:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54295 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3LEAmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 19:42:15 -0500
Date: Thu, 5 Dec 2013 00:42:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>
Message-ID: <20131205004211.GK29268@sirena.org.uk>
References: <1386159757-29966-1-git-send-email-linus.walleij@linaro.org>
 <20131204230721.GA9376@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0ZSpXV6RUUo6PuQK"
Content-Disposition: inline
In-Reply-To: <20131204230721.GA9376@kroah.com>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Documentation: start documenting driver design patterns
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0ZSpXV6RUUo6PuQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 04, 2013 at 03:07:21PM -0800, Greg Kroah-Hartman wrote:

> No objection from me, I'll be glad to take this, thanks for writing it
> up.  Hopefully people will read it (the problem I've found with
> documentation in the past when no one actually reads it...)

Still means less typing for the replies if you can reference something.
Actually to that end might it be worth making it a directory with one
file per recommendation - easier to reference specific things?  Possibly
stored in the purple bikeshed.

--0ZSpXV6RUUo6PuQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSn8vgAAoJELSic+t+oim96oIP/RZM5LsnpP052zvBz4WTXXKq
MZ7697ZnpPvcyFNv263QE1Q9sCto06VyTWDjzB2FFmyzb+Nk/f6fNcMGSiDMUQed
YYX2dStI8xZIS16KTJb5qE02pY46WOqq0kQSchYOyfLWrj9ps+WeKVYGpONmsydn
98YRinZdt2ux8gAz8DBZNyLzzFnG+Tn+BHZ7kyCJeSCuSPHH3qCV53y7nWRemnb7
M7rfuGqc4yNbxtZTc/pzFnopOlSMNrlHvRytekGbOpE6h6Dg2rcXod/0CNp9aBtH
0lvCSsiEoUjzVktI/g1BH4AKDzGAgWrwrtc6glxaJ0g6zdNJ8HU/D9S42rE9FS8J
K5tVGxLZasUfpId/vdjd90c9ZW9IJb+QyB4x7qYUzCIplFYpcPQFScGEiyCwu6C3
QWPvHfqvTsUuLylTQ166UDvFxyg1VZSl5osmNHWGYKiQpbFhoo2Vm3XB6GV+FsWc
gD7r9SHss7Njmu3Dv1TGpcfVygSbnK3qaZeDYr5L5eOBasNWvmoE3lxlMTt6SxeI
IvC+GFTE91QqFxYAaCfboWLt3KUzug4NbGWoO9R3m2DOPwNb5yOH2BVjVgjP/A83
jKkB3rsnb7iXPOQpXxFk/nCYQwO8upPcYQqhYVmISJiE5iQ9FtFDPkFP8GwsHv78
rDXP6NuBvOq32/EblvOB
=RUDl
-----END PGP SIGNATURE-----

--0ZSpXV6RUUo6PuQK--
