Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab3GZWnM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 18:43:12 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46509 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756108Ab3GZWnL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 18:43:11 -0400
Date: Fri, 26 Jul 2013 23:42:44 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Vincent Palatin <vpalatin@chromium.org>,
        Grant Likely <grant.likely@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olofj@chromium.org>, devicetree@vger.kernel.org
Message-ID: <20130726224244.GZ9858@sirena.org.uk>
References: <1374781320-10793-1-git-send-email-vpalatin@chromium.org>
 <20130725200343.GV9858@sirena.org.uk>
 <2074197.ld4vucf8Ke@flatron>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8cD+samFMzS4KXm7"
Content-Disposition: inline
In-Reply-To: <2074197.ld4vucf8Ke@flatron>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: read low power states configuration from
 device tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8cD+samFMzS4KXm7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 10:54:10PM +0200, Tomasz Figa wrote:

> > The reason this isn't in device tree at the minute is that suspend to
> > disk and suspend to RAM are somewhat Linux specific concepts and the
> > whole thing gets more and more dynamic as time moves forwards with the
> > suspend state for practical systems depending on the instantaneous
> > device state prior to entering suspend and the bits that are fixed often
> > involving sequencing elements and so on which get fixed in hardware
> > and/or bootloader.  Do you have practical systems where this is needed?

> We do have such boards at Samsung. Actually I made a similar patch for ou=
r=20
> internal tree.

Do you have more details on what exactly is happening with this stuff
and why it isn't dynamic.  Like I say suspend to disk seems relatively
easy but suspend to RAM gets a bit tricky these days.

--8cD+samFMzS4KXm7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8vthAAoJELSic+t+oim9id0QAJFrll9BBgzfSoputIYQb/3W
rCTzGWSC0rwXfInrbIHqRvzUZz8sK3wTsnSF6KXMkAxGEWF7Lecv8XZvUkxhaPtb
i1g5/9qVri7pZTuAeAq49+CjdSSPdSpOrfzdDmegIGzuqI2koE+DRcavD2/GI+sK
cPMUqLneapkn9ydElFgE4sfsXj+2H9/NT/eb3tTBEEMWfILQt6A3HuGtkoMbLIRp
vKbeogA/hS1Z1dn4rjYRfj//IJfkvdkXm4zSlrXfJm+CmpOlJ92y2FtYizk/2HMi
sanE8jhhkRMUQes7tZyublUEpom6GX6WySbolETMkTj+xkElAVDgbMUfu5gO6G3C
p0qtY2On1LnLHvvK7GOLyE47kNUbp/AFcMAzlpeZiCfdPgXuklztEtnBG0LmoOmU
RMU+pls/EAFDHpn41aT4exOUbIavj3t7/5wZ9kLK8Coiq416Vljfa7jBDQ5D+qVE
fJ+0TBrKjyvGYqHtY3UNnyxSIf2Ad0jayJzk2g/4ViMzxwNv7EljVTFLWtOl0MMH
Ng1IkF+IZzrctZktFlgMPKn31WJUl3WKhKjTMk7aLuk1D5tBJP5LDusIDjMyllYb
74nIV3X0CW2hVS2hKfYYdVddDDVa7XKRT55b+IxK/hpra9EkMIGmD0KsHcOKpt7x
zzoDuCZAjbzxwzEsKV6t
=sGal
-----END PGP SIGNATURE-----

--8cD+samFMzS4KXm7--
