Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3EHK5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 06:57:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43832 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab3EHK5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 06:57:31 -0400
Date: Wed, 8 May 2013 11:56:54 +0100
From: Mark Brown <broonie@kernel.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Message-ID: <20130508105654.GC7478@sirena.org.uk>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+b2GFy/wpzNn/yIF"
Content-Disposition: inline
In-Reply-To: <1367997261-32048-7-git-send-email-fabio.baltieri@linaro.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 212.183.132.60
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/6] ASoC: ux500: Use the first two AD slots for capture
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+b2GFy/wpzNn/yIF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 08, 2013 at 09:14:21AM +0200, Fabio Baltieri wrote:
> Set AD_OUT1 and AD_OUT2, corresponding to LINL and LINR pins, as the
> default input slots for the capture interfaces.

If these are routing specific analogue inputs to specific timeslots then
this is routing that should be being exposed to DAPM as muxes, not hard
coded in the middle of TDM slot configuration (which is both obscure and
not what the TDM API is there for).  The TDM API should be purely about
placing the timeslots for the audio interface on the bus.

--+b2GFy/wpzNn/yIF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRii9zAAoJELSic+t+oim9gi8P/Rb0W7HiW0pqHMXPVaeRj5Oy
CvIg5w7+zSoKLMacCrr2GcmCYfgfKnsxAEz4np9xcS9VdoTF6EesR1HOQ/bYCr/K
XKvXSxgbmi8JPq5nYX4tOYl0ys1ASjnW1iAaPusdABP2RUTVYxb/UmEzeHdb82AA
eGfWb0c2Q2eol03oktcEif0+RSmu0ekzjZY0lESrnjwafYpAZRydoATH3iWczN8k
+Jz8jmEwNYwMzmCcHRqRHo8DU0PPz7KxC982OTHSPZTVtMBRuWd93FGa09djsCdz
H15qaiuoc9tpjGUAFQZv2DkotRp5PzPgj4rFVYK6aQjeWE0n25JL/sCfALefiY0X
kL70jPJ5aYbXqiMYlQADlPmPGMQlHgTMYAK/pKrB83d2jdR3jjwCQO1ivEEDUlmF
Td/07WvlEV8f5eMK4X8+3sOE/3UXQSq2AqR/ogO0TiuhXQtwZ1XQgFvckIgSbgV0
zJWp3ivgdRTjx3YFO21PHiAD2EzI+F43Zx5l7zYB0PPlZMoZ8xl4qMz8c4BPECSk
5ncRI0IJwvmDnp8NqXCpw/F6mhzMttpYHGv5wvWbX9VHe/0Oy/2lJr3wEGir3MJD
JzhK904TWNnnvy2RhrAE3ihZCDVeDHemF/xYPlnGXCJOKHFvj84HLmyj70mT5EmA
fK62JHETu7a/kXItN6j2
=RvQx
-----END PGP SIGNATURE-----

--+b2GFy/wpzNn/yIF--
