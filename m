Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab3GWNaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 09:30:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43789 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3GWNaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 09:30:12 -0400
Date: Tue, 23 Jul 2013 14:29:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jean-Francois Moine <moinejf@free.fr>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@vger.kernel.org
Message-ID: <20130723132948.GF9858@sirena.org.uk>
References: <20130723104641.6ee0b9ec@armhf>
 <20130723125756.GZ9858@sirena.org.uk>
 <20130723132314.GU24642@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OjlPywxCsLltMP9x"
Content-Disposition: inline
In-Reply-To: <20130723132314.GU24642@n2100.arm.linux.org.uk>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ARM: kirkwood: extend the kirkwood pcm/dma driver for DT
 usage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OjlPywxCsLltMP9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 23, 2013 at 02:23:14PM +0100, Russell King - ARM Linux wrote:
> On Tue, Jul 23, 2013 at 01:57:56PM +0100, Mark Brown wrote:

> > This device has no registers or other hardware - this looks like a stub
> > device which shouldn't be visible in DT but should instead be created by
> > the I2S driver - look at how most of the other DT platforms using
> > dmaengine work.

> There is no separate DMA engine on this platform.  dmaengine is totally
> irrelevant to this hardware.

The pattern for instantiating a DMA controller that's integrated into
the DAI is the same as that where the DMA controller is a shared IP
accessed via dmaengine so it's still useful to look at these platforms
to see how to do the instnatiation.

--OjlPywxCsLltMP9x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7oVJAAoJELSic+t+oim9M40QAIpBsTnzY1l5HGweNibKYxph
iXzOXZvvKqWTHGN4+Nel1c7zlQIGV8xgxOCpvx/OVXDAUbcVzfA6Jj6cFvg6RQ1U
vomeUH5X7dnGKJRy9YEQjUEnAyFSE75MJDi2KcV7BcN6yXYKJ1H+OHbSMy+gOxJz
Ius7RVI9zL7J+M/3dqbiT7Gr+qVCrKCnHUQmQRbHfDdDc4rD12tcQDljZMlUGQlV
BEtLxkxhr4ST8Mq4PjcMbfF4Aqb4uXrR8sooai0ckmcPy14/VY3rKDabDTgWcGX7
8FREXHxkERgdzaFayUk8x2Mf+hUO4DnGsqyFBJ69lqJYd9+K7Qqlbj3IwYLaDrJE
X0xB7zAD+DrVCSFwdFftMRPy4bvXBEXwDcSy3EZeG/o2nInWVmXG6MPauzQ15nBD
7uJ45h8ZoVs8P4ZdR5le+R+kInAV8j7OTgvi2H7sEJjZwwls7LDxx62HOWOfeZSo
FcmpN65VuSjRzgR70sZ3H5/ErSQXhzk34Yzy4wv2JxPD7K7UUTScURIhCVQsiiXr
rlc6Vt02hgKLTmRymPaviWtqX4HF+Ujee6TNp5ZgREaqhYMSWWrVAjn/pDyM0Vuv
FxP1oeEbFH5Dm08VTcEfBawkaJxyoGH/GOgUGH4HLy+iYU9wYKVSsJ5m53zcXScn
QJOHoeqYb6zTy9mR9E0E
=dC3z
-----END PGP SIGNATURE-----

--OjlPywxCsLltMP9x--
