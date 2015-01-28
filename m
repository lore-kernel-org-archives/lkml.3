Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbbA2BZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 20:25:58 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38409 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbbA2BZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:25:54 -0500
Date: Wed, 28 Jan 2015 11:06:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20150128110632.GR21293@sirena.org.uk>
References: <20150128130047.2311c637@canb.auug.org.au>
 <20150128090935.GH14516@opensource.wolfsonmicro.com>
 <20150128095040.GI14516@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="79RLYUToM/4jl2vV"
Content-Disposition: inline
In-Reply-To: <20150128095040.GI14516@opensource.wolfsonmicro.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the sound-asoc tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--79RLYUToM/4jl2vV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 28, 2015 at 09:50:40AM +0000, Charles Keepax wrote:
> On Wed, Jan 28, 2015 at 09:09:35AM +0000, Charles Keepax wrote:

> > Very sorry guys my fault, not sure how that slipped through. Mark
> > do you want an incremental fix or shall I respin the two patches
> > in question?

> Ah... ok I think I just timed my patch very badly in relation to
> Lar's changes and it was building here so I failed to notice the
> error. I see you have fixed it in the merge are you happy to go
> with that solution?

It should be fixed for tomorrow I think - the zero day tester was quite
slow for some reason.

--79RLYUToM/4jl2vV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUyMK3AAoJECTWi3JdVIfQTtwH+wesOWVOVHHRceeFmLExpWv+
5wGu9zwonNJ0CaTfWNSrs8MwV+7o4qa/sQWYThJuJAg4XS6VtvtMiVyuPsvymRRO
fJGvJph49n63VNm0WKLHWNRwAThLZU9rQldGdQPWNqs/v2bCbaseqpa10AsNEiZN
eX3N8cXH5uuWlvXGOVgmiKY7S+uahbjY0mXFYdytpAqtto+v2oMVHYk3w8rS1OhF
EdUuzVhsWaUxVL2yDsKf1wwI8Fea5ilNYRYRyAjXtj/1IreMq/9P9mdgthDPHSrz
jD7NkK/Kr2N4CMRSqLe6RZl0De52jofGf1NFALJlAZbPepbZvbQN0/27psfj/Hs=
=ozMb
-----END PGP SIGNATURE-----

--79RLYUToM/4jl2vV--
