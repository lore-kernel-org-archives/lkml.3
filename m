Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaAWM2B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 07:28:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58539 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaAWM17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 07:27:59 -0500
Date: Thu, 23 Jan 2014 12:25:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Michal Simek <monstr@monstr.eu>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Daudt <bcm@fixthebug.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc C <marc.ceeeee@gmail.com>, Matt Porter <matt.porter@linaro.org>,
        David Brown <davidb@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20140123122519.GI17314@sirena.org.uk>
References: <1389743333-16741-1-git-send-email-marc.ceeeee@gmail.com>
 <201401161219.01038.arnd@arndb.de>
 <20140116134732.GB17314@sirena.org.uk>
 <201401171804.30572.arnd@arndb.de>
 <52E0D9AD.1040409@monstr.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nKzfxXxTXZ/rSi7L"
Content-Disposition: inline
In-Reply-To: <52E0D9AD.1040409@monstr.eu>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 7/7] ARM: brcmstb: dts: add a reference DTS for
 Broadcom 7445
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nKzfxXxTXZ/rSi7L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 23, 2014 at 09:58:21AM +0100, Michal Simek wrote:
> On 01/17/2014 06:04 PM, Arnd Bergmann wrote:

> >> I thought the solution with deferring registration of the resource for
> >> dev_get_regmap() until a proper device materialised seemed simple and
> >> enough, did you folks run into any problems with that?  I had assumed a
> >> patch was likely to materialise so wasn't worrying about it myself.

> > I'm still hoping that Michal will do that patch.

> And what was the resolution/recommendation how to do it?

Split the regmap creation so the managed resource registration could be
done later on with an already allocated regmap instead of requiring it
to be done at creation time.

--nKzfxXxTXZ/rSi7L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS4QosAAoJELSic+t+oim9IRcP/RcjGAsMw6AO4bwnobfriOfK
xb5wIBfEqOzluTw30In/ZnbAeC3K5Ul0nempH/U+RxD7xyVnNlZO+UUINEWN5ItE
JsSGEmn7e0JG//41R1AzgxbsbNGNYfpRpb2xlYhWLS6OatMg8w8kUV2c55r36Siz
evsaTwVLtthtKqAe+dB/67gtMzAZ2ZmzTShifIRankVekdS47bRDIkeYDzM51rKG
vYRub5hVHZpCPAvAQdtJLXRTZYAr1QCLklSt8UI4ljoU6UrsKaUBBhdJ+LdKOLEO
zPSYgtJv+r6uyO6SRIj4qCCYy9mhkYkNzWRjII1Spsajec+aauFTPu8vaB6xo6Sm
RkgkxzbR27lwNH9vXIj6KuFlFfcEX8kgby+RqbIL9vEFOEy8wuOPGYUtSRJskTSq
gdMigTu28aMrfFt+xQkwQiuy8AD7/I/sVo4JtWj4w2bYce5D+hfaSLJZ2oevQgRV
geAVvBbka1B7+zM6yMTrEP4VO+vQHi1nEzy71XnyYyeL8mVcR/RauotNP9j2dcyt
spIn4+xOaCCOPi4MQgMZM12Tmb+R6XUppqzpYJ3D0eMk1bhU+CrBLc4NhJoyMW7p
ESmev1tmVjQL20iICF7PZ7fwOlYZUNzvhbKl6ad18HrFUnQoLTZHlo8fB02Z15MD
2LDhhY+BvIZ6aR8FVUD2
=Xx7b
-----END PGP SIGNATURE-----

--nKzfxXxTXZ/rSi7L--
