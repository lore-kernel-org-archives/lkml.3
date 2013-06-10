Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab3FJQti (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:49:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:38592 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab3FJQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:49:36 -0400
Date: Mon, 10 Jun 2013 17:49:05 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <20130610164905.GJ1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
 <1369246717-4167-2-git-send-email-nm@ti.com>
 <20130610103131.GR31367@sirena.org.uk>
 <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+WOirvrtTKur1pg"
Content-Disposition: inline
In-Reply-To: <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+WOirvrtTKur1pg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2013 at 11:16:59AM -0500, Nishanth Menon wrote:
> On Mon, Jun 10, 2013 at 5:31 AM, Mark Brown <broonie@kernel.org> wrote:
> > On Wed, May 22, 2013 at 01:18:34PM -0500, Nishanth Menon wrote:

> > So, the biggest problem here has been patch 4 (having to have a hack to
> > deploy this stuff is a bit worrying) plus the general not having a real
> > driver thing.

> Patch #4 in this series was a hack as it was not properly split up and
> organized as a proper DTS series -it was meant as a proof of concept -
> not entirely meant to indicate the remaining 1-3 patches were hacks
> :).

The way it reads is that you're building up to a hack - if what you've
done isn't enabling a sensible solution there might be a problem with
the earlier steps.

> I think you mean http://marc.info/?t=137059249100003&r=1&w=2 series. I
> will dig into it. if it is possible for Tegra and OMAP to use the same
> framework and strategy to deal with these kind of h/w blocks, all the
> more better.

Not just better, if each system doing this sort of thing needs to
reinvent the wheel something is going wrong.

--x+WOirvrtTKur1pg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRtgN+AAoJELSic+t+oim98t8QAIbdDPOytS2PBZV+slQte48S
3LpjVuPFHLZTWpS0bW9keYEVXBgyqln6BQIkytwLhcJyUORgksPBEr2XOr+ezW4n
1LOeRmHVE27h9Bb3XO5PBu/Br5VDA2u6Q6wOCCFPNyThsMeIgpMsM+EPzMNz5enW
v1z7CvI8tHElxUT54eV1KqKHzpHzOvb9hqo7pFip9aqYI8jzBMxvnwpMJot3ggL5
lp8f9Tt02lyBypK8OHrH/cASJnhNB2nq9dlUEbpRCIMZAQIu3rmDCRcAjRV9jG4v
hoYoSjJ3NDXMECMNFDyAACS3CjDw4UClZbNY3tWUi1I8VzOBnU1j3J7cP1OMMQxx
tVQbSG/t19uQkIUgX2+TvCzPeDXTb1FUt2wtnoeG9Ujrg3PtNDIg1CTwTRt01s7N
tMVAT5VZqi/iwAFpFY/zSlklD0rC1JmXt1lrySlJU00ifZk64EIPWFR4kk2c5tEF
Ofv7exg5tUGJKASrza66IeFBCdQQrSAS5yZSUVR+goJvlzKjG3pDyVlmPBx8I058
gKh8+jfGZwd+B4JymJR45ZwUDFXDWbOJCqEts/Lcygfb5WcFL9eQloztYKqbX5qb
ZP2WDKNhrPls2RgV6mN+eHk86sKHN8CdjXySljLjLZfmVRSLw8OgrvdjcwrrnBPY
Of0TKf/k8D4j56IGhqaL
=B8U0
-----END PGP SIGNATURE-----

--x+WOirvrtTKur1pg--
