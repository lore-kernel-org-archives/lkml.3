Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964824AbaH0P2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:28:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935151AbaH0P2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:28:34 -0400
Date: Wed, 27 Aug 2014 16:28:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Stephen Warren <swarren@nvidia.com>, Xiubo Li <Li.Xiubo@freescale.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140827152808.GG17528@sirena.org.uk>
References: <1409150163-25729-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9b8y2y+zkLfXHuMv"
Content-Disposition: inline
In-Reply-To: <1409150163-25729-1-git-send-email-geert+renesas@glider.be>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFC] regmap: Split regmap_get_endian() in two functions
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9b8y2y+zkLfXHuMv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 27, 2014 at 04:36:03PM +0200, Geert Uytterhoeven wrote:
> Split regmap_get_endian() in two functions, regmap_get_reg_endian() and
> regmap_get_val_endian().

Applied, thanks.

--9b8y2y+zkLfXHuMv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/fkFAAoJELSic+t+oim9kjsP/jg815idrztO/dR6W9V5RNAR
jAg8p8JaW2NF/F0oXJdd0U1zZqPqQpvXGrCpo8mzv97+WKqsmBww6v3cOVWpNsx6
JceXM6xgHF/BXoCy9lBY7DfqVtRCicGwpwR3gkvalqyFW2pmGhcfaubzJU/OYhz/
F6qyULQAoB7PGEyvn0s/3fsY9IW0cHizbGA8cRt8QW/L2OY9NRgPieBw/1Ksy/sT
6RFXddWQJMe0lQD8u6UoI1WLpX0qCBIol143xWHh3tdT675ZH+xwiLhDDMT9P7Ay
QhKqMYqd5sXvDaiuyM3yNuYAwzsEH5OR97k5edTRC6eX1dvfICx4HxAXIUd8SdF7
zthotyhi7JojEsG0gyjiQ/qlKH6Mor2frD7eSG9g+zE67s6Rb7yncN4lnUekavWX
vsXa1hKQ4q9Ko7MDaM98Ew6n7O47uJSd1SLL5YjfU2J1JGo967qkXwts2I5Hf8WY
VT9D9S1YoUjPmYNfkWqA1rROTwCxeeX9yzeVf4fNoMpUYsnbkwz7eJ2GClpUHGO7
JMT7n4cqtbM3nvbtk2KN74F1qL9xRlNi4z1rG35LG/2F+m+PvV/th8THx6VOTt43
EIPQxrgkMYmuz0ckhxmyT4iZqcnjdFR/F9SJwciNaVS9Wjo8Ugo9DsUCJbJM4163
NE1Lpqj7orFGryoEz5kJ
=HOgv
-----END PGP SIGNATURE-----

--9b8y2y+zkLfXHuMv--
