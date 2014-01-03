Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaACAu1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 19:50:27 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40555 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaACAuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 19:50:25 -0500
Date: Fri, 3 Jan 2014 00:50:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-input@vger.kernel.org
Message-ID: <20140103005019.GJ31886@sirena.org.uk>
References: <1386718996-3733-1-git-send-email-sboyd@codeaurora.org>
 <1386718996-3733-3-git-send-email-sboyd@codeaurora.org>
 <20131215113337.GB14818@core.coreip.homeip.net>
 <20140102184959.GI31886@sirena.org.uk>
 <20140102191757.GA2025@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RAJzu4PW+u81FKHr"
Content-Disposition: inline
In-Reply-To: <20140102191757.GA2025@core.coreip.homeip.net>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/7] Input: pmic8xxx-pwrkey - Migrate to regmap APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RAJzu4PW+u81FKHr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 02, 2014 at 11:17:57AM -0800, Dmitry Torokhov wrote:
> On Thu, Jan 02, 2014 at 06:49:59PM +0000, Mark Brown wrote:
> > On Sun, Dec 15, 2013 at 03:33:37AM -0800, Dmitry Torokhov wrote:

> > > > +	regmap = dev_get_regmap(pdev->dev.parent, NULL);
> > > > +	if (!regmap)
> > > > +		return -ENODEV;

> > > And you are leaking memory here...

> > He's not, dev_get_regmap() just gets a pointer to an existing regmap -
> > no reference is taken and nothing is allocated.  It's a helper that's

> I was not talking about data returned by dev_get_regmap() but all other
> memory that was allocated before as this was pre devm conversion of the
> driver.

Ah, OK - I thought you meant that as that was the code immediately prior
to your reply.  Sorry for the confusion.

--RAJzu4PW+u81FKHr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSxglIAAoJELSic+t+oim98YUQAIrK4NWbSX0wT5D3uGf0hu4Y
ZnQovrZMbuD0r4euLUbKDJ9EV9U9ZgEcbyMl63O3h9ny2z8a0r7Vxg9oxDYmSc+b
ajn6qVnaunJCamzPFsFM/U8rtvEiK5K6DMOlF/wAX3nNYj/T900zIgtoAfgf3CF2
JL0PKLpqVuiyhHPyv/USciko93mYEJMKF/YsyAN80VrjerEqAOCmL1dhDEu6Rgn/
dzyFyuoxPoR9+wJkNo8KI0Tfcwl+bqwayMQlHJCUM2ITMWnEQNCUwREhmdLsWWdA
/7JMZVxtrPcm+A8VQwhi4KbL6f10eLTDKgz203Li9xppAdE08ek4HqZwisgkCIKx
+1GtbWDEpRkNJOTk2sYEdZdShCW+18wEEod7WFoivqgjjVrayuyy9IS9hJ5aDgOm
3RAscKtRLU2CXXHae8o6mSj8ETjFocCdn8Gs91hvGP0NqLHFpWZ69s7CCzBOona1
39GIe2UO1TSxfH1d6JoQ0o8dI2Pk5ckHnYX0sA8FjLY7sss/J23l8KNIoa4jXqqd
Lae9LPXXpqxD+shG+ZfTC2tpdaO3dMUKFx6geFXsInPhFtIjx/PJNhZ/zi/3gv0q
bOwF0hzv3ecKXaSVke9wenDZW55Kt0/iDws1ILA8r20sbnAMWdf7oEGnbB7T6iMe
/tgN4IutOPvpsHpTrusr
=OSwj
-----END PGP SIGNATURE-----

--RAJzu4PW+u81FKHr--
