Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab3L3MBi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 07:01:38 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51287 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754772Ab3L3MBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 07:01:37 -0500
Date: Mon, 30 Dec 2013 12:01:10 +0000
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: shawn.guo@linaro.org, timur@tabi.org, lgirdwood@gmail.com, perex@perex.cz,
        tiwai@suse.de, alsa-devel@alsa-project.org,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        b47053@freescale.com
Message-ID: <20131230120110.GL31886@sirena.org.uk>
References: <1387941614-7629-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ura8jf0QYTXVPAoa"
Content-Disposition: inline
In-Reply-To: <1387941614-7629-1-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: Go climb a gravity well!
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: fsl_sai: Move the global registers setting to
 _dai_probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ura8jf0QYTXVPAoa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 25, 2013 at 11:20:14AM +0800, Xiubo Li wrote:
> Because we cannot make sure which one of _dai_fmt() and _dai_sysclk()
> will be firstly called. So move the RCSR/TCSR and TCR1/RCR1's
> initialization to _dai_probe(), and this can make sure that before any
> of {T,R}CR{1~5} register to be set the RCSR/TCSR's RE/TE bit has been
> cleared for the hareware limitation.

Applied, thanks.

--ura8jf0QYTXVPAoa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSwWCCAAoJELSic+t+oim9knYQAJakvpQs+x5MjjUuQY1oeO0R
Hwqc7Zp7YJQ8M3ZK5Q0sGKi4k75gejtmQseR50fKNeiGHJJ6zaq+yyjRdhlS/gzB
WZtq2e/vgwmYZlTLOERUq5jbCfHJXgUH+vTGTLQAC2lCh15mZC3U4WA7may9TYE1
DjVMusxDd13EiLg9nHfnKVbEE2EMQR6xDafe0YJaOpWvq4boZlG6umKEzTZI/Vfo
lu2fkUS4ldZX5kPdiNUfV76U7m9yPD3sE0S3IDuc56DTK4+eZUdwyBYoQatb09Oy
coMVxivHXC4kAQ7R9kQ5woPqcRZRgGSi0HpRyDdyUV06e2G/4EC4dIT6Vz5LSAJF
qDUpITDyvRj/J91CqvxLJ+f+JpQqfz1x0f8Of/gmydO36spTWWBlTCzLRQRWT3u4
IV2OA86XEGAsDOMeemjS0n3QOQM7cxUeo2+10Vr9oe5eFh4+KGH7QEXfmCr4Mjp2
hf/KXt02+1FIv+URSSsmsFkblnIkXi4gMCuez4oigm5zZ57/1M5XbMqVHrmHEM+D
y3sO05mq3Qln0RwA25IXheK6GzrAL49C4ltdOmlzA3VeWg2g3SaNdQUQhLqpOcNo
oLfYehd6kHxR0YYVZoHcQdH/LHz7zCIMYnXtfQTsZScu3ahzpykvj+4kw4KBmIwj
4e+NNMxxHpsUYvyqlwX/
=hQAc
-----END PGP SIGNATURE-----

--ura8jf0QYTXVPAoa--
