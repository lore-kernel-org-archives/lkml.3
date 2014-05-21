Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036AbaEUKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 06:25:26 -0400
Received: from sauhun.de ([89.238.76.85]:46865 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751786AbaEUKZY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 06:25:24 -0400
Date: Wed, 21 May 2014 12:25:15 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Mark Brown <broonie@kernel.org>
Cc: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        sjg@chromium.org, grundler@chromium.org, linux-kernel@vger.kernel.org,
        cpgs@samsung.com
Subject: Re: [PATCH] i2c: exynos5: Initialise Samsung High Speed I2C
 controller early
Message-ID: <20140521102515.GJ2708@katana>
References: <1398350916-885-1-git-send-email-ch.naveen@samsung.com>
 <20140424162558.GB12304@sirena.org.uk>
 <CAHfPSqB5+mLiC07jbEpeUgW63pZVk700SkYGxToO7GRAsFm_nQ@mail.gmail.com>
 <20140509135153.GM12304@sirena.org.uk>
 <CAHfPSqDSTyQXPT-NCZ2hE01qpdmaR54tbWCUYC_zSDGFp58+7g@mail.gmail.com>
 <20140509145425.GP12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Content-Disposition: inline
In-Reply-To: <20140509145425.GP12304@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 03:54:25PM +0100, Mark Brown wrote:
> On Fri, May 09, 2014 at 08:12:47PM +0530, Naveen Krishna Ch wrote:
> > On 9 May 2014 19:21, Mark Brown <broonie@kernel.org> wrote:
> > > On Fri, May 09, 2014 at 05:50:00PM +0530, Naveen Krishna Ch wrote:
>=20
> > >> DRM related drivers like DP, FIMD, HDMI, Mixer wants to be probed AS=
AP
> > >> during the boot.
> > >> The real problem comes when, one of these drivers do a regulator_get=
().
>=20
> > >> If the physical supply  is not enabled/hookedup the regulator_get() =
call
> > >> assumes that physical supply is present and returns a
> > >> "dummy_regulator" (But, not an error).
>=20
> > >> Because of which, Display and several other devices fails to work.
>=20
> > > These drivers are buggy, if they geniunely expect and handle a missing
> > > supply then they should be using regulator_get_optional() to request =
the
> > > regulator and even if they don't the use of subsys_initcall() is not
> > > going to fix anything here - if a dummy regulator is going to be
> > > returned the time things are probed won't make a difference.
>=20
> ...
>=20
> > If all the I2C, SPI, DMA, I2C_TUNNEL, DRM based LCD are all mod_probes()
> > DRM drivers are probing a head of the PMIC probe. Which is causing the
> > display drivers to get "dummy_regulators" instead of the real supplies.
>=20
> No, it really won't - I have no idea what you are doing but it's not
> mainline.  If you are getting dummy regulators then you don't have a
> supply present at all and probe ordering isn't going to make a blind
> bit of difference.
>=20
> Please provide a specific technical description of the problem you are
> seeing in mainline.

+1 Unless we have a clear understanding that this is the only acceptable
solution in mainline, this is really an out-of-tree patch.


--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTfH8LAAoJEBQN5MwUoCm2ucIQALTUkXNNmgTuuIsPE0Wqrfie
eJDqbBy5ImwGsGGdAfZBM9Y11kpI9+SHNKMInx0iZCqS5rjodEA0y/cBy+1d6pvZ
RcWvGoUTFjkQ22XUQhiSFMioaI4tf0HVrhX+N8XYghGYyw7XlaBbpiWh9IPNxBfG
XJigANkBM50p+Gsme2dKk0nKdOwpat3eQF2MbQX1+W99K4tW6KcTFlm57AjfYfdV
XESUx1x4JfCNOhag9K9WxANj8kqIg7jwbq6rvpV2xC3z5jLnMlOBbgsGYyB4ATug
MBgkWm0LjnSWekIXxKP8mrZtwguhKnvj4eNoaSInBauvXHUk12x5t7ZvA+75jQ0S
F1LEzUmlhCbi/JAbVOEXfBmbb0WddcUOHxcM2HLdzU2MaZfR2XpVAE9yrsAGjzhI
UT8mMKGhQLmNBULeEuwDtmtA5qbyJst1miHB2WIlTTt3A/azlGzPAhkv+dJDqSqO
AGHL64lrWjyl30pcd51EWcstBIWSe+HKtUb326gqFGLxZssMP9QQ/3WhZoC2pHbJ
+X+jX9rpxIBOlnNEyDDgnyE5If3zWQR4mSxQtAjoefcO5N5bRRRgq37zXb63YEnt
7358E29wCEHkVXW0PuAR8QlTzwa+D5YpWudUjdOT2SUC/3QHdsEi8Weg6fps0Y/5
oo47lcIJY+Rr1TSq6KZa
=V8vQ
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
