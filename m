Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaBDXVs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 18:21:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35552 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750716AbaBDXVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 18:21:45 -0500
Date: Tue, 4 Feb 2014 23:21:17 +0000
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
Message-ID: <20140204232117.GD22609@sirena.org.uk>
References: <1391516352-32359-1-git-send-email-mporter@linaro.org>
 <1391516352-32359-3-git-send-email-mporter@linaro.org>
 <20140204172309.GG22609@sirena.org.uk>
 <20140204211638.GA16179@beef>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fICFoEfxmEe5Oilm"
Content-Disposition: inline
In-Reply-To: <20140204211638.GA16179@beef>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/6] regulator: add bcm59056 pmu DT binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fICFoEfxmEe5Oilm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 04, 2014 at 04:16:38PM -0500, Matt Porter wrote:
> On Tue, Feb 04, 2014 at 05:23:09PM +0000, Mark Brown wrote:

> > Is this really only a regulator - does the chip have no other functions?

> It's your average multi-function device with other functions as you are
> suspecting.  Buried in the the MFD driver comments is me admitting that
> I need to split this into two bindings. The base device, "bcm59056" and
> then "bcm59056-reg". So point noted, I'll updated with the appropriate
> binding for each.

It doesn't need to be two bindings - just move it to the MFD section and
document it there.  The existing binding is totally fine from a
regulator standpoint and should continue to be so as other functions are
added.

--fICFoEfxmEe5Oilm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8XXpAAoJELSic+t+oim9S9wP/RT/4yR8J+RyLq6g9t6sk4GR
y/uTK+SKhXg1G2HOKBVWhYDrWO1DYOPVDp7f3dGM6Bm/Qn6NCf69zsYpEjFD/ODq
0sloKa3LWQej64fznnB1geUGpXKl50PFQ8oF0zQl3bC0lHkP3HVPreqgCnafJRra
El5IXge59LQ5tRp8nqhpwm+wfNTJRpXNtEhVoFzn3Y1/HvioU8HyOJuumXLztA0F
hHJP+s6TECeKTHZkLf58Efaz+bMfw4KJbl3sUiZS+gFtY1V2MonXtabE42nxadZz
MRbn3ciiHsCXktN6uFoTykWB/LRaVuCz01JzL9QOqNmFBiotJlOO+IT5CvIsiZHB
EZopZrKL9cCwYiV6sZoIsUwHGNgAM1QWcN+yhg+XhZDUH6jX9sNHYcam8/J9gHwf
7SzsuSZTEHPV7z2MIKvID/DG/Rv/4wJdfsoTpKZR/R7R5v3RyUNhQ9CBHTyQe5/q
KAl7heGmA7NyW1qMw1tZ72Uu7SUGLqgEwYaWgzP/wn5pHxa2vo9tAl5137nme6kS
29nohEvN7rNDKYhw3805XFufQuEJFfNqw03TRmbL61gLvmzS2e5VLfroc3ed9oH7
AWWrUV1VC+FAlprDujdzfsxn5JjDF81riyIS3V9Y/HTFG6kJQ//kj1YVFcHs6Qjx
Mja6JhGEzMrrfLLvVEsP
=NewP
-----END PGP SIGNATURE-----

--fICFoEfxmEe5Oilm--
