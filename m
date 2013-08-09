Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758587Ab3HISBX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 14:01:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56616 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758547Ab3HISBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 14:01:21 -0400
Date: Fri, 9 Aug 2013 19:00:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jean-Francois Moine <moinejf@free.fr>,
        Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Rob Herring <rob.herring@calxeda.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20130809180058.GM6427@sirena.org.uk>
References: <20130808132201.2610aef3@armhf>
 <5204A716.6070507@gmail.com>
 <20130809091953.GO6427@sirena.org.uk>
 <5204B7A6.9050907@gmail.com>
 <20130809094340.GO23006@n2100.arm.linux.org.uk>
 <5204CC04.4000401@gmail.com>
 <20130809113940.GY6427@sirena.org.uk>
 <20130809130932.GS23006@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CinbraM2ncepWOqm"
Content-Disposition: inline
In-Reply-To: <20130809130932.GS23006@n2100.arm.linux.org.uk>
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


--CinbraM2ncepWOqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 09, 2013 at 02:09:32PM +0100, Russell King - ARM Linux wrote:
> On Fri, Aug 09, 2013 at 12:39:40PM +0100, Mark Brown wrote:

> > So extend Morimoto-san's work on the simple card for this - that's what
> > it's there for, it's doing exactly this job for non-DT systems but it
> > just didn't get DT support added yet.  All the trivial cards should end
> > up using this.

> It's quite rediculous to request that the simple card stuff is expanded at
> this time, when you're also telling us that we must use DPCM for Kirkwood,

That's the place to put the sort of shared infrastructure for trivial
cards that Sebastian said he wanted to see - if you guys are saying that
the machines should all be able to use a trivial binding with shared
code that's where that code should be.

--CinbraM2ncepWOqm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSBS5XAAoJELSic+t+oim96n4P/14jD71UpJ3qtuZbFQlvgFMP
u1+6lS5ONC/BpRSJWt/+2BZJ7wyIX/3BkCkCfntIPAtlwsZ54iax/ZNhQtkq+Kw9
cqc0KgJh7m3OXoyLbnSyog/KlH7kB/kKdmwhO8q2mcd+KVaNkjz5TBmGBXQHjo2w
ywySeetNrBtQG7hUp6mimy5fDqaWuLJ9cBaG9Tfi+QeYwLA5za4kJ68RwdmboiB0
XKWCvcefpb/y28QSqDgW/SwRCIEKvKR2mf4/dBbFiiUTwSIgeZGg3WXFOyKpL0le
cS2tnpnbGa6epAAlDfZjjRQQdNSscNd2xtLmqXhafQL+25ZLfOcRNCavZqnUx1V9
/izsw+Pqk9fq1lOPBSVVWrpL5uJ3rABSc/rZCgS/UT+sNI26/GzQcHBoEH8oSjNR
uw30Qmlpux97pF/+xJ/Tv2saczFTS+W9vFIOKGgD1tNpuUQR3eYy6ooX2FoGLnlK
17uMeKJb5GaM88sx+2aHbeZFZp8KIsxQpvoUyKP7nnBuIaC2QBkaRcrVMJeRPjQ/
FdCUXeErGmJT+sQO70XCYNoMXkr8MdiriLLxBgyrqJusJLEXF7eSTmj80swXKxBC
br3CdT1yrCn0SLnYjL9ys5eILGk5cLhmhHLFODWiB0NSDrwD1Yky86FP8F4Vrv+0
jLsIyiFC/yL+CxpQZgQG
=JNhp
-----END PGP SIGNATURE-----

--CinbraM2ncepWOqm--
