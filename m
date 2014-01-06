Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418AbaAFP3V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 10:29:21 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47902 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754651AbaAFP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:29:19 -0500
Date: Mon, 6 Jan 2014 15:29:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140106152911.GY31886@sirena.org.uk>
References: <1388982876-20746-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MmX58n9T22ba0WwG"
Content-Disposition: inline
In-Reply-To: <1388982876-20746-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: simple-card: Fix the sysclk selection.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MmX58n9T22ba0WwG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 06, 2014 at 12:34:36PM +0800, Xiubo Li wrote:
> For spdif there is no need to do the sysclk setting.

Applied, thanks.

--MmX58n9T22ba0WwG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSysvEAAoJELSic+t+oim9Ne4P/0liEc/rXKiOvmOo8upNa09T
ud+BoNliiPcDPlPLLy5gWMMd7EvOZyJodNBJw6Q5LoVD0uiU6mlgfl88sc3oUV03
HfInN1WS4ENXAgGvYEHRAGrYH9ag73huo2kwHAM4/yEHQ208EwXfQohlTmnALbXQ
Ros8G4gnI5rN7SDUZsnvQ9EyZnl09IG1FeBldDI4UCbXC3N3Ei4nbGvjN/9XAmG9
ioYf9TjJDpPhITZ+WHobLWk96LRv9ns5leQEpN9SVy0QDq3f9pY/n64eSIeZPFw0
AJccC7gm7RW3rPpwmgKEnF2i6F9cYwxiImPmVP4z1v5og1rJGIvCWSD/BNyDhBcV
l/aTusPPSQOPx6hs4NYt8rQoXYI0RjB5XsTBW0lcJt5PChNJJG3LwHEsMFrVw79F
JivW57aDQ/V6InFyROrdcedsqd4CBtD3zEqArN94RJEeVrk9nh0kMNG6Tb2itsdS
cjFkYI/QV1djBLpL80cP3Wk5UbXojuPhJaAsnpJU6QxUqYz+5vF309Vwc/KzBHmA
0PhmDk9WuhChvDpKPtLOFhM3p37e6nHz0flWu5mXhbQkPhQUPeP0xOZH4aikL2PD
KGssIr0sl79cSTCQsmhhLSuuklGyEeVQjoJ+bVU1OJDZfqy+Rvd5gx9B+Vp4VVbE
DUqrgATWzFs+//RfywbZ
=T8JI
-----END PGP SIGNATURE-----

--MmX58n9T22ba0WwG--
