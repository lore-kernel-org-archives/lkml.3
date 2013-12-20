Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3LTL4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 06:56:19 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52314 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab3LTL4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 06:56:16 -0500
Date: Fri, 20 Dec 2013 11:55:54 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alison Wang <b18965@freescale.com>
Message-ID: <20131220115554.GR31886@sirena.org.uk>
References: <1387501387-2151-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GUWDakHTpZ9AxSMt"
Content-Disposition: inline
In-Reply-To: <1387501387-2151-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4 1/4] ALSA: Add SAI SoC Digital Audio Interface driver.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GUWDakHTpZ9AxSMt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 20, 2013 at 09:03:04AM +0800, Xiubo Li wrote:
> Fix the description of one comment.
>=20
> This adds Freescale SAI ASoC Audio support.
> This implementation is only compatible with device tree definition.
> Features:
> o Supports playback/capture
> o Supports 16/20/24 bit PCM
> o Supports 8k~96k sample rates
> o Supports master and slave mode.

Again, this has already been applied.  If you think updates are needed
please send incremental updates.

--GUWDakHTpZ9AxSMt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJStDBHAAoJELSic+t+oim9uB8P/Albsla4jS5J6QmesSjtA9OT
eqGhdaY+enJxp7ImmxJfK2N6vEYHXNqDwswimEVF9XOID5qW7Kqa+3glTip3PqNi
1qgKX//Wn+lhO5mF3W+Ucv2zgsofTS4e+Qe1LMW0ec0PYSLqQQyEE6iy71e/X0mU
6y5ZWlmDTVMNmiKTBY72xbLX9Xj0cyJBq3+MRjKnYwGLqjaPsjCAuDVF0inebgDk
71HeddiR8HaYp11CV2dpGWlrjCx40n/6CCytdktY2Psby7MrIuX8vTpySPoOm2W9
7UHigoGE9vVMuW+fFe11+SKYeFBOi5y4jx16qqoOhpTESS+Gip5kERMXe1pLjd7m
sZGcWURrlltxstJHNAPIagHlUZx+3d/HNAemJzEBNbUDQ5KFhqqqfWKrSV+1ux79
Yv69abF3cWsBjL0TOacYErBUflO6g6Y9bOBF7yEFWtbekfKyT0oLKtKkJG8wlsj2
BpwWmbNNW6cfNvYw/eDxfkymTHKjYshe0vn6zoFSt9yLDRhcr8ex/hTrWYF9LAsW
/umElS+S2kY56HaLCvizshI7xu2sRhghtugm1b6YNVuX/zfP8AJqSxQyO+j5AruM
dDx9MFFJM2hHOmnvKJH3X5OxVUPjcSYTD1JTc0jLqnadTHHjbcfd4q3oJZb4sXgI
bxAIx0s9TplEJ+NrS7rc
=j9Pr
-----END PGP SIGNATURE-----

--GUWDakHTpZ9AxSMt--
