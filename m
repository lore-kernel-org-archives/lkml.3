Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751541Ab3FDSix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 14:38:53 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51999 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FDSiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 14:38:51 -0400
Date: Tue, 4 Jun 2013 19:37:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Kevin Hilman <khilman@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Hebbar Gururaja <gururaja.hebbar@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vaibhav Bedia <vaibhav.bedia@ti.com>, sudhakar.raj@ti.com
Message-ID: <20130604183754.GT31367@sirena.org.uk>
References: <1369995191-20855-1-git-send-email-gururaja.hebbar@ti.com>
 <20130531170437.GA17591@core.coreip.homeip.net>
 <CACRpkdYnhjpFp1CM=P_hddBe4qVigtE0c+CN9NKvk3nFgJS-ig@mail.gmail.com>
 <87k3m92148.fsf@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4A5jqvouPF9zMMhx"
Content-Disposition: inline
In-Reply-To: <87k3m92148.fsf@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/11] drivers: Add Pinctrl PM support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4A5jqvouPF9zMMhx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 04, 2013 at 11:15:51AM -0700, Kevin Hilman wrote:
> Linus Walleij <linus.walleij@linaro.org> writes:

> > I think this will save a *lot* of identical code in all the
> > drivers, that will just have to call
> > pinctrl_select_pm_sleep(), pinctrl_select_pm_default()
> > pinctrl_select_pm_idle() instead of all the complex code.

> > This is what I planned to do but never got around to.

> What about taking it one tiny step further, and having it done by the PM
> core itself?

> Seems like something that should just be done as part of runtime PM
> transitions and the suspend/resume process.

Indeed, I remember suggesting this as part of the original discussion of
having the code do the default state setting.  It seems like there ought
to be very few devices which actively manage pinctrl themselves,
otherwise we'll get a lot of boilerplate.

--4A5jqvouPF9zMMhx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrjP/AAoJELSic+t+oim9DmEP/3sP8FVKLoscMVCtMQc42wPF
bkIv73O08RRyFyiY6s6qonCXt9BgDqx2fEINZlKBq9XgngFTnFBSfmvK5xPSqwON
eZK3JNOHn9B3nFedspDc2ybVEjCdx6caW5OqR5ywShEFK6ZNI4cDpC15ploP8cGe
pFBXSKDVYbeisXz40peJxVnoGcu34gK0uQmX9FUc0R3zfnZsmUf2Z/IWTLs4sPPq
YWVZtsU+hIMnrpBEEW/xdYFQ23iGSVcYj5vGHNakXA5CkKQr11kXG5EbZ0qDbb27
BlVMEMKQYKD4CNd4C+s+5TYa381TeOT6ceLJwGArf6TBeagwByotJJT4ibS39er3
LGTtZHic4II/ARv9YSzIXTfHOk6EpWLYAvWcIZEf4d9yMabGVh15fK6gB6He9d7x
aW7c0qbnnoN/wDkjbGGExpf3V4fj5lt6uy0DpMZmzumfBFXizev+i4zbxnE9BLSy
Wk1czJ0ck02wnE1di/AeKAhuVAatIqClCDjSs97TzEWT2WYXrW+uBmkHOWWFS83s
z+m2C1vxWP61jpnv5spEGrjERrg2M5+AosQ9tYmj3waHPMD4YZtZhuTyFZcvD6Si
5ii8CBnwkpMIbUnHPRDP4d1K5nWy3qm06B8iC5UGtT4/8kcm+q3RUe5Juvc78AzJ
rjoDxyUTrkWh/MbsmLIt
=lnk6
-----END PGP SIGNATURE-----

--4A5jqvouPF9zMMhx--
