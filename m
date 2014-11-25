Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751174AbaKYNvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:51:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38140 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaKYNvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:51:40 -0500
Date: Tue, 25 Nov 2014 13:49:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141125134945.GG7712@sirena.org.uk>
References: <cover.1416918909.git.moinejf@free.fr>
 <2ade2a90025d3dd4fe8872d36956ac08f0a81103.1416918909.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U2airnvjqUwLRQVR"
Content-Disposition: inline
In-Reply-To: <2ade2a90025d3dd4fe8872d36956ac08f0a81103.1416918909.git.moinejf@free.fr>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v5 2/4] ASoC: simple-card: Remove useless function
 argument
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U2airnvjqUwLRQVR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 25, 2014 at 01:22:45PM +0100, Jean-Francois Moine wrote:
> The device node pointer 'cpu' is not used in the function
> asoc_simple_card_parse_daifmt().

Applied, thanks.

--U2airnvjqUwLRQVR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdIj4AAoJECTWi3JdVIfQtc4H/3HtqS65ZenOxdk3xQ9vT8ia
Y4hcLU1qZ4j6PDZ81l3YxZh8++HHJY0BmrZf3Tcl9AEx/guXfgwpPjY67GT9E/kM
gP+Ry6id2pjcYPVOw0K4wp2a9Q5hiGj7jgy4lL17fjpaI2k2T3NYyiVXtUZ/s1na
VUqBQr48Vjb0QakRFkQrExDBqqaE1BlQcp59+acAVj9tPo5toMbf1ITNzGy1KxzT
J1wSbmAVwPDxuSAC2G+14AqsRrLuyOR9y+Wy+Xw+e6U6KB6KQJZ7vV99MbAYG2E5
6Wc2/YDElVLq1+3xeI7i8mZlakcBqsxqMC5BPBqNUNrjROM8s645EEyf+yLTaaI=
=fEv5
-----END PGP SIGNATURE-----

--U2airnvjqUwLRQVR--
