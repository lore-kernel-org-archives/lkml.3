Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbbAOPxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 10:53:35 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:34045 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbbAOPxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 10:53:33 -0500
Date: Thu, 15 Jan 2015 15:53:14 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20150115155314.GZ3043@sirena.org.uk>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <54B4DA81.7060900@samsung.com>
 <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="oRWDw5wXQ3uCJU7V"
Content-Disposition: inline
In-Reply-To: <CAL_JsqLYxB5hzLAWXpU=uncM5DEMZU78mP673H9oSSNB-cgcYQ@mail.gmail.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oRWDw5wXQ3uCJU7V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 15, 2015 at 08:24:26AM -0600, Rob Herring wrote:
> On Tue, Jan 13, 2015 at 2:42 AM, Jacek Anaszewski

> > I am aware that it may be tempting to treat LED devices as common
> > regulators, but they have their specific features which gave a
> > reason for introducing LED class for them. Besides, there is already
> > drivers/leds/leds-regulator.c driver for LED devices which support only
> > turning on/off and setting brightness level.
> >
> > In your proposition a separate regulator provider binding would have
> > to be created for each current output and a separate binding for
> > each discrete LED connected to the LED device. It would create
> > unnecessary noise in a dts file.
> >
> > Moreover, using regulator binding implies that we want to treat it
> > as a sheer power supply for our device (which would be a discrete LED
> > element in this case), whereas LED devices provide more features like
> > blinking pattern and for flash LED devices - flash timeout, external
> > strobe and flash faults.

> Okay, fair enough. Please include some of this explanation in the
> binding description.

Right, the other thing here is that these chips are not normally
designed with the goal that the various components be used separately -
I've seen devices where the startup and shutdown procedures involve
interleaved actions to the boost regulator and current sink for example.
Trying to insert an abstraction layer typically just makes life more
complex.

--oRWDw5wXQ3uCJU7V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUt+JpAAoJECTWi3JdVIfQJlAH/14LZlsbUxQleUWSqvUm0Utn
Beo8Jw4dP9fhDxexIZQsWZx9zi1XTlHhlOWLYBi8G4dDm8XVsLE0o8hf3bX+oFmR
1GD/3DwNkk7B15ENbnS8dCZec0e1E4v0XOfNOY9ppEc9l7DdvbTgdL1oXUjJOSx9
s246WxUHhpTuVGYk5ES55YxuBaZeWVrTn8D9S4894REQISEC1c1ILjbyvdS9HiAp
CArEVXYBFhvGWg7vcom+bg30Ro8m/2THd5gDrxtQjU4L4FVavp/EjfdKVJFvSEj6
/2dwK7AGJLFywtXsioiwRQsG3B4facZ7DJsZclFOAoGvHSf9zPfv/5I4Sty3V+4=
=QiRx
-----END PGP SIGNATURE-----

--oRWDw5wXQ3uCJU7V--
