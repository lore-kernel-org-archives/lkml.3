Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaCJHij (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:38:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36024 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751675AbaCJHii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:38:38 -0400
Date: Mon, 10 Mar 2014 07:38:26 +0000
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140310073826.GA28112@sirena.org.uk>
References: <1393814545-15002-1-git-send-email-Li.Xiubo@freescale.com>
 <1393814545-15002-2-git-send-email-Li.Xiubo@freescale.com>
 <20140303045952.GO2411@sirena.org.uk>
 <5bc570ec866541a68df5813ffbe3168e@BY2PR03MB505.namprd03.prod.outlook.com>
 <20140304043603.GI2411@sirena.org.uk>
 <0dbba1debfd149a6a5e3985349a95793@BY2PR03MB505.namprd03.prod.outlook.com>
 <531D6262.3070201@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O7yGjEYpwrIKCenc"
Content-Disposition: inline
In-Reply-To: <531D6262.3070201@metafoo.de>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCHv3 1/3] ASoC: codec: Simplify ASoC probe code.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O7yGjEYpwrIKCenc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 10, 2014 at 07:57:38AM +0100, Lars-Peter Clausen wrote:
> On 03/10/2014 04:51 AM, Li.Xiubo@freescale.com wrote:

> >Has there any other problems about this patch series? And this I had tested on
> >our Vybrid-Twr board based on SGTL5000 codec and SAI drivers. If not, I can
> >continue with my second patches series about " Remove set_cache_io entirely from
> >ASoC probe".

> It looks good to me.

I don't have the patches any more.

--O7yGjEYpwrIKCenc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHWvuAAoJELSic+t+oim9DOQP/2uC004Rud7rRuhTf3EYs0Cj
qQzuzB06p/aFJQIkpuaNkYkOEk5BN54KgMah/gJ13hMhdG5v4zKFuMCqmshejsPH
9BMhY9E/L4YauozkEPoebqi6CdLLCEqWBlbvMdBxLHQe/e2hizlKbIhcvxwJ0uVi
1eeNQUOaqUUxwhOQmSL5BocROqyLQIIbG+qg9Z3zxS7WLIJMPHmmXqEGwPOxsPzi
xzare6CkSHGKVo5b91r0f7erLouOEG2AFifxHbi5ZenwVLP3bXn3SFmvnGy5kwN6
O0Zp6/HsBsB/EG4/oYuwEJxLVgme1gUzxliL6Y3GjKKQ1obq6y3UdgX+kDSRjXjT
+e02mxGOWA2krRi5OcakzA0hRRIiqGbUc39VS6mzpYMDbs+M1et2mKrIqdbRShNY
whyI4gUnpDzBbIRByW769Xh8bkWwjl0KZ931Yoq50UPcrUxFeXb+LLxIoDZJ/d5x
gTYtxHvNqTkHbBMvuGvdVprOZmziITc/fMcZ7m9EtpqoDmLfSr+HMWsgn0/N326q
kTtRtXdbQkEM0MS/KgKvufbjw6TDhJPskRLRbL4VdAiDdQKtAXscna9+83GfaZij
pMJs2zvBBdhh0pY6phi08i9AmZ6+4xSVUraJwrN4qMzAQ4XUikfWLKQ7uIRcGuu8
hyhlOtG7akyWLAVtfYXz
=9+jj
-----END PGP SIGNATURE-----

--O7yGjEYpwrIKCenc--
