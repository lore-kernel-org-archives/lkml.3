Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaBOKIE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:08:04 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60344 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBOKIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:08:00 -0500
Date: Fri, 14 Feb 2014 21:09:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214210943.GA4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-3-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OXAoLeOWtqbacoe/"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-3-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 03/16] regulator: max8660: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OXAoLeOWtqbacoe/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:49PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--OXAoLeOWtqbacoe/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oYUAAoJELSic+t+oim9nxQP/06gihzgsi0lMiooGDXtDZ6y
JkR75qdMOHfTXxfb0HbtkCufmMS1iRZntYQHQgf70WTt/h9SPzVlVoNnx/Chsbcx
sntoJcjGfIgpbYV3YEsxWkLKyzVGu9v6x28HVAsy8ZCXuTWpCxQO64roCBeOlsAG
Jtm53vR4w77F+KOJRJ5cavgw8dpQ1n+moqqJGXotcDRhQKn4MGQq5pn+ruMcb1QX
wAbjdT44b+NB9bruBb9h6Yv6hYacPl0zQufuz9hpqXtyw5Bu/CpHMCSQ3DDeoG8j
3x3Pkyls1GmUtO9WCGIYFPaE4QyKtBvjA242mU3QnNa8YfiIrzCVXjHZ6U3t8SxT
iTCP7c6GuFIjgRPjBLblxyIDiVywqPQ0wsvsJvSKoChcKMq794ErA1zkvi1qH+IJ
Qhafwcmc93BFS1aQ8biPNMSeHk2ej8gzWV24wEhC7Mdwe9tDeZV91BcIPfEGBqI/
/UcCptQrNrA0AihluS3XFaMnBzUIin62OcJQi3Bzr027HhCcfZ+FjfpJCmeP9T17
jJzhZo4gH2VZblTaHL0U92Xk3+8ojMPGYaS99ELexEZO3+h2/3nRKtqZ12MVRPBt
unAwvh/SQqK3lwncs/XW6M3gJw7N0dIQYIaEBPAnb7zEujrEALV3mU3OfKLRsFJE
aKo89iyEayf5nwExj1jQ
=v8tP
-----END PGP SIGNATURE-----

--OXAoLeOWtqbacoe/--
