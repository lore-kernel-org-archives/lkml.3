Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600AbaAQAzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 19:55:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55838 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbaAQAy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 19:54:59 -0500
Date: Fri, 17 Jan 2014 00:54:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Daniel Matuschek <daniel@matuschek.net>
Cc: alsa-devel@alsa-project.org, Dimitris.Papastamos@wolfsonmicro.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140117005437.GQ17314@sirena.org.uk>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SlnaBQtdWG0gYnqZ"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: wm8804: Allow control of master clock divider in
 PLL generation
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SlnaBQtdWG0gYnqZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 14, 2014 at 08:34:10PM +0100, Daniel Matuschek wrote:
> WM8804 can run with PLL frequencies of 256xfs and 128xfs for
> most sample rates. At 192kHz only 128xfs is supported. The
> existing driver selects 128xfs automatically for some lower

Charles (or someone else from Wolfson), you commented on previous
versions of this - are you still OK with it?

--SlnaBQtdWG0gYnqZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2H9KAAoJELSic+t+oim9W0wQAIWi+Mk+3vMrY7U7262sZkkZ
25sCTTTfuvDXcEqt3DmnTfhNWALWBEUsNKmuiX/rK1TcSemRxuSeG+ydJSvJYE4U
+wwaNlOs1dmcgQF+4xlyG6H3G7l2Zap8loP9Td2IGrZkSv++WF4B+W3j/caMzhJ2
pjMiMrSN32Tzaezmbd0sjXM7R2bJhLy2xJG+zzm+D9X/Mnw+mkkEtLbHVOuKgL2D
sjIN95DoTWlHU0zNEALn2X2SPAWuV+iOqG86Y6I/0iD6vMvvaE0iYB8kG28xn85f
WSxk8me0fyAFtA5Rxy8SHiBLV1vYvywP65I6HwNPp0GL0KLShis9KWQHoYbpDm/h
ZArZ1rcANeiFFP3ykCPH8Uk28StN4Lq4CvKX2L+PrzuTX/NYthe07AVy+4R1IHIi
Evge0tNOEdD1vf91iQzCsskDzMGsIim6XbiIuEp5nw/O/cAOegeOitPHGNjsUGMS
wvXkqDJgTfKE/gpLGVrxiGosQGj/jE1vCGomd85KgEj093isGcmG0VHASBU/q1G+
4y1pMIIXI7bHRz/47uMQuJyRmdPSuSGLZufTiLhlSW/6Fq+AQNoGTrhCF14XF/mi
Myq6e3wxyaOUDP9dG3n1eBo70/l3oWdzwkPriiII0FoD9ZfmaMxbFSgxbJrYgHvF
k2gWqtMToYDoLzqb71yu
=OayP
-----END PGP SIGNATURE-----

--SlnaBQtdWG0gYnqZ--
