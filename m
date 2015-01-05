Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbbAEOoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:44:11 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36271 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbbAEOoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:44:10 -0500
Date: Mon, 5 Jan 2015 14:43:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Tim Harvey <tharvey@gateworks.com>
Cc: Fabio Estevam <festevam@gmail.com>, Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lucas Stach <l.stach@pengutronix.de>,
        Silvio F <silvio.fricke@gmail.com>, Christian Hemp <c.hemp@phytec.de>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Iain Paton <ipaton0@gmail.com>, Anson.Huang@freescale.com
Message-ID: <20150105144335.GR11764@sirena.org.uk>
References: <1414729631-11005-1-git-send-email-tharvey@gateworks.com>
 <1414729631-11005-5-git-send-email-tharvey@gateworks.com>
 <CAOMZO5DzEe91pTv+UkCbj0DzgVDOb9hjuakt9NmpTJnEk-j8UA@mail.gmail.com>
 <CAJ+vNU3PQYCE4tABUiqU+vGkGqBEqdVKz25W88-ByOQZxunVLw@mail.gmail.com>
 <20141218142205.GZ11764@sirena.org.uk>
 <CAJ+vNU1YQWGFaEm8w8wtaFvUy1jig26jW3+3teMFHLB_oFyn8Q@mail.gmail.com>
 <20141219162343.GF11764@sirena.org.uk>
 <CAJ+vNU0S_=H=VDwxUXBGyNrvjg5MRe3UP-UV9Xnj3MkNdWM0ng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SJ29TS0RoN/cFq+"
Content-Disposition: inline
In-Reply-To: <CAJ+vNU0S_=H=VDwxUXBGyNrvjg5MRe3UP-UV9Xnj3MkNdWM0ng@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] cpufreq: imx6q: add ldo-bypass support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1SJ29TS0RoN/cFq+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 06:38:50AM -0800, Tim Harvey wrote:
> On Fri, Dec 19, 2014 at 8:23 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Fri, Dec 19, 2014 at 08:17:41AM -0800, Tim Harvey wrote:

> >> frequency setpoint. If however you have an external PMIC that is
> >> capable of adjusting the VDD_ARM and VDD_SOC to the IMX6 and an
> >> appropriate regulator driver is capable of doing so, you must
> >> configure the cpu nodes vddarm and vddsoc regulators to those provided
> >> by your PMIC and 'bypass' the internal LDO's by setting their scaling

> > You're describing the implementation again, not the system.  Describe
> > the system then if you want to describe the solution you've come up with
> > for modelling it do so separately.

> > Please also try to use paragraphs to break up what you're saying a bit.

> I'm not sure I'm understanding what your asking for or how to describe
> it differently. Fabio / Shawn / Philipp could you help me out here
> with the proper explanation of the IMX6 LDO's so that we can make some
> progress on getting LDO bypass implemented?

I have no idea what the context is any more, sorry.  The above looks
like you're talking about the specifics of how you've implemented
something instead of describing the hardware you're trying to abstract -
you're taling about the "cpu nodes" in what sounds like it's supposed to
be a description of the hardware for example.

--1SJ29TS0RoN/cFq+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqqMWAAoJECTWi3JdVIfQWekH/jyuWFiDQzhXsXynLm38iti8
3CE1RFhltvBFuj4mRDa/p1XJWPOy9e1z/7TUznvsiRjMq9S1dJcmObWAtUEUvpW2
Bkovtu0JCGDJ76JC/Mm/2f9UoScPxiptiftEJH6qvzR1ar0n/DDy33IcDbE9UP3/
juLTnfmjtOL+dsnfm8qykPqMIMGk8ULQAw4WSZ9BY3ebhFbmOqM3GReFUfQ6f/1B
GuPhRqMwlAE4ldyGy5w/1FbfzPTKFHGDfTeEhA9jHJ6JY8l07L54n7PfcwqOVAZ1
Zaa8tRNrdBEp5j+MHa6zsf2qMMLIAbUWwKP/EjYspHQUtLpA7KlU8B0bqsDBxpk=
=2Dj5
-----END PGP SIGNATURE-----

--1SJ29TS0RoN/cFq+--
