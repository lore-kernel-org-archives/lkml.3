Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757426Ab3HLRFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 13:05:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34849 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780Ab3HLRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 13:05:30 -0400
Date: Mon, 12 Aug 2013 18:05:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org
Message-ID: <20130812170504.GC6427@sirena.org.uk>
References: <1376069102-15658-1-git-send-email-broonie@kernel.org>
 <20130812163324.GB3636@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JsPm5tED8eNFkDPA"
Content-Disposition: inline
In-Reply-To: <20130812163324.GB3636@lee--X1>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: tps65010: Use power efficient workqueue for power
 polling
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JsPm5tED8eNFkDPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 12, 2013 at 05:33:24PM +0100, Lee Jones wrote:
> On Fri, 09 Aug 2013, Mark Brown wrote:

> > -		schedule_delayed_work(&the_tps->work, 0);
> > +		queue_delayed_work(system_power_efficient_wq, &the_tps->work,
> > +				   0);

> ... move this back up onto the line above, if it's all the same to you?

If you do that it'll go over 80 columns, the ',' is the 78th character
already.

--JsPm5tED8eNFkDPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSCRW9AAoJELSic+t+oim9ljoP/jhF1vxzcJFqBLT7sOCgnA+e
TofuOABGPgFKWGBbdC3kdspZcPazTjPJ1gRSVf++2qveh2gwgauyAsIayH5DKwnV
PLkvrVzGlanj2Oh8H+XKphAsgdX6JN+rGsjIfA3MiamsUVbJ6ISe7tUiEzcglUbt
aq2IRvMfAWJlN2qCN18dFIDHjJA80aZDoSq/U8awsEEMhE2fRWyd9WmMMhyr5P+3
dwfA3KGlISQyJ5avy5aCwKJZNBJfOVrNfOQgdyxsXglGq/va4bQBudxZBe2ai7GB
ksg0QgnySFJhD4kV/ISpPy6N9l94O9jjIMt6QxUrevzpsfH7vdhV5+8j9Nuy0rcL
uQEqa9iDvCygUDEKu0AILxKw2rl4V+zVeigp3AAXWiDH2yU9j4S+58xpA/vHVsdJ
1CmcdTCMtBI5/HoDxsiOOKCMeY9JKn6IBD24+vMoWjrtEiWAel1NPh3hMVG7scKl
6IMjRKqsLqHS7MO0pCydet+fD0sPSU3eIyOB3MbIOivzm16nbkNBqAyz4gm7nlgW
B1BIEaf/WFD+J5whtxAQhZ7G+g4mTTXIqqiorRFHagd66UaqV5W1l94k4SB8aSmI
WKEFHi04RBfZAFTCPlbE8V5zPUa2l8eHluh7EG/Qul4yF7aG9dXb+Fl+4omluXpG
Wyrcv+m9ZrZCJGiy4p/i
=Sn+r
-----END PGP SIGNATURE-----

--JsPm5tED8eNFkDPA--
