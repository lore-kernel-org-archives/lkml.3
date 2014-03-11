Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbaCKN1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:27:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49920 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaCKN06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:26:58 -0400
Date: Tue, 11 Mar 2014 13:26:52 +0000
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>
Message-ID: <20140311132652.GS28112@sirena.org.uk>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
 <1394531952-3905-3-git-send-email-geert@linux-m68k.org>
 <20140311104713.GN28112@sirena.org.uk>
 <CAMuHMdWoPWebnyUu2uGebbnzu68Lh4qsgzpu-otnwMmvaeY1hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TBfMz8Gxdi+pF8p5"
Content-Disposition: inline
In-Reply-To: <CAMuHMdWoPWebnyUu2uGebbnzu68Lh4qsgzpu-otnwMmvaeY1hQ@mail.gmail.com>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3] spi: rspi: Add runtime PM support, using spi core
 auto_runtime_pm
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TBfMz8Gxdi+pF8p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 11, 2014 at 02:10:31PM +0100, Geert Uytterhoeven wrote:

> Can you please elaborate what should be fixed?

> If I disable CONFIG_PM_RUNTIME, the kernel prints:

>     Runtime PM disabled, clock forced on.

> and the clock is enabled all the time (verified by looking at the clock
> registers)?

That's very SH specific and doesn't apply in the general case (I would
not be surprised if future SH updates broke it...).

--TBfMz8Gxdi+pF8p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTHw8ZAAoJELSic+t+oim9Zj4P/jDlu+1L0RvnKRGlUQ5Bx4AV
isuOSONQb9GzM8EhXJcx+lAgtl4ZWAceKAH5LIBXWMchU7zWrFH10nOBz/pHZ3oI
ytVE3g2fBB81oRKcukHDPlfFzKc75Mj1fBWWSCfve2tw1+WRgGdce3BFVxVkEeOu
4miolAww9QPW+t8GMl8EOQanFF9Mf5m+lvlv8fQvb/A02JRJRas+/EtUIbMKdytk
pUxywlQFSXmGZKk1ATd7126FvJS4SIA+FfQEKDk6zfwy+7bGLC7aJEGBScOcWcad
YsLPPW4N4SMTNBv4NPNFiVkU8Iubr5806FcdImFWRLQFiU1c6z8DJogIGl9Oa8w0
xcwEvxu0fWnMfubJ9xs6JSx4eLjtctV6wsTktLiRguTOrvw0ZCgXIjG75gb+He+q
z4DnlmJ8EF4lXkHl2W+SyDPeol3IM5a8a2zOKXS7iELzAJxqy4u6A6lPxU30ZzlJ
q/rlqGq7tkyjBFU5MMacnDW5SOpzRKJ0sCRm+PffiRzgH2R/loRIJZJ7aZJj0pp7
hXdpeJePL11CVPwK7L6KUeS8u6SQJUhmr/NToRHLYAJvBrEuHoMRAnTLxg9ay3If
CbbM7Lp0O/uEf4bZRsWT3ug5E6m1P0u6ti7RSFpYAdjeleWZBx0Tt1GE6gvlkGSW
0mZdLC+LhlH/H72PLAr0
=Pt84
-----END PGP SIGNATURE-----

--TBfMz8Gxdi+pF8p5--
