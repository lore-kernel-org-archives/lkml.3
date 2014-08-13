Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751896AbaHMLNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:13:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33214 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbaHMLNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:13:21 -0400
Date: Wed, 13 Aug 2014 12:13:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140813111312.GN17528@sirena.org.uk>
References: <1407495756-19331-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qoWe+8UHdW+w9zaz"
Content-Disposition: inline
In-Reply-To: <1407495756-19331-1-git-send-email-thierry.reding@gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: Add missing kerneldoc bits
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qoWe+8UHdW+w9zaz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 01:02:36PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> These are all arguments or fields that got added without updating the
> kerneldoc comments.

Applied.  It's really sad that kerneldoc doesn't have a good way of
handling internal only fields.

--qoWe+8UHdW+w9zaz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT60hFAAoJELSic+t+oim9wcMP/34SJOZq40g/f9L1rWjLkDB/
tKH+s+LnAkLkrl5OOJrLHob+y4S+/XTJH8pYxoGZH4GTt3fCcFqluw2qO1hqKEJ9
vrA7lYa4rdl0CsmlTaLHQnKq107qLnhUUdmOm1RkxDoqDpbyRmyzsIOELSrM8Vjn
/iHuVDJL5+wrpAY8R/kG0JEmdWFY+xYVOTV7WQu+U/AaaDJbxGGs2AuxjfqmMHZh
8gzp8O2bF8zC7sW1bafpJxCOovYZ3/bS2943HgSmRE/qEpAL4Z+ZHvutatXVbw9/
NrM9R9B/nfrP/49Q85w7Q6hurkwIpuI6exRIT1K2Xi5768UxKAKfKQwCrQZ4xswD
XRyPxOAW68q3Ll56tJvfsduxiY3dh5uVWdinAnpxsuLUekn7Jub18qAYcmtFe8kw
t/mHE2qZjZEojvan4oZLJRSKwY7JjTrO4om5/M9Xif9CJalnbhXS9GWby7lSY3sl
7LbN1Rg4YJHXdJh8HRc0CgTgy4ZAiV7BZ9SuQ5Jt9d3QVOTahkg+4NWohgkN85r8
j/8fj8B8pfqkBeoHm1w6s6qNk7iv5VVd7JS+CwRFp2xPJbz8QIM99HdvA/RE/Um5
hf0U+95ZXv9j9bUzswyLfaQ9iVogJHhBiBY/Xha3OpXXanhO9GdOajkr0iYm0uSh
Ceol5yoIXptk1cT0d7wx
=Jg0R
-----END PGP SIGNATURE-----

--qoWe+8UHdW+w9zaz--
