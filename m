Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756352Ab3JJRua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 13:50:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41779 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755863Ab3JJRu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 13:50:27 -0400
Date: Thu, 10 Oct 2013 18:50:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Archit Taneja <archit@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Ricardo Neri <ricardo.neri@ti.com>
Cc: linux-omap@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>
Message-ID: <20131010175020.GS21581@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kg4mXnqz7C/eEpmA"
Content-Disposition: inline
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: linux-next: manual merge of the omap_dss2 tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kg4mXnqz7C/eEpmA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Today's linux-next merge of the omap_dss2 tree got conflicts in
drivers/video/omap2/dss/hdmi4_core.[ch] caused by ef26958a (omapdss:
HDMI: Rename hdmi driver files to nicer names) interacting with a range
of commits from Ricardo Neri in the fbdev tree and possibly some other
stuff.  git is unfortunately not giving me a useful diff right now :/

--Kg4mXnqz7C/eEpmA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVujZAAoJELSic+t+oim9tRsP/2qlXUFON7LesGn9lMvdx1sv
OVHSiDXkSTRw8QN5gdZGVgIoCdUDzGsKkJMR6kTUNGTjgWxyukFj0ScOkTchYKXq
tMW2YlMNi+cNBKXnX+Destt9Wi/pws6LQSSitT8XDmnX9V8QfrLQDhBY2yQ/Ekew
N1/oIj+D909ODMEkHVKYhgbWh45ScDHMBVyDlc5z04bZb+BmWkm9TMH2ORfoVYhI
oaEevVZD4CXwYAkd1iiaO7PXo7ye08LLzg8X01wnbyMZWDbHBdwdS5nyHfi2xh5A
amY9Zgf19ZG4hxbbmheg7MoQlOSnl1fohJSg9dTkE4saOHoXV+rA0eqwoZhxuEK2
WgGbpXFqvMnp8G1BUfNwtPuBmPWon1fAIQARNo/3aEj2TD2XdFD1MbhzyqrBSo0e
g36/z5K76sToX3cJgAD0V2Lf52ODkor7xqEhhbWt0PIadjBrGKKm4X18vQlXoDpD
4YSv57U9ZQzJPyjDG9jLR1kEjJVtC8wDfks2VPLbtaPQq4XbXBoM6YrsGBK5ncVT
NET6BK2imHbgyVO8sxCqETWvZ7FPpRcpvGMzIP11GY4OOBSy4x5f6iHlvcEmyMZ4
mPKh9vLzNwIP2DYA1Ei0XA7CW9VAZOMjPiqOQmH9Hh1Mg6RPX63gfuMjzho8EYhU
t6TLKIvyVInKef49UXGO
=KMwQ
-----END PGP SIGNATURE-----

--Kg4mXnqz7C/eEpmA--
