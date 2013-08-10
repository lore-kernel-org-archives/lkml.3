Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556Ab3HJLNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 07:13:08 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56028 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab3HJLNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 07:13:06 -0400
Date: Sat, 10 Aug 2013 12:12:31 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130810111231.GR6427@sirena.org.uk>
References: <20130809094340.GO23006@n2100.arm.linux.org.uk>
 <5204CC04.4000401@gmail.com>
 <20130809113940.GY6427@sirena.org.uk>
 <20130809130932.GS23006@n2100.arm.linux.org.uk>
 <20130809180058.GM6427@sirena.org.uk>
 <20130809182516.GT23006@n2100.arm.linux.org.uk>
 <20130809194434.GP6427@sirena.org.uk>
 <20130809203847.GU23006@n2100.arm.linux.org.uk>
 <20130809234209.GQ6427@sirena.org.uk>
 <20130810093137.GV23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9BaxaTZrvsRxcpDQ"
Content-Disposition: inline
In-Reply-To: <20130810093137.GV23006@n2100.arm.linux.org.uk>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 1/1] ASoc: kirkwood: add DT support to the mvebu audio
 subsystem
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9BaxaTZrvsRxcpDQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 10, 2013 at 10:31:37AM +0100, Russell King - ARM Linux wrote:

> Right, so what you're proposing is to come up with a DT description for
> the existing stuff, and then have to change (or at the very least augment)
> that description later when the DPCM stuff goes in.

> What should be done is to sort out DPCM, get that working and then sort out
> the DT side of it, so that everyone gets only one transition to DT, not a
> transition to a half-baked stop-gap DT and then have to go through another
> round of DT changes.  "Because we can" is not a good enough reason not to
> get this sorted properly.

Since we know what the hardware physically looks like we should be able
to write a DT binding which can be stable for both before and after the
DPCM transition.  The bindings would have to be truly awful to require a
rewrite here and as with all the DMA wrapper drivers if parts of DPCM
that don't reflect actual hardware are appearing in the DT we're doing
something wrong.

--9BaxaTZrvsRxcpDQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBiAcAAoJELSic+t+oim9WnEP/2EmtbNkMH2GxOdeF/Q6xkOd
r3wE2UjWADwHB00CWKFh24P8jxDRGGGOmSRIeIrxSlKta6No7pwA04ld3z08ykSa
ZbsML0QQZl9Dn94F5PNc4LQg66SUgTSIGaNAhKOI7CEcafTIxIftQDYZtQTiqsiC
lgfCeXVqNJk4427SH7xTuQNvKrAlSrDJJnTdhM9XmdvZd3jbj377LNH3WCgRC0q9
FGGxBdd/o8jGZJmy2+smMEgK7bcbDLbmb6JBwsHUokyOrIxsfSLnJLBOy6vabiAe
xrHcj75we/olH50m7yVYizU3Dgq+vvAjiJOI3Msc/iQhv1EHBQ4eD3sGvSjc5vUU
z58K4PyjHmJG9W5bFIQ6VYlTcRMlTg4fTbn8R/hhRepq7bHVAzZ000vpbNmgbWG6
KdEx+XQ5jD3F0TihGMxo9Zon8XE8i2KiHJaqWh+Jgyrcf1LSkNSZaQtB/P21bv9X
XQwB8lnPBPAfnpXJw2mUF/mMmd6DysupI5ilOSuook7zrOkkcQbXiVMSgcSf8qAI
7BNjSisOvP5NVroxJ4vHvPhItzGLGcp8oBEvonpfX/rZ9SoZoaoePdPr5KK3pMuE
PEaXPKi1N3151RZjmll9JPaVG8xOQ2GJPnLdEWEPhtP2sz/kRar2PuHgBNjCad8+
44tuuLROHoHmiJiS9oQu
=KqIZ
-----END PGP SIGNATURE-----

--9BaxaTZrvsRxcpDQ--
