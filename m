Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab3GPKEi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 06:04:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40477 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab3GPKEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 06:04:36 -0400
Date: Tue, 16 Jul 2013 11:03:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20130716100357.GE22506@sirena.org.uk>
References: <1373906531-6938-1-git-send-email-lars@metafoo.de>
 <20130715172643.GZ11538@sirena.org.uk>
 <20130715165721.GV16653@intel.com>
 <20130715175726.GA11538@sirena.org.uk>
 <51E43D6C.1050000@metafoo.de>
 <20130715195145.GB11538@sirena.org.uk>
 <51E50D3B.2050207@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n+lFg1Zro7sl44OB"
Content-Disposition: inline
In-Reply-To: <51E50D3B.2050207@metafoo.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 1/2] ASoC: dmaengine-pcm: Add support for querying DMA
 capabilities
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n+lFg1Zro7sl44OB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 11:07:07AM +0200, Lars-Peter Clausen wrote:

> I would assume that most of them don't express hardware limitations but
> rather are sensible lower limits which allow operation without
> over-/underruns. But that's something that doesn't necessarily depend on the

Yes, indeed.  Or just cut'n'pasted from some other driver without much
thought.

> DMA controller, but rather on the system as a whole, e.g. on a slower
> machine you'd typically set the limit higher so the CPU has a better chance
> to keep up. So this isn't something you'd want to set in the DMA controller
> driver. But I'm not sure if there is a good way to calculate a sensible
> minimum buffer size based on the whole system's constraints.

Not really.  It's going to depend on userspace as well, and things like
SMIs on systems with those.

--n+lFg1Zro7sl44OB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR5RqKAAoJELSic+t+oim9l8AP/31XO0Q7swuEew4ypKwBl3Kb
rJBZU13oPXRHPcQcic8gUCp3A+mDcz9onzcAWWcIlsfVmXI75mZOUmaGfU4QPVe9
GRDKNwVA+1/Rc+NA8ZqcaRTFQ1mRAAVjvmmun9mewRi2tRPze59ChQKnrYkEpafA
JH2faLcdGSryLcNt4aPNnXYgemoZouSMpMmOFMqNWMViVakeIB3m1E5WXzYK8xJE
nkBp5zWgesUFUKnlPiHeCcdi4gGG42kETJHWdz5ZAKVJnXa/HSLVYJUdny3csZME
lqAgidLzI3h7Eh/FUCu4Xxt0jSOsfg47KoF8UBzLKokreI+kf2gf1uCD4DcLPKbN
Vuvd1n8zumA7OkTAQ6ls0RgvDq+MlnP5nn/qO6bWA1WAQ/wzEDSM87b3qdrbiHL0
2b/p18VZ5hTqe8vwxh3CzrmcLWK0an/geB5WUKSfMu9V0rpXheXZJFIj84QyXMcO
CdwXo2sD/gtwORKSEklcs5asfag/AfpM6C5NmI8giy+lFq+ZTmycpfvFSZzVqAny
QN64ckmJxi8ZDqlOjkJSyg24knABQ2dw7sqa1m9WRlhQEajVfo6IygwX0LEDL2+g
sKJ3fM7eDy93PNyafGQ5juxhCKclVm4jplT0bt+qac92T5QK4WFDMPImqgk6bcMB
DwuaerzRF2iaiqfIC9EY
=NmsS
-----END PGP SIGNATURE-----

--n+lFg1Zro7sl44OB--
