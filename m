Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751604Ab3KRPlt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 10:41:49 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51217 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab3KRPlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 10:41:42 -0500
Date: Mon, 18 Nov 2013 15:41:37 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Message-ID: <20131118154137.GA28334@sirena.org.uk>
References: <1384438956-31153-1-git-send-email-lee.jones@linaro.org>
 <1384438956-31153-3-git-send-email-lee.jones@linaro.org>
 <CACRpkdaccxcTfKc-y7rPEH1H3yua3ubLvuvTzWnMs1rOwjiVNw@mail.gmail.com>
 <20131118093229.GB13640@lee--X1>
 <20131118133940.GC14306@sirena.org.uk>
 <20131118142447.GJ13640@lee--X1>
 <20131118144512.GB24408@sirena.org.uk>
 <20131118145614.GM13640@lee--X1>
 <20131118151651.GE24408@sirena.org.uk>
 <20131118153110.GN13640@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ5djTAD1cGYuMQK"
Content-Disposition: inline
In-Reply-To: <20131118153110.GN13640@lee--X1>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 31.115.204.151
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 02/10] mtd: st_spi_fsm: Supply all register address and
 bit logic defines
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ5djTAD1cGYuMQK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 18, 2013 at 03:31:10PM +0000, Lee Jones wrote:
> On Mon, 18 Nov 2013, Mark Brown wrote:

> > This doesn't seem realistic, you're assuming that system integrators
> > won't go and use chips you've not heard of and at least in the case of
> > things like quad read my understanding is that the commands aren't
> > standardised so the host just has to know what to write.

> I'm not following? What are you suggesting?

Like I say I'm suggesting that the bit of the code that understands the
flash chip is separate to the bit of code that knows the mechanics of
sending commands and data to the chip.

> After some analysis we have come to the conclusion that using m25p80
> is not feasible. It makes more sense for this to be an
> orthogonal/stand-alone driver.

That seems plausible for the controller side but it seems surprising for
the flash chip side.

--YZ5djTAD1cGYuMQK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSijUuAAoJELSic+t+oim99ggP/ArJ1v4KApN212WZ+aIRAsFQ
dxt0EnHDdM4QKwmgY2pdg7R9pd/1BF4SBAr04IDR6sStjBiURPhKydpNLDMln1uj
zkBIxI2cF9cOQs2VHppAI/c3QHr37F2OLrv3XrXFD0U8CPlv3BKHCfn6tftF86Mr
3C3e3wLAeLCaLYYYaxiOYIs+Mocsp+dh6Soj8DX/lagdkG1hn+8Ys8x+IrRUSVKg
9MYL/FJGXF5ShLyBQQ4yAUxr1OzRD6jEt9+a/OFeTPKp+tMZjgNANgXQGyxdqbw2
d+BOVDv3dV8TNHHIqxdvBVWoB5lC++y1/YiHVtqxrR1OFP4mz6Vf0hg0nCYqT+Ml
AISZKU63US4RYfItYB7cPq+M9YoqsTdi7kyY+/PWEIbocZK8A2Eg3BbRwb5zUXNg
KYQkN/JlEO6KLXXu2C2rjM8+rrEKeLwCR3U8tQ9ALbkKCgXuueV4rWArn/jcGBHv
kEVKmrDfjZrE4HIxNoTl/MTRBn2yS0TtSJtD4NW2cKe575CsgJ+mKOtL9EvQtqlr
hMobCNBiaw0oiMbRgV+mzV+f2Sf4Vi85l1F3omfIV4RhYekG25jp+VBFIBUTDK+T
MZAZ0CtQXPClcFXj/K53wa7EmHWMIYFzExZXtqVakfYpKAClKZitxaK7bAnF7vMk
NFSZ5dCL8lL0RNG3655F
=b0m7
-----END PGP SIGNATURE-----

--YZ5djTAD1cGYuMQK--
