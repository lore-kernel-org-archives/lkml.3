Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaEBQ5E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:57:04 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55341 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaEBQ5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:57:00 -0400
Date: Fri, 2 May 2014 09:56:43 -0700
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, alsa-devel@alsa-project.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        sbkim73@samsung.com, Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Message-ID: <20140502165643.GQ3245@sirena.org.uk>
References: <20140424133920.GA12304@sirena.org.uk>
 <5359E18B.60600@linaro.org>
 <20140429222915.GU15125@sirena.org.uk>
 <5360E5E7.8090807@linaro.org>
 <20140430180314.GA3245@sirena.org.uk>
 <53623004.5010805@linaro.org>
 <20140501141510.GW3245@sirena.org.uk>
 <CAD=FV=Wa4CovkxBng0SkUUAryiFqa=m63tro1Yv1jRgp4e95aw@mail.gmail.com>
 <20140501164003.GC3245@sirena.org.uk>
 <53632568.5020200@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="huW973Vpf/9rkSey"
Content-Disposition: inline
In-Reply-To: <53632568.5020200@linaro.org>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 209.49.225.226
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huW973Vpf/9rkSey
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 02, 2014 at 10:26:08AM +0530, Tushar Behera wrote:
> On 05/01/2014 10:10 PM, Mark Brown wrote:

> > There's patches been posted by (IIRC) Sylvester Nawrocki for this which
> > I think Mike was basically happy with - I don't immediately see them in
> > -next though, but I may be looking in the wrong place.

> Right, there are some patches from Sylwester regarding this. I dont'
> think the patches are accepted yet as Rob has some reservations against
> the clock parents.

> https://lkml.org/lkml/2014/4/9/173

Well, OK - that's the bit to fix.  Speaking to Mike the other day he
said there was also another competing implementation of this.

--huW973Vpf/9rkSey
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTY85IAAoJELSic+t+oim9P54P/Rbsqm/AfMtIN4H7pGvOO8hx
AMthNugbHtxV2QHrdGWE0dPuigHhKv1M1oyFuBQbn/hQNJmdYCKA4iYM07pCNctT
pBksXo0UwA66SghLZiH4XF4XN278Xonj9zvjnza2+v0l5tGESORbUNWgr54Bkg7a
UBx3wh/bB9t2ZCfYvmx74yWW3JMQoqNdMrdASJ9uJW1/Xdb1p82R1WVtHmy2iFmJ
25udDZRMMqHX1RqkpGvuZX2uVAyYkZ4igROJAJMeyrg78xqjt4nwQoa/6JdaGPlZ
4tlVSt06h2ohCFAX+A35lLRfJ4JXQKPK+dGGmJOCvs3N/6gin7Jn277G72/UBBVx
h1Xqt+LkCTHDyhAdDYS+BVWLcU5cp8LodL4qV1iJ8Y6Em2zudaqtqN+MI1kWtqxh
dgpNMOlvBs8rTTBgvDLrEaiDtiXg/xylRSv933QsANmaw7zKzegYHwMMp5vTftMh
dHSaMxuF7zvACzxswjKJ6oNZd8u+NORknXQVskC+GCV47JKfz6MYmQfr5ezuJ3XJ
nATMWehVsDMQ7eRBoSY9G1v1AbNKeKSOhMa1Xct+nqEWn+bB2hLZC4PrDGvF+ttg
22dTqGJMIp1UmgzoOdV1Nv1zy7UPosXxEdN3oT3g30Z788+hn0zExePnYqgaHJRd
VxNCb9ErXfA15dlp7i/w
=HMhI
-----END PGP SIGNATURE-----

--huW973Vpf/9rkSey--
