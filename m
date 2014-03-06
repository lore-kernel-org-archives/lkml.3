Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbaCFJRS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 04:17:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56731 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbaCFJRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 04:17:15 -0500
Date: Thu, 6 Mar 2014 17:17:07 +0800
From: Mark Brown <broonie@kernel.org>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140306091707.GK13126@sirena.org.uk>
References: <1394091862-13603-1-git-send-email-jcmvbkbc@gmail.com>
 <20140306080720.GI13126@sirena.org.uk>
 <CAMo8BfJit6Bgafi7Fwgwmtn36QZH6XsHucdPdeffjgJn0byDpw@mail.gmail.com>
 <531832F5.4030000@metafoo.de>
 <CAMo8BfKMz1d9zpbrb=JUMvjs4bE=ah1DfvM8f0KG5=uJuNJKxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UN1ZhWvvntdx6hvb"
Content-Disposition: inline
In-Reply-To: <CAMo8BfKMz1d9zpbrb=JUMvjs4bE=ah1DfvM8f0KG5=uJuNJKxw@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [PATCH] ASoC: tlv320aic23: add support for SPI
 control mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UN1ZhWvvntdx6hvb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 06, 2014 at 12:38:04PM +0400, Max Filippov wrote:
> On Thu, Mar 6, 2014 at 12:33 PM, Lars-Peter Clausen <lars@metafoo.de> wrote:

> > It's in the ASoC tree:
> > http://git.kernel.org/cgit/linux/kernel/git/broonie/sound.git/commit/sound/soc/codecs/?h=for-next&id=6c3d713e6d32706999689e379a9098afb4cd8a2c

> Thank you Lars-Peter. I'll do the same split for aic23.

In general when submitting code you should be looking at the latest
development code, MAINTAINERS will have a pointer or most of the time
linux-next is a good approximation.

--UN1ZhWvvntdx6hvb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTGD0QAAoJELSic+t+oim92bAP/Rz4ybWwa1IiqdAVZQOvinQT
X3Ol/vs1Kb+P3A2Z1dgyLu0rVG4gCs18D8g1mvpVQV/d877wUTdW9DOeB+HiZB8m
xQzWk/LSlTTLoN2sJf6qi/TyJCcq3fdic2+p0ihEpTdZv5ZHE1ZsGbgNOn4Ym8Hx
59yWsOZieM0w1wCzPJw7sws4mxJ7jTC4B++RDqLjuQ6Oxep0uytiutA4p1YYMdtm
avVE2PY+l+KnOou/aVsmWDp2wILnzqOezYtrB+9GVzWdoaDA/lFxStGEjgXv40JH
9axoT0MPWAxrLFVWO5TqPUtVEAA8dCs/f6+4wmReDtv9xYgXRsqoX0m6sAPxMjlG
vh36NoW+stAfms0YrpDtg5jpoSy3mVLiwqkitQViOZMDwGB8CsRwH99lwdgyhVap
9fsu5wLPVqABVw3lUCK8PHkJ1aDOWlvd3vtBqnw4r3v9SubEKYfp3qHbUX1znXx4
fGnDVJg/2zo/ZxkCbLmv2VN+NTFa8wOTEhnGlILzTmxwCPdx9XQIzFvqUQzdZVQF
9SSczjyhL/Z3r7AexqEHuuAz97BZNjQzxTetJcV4ft9n46AIMIiFCxNegJ67Ifag
NT+3pdIm4+Sul6wDtK+PRUtBFQX5MAZPhZBOvLIrLhLagnJ5gwVP3UgBqVn0Va/Z
imKKXGO1KWKsbkiFTH/r
=YiuO
-----END PGP SIGNATURE-----

--UN1ZhWvvntdx6hvb--
