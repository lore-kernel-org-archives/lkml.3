Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab3AaHJs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 02:09:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35398 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751562Ab3AaHJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 02:09:46 -0500
Date: Thu, 31 Jan 2013 15:09:39 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Shawn Guo <shawn.guo@linaro.org>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: fsl: Fix multiple symbol definitions
Message-ID: <20130131070937.GF7663@opensource.wolfsonmicro.com>
References: <1359577471-15029-1-git-send-email-thierry.reding@avionic-design.de>
 <20130131014214.GD2765@S2101-09.ap.freescale.net>
 <20130131070658.GB31996@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s5/bjXLgkIwAv6Hi"
Content-Disposition: inline
In-Reply-To: <20130131070658.GB31996@avionic-0098.mockup.avionic-design.de>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--s5/bjXLgkIwAv6Hi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 31, 2013 at 08:06:58AM +0100, Thierry Reding wrote:

> That does indeed look much better than fiddling with the Makefile. My
> automated ARM builds of linux-next were failing for a few days because
> of this, so I guess the fix (as well as the MMC one) just hadn't made it
> into linux-next yet.

The last -next was on the 29th, once it's rebuilt the fix should be
there.

--s5/bjXLgkIwAv6Hi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRChioAAoJELSic+t+oim9VREP/ik7S6DHy8qnVVYRbHIcbpG9
AzLpAmttnJjG4gr9PM3nqdUe5n8oah1/eLrf6RcIlryoS1rVkUDPNvcmMqtdmWdx
9hHQmyJZ3exop9m8sMkQKnKac1VSTBgRTRRgPkxt4RIW1rYQ7t6Uzh+ASawjQB/X
LQoLyinxu1jvq+kYizBWYEU5MEeFK/HoikyYkFp1x0oCojkVq6tF1xHQZgep3EjV
Y+bJUX0rKEh6Naga40xWF1swgAwegEAqEHPvme53ktGSUxRE3wpCCFTEmh+aWTXV
gv3U2SmQ+v+C3O2A8denmoKe8CGyccIKabCbbXfxg+DrXElNaIgi8X0ENFPINBc7
qnFjGbJEh0al9AWlD2nPt1ijPviR26BH2tl+vis7B/I7YB6pHJ5CBGaVtMfzZh2A
JazDw2U/RIE4sNvReHgKzgIh3lHFIRzABoPS+OUw+yiCgm8PkMIGqns5i+icfDAG
Eyet+kdJ7cdRPPiKHruENk3Rc/2GyUKvCCNDU5qDqMG1YqNtHJzgk1RDBnx+p6Tu
eUMDHUZa81n6dslYSyhNId9V6jBh2pH53K3KJmog/U/Q+s6dlIrtCGjrY04UCn6I
HBUDJgEoU30dHFhrrbGDCoVWkpnU7a4O0LUy9GJYybsK4nIoUkf5Jx3ereJe40qS
A15uF+QKNHZYpd/t8uOW
=m/1B
-----END PGP SIGNATURE-----

--s5/bjXLgkIwAv6Hi--
