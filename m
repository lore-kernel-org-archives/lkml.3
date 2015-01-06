Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264AbbAFQB4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:01:56 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38653 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755535AbbAFQBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:01:54 -0500
Date: Tue, 6 Jan 2015 16:01:23 +0000
From: Mark Brown <broonie@kernel.org>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Bo Shen <voice.shen@atmel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>
Message-ID: <20150106160123.GA2634@sirena.org.uk>
References: <1420542872-10015-1-git-send-email-alexandre.belloni@free-electrons.com>
 <20150106120049.GX2634@sirena.org.uk>
 <20150106122751.GO4194@piout.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BEfR2jmXRHrz4elx"
Content-Disposition: inline
In-Reply-To: <20150106122751.GO4194@piout.net>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: sam9g20_wm8731: drop machine_is_xxx
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BEfR2jmXRHrz4elx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 01:27:51PM +0100, Alexandre Belloni wrote:
> On 06/01/2015 at 12:00:49 +0000, Mark Brown wrote :
> > On Tue, Jan 06, 2015 at 12:14:32PM +0100, Alexandre Belloni wrote:

> > > Atmel based boards can now only be used with device tree. Drop non DT
> > > initialization.

> > This doesn't apply against current code, please check and resend.

> It should apply after "sound: soc: atmel sam9g20_wm8731: remove useless
> include". I was based on 3.19-rc2.

So, one reason you should use subject lines matching the style for the
subsystem is that this is a big part of how people find patches to
review...  I'm not 100% sure I still have the patch, the volume is
rather high right now.

--BEfR2jmXRHrz4elx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUrAbSAAoJECTWi3JdVIfQYLIH/iXGi3OfHhlaLFOtrwN7sCnZ
QW4fUwjuCMJN+Cn3wkfrq+YpWnCyfycQXvyHV/t6R2XsEarS+DF87bxuffWlcNL4
nZFwaOjxVcRuRCGQB+7HsyQL2N8kMBWfpRJPpng4FZHzS1NsaxWC7Ijs9AHaZgsN
0Bh63FUw6HeO++Wnw7M3bbzSuJvP6je7ncsIK0e9yCrMDC8SeDnSvGf1TBtYCTdA
nBFnXwqUhGCyBiLEbjkHKzo9oF4AfBy+vzWN0YeTvdxbeEwUucQB+Tgc/pRs2BXT
Zd1+mQxe9cwCdgYyLlCYhj0cm+aEIWgWYDnIOGaT3W/MQKkSPKu0j8yPLKuLgjY=
=xw0i
-----END PGP SIGNATURE-----

--BEfR2jmXRHrz4elx--
