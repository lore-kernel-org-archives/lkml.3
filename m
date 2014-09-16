Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbaIPXTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 19:19:40 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46392 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaIPXTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 19:19:38 -0400
Date: Tue, 16 Sep 2014 16:10:50 -0700
From: Mark Brown <broonie@kernel.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, Brian Austin <brian.austin@cirrus.com>,
        Paul Handrigan <Paul.Handrigan@cirrus.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Message-ID: <20140916231050.GF7960@sirena.org.uk>
References: <1410894151-6246-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4OxkfA0LVqADv3Vx"
Content-Disposition: inline
In-Reply-To: <1410894151-6246-1-git-send-email-fabf@skynet.be>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/1 linux-next] ASoC: cs35l32: remove second linux/slab.h
 inclusion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4OxkfA0LVqADv3Vx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Sep 16, 2014 at 09:02:31PM +0200, Fabian Frederick wrote:
> linux/slab.h was included twice.

Applied, thanks.

--4OxkfA0LVqADv3Vx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGMN5AAoJECTWi3JdVIfQYdQH/3EVPnfl5jWQpB9elDtXy0ka
m6Ztmy/ptQJgvDjIg8EhFtxuL0YwYM4GnM4ePn8mAZZLdx4Lhn2ae/LyocNp/EJX
oTt2IBQRIK2Ch5tsqdQ/Bd9waf43yq3L8cEuzqNjBjAojnGtju7zbgURtmPQA/rm
ak6imHqDdfs5Wdq12BZK+9ja3e3sj0T1IBpyKQwBHaVHOlLIinhRCXwpuGaGTaCC
wQEfBS76ed5YKzDHmuDAVfMVC/DtqoQTCzwIMNgStuT5S8TyLQSQ/7ZQuuaQajJY
Un0y6coHT/K5tO6tZE6q+aRwiblmWPErrsncR0Mm+MbhOQ7r1DXmL2cCgX1n+wY=
=dpHc
-----END PGP SIGNATURE-----

--4OxkfA0LVqADv3Vx--
