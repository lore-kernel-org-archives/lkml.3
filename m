Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab3GKKbO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:31:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:47183 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868Ab3GKKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:31:12 -0400
Date: Thu, 11 Jul 2013 11:30:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, Alan.Bowens@atmel.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        pmeerw@pmeerw.net, bleung@chromium.org, olofj@chromium.org
Message-ID: <20130711103007.GH24508@sirena.org.uk>
References: <20130607154134.GU31367@sirena.org.uk>
 <51B20630.7000304@itdev.co.uk>
 <20130607164700.GW31367@sirena.org.uk>
 <51B6FE69.6060505@itdev.co.uk>
 <20130611114727.GY1403@sirena.org.uk>
 <51B7151F.5070307@itdev.co.uk>
 <20130619185909.GG1403@sirena.org.uk>
 <51C47C50.8000606@itdev.co.uk>
 <20130702101125.GD27646@sirena.org.uk>
 <51DE61B5.1000600@itdev.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZYOWEO2dMm2Af3e3"
Content-Disposition: inline
In-Reply-To: <51DE61B5.1000600@itdev.co.uk>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 193.120.41.118
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 10/53] Input: atmel_mxt_ts - Add memory access interface
 via sysfs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZYOWEO2dMm2Af3e3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 11, 2013 at 08:41:41AM +0100, Nick Dyer wrote:
> Mark Brown wrote:
> > On Fri, Jun 21, 2013 at 09:16:16AM -0700, Nick Dyer wrote:

> >> For some operations it does. For example updating the whole chip config
> >> (which is a common thing to want to do), it would turn a couple of write
> >> operations into ~20 on recent chips.

> > Is that really happening on peformance critical paths other than initial
> > power up (which could be handled more neatly anyway).

> Well, you're right that we could probably add more API for performance
> critical stuff. But that wasn't your original question.

You probably don't need another API here - for example, if the driver
understands that the device is powered off and knows enugh about what
the device is doing to understand that it doesn't need to be running
then it could for example cache what is being written then flush in a
more optimal fashion.

> > If absoluely nobody has used the separate wakeup pin then the hardware
> > designers are wasting a pin there...  my point isn't that nobody would
> > use the reference design it's that some boards will have the separate
> > signal.

> That's entirely hypothetical, and you're wasting our time until you can
> actually point to such hardware, happy to write patches to support that
> mode of operation as well if you do.

See above - it's not just about the possibility that someone might have
done a better job with the hardware design, better power management is
just a good idea in general.

--ZYOWEO2dMm2Af3e3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR3oknAAoJELSic+t+oim9/bsP/ilw0qFkGwIJfT5AI2kWcG+M
SWtyqjuPjOZP2XsKCemiyi0/KeyAf2gHGP6hxkTDUZMKZKJ78DqQ/2T6FeixKdcP
iBtVUEJam9vDDByWMe48L0WEjiVTase8PuFevshloj8xQ9GELTl2G7wCWO13m/pL
prUcj339B+CXQKGyukZ2S04EP3Vvo20vSrkiOXdQOS3+i6vXRnke+ggadVWeTMTU
R692ZIwW5ZrT0C/CT/5sVvUPNiLXT71esLqNMF/s1z6LrUxXAuPnjmb3BkFTpIf7
ENUY1qDfcQibr3pF6JWVIZJ3EYkTczuxJRPQbnOsvAvTJBLA35uK1QUZB9ZDeGL5
y5fOwiiY8/HRxcLqWMC/tHHLON6KC8SurwJNihPAh8SkrG85EYULosKpGUEXmYdJ
6X9Kzatv59uxBmb3ktsQR1QQd7RKjBIQp5/oq+IbX0ixaQBCXGziqpvyFn4Q+Ftd
RL/MyV2UnMqLL0jJC51VoTurm8SXdIpAV0mMXS/ctrIqY4GSJQBJ1eO3aLhUtnO3
CQP5Mk7YF4NzcKrPKxuJiL2RzFoV2NjUbn7xzDitmU+jVNib8lSYvtFFfDqAdvKR
+YNejmPeKN4SmSmy4cTbt5x80I4EenquSUWQNUo/OG6i3ltovpOkt2WQpjCI6/hd
GkEE04O3oZy88DnlCRDi
=YGIN
-----END PGP SIGNATURE-----

--ZYOWEO2dMm2Af3e3--
