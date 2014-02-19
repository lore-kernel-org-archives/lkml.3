Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392AbaBSE1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 23:27:39 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58140 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190AbaBSE1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 23:27:37 -0500
Date: Wed, 19 Feb 2014 12:39:39 +0900
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: shawn.guo@linaro.org, sachin.kamat@linaro.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20140219033939.GO2669@sirena.org.uk>
References: <1392777974-26254-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LXESt2jNC8oCvz8w"
Content-Disposition: inline
In-Reply-To: <1392777974-26254-1-git-send-email-festevam@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.132.247
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pfuze100-regulator: Fix of_node_get() parameter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LXESt2jNC8oCvz8w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2014 at 11:46:14PM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> Since commit d7857c42 (regulator: pfuze100: Use of_get_child_by_name) we =
get
> the following probe failure:

Applied, thanks.

--LXESt2jNC8oCvz8w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBCd4AAoJELSic+t+oim92EkP/1OSX7YOnfz6JixGOFOhd+IO
Xxi3PJbLTGvN0/N3zak4W2JLP9FITOIo/v6yfg1BfY0YA8kOrtylc2AehJ/Ch8Ea
Cg6QHMfqdeyor3pczStJ3znrVttm/6h0vPV/PE6NGE1nBobmsJPYTD9qhpIPlnZu
yfUd3naL/4FC130xFQK9A2OfRhEB3j1iMEUHxeNaIpjrDJUjBWEOcmV8ErwHlJTk
4XnQ15eo0NSEK7lu7v5ddj6B9CdSvICmmdRz0YX5nZx7qAkvxvJFGtDPPBFDqk4r
inNdJARsi++a4k+qlLqmh+4Nve8SH7ALAdcGu841iB392T+eXdJjnZFlkzZKPack
bZHG8UGzjVTaxxpbrvmf4NVj9PAGGU+PbqSXJNI5Wke+tubSw2JWH+LzeYEPm5gI
F6caup9c8IS0FR7NpPap5Vuva5SGmDmaFOxr5tPh8gtFF7o1DcGZE+Fg+ruj/YeZ
Cp5RzKwQFhO6Emlj4SC03sQvGG7P6qKxRIyjk99pFnOoHOwyxSzrr6Cd0oA+2lYu
H+x025Nas69kX5z01SIusUWj+MSoQqjBmi7fCG03aqrkSMdV14IU/3cicNICtAqT
lF9GYEWgXY5Uwg9lq5CdUomdQulJhJsglKuj5AC3uyqoQWH626+EnMAs/VcCCST4
zve53mmXscNDzWF5kene
=8ts2
-----END PGP SIGNATURE-----

--LXESt2jNC8oCvz8w--
