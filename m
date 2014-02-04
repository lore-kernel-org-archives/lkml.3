Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaBDLLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 06:11:00 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35113 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464AbaBDLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 06:10:50 -0500
Date: Tue, 4 Feb 2014 11:10:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140204111045.GS22609@sirena.org.uk>
References: <52ED901F.3010002@roeck-us.net>
 <20140203182152.GG22609@sirena.org.uk>
 <20140203222726.GA5053@roeck-us.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SuijDa9i9ROVGHY8"
Content-Disposition: inline
In-Reply-To: <20140203222726.GA5053@roeck-us.net>
X-Cookie: PARDON me, am I speaking ENGLISH?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Would devm_regulator_enable be useful ?
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SuijDa9i9ROVGHY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 03, 2014 at 02:27:26PM -0800, Guenter Roeck wrote:
> On Mon, Feb 03, 2014 at 06:21:52PM +0000, Mark Brown wrote:

> > As previously mentioned please fix your mailer to word wrap at a
> > sensible limit.

> I thought I did ;-). I'll try to make sure I only send e-mail to you
> using mutt in the future ... but I notice that your line length is
> less than the one I configured, so maybe that is the problem here.

You need to allow some room for quoting.

> > In both cases enabling and then leaving the resource enabled throughout
> > the runtime of the device isn't normally the best practice for using
> > them.  You usually want to enable and disable at runtime with mechanisms
> > like runtime PM when the device is idle rather than burning power all
> > the time and once you start doing that managed resources don't fit so
> > well.

> Ok, I accept that. I thought that was what devm_xxx_[disable,remove] etc
> was for, though.

Sort of.  They're there but that doesn't mean that they should be used
in normal operation - they should be special cases, not normal things.
Managed resources are supposed to for things that are more fire and
forget.

--SuijDa9i9ROVGHY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS8MqyAAoJELSic+t+oim9yMAP/12UxPhF5pc422lR9Q9Wv99q
FS8hC0p8Q4oPl0gsFl5aRIiCFjgTd84D+8ZkdQ9aILEQVBQB7YAVnDCkyDEfPCu4
4eVGz/Xuk4kXOH24+dfPTs6hoFrS9U1gAo8u0XPbKfY6Cd1i9g72LLvx6OVR96vr
T714/8Z2SgAh3UH5gHN/kQqBGVn9VloncgaT3Ah/B6RkL+ugjlaPDMYYxZ0Lb/qE
EWxEbNvZO3QNzxtU2AoqCZwQ7ZdiOPpYPG0+Wt6iEjW76vEGivVyaxLXsnGyCU2W
IrBaOVjNBD+cZ0yYeb+INjTnHLAIZlWO0V8fT2My477zhV4BnZq0b1Dbj/YZU21R
xH8nuG6kUjIFYmBHmx0uvlRq68mOgW45R2MDQ3bPZMVIPbQQhst0B4ZSUo2zJvTh
xsgwAv6WWlpDy/4ssVgPvcP5KNyBaGrS0mNJ96Bo9MJEALmZPjNlNcWD7QpSzM8E
p63yoVLXO5ocsDOSternY9Z4sUprn2E3daadbHuL47wbKCvpuGPfNyhCRDH+L7yV
mL0r5TNqAxsDByIcQNYor6Mt0cEUEA6AdaT7ufi8CURbwr2HIyTGsifCmuQL7gTH
5R3hfzxrpp3d2kX/vAgoNytkILv7OkSNn3Q5OBU3jhCtOuPjb8jIEUwxROhS1eck
6WX0GAVbt6N8leUdijMn
=bdfO
-----END PGP SIGNATURE-----

--SuijDa9i9ROVGHY8--
