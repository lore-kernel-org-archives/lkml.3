Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757038Ab3J1QiK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 12:38:10 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44007 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395Ab3J1QiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 12:38:06 -0400
Date: Mon, 28 Oct 2013 09:37:21 -0700
From: Mark Brown <broonie@kernel.org>
To: Sebastian Reichel <sre@debian.org>
Cc: Sebastian Reichel <sre@ring0.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>,
        Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        alsa-devel@alsa-project.org
Message-ID: <20131028163721.GJ13643@sirena.org.uk>
References: <1382909086-10493-1-git-send-email-sre@debian.org>
 <1382909086-10493-4-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aznLbwQ42o7LEaqN"
Content-Disposition: inline
In-Reply-To: <1382909086-10493-4-git-send-email-sre@debian.org>
X-Cookie: You fill a much-needed gap.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 66.78.236.243
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC 3/4] ASoC: Allow Aux Codecs to be specified using DT
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aznLbwQ42o7LEaqN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 27, 2013 at 10:24:45PM +0100, Sebastian Reichel wrote:
> This patch adds support for specifying auxiliary codecs and
> codec configuration via device tree phandles.

This doesn't apply against current git, please check and resend.
Please also consider your CC list more carefully, there's an awful lot
of people on this...

--aznLbwQ42o7LEaqN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSbpK9AAoJELSic+t+oim9xrsP/igxKF053ju1GVHtJe9sO1bE
UXnFGI7XeXTR287X+/9onRmKyH0dwjDdgcj0XkPBBLmDX7+LRpOdfQX6f/YZZdo7
X+Sx4jcAmI3qQ/BMNpkGrUilxADj6q8BX3fP9HjrijY+CholSOUnAgr8q4bUlgyC
pOLS2A7Jrcbb+KT0PR2fn0BKuH2pKzref/aPisFI088csN69HD2sbU99tmsbn65p
fWcpt/YW4MwbPnHtHMGey2h2wWv3rPWC/uE63WEyXfVJbHhE4z3mTh/iNaAsnjL+
VRDI+E6xpR+sb2dJszQ4BEDxem0Axjs2Lk3dub8myPfeOm6EiW5bsB0C23ZUJXPS
85/3YB7JnJlS57OSbkH8scE1IDPjiv3Q2fEwcqXK3BazEE7rqBufgm7nGG/Oa1B0
D6WafLfYybsNIwxuG/N6ZHWm58AwdYy6nIEfTvZ8SA7O3AH8r4MZopJXCkhfGNeS
ctd518x0u4lEvoxgjflwO3ov6xwPsBw3ULM6IwLf8OMMp6Y8R1bMgIT50uZW0LMV
NRKoQLnjSJscYdViCcVf076uXb2FrKnq0ZE0mo3jRQteRew7g7nmelFPMy1LnXOu
bZaGuEk5XJ5lvLTaqQKIqJYZq/HuFHDjaIvCv6ks7urAJPd56rGKWYUQ2/tTQkdL
gDW95no7fIY7h8HT6cWy
=T9sN
-----END PGP SIGNATURE-----

--aznLbwQ42o7LEaqN--
