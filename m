Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab3LTSb7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 13:31:59 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34025 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616Ab3LTSb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 13:31:56 -0500
Date: Fri, 20 Dec 2013 18:31:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20131220183152.GC31886@sirena.org.uk>
References: <1387508269.10796.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0/mZ2nErRHiqrPHn"
Content-Disposition: inline
In-Reply-To: <1387508269.10796.1.camel@phoenix>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: as3722: Don't set
 min_uV/uV_step/linear_min_sel for linear_ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0/mZ2nErRHiqrPHn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 20, 2013 at 10:57:49AM +0800, Axel Lin wrote:
> These settings are not used when using linear_ranges and it makes the code
> looks confusing. Thus remove them.

Applied, thanks.

--0/mZ2nErRHiqrPHn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStI0UAAoJELSic+t+oim90WwP/1p/8Oijld5P8qEaASi1kVwg
eIo6DJvJRtfd5WjpB7nD//aQRrzrHF6TpAwXiKVM8/mNuK05wioPQTM46ucgdhvl
Tv/ruepuFaT04qeS0SA5bCOAdijOnnxNHGEe71WUD3gudy6RtC5vB+BdHN/IJIqd
7D5tZu8iGhZFPa3aQyMDvW8Kx2S4YJfloG1jpo8NRRKaxsFb1we0yhvUOb6v1mp/
5g1cLxO7HY+DjfDkYP1hU1YTPewg+6ZsS3UQ+D1X1wrxkgLHKwrQJXUelAkpQ9Ex
XpEO8Y7UcOpFpNjmIttIKBMUVUYwG9dxPyWlZ96xl25Kmmps7Ufz3zjjaFDqb+K0
5UuL+DpDQzjfbmrMQHwyk6kPuRtJ6Zgk5L17aNWKX88iKCiUwsrpq+zEIcP/VLLG
+wxyfo12BH+ghXHmVEu12oqOIPwBeM5IuLRmlTvQ5UbJ2ppxI/OF2yJ2xTXuxm8l
La0ZNY4fJBRU+3FhbPrMZDYPquJMNTsv4T6y9o4gyRRSWsyz1/8kymicx+1tVGK/
Q0AvIhqrxC2cfMPpDUKrntlJuR4MS/TqbKci9zZcm04rHKGFhf8GHf3dF+AgKvCe
6XkZYcdE+OmcaKHXFsYMYolACEeOrJvHnMZxtttH/PzoA/v18VwjtVmw3rw78agq
B4OuT2JVGnm6VQFApTeB
=CNHT
-----END PGP SIGNATURE-----

--0/mZ2nErRHiqrPHn--
