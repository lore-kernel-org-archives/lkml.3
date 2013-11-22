Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab3KVOFp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:05:45 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54664 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753500Ab3KVOFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:05:43 -0500
Date: Fri, 22 Nov 2013 14:05:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-rpi-kernel <linux-rpi-kernel@lists.infradead.org>,
        devicetree <devicetree@vger.kernel.org>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20131122140519.GN14725@sirena.org.uk>
References: <528E4E4A.20403@koalo.de>
 <528F5CE3.30105@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5FetH82qe0Z6y/zI"
Content-Disposition: inline
In-Reply-To: <528F5CE3.30105@koalo.de>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv4] ASoC: Add support for BCM2835
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5FetH82qe0Z6y/zI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2013 at 02:32:19PM +0100, Florian Meier wrote:
> > +	dev = devm_kzalloc(&pdev->dev, sizeof(*dev),
> > +			   GFP_KERNEL);
> > +	if (IS_ERR(base))
> > +		return PTR_ERR(base);

> Found a typo here, should be IS_ERR(dev) and PTR_ERR(dev).

No, it should be a check for NULL and returning -ENOMEM.

> Is the patch acceptable apart from that now?

Not looked yet.

--5FetH82qe0Z6y/zI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSj2ScAAoJELSic+t+oim9zCAP/1zcMpvVJkYKLvp/7mOKlugP
ercKdvPV12HmeNnjiHyzJemq4qjlAsShvsxX6lYZmuofLFzO9pxA+isiiq+9LqDI
eLO0QXCXnVywpn+B5w76XPr5EzAwm1p6WyPIS0TXRGrAy/27qY42+LG6MG5IA5Sb
Htc+Xx5BttNH5mTf0t5OpU7+zWyac3t2B5e/RJ+6ru0IpnA9Z4C3pgiosW8SBrUL
mEQk+msKKryQ2nObVjiIK0QAdEKhg5pGn4/VYFebAUYV/xzM7+xSCpWu62vcHMAY
msvam5ztE+27Dow63aop75V1JzPIhNY3XYk/T3TY56XDQ2rCrT2G3Q44JmztM1Xk
cIebndq29Ub4wY91QN5B2HBm2dJtLT8+3wf8WlS03QiEHpNIj5T+HlGs0LAtKVFK
5SVyOf7Ojeks7iYPplp98v33Z3lEdqmex4oTJjazHfdz75xA2SH7Ap9m1XnMRSVS
f8TpKMcYXS35NhueVvf/yt2ddKiWzNQ8I01ZwjrJLJtoPgdfdf+Cd/PMgjvenJB0
Az7FryN+VSZrV9SUpmjEFpd79XilESSlz32QK6W76KnUTZJe6opERmL15R41el9r
zmm52IcG2GoSJeiIs7f/Std6rg1/M2183X1QORfs0JT+JTrLAOsju1yzzEKGVNHw
G8mzWLMskQgZEGdAyoz0
=0yDE
-----END PGP SIGNATURE-----

--5FetH82qe0Z6y/zI--
