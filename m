Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab3H2RMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:12:20 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56910 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab3H2RMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:12:18 -0400
Date: Thu, 29 Aug 2013 18:12:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        devicetree@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        Ian Campbell <ian.campbell@citrix.com>, liam.r.girdwood@intel.com
Message-ID: <20130829171210.GM10783@sirena.org.uk>
References: <20130828113459.48ecbb34@armhf>
 <521DCD33.2070008@gmail.com>
 <20130828121943.1c8327ca@skate>
 <521DD057.4040208@gmail.com>
 <20130829161217.GK10783@sirena.org.uk>
 <20130829163358.GS6617@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ct8ez/PVgO98mXV4"
Content-Disposition: inline
In-Reply-To: <20130829163358.GS6617@n2100.arm.linux.org.uk>
X-Cookie: Snow Day -- stay home.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ARM: Dove: Add the audio devices in DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ct8ez/PVgO98mXV4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 29, 2013 at 05:33:58PM +0100, Russell King - ARM Linux wrote:
> On Thu, Aug 29, 2013 at 05:12:17PM +0100, Mark Brown wrote:
> > On Wed, Aug 28, 2013 at 12:26:31PM +0200, Sebastian Hesselbarth wrote:

> > > Also, we'll need to distinguish between the different audio controllers
> > > on a single SoC, i.e. i2s0 and i2s1. I suggest checking the (phys) reg
> > > base passed.

> > Why is this required - ideally this would have been mentioned in some of
> > the previous reviews...

> I've mentioned the differences between the blocks to you repeatedly in
> our massive thread, including that some contain the block with different

You have described some additional features which will require
additional driver support.  I would expect that the device tree bindings
for these features would be added as the features are added and the DTS
files updated, for example by listing additional compatible strings if
that was the binding update, as is the normal practice.  Obviously any
hardware which is not compatible with the current binding should not be
being registered using the current binding.

It is not clear from the above comment by Sebastian if he is referring
to the same set of hardware differences or something new - doing things
based on device address is highly unusual, it sounds like something to
do with the integration into the SoC rather than to do with the IP.

--ct8ez/PVgO98mXV4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSH4DnAAoJELSic+t+oim9WaUP/iIRyI7VvEaZ0NKasXFMhef1
UcN/ufAgcobuewmWn12bBrgRtmmw3A4Gb2CH72ffY+CrxkHIPkbAeoHzAAkCZbXD
Em8+mWUd3UmHcJ9MOngOe4XYS2oEEaCcQ4Due8IZF54ShI3LwuGYp6bgaV+zb+GJ
2AJTJXX6e4sEX36olhPyfrQ/QnFD5P7/pGX3LaQ8rdEPSeqJt1pUqJ1C2Gus4cPZ
QzS32riOGd63jHCGzX3UXhf3ooEeLCFPcu42HMxe0QvgGtkljM0u7EfEQbEFZDKw
USpJGQ2G1xOzaBzP53Bqp/yGEaJYFctghsRqR2fIg8jCCWXWjUkgYKRN3HXmv5PL
vvU5MOG5TZPfDScWmaGPEQxRem9JjeOAEzucIegCHVIOiPJEoYmPRPk600Tmt3dy
iPvGYLKBHRNE8AN8IuoC7xVB5REP6p5raKV25mZymyo0Db5FIbMcV1DmyOa6trSL
l+IWod8WYr0chfagKHmrzhlMp6bgAj0GhF0ifrqeynvnjEUNSv9nL6oI6L00OtlE
3+K0QgWV/wimzJWMNZ0k4JAarA3bBNJa3gwccLYBY7dX7C0p5Z6nIhvuUKuVvpr1
SDF+vSGqjn3I4XjeFRNF3WaN2YHLZRc2q4v3YqwsLShZcKRBiUXrrJfuxzu62JFC
HW2Pp9lm83r4CMf+XKEJ
=WXFo
-----END PGP SIGNATURE-----

--ct8ez/PVgO98mXV4--
