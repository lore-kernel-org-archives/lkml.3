Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbaESMej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 08:34:39 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33161 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932118AbaESMef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 08:34:35 -0400
Date: Mon, 19 May 2014 13:34:16 +0100
From: Mark Brown <broonie@kernel.org>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>, alsa-devel@alsa-project.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        sbkim73@samsung.com, Randy Dunlap <rdunlap@infradead.org>,
        Mike Turquette <mturquette@linaro.org>
Message-ID: <20140519123416.GV12304@sirena.org.uk>
References: <20140429222915.GU15125@sirena.org.uk>
 <5360E5E7.8090807@linaro.org>
 <20140430180314.GA3245@sirena.org.uk>
 <53623004.5010805@linaro.org>
 <20140501141510.GW3245@sirena.org.uk>
 <CAD=FV=Wa4CovkxBng0SkUUAryiFqa=m63tro1Yv1jRgp4e95aw@mail.gmail.com>
 <20140501164003.GC3245@sirena.org.uk>
 <53632568.5020200@linaro.org>
 <20140502165643.GQ3245@sirena.org.uk>
 <5379F3CE.8030404@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tPs2xF8bwC43uhQg"
Content-Disposition: inline
In-Reply-To: <5379F3CE.8030404@linaro.org>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] ASoC: SAMSUNG: Add sound card driver for Snow board
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tPs2xF8bwC43uhQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 19, 2014 at 05:36:38PM +0530, Tushar Behera wrote:

> Instead of setting the parent clock, setting the desired rate on
> XCLKOUT works for audio playback.

> Will it be okay to do a 'clk_set_rate(mclk, 24000000)' in sound card
> driver or should we wait for Sylwester's patch to get merged?

Yes, that's fine - going further back into the clock tree isn't.

--tPs2xF8bwC43uhQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTefpFAAoJELSic+t+oim9/+YQAJhXKgmK6oOpUbyw6+TnbLCI
mnWRcMbtfMTR5aItorrVqgQ8n39/4XBrJ3z9nTYIfG59VYdoqHYYFqTxMnlNkcYT
pg4vapEM/o09Z198vixZRJkbcHFDakIUE16Tf6P1MFqM6UYyAReNOznIU3m32zkX
XI6k8RHsZV4ILIjBhFw4zYaSCOREZp1GpWYj/ulHNe08ID3nVhLuaSmXDnMdZV0f
wsrjRtSl+G3XJC9Mxk6ID5HuMsc1lvAXQhyzf/AJzdz97ayZeptqt9IzgjbyFA2H
f/pCf8B0jEiVjggRQ3HqLH44nFYnzbVN1vGyK6G8tfLJOEhlAwImkQeGQ4FB4C9o
MOgfQYSS4RRohTW5XtSRO8YLM1mqTwJN87uEbEkb5IVP9IY14c/6jSlaMJaB1tya
Wm8eetSaU4pAXUVPASNvf0rambyNgTdwxAa97VOavSdYbHMB9ru09LQR44WqEohk
yBsoCH7REYpz7snvNRLCwvGgaHZ7nou6b+oj5rKFW4Iqnk2VyMMcq1JoLGBce0bB
NhQ+xhX+wcpQcQipYf8js69tSZRVoznt9prhw+1BEEHGSYHm727Ebwx0aj/s15FC
TiFI0kgbDrXB6F7DFjz06MXyXhK2MrZ96sEUwAGYA0MF7MZjWfVy347YhJJTYgXv
YVknhzt+uVSGZDRCroQJ
=UuJR
-----END PGP SIGNATURE-----

--tPs2xF8bwC43uhQg--
