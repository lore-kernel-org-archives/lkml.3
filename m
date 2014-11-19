Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755121AbaKSKhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 05:37:33 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52878 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaKSKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 05:37:32 -0500
Date: Wed, 19 Nov 2014 10:37:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141119103713.GZ22111@sirena.org.uk>
References: <1416336354-32148-1-git-send-email-lars@metafoo.de>
 <1416336354-32148-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lKbk9CFItQTD29wm"
Content-Disposition: inline
In-Reply-To: <1416336354-32148-2-git-send-email-lars@metafoo.de>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 188.29.164.121
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regmap: ac97: Add generic AC'97 callbacks
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lKbk9CFItQTD29wm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 07:45:51PM +0100, Lars-Peter Clausen wrote:
> From: Mark Brown <broonie@linaro.org>
>=20
> Use the recently added support for bus operations to provide a standard
> mapping for AC'97 register I/O.

Applied, thanks.

--lKbk9CFItQTD29wm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUbHLYAAoJECTWi3JdVIfQyAYH/RMswVANRS2KwNr7T6XYPDWY
qCTaCt3bLuKAUzwTErJ7BtmsJ7ncBhpWCrbcMBAfmb+Rmj5AahuwuwA1TcTDTtVC
nrG6lH2pQaQYGh711mngoPcQAf2rbz0rrRystaofr43jMPBnKyY084bMh1Pl/XRA
0VtyKMWZpCDbPmvObR8ExEfD5djZeYAWqZJHPeiElZH0JF2S8N8wXBbZd64ngxmp
xLPTd+TMjgT1v89B5f9kXZKY22xL7nQDhhSCPBD1qwe+86uHFD3pZqFpRKubdUZt
fMc2q8uzu+9N/0d9XpGOntq0T6RzNBko9Smmq3+L4dTYRf6M5j6BXK6f3Y5JsTs=
=dRm/
-----END PGP SIGNATURE-----

--lKbk9CFItQTD29wm--
