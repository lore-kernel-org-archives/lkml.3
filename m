Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbaAQR7t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:59:49 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56084 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaAQR7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:59:47 -0500
Date: Fri, 17 Jan 2014 17:59:27 +0000
From: Mark Brown <broonie@kernel.org>
To: Florian Meier <florian.meier@koalo.de>
Cc: Daniel Matuschek <daniel@matuschek.net>, alsa-devel@alsa-project.org,
        Dimitris.Papastamos@wolfsonmicro.com, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.de, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140117175927.GZ17314@sirena.org.uk>
References: <alpine.DEB.2.02.1401142030110.23472@parallels-Parallels-Virtual-Platform>
 <52D95DA2.7000509@koalo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mu4zWe6QekgCAJVd"
Content-Disposition: inline
In-Reply-To: <52D95DA2.7000509@koalo.de>
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


--mu4zWe6QekgCAJVd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2014 at 05:43:14PM +0100, Florian Meier wrote:
> I have tested your patch.
> There is a (non blocking) error message regarding .idle_bias_off, but I
> assume that should not have something to do with your patch. Can we just
> set idle_bias_off to false here?

What is the error message?  I remember that the first version of this
had an undocumented change to idle_bias_off in it, I expect that needed
to split out into a separate patch rather than dropped.

--mu4zWe6QekgCAJVd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2W98AAoJELSic+t+oim9aUwP/i5K5QxgkwK28oKq5zTiX717
P4gh/Fxv9p+2GYdbfD0u7W1mfqvWbcM7rVaIU78sFcSVsc9bERSr1CLdvSUpiE6u
eCe66zU7vKTKXY1IIqYw5yd1wI9CnQC4aoFiudDNCmlnD9GjBmupkO36GoSeBjlI
ayV+5RdsSmP5vdJS5w80JHRXKJq4k6vTz68J+CV1+yyMnTbfY7rAgbsxjlp5jc4t
bwp3smxUGzfs1niF6kdAc4TzB9cMgrgZmRgbaXIoefY8lem63GjYmWjYw0rV2vE5
GzT0Cq8+h+jVjRcZcWFikygeR3Od1RtU+E3k59HkGD1oKVT3u9SpLwP25ovozeHN
Ocpn6zzwpWLBwHU7juq4w8JLbpbZfAzFUdGPoRDUAgnzlCa5RB5pn/Nq148CX5e3
l7sCvKWKXKBWdqyG1t4GaT8cdG/o6LmmOcbdtvZa8NKJNBCn5zhW2Cua5JiT4HtG
TJ4pzp4ToGgpIUCc/2Pc84T4UvFBORV2qwpSc14MzusyUJkDWzoKHi631uZ5kuwW
jRqeK+J1o6vG98YUjOTi2QOUma8oxWK2k1FYdB/RaXRnxe3XiMU1NKTcW0neJ3ee
Cr6oyBeZRItewtxfsgUoNDeIiLrzX77irF0z4jdN9ny/K7tFkYUr7mWJMq+RB/2k
iK96ox91nOX/LYJwhX+E
=Fxz5
-----END PGP SIGNATURE-----

--mu4zWe6QekgCAJVd--
