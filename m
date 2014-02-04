Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533AbaBDXWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:22:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35565 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaBDXWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:22:32 -0500
Date: Tue, 4 Feb 2014 23:22:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Matt Porter <mporter@linaro.org>
Cc: Wolfram Sang <wsa@the-dreams.de>, Tim Kryger <tim.kryger@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux I2C List <linux-i2c@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <20140204232211.GE22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-5-git-send-email-mporter@linaro.org>
 <20140204172836.GH22609@sirena.org.uk>
 <20140204212914.GB16179@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yOJWIPlLSoQhvV9Y"
Content-Disposition: inline
In-Reply-To: <20140204212914.GB16179@beef>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/6] regulator: add bcm59056 regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yOJWIPlLSoQhvV9Y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:29:14PM -0500, Matt Porter wrote:
> On Tue, Feb 04, 2014 at 05:28:36PM +0000, Mark Brown wrote:

> > > +		/*
> > > +		 * Regulator API handles empty constraints but not NULL
> > > +		 * constraints
> > > +		 */
> > > +		if (!reg_data)
> > > +			continue;

> > It should do...  if not then make it so since that'd mean most drivers
> > are buggy.

> Ahh, I see there is a check for NULL in the core. Will drop.

It was missing in some older kernels (much older now IIRC) - it's
possible that comment was written before this got fixed.

--yOJWIPlLSoQhvV9Y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8XYgAAoJELSic+t+oim9oVYP/i6v0RZ4Ap2e4KRoPm5nnYU+
qIEqClNVIpawWV2CncXcYPcggrzxGMw6x2uUulllZyJ/GA4k2kzm7Neg3vWRIl+a
+6AxfW367UG1E1dPkW7VEmqlCEvROx8eMx63U0H2N1IiaME43ctpVcMX4mD7fFSP
ERS4dzzJ1CpenJ5LwZhIZ1V4BqVCcy60FFIfIKvXoCB/G3RBdMIn2HNVgxw2V1Wn
FSstQ4L6ResNYYkMBcSP/gbkYJw9WusCIldjyMORLyYJAxp5VD15WsEWQUhoatTN
BrwZbre/YgwdIxxHUe+pZZM+wFcwD+JKOkpbnC11sa/xXOxSmdf4IdxTNY/G9IXR
V19ToFeYPEO2BE1TIEDOUToADpMlwKE8Jhmama/bKBLqrIF1U0RTM2XE18zYi/uB
45doFvwoL7lLK/LiJCZv292ZdkmoVMIe8SW3BlwWCHhvwUlM37Nr4xwtjC1Szh1/
YbA4XwThZruC3fcU4p+/5MqS5e9bjFrTzLZIy/0D6qPI+/M3lxVoZ/4kavRAACVD
XlWZhqXeFdEAO1w3xO2+l7hIOPs9a1+sq76PMTlpQWTpnFO3/gnRkBy+DNPwJM1h
cyRrQpPzeF3oseKO38l3XI3WNOYf9Ln5kJDX5g+i4SrdK+lOmiBNnalHvt58OWDf
CvR+SsAt969QV+n+T8at
=N8bu
-----END PGP SIGNATURE-----

--yOJWIPlLSoQhvV9Y--
