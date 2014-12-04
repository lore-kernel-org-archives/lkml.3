Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933312AbaLDWkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 17:40:53 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48528 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933139AbaLDWku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 17:40:50 -0500
Date: Thu, 4 Dec 2014 22:40:33 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Rosin <peda@lysator.liu.se>
Cc: alsa-devel@alsa-project.org, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Peter Rosin <peda@axentia.se>
Message-ID: <20141204224033.GA11764@sirena.org.uk>
References: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mYCpIKhGyMATD0i+"
Content-Disposition: inline
In-Reply-To: <1417122162-8122-1-git-send-email-peda@lysator.liu.se>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Augment existing card DAPM routes in
 snd_soc_of_parse_audio_routing
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mYCpIKhGyMATD0i+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 27, 2014 at 10:02:42PM +0100, Peter Rosin wrote:
> From: Peter Rosin <peda@axentia.se>
>=20
> If a snd_soc_card has any DAPM routes when it calls
> snd_soc_of_parse_audio_routing, those are clobbered without this change.

Applied, thanks.

--mYCpIKhGyMATD0i+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgOLgAAoJECTWi3JdVIfQadgH/Ai1BfqxhLKxGP30YZKWYsyf
K2bhZgCRxkeqiT0wJ4YGbS2jICu5We5Yfqym/sUQfpUoeUsUv/IYIiQ5ysnJD1uY
JuojkpbanP08vpuQnWRbtF+Rfy8OZZTeMVLHEFTGQoKg3f69kDI2zJPgJFfJj8YT
6S4rZMHxV086XytpLsOj6ARFSH8q+B+IDuzVhQmpc6qX/LF+vkR0t2Mc+h7Xgx2M
voRmApbUPddYawLa9c3ykXAGgAzyPLg7LVOmVtcW+Hl4Iz9cxNkh3L11B0UJ+tEL
w2NyGcSJ9X/zvZoRlR+Dist5++uqvCQRgj+9w2TDczNTdN/zKfJoapwokNElDDk=
=9w5l
-----END PGP SIGNATURE-----

--mYCpIKhGyMATD0i+--
