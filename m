Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933728Ab3LESA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 13:00:57 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59656 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933711Ab3LESAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 13:00:53 -0500
Date: Thu, 5 Dec 2013 18:00:22 +0000
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, Kevin Bracey <kevin@bracey.fi>,
        Kyungmin Park <kmpark@infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-ID: <20131205180022.GX29268@sirena.org.uk>
References: <1384881351-10782-1-git-send-email-t.figa@samsung.com>
 <CACRpkdYrPd9tnO48bA_5n+-k=KEDyhY7czkCNhTZfpgF3ar+LQ@mail.gmail.com>
 <20131205150747.GW29268@sirena.org.uk>
 <1502243.eRBlCfUhTO@amdc1227>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DLfA7Wi+Vmsdqq5j"
Content-Disposition: inline
In-Reply-To: <1502243.eRBlCfUhTO@amdc1227>
X-Cookie: It's clever, but is it art?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] pinctrl: samsung: Allow pin value to be initialized
 using pinfunc.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DLfA7Wi+Vmsdqq5j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 05, 2013 at 04:11:15PM +0100, Tomasz Figa wrote:
> On Thursday 05 of December 2013 15:07:47 Mark Brown wrote:

> > Or should we be going and applying the default state to all devices on
> > init without worrying about a driver appearing?

> If a device isn't used, then it's often better to configure the pins for
> a different function, such as GPIO, to minimize leakage current.

That's true but on the other hand it's much more likely that the default
information will be there than the hog for the case when the driver
doesn't get loaded for some reason so it's more likely that the default
will kick in; perhaps we need to work down a list of states in order
instead?

--DLfA7Wi+Vmsdqq5j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSoL8zAAoJELSic+t+oim9tc0P/1VYr8OYjYMtRpfZVDdhkWOp
YtV/ItbepthusLVGzFzMbWvPg+lPanub3eUj0QxDLD9mwmegVCEOXc5CQkOvvBsB
ZzLUwdufYzG9dwrzOjTLKV76p27pb+fwpQ+ElnGrBQzwUlKY6ACOlgQ9pC0RiJXD
gAjvIat8TurrHA2OOQ/ai2d3a1XHjFNdUsvTBltKmvGvgpbCzhnHarTSO/qFvjYq
h+VoUgZ1yAzpglXya5wS7r/l02Y/cpKYM2rTI4eCGO17/QwVrxPpdvDrVxmBiKiy
RyfbEOGNDBPESJnnYMfxs4G+Z7Aq+H4rMJDMnYyzoWFeujEjt5mL4ZMdLghHVi/g
euSigZXj1XTxsaGgJtb9LcO/81OTxkyXI5/0Udygt/If4iIHqx/rSneN/vPGmUlt
3uQGWLwEtUreBP0/LqfpNerHB7CD1SW7WEhXiTf9zOaXvC9pDmKuHoA4eXy9uALL
yRan0uSm4zUHDEwWR4p1bn/Khzr+V4+K7cQ73p2gBtR3sc5pv468BEuQhraZlYfU
hGSPIGwhuKFigFnM2Z6zZ71Cq4P8ZE3Ew+gIr6H+bdmsd31nufs0PRVf1ylina4d
oDzrE75Vn/Mzfl1mG1tcUMh0cgCwGt1LLF/2Q+G2oP8aKzJ6Ruoep2ltT0HVHYEG
Hq1iqGkns4I0mGQ9iwfL
=bl4v
-----END PGP SIGNATURE-----

--DLfA7Wi+Vmsdqq5j--
