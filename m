Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752599Ab3IFLKC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 07:10:02 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38323 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187Ab3IFLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 07:10:00 -0400
Date: Fri, 6 Sep 2013 12:09:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130906110957.GD29403@sirena.org.uk>
References: <1378351885.16198.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <1378351885.16198.1.camel@phoenix>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: palmas: Drop regulator_unregister while using
 devm_regulator_register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 05, 2013 at 11:31:25AM +0800, Axel Lin wrote:
> Commmit af40a94aba "regulator: palmas: Use devm_regulator_register" missed
> removing a regulator_unregister() call if palmas_extreg_init falis. Fix it.

Applied, thanks.

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKbgCAAoJELSic+t+oim9bSEP/39lZ4yHXlDWUrd51RG1bmpf
RzVpxFtR41b32rh/UXlTPPH4Vsk52gdcWArI1ducnzUAuzXpiR4hRYpZo9hJeZEi
o44MSL21zcQUJhWbJPqinKmPwApeFy49SBBhmS/MtOd6RIGiZfQRQ2x+5AbHE8JA
Ji2x2vmUQeFHypBsiBKWh6F4jjgyhFr+XO7bRiMXojsRaTJTX2QnFTLpa8vXBU/X
96uUAC8RrVrMjM6uLRaWIVF28fua8i7f13zyORKR6Fdgovr8la1KOIhoEgNNqC1W
kaNuUUCmodv8OWf1CqvpatbxVSjwu14WKqBd8Z1cE542URUv7kXPZStRcc1ScCCS
8RZaTeA2uRjlXf+HuqnUDklXzyt++kS3nwFq6Mi3gM/m1v8BoE7CZ3ivtRYOLyqL
Ueen7datF38LuxqgVPZTopZWiUNwsjSqaDT9JPV++yuDNsb5iHrKV/9L5dII+d2T
ateXNqi9Nkv9N8iG72I43Sz9o8K7DJ2QNh4dHEY8H+DUeMvHtL/d2+/MwT021POC
CcW5rF5d47q3AulssGvHTO/udPaaN/sIUeIClTGUMfeWRyeOLPcGqMIHCcWFoSrz
MZt0Z22axv67gL1zMuDNwC0u5AJwHrVTVVO79t3Pb04gqIexEu6dtQ4J/blR+If/
uyqd4HO8cqgzS02MdwL8
=6ZU3
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
