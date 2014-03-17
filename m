Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaCQQ3a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 12:29:30 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55969 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483AbaCQQ32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 12:29:28 -0400
Date: Mon, 17 Mar 2014 16:29:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: alsa-devel@alsa-project.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        linux-kernel@vger.kernel.org, Xiubo Li <Li.Xiubo@freescale.com>
Message-ID: <20140317162922.GQ11706@sirena.org.uk>
References: <cover.1394883134.git.moinejf@free.fr>
 <0d648a81b7dd3fbd3ec769cb77bce0af5b39d699.1394883134.git.moinejf@free.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="z87VqPJ/HsYrR2WM"
Content-Disposition: inline
In-Reply-To: <0d648a81b7dd3fbd3ec769cb77bce0af5b39d699.1394883134.git.moinejf@free.fr>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 3/4] ASoC: simple-card: Handle many DAI links
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--z87VqPJ/HsYrR2WM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 15, 2014 at 12:26:54PM +0100, Jean-Francois Moine wrote:
> Some simple audio cards may have many DAI links.
> This patch extends the simple-card driver for handling such cards.

This appears to be updating the device tree binding but there is no
documentation update to go with it.  Given that there are exactly two
DAI subnodes specified explicitly by name in the binding it's not at all
clear how this is intended to work.

--z87VqPJ/HsYrR2WM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTJyLeAAoJELSic+t+oim9Q4AP/0w8t2XWKgZ2tw4CUVcVgnZg
S8og4I6W8IuSsJcDpxTdtGxKnjeSuldH9SJFFc4L8RJ1VpKeuSBJDePOkpHnNo/h
Ck6+uN9C7/55UhWTkbUE0CIdLVozaYCgsykUAz6g05rxhQ/h0bEb/RoqtX1oDFuw
XJPd7IUYCxvTasJE+IDUgZOOnNMgTQYzrKnl7XjXMgeQHfTUbwldnRL5HUUzJvKl
BhJbjMBUK5QF6qhuihiPBtSdd08f+P+t4nx76w/WOCbmt0H4Ozw0X/QQWrmUjJ6b
KOtZJL77KHuq/zYr/+mSmwojCz+PA5XgNW35XG482a5TEV55QpwnCzPqamqEwswK
2A20nZ7L+/11BDntxDzRWUsIAr79V5c+LkzclnzXQp31pJPegfkdduxkzU1nVnTb
q7oV2swW8ibtyaQmvxJk8HL4qb9ojsdeiAQgL4ffq8Hu41c0edBzOx461+fhkix0
FGRNdpvKDCXh8/GUYJPSPC/g9bmHXCNZs1FBN59ewGpCz1HZmzILT3r4SUtMh+Jr
eYcOi2PzMAlVG9B6yiW7q0EDrjicXlLxXQqbUWh0ILt3Midg14C8tU0sUPfOheir
mm9fGMqQQflqQie6v7R69AHn9PUbM5HZ1iBY8/T7vG8WtA6O9ejjmWO2HT/RYx6o
Ld4yY8mqvmjlWAcRC3cU
=Tpvn
-----END PGP SIGNATURE-----

--z87VqPJ/HsYrR2WM--
