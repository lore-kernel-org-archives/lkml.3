Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaLDLIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 06:08:19 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:48027 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752992AbaLDLIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 06:08:18 -0500
Date: Thu, 4 Dec 2014 11:07:46 +0000
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Jackson <Andrew.Jackson@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>,
        Rajeev Kumar <rajeevkumar.linux@gmail.com>
Message-ID: <20141204110746.GR7712@sirena.org.uk>
References: <547F3CAC.9050105@arm.com>
 <2041200.ZjakFFAZAU@wuerfel>
 <20141203201905.GO7712@sirena.org.uk>
 <2240364.fL8B0EDbFB@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5KGJ5KpT/l+zfomc"
Content-Disposition: inline
In-Reply-To: <2240364.fL8B0EDbFB@wuerfel>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/5] ASoC: dwc: Add devicetree support for Designware I2S
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5KGJ5KpT/l+zfomc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 04, 2014 at 10:55:55AM +0100, Arnd Bergmann wrote:
> On Wednesday 03 December 2014 20:19:05 Mark Brown wrote:

> > Not all the world uses DT, this is a DesignWare IP so it's likely to get
> > deployed widely - potentially on PCI cards and things like that.

> It's not really new though, and we are only seeing the second user.
> Maybe this one just isn't as common as a lot of the other designware IP?

It's relatively common with newer companies - it's like UARTs, any
company that's been around for a long time will have a homebrew IP
already but places that don't (or get fed up with their existing IP)
will tend to buy something in.

--5KGJ5KpT/l+zfomc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUgECBAAoJECTWi3JdVIfQexYH/Rm5bxW8m5pVHx5EZn80SjlF
LstfmkdKfuiIlfmfWUlOdOHN9/eEll7q7xhsJ7SQPG3IWaVXO50XZV+QY+XRuliv
x5PZJhIURhR478tqpeKNOlidxj4XO2TcX5JesDyQBvDj7cf+Ao7ZUuaS4Kpnu2p2
xvhXYFl7Rllz+kJiL4u5pB+U/dSBYFMR+SNmTzoCx1WTCwbBjR+5fR6aEyWD1oqQ
pTaVVfgRoDbojl5HYUGKLuQSFxGWaYEHUj5Oy3VcGTuKYMx24YJeAK8Vq9NjoVNN
3AVUuiFjjEGmN1UNzH+16XHX0TVPboRa6HU7VCbEMrvFTaO7cf6H1L14wiMimrI=
=lEd5
-----END PGP SIGNATURE-----

--5KGJ5KpT/l+zfomc--
