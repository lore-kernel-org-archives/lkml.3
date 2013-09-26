Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932106Ab3IZKQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:16:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43586 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab3IZKQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:16:10 -0400
Date: Thu, 26 Sep 2013 11:16:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Liam Girdwood'" <lgirdwood@gmail.com>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Steve Twiss'" <stwiss.opensource@diasemi.com>,
        "'David Dajun Chen'" <david.chen@diasemi.com>
Message-ID: <20130926101605.GC19304@sirena.org.uk>
References: <000701ceba5c$69459b10$3bd0d130$%han@samsung.com>
 <000b01ceba5c$e35a8140$aa0f83c0$%han@samsung.com>
 <CAK9yfHxSFZv-=cdsoLzYBBZhShX9iMgoBBfOCJDLA3_P_dGetg@mail.gmail.com>
 <002b01ceba81$4413aa10$cc3afe30$%han@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xo44VMWPx7vlQ2+2"
Content-Disposition: inline
In-Reply-To: <002b01ceba81$4413aa10$cc3afe30$%han@samsung.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 05/18] regulator: fixed: use devm_regulator_register()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xo44VMWPx7vlQ2+2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 26, 2013 at 03:25:59PM +0900, Jingoo Han wrote:
> On Thursday, September 26, 2013 3:14 PM, Sachin Kamat wrote:

> > > -       regulator_unregister(drvdata->dev);
> > >         kfree(drvdata->desc.supply_name);
> > >         kfree(drvdata->desc.name);

> > Sorry, couldn't go through all your patches yesterday.
> > This one looks a bit scary too as some of the driver data is already
> > freed before unregistering.

> I looked at regulator_unregister(). I am not sure that this is safe.
> So, I will remove this patch from next v3 patch series.
> Thank you for your comment. :-)

Yes, it'd be better to convert the allocations to be managed ones first.

--xo44VMWPx7vlQ2+2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRAliAAoJELSic+t+oim9MhcQAIi3U0VuSAFuEsG6O0wfBEDL
mlBeVkBlorduwT6RJ0s8AWp4eYQwdCNwQa/b4Rg+SBMiFfXRZd98rMewGQ3DE1vo
256zzoC0kBc/ZIpAGucgbHzA1sl3F2vs59HHUAAcRG33o9puIC7dehHBjKcd9OPf
h0GlzZmOMF4P3yO4BWBrKavXWe6hckJIHnwf6q/+ipFUGhhKIOifawQfaziqHm+E
x93ES9xTy1vGrX5L2pRO6hDW3mRRxdA6AECbKhH99pgeuaRsyM+OyvNLmHAeferz
74JUfCNFjgcks7g16ZV4Cu8or7fc/MIs6n67/SwaEquDDapz2Vbd5dDrO08j+u13
5BR6LQPXZCGPO1bdFdob4K1Be99YSBQbN+tV0qCsBK1jZD9xRu7JZtRCyb/f/y2w
Kcp1kmTTmcRJ6OoKVkJ8preI8XWyycpcBkmz/x089l7iRZScLT0rp2mckiXvGlyF
gj/umoPq6hwCCLED0XrDTlAh+QDt+11RP3Q8FEQgknooRCz0NVNik8KNQDGuNAUv
ERb0dpibGQUQmZcq0Kdu8uDCqpbnU0mrDrTul5omwY9GZbO2z1iMypTr1qzrUHkd
UspqqAVUy7tcgDFzg0ii0t7f7/2Bb/tbxloL593O2AuG/wumDv2DDRKpw8XIvoFB
+jjwkkPoA/nvpjUNdrNa
=m0VQ
-----END PGP SIGNATURE-----

--xo44VMWPx7vlQ2+2--
