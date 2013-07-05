Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab3GEVTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 17:19:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40795 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3GEVTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 17:19:45 -0400
Date: Fri, 5 Jul 2013 22:19:20 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>
Message-ID: <20130705211920.GK27646@sirena.org.uk>
References: <201307051745.16140.arnd@arndb.de>
 <20130705173321.GE27646@sirena.org.uk>
 <201307052255.10765.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ESod/vG06iFAbj33"
Content-Disposition: inline
In-Reply-To: <201307052255.10765.arnd@arndb.de>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: Allow imx-pcm-{dma,fiq}.c to be modules
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ESod/vG06iFAbj33
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 05, 2013 at 10:55:10PM +0200, Arnd Bergmann wrote:
> On Friday 05 July 2013, Mark Brown wrote:

> > Is this actually OK with the FIQ APIs?

> I don't know. Why wouldn't it?

It was the only reason I could think of why that'd have been done.

> Other users of the same interfaces (mx1_camera, spi-s3c24xx) can also be
> modules, so I wouldn't expect a fundamental issue.

OK.

--ESod/vG06iFAbj33
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR1zhVAAoJELSic+t+oim99/kP/28JYWCNMPVUQP43nBiyAvdT
BHZX5wESwQHMV0lQ7jfGvYcpN9aLW0NmxDgSbg1W7/rZHvwR20NAS+dFqZ3Pxyeq
zMX5O+T4OefimcSyr/pv/fujYr+3R7SpVkb03w53UraimtrLfq+ULvWaDVmmylLl
WT+dDcTuzcFSW3d/3OqSJQSqM/g2fc/9fxGNV8x60MTEx4j3Wq0zv5S8RTnjlEHx
4TY28EB9e9qbtgiXVHZSJMXA+F4jAACLEprgaiolF6PGxxjslnatX1eIxlZGhENe
CZYUWgO9kv0P9d5PLgPhJeywRP5EkkMxCHe0XLyI/lvEvzDqBNAeIawDl+E0faC9
YZJ19vWWxRPiu96MUoTGWFgn9aVqKVU3kDL0uciOyGXv5FVWBh0ubEIYT9kphW0v
9c8Q118cseNdhfB5FPRVPSQsJYFGjI/SueirdM/S4Z38UfQOlqi3Ap3LOjU3f5zH
O86z0AFI0v7hQcGHdscJQbkwByRpJOp3+eNvpXKbT2E1ioDfq5ISY9pcec1Njlzn
weo1Al9KhlOeGoCLDZLoE6D3F8ohj3mKc3PNaFfLcE9ZrFQBM99neVYBBvd+AbFm
asUPGmrX2QZhufIKj9lJUR3S7srgQ7jVK610qAKt8n++PZThUxkd1QvEhyHw6EAy
9Q1N8dSK9Em5BZLIHMWO
=ayce
-----END PGP SIGNATURE-----

--ESod/vG06iFAbj33--
