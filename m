Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081Ab3JJWsG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:48:06 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36038 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab3JJWsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:48:04 -0400
Date: Thu, 10 Oct 2013 23:47:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, lee.jones@linaro.org,
        sameo@linux.intel.com, linus.walleij@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        rtc-linux@googlegroups.com, rob.herring@calxeda.com,
        mark.rutland@arm.com, pawel.moll@arm.com, swarren@wwwdotorg.org,
        rob@landley.net, ijc+devicetree@hellion.org.uk,
        grant.likely@linaro.org, Florian Lobmaier <florian.lobmaier@ams.com>
Message-ID: <20131010224748.GW21581@sirena.org.uk>
References: <1381321761-8898-1-git-send-email-ldewangan@nvidia.com>
 <1381321761-8898-4-git-send-email-ldewangan@nvidia.com>
 <20131010152446.1715e64b70ddd0281a3971e9@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vs6r5beQVWevPlSD"
Content-Disposition: inline
In-Reply-To: <20131010152446.1715e64b70ddd0281a3971e9@linux-foundation.org>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V5 3/3] drivers/rtc/rtc-as3722: add RTC driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vs6r5beQVWevPlSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 03:24:46PM -0700, Andrew Morton wrote:
> On Wed, 9 Oct 2013 17:59:21 +0530 Laxman Dewangan <ldewangan@nvidia.com> =
wrote:

> > +config RTC_DRV_AS3722
> > +	tristate "ams AS3722 RTC driver"
> > +	depends on MFD_AS3722

> ... the rtc patch depends on an mfd patch, so everyone ends up sitting
> around looking at everyone else, wondering who will merge it all.

With the MFD ones providing you trust the interfaces with the core
are going to be OK there's no problem to just merge them via individual
trees - the dependency on the MFD will prevent bisection problems.

> > +#ifdef CONFIG_PM
>=20
> Most (but not all!) rtc drivers use CONFIG_PM_SLEEP.  People have madly
> mucked with CONFIG_PM* and I don't know the difference and I don't know
> what's going on and I don't know of a convenient place to go to find
> out.  If you work it out, please be sure to tell me!  But as soon as I
> figure it out I'm sure they'll go and madly muck with it again.

The two effective options for this stuff are PM_SLEEP (for system
suspend) and PM_RUNTIME (for runtime suspend which RTCs are unlikely to
use I guess).  PM mostly just enables selection of the other two.

--Vs6r5beQVWevPlSD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVy6RAAoJELSic+t+oim9uQoQAI/jGxDlxhiuYUiEW0B1k1vQ
fYBGYMv6XbuJAqC89fwCKA6uW45yHWTDBsn+AmW76My4d+O2lsYvp/oDrGAigYzf
5neP8+jsNPbcX4JFDl55aMe7F4l3CfwXgIGSHDmL3ibe+ZXRv93cYTSORSBVGtgP
ZdvJTJwjNft2hGs6Ibp2cLH8yDNXZXzEWsZcA5rYBmLvOOeBCst13O/EVPOeyMWN
zwTTqvCkAuDnPh/DATFm/XVApxTR6TiMfLtw8G5Y8VzBVXpM9aTNM+1FA0BSOwly
w7XUSzSTV1REPc2VY/y57lBx2pl6Xl70sUQE6qtsEhIVnhEKCbPxyWQome9a374O
9rJ2cptzm3e3OxCMM8XCyd0hWFA1gqJGUKPFSZxo60L+gkLU7TrWNWaHiJpxyMPm
RbttLH91SISGCBVf3QZ/f4skOt0yuNRzIeTryd/Y8xCWIYTR3aOOnKJog07Is+57
GSQLlQSahRvsks/13VumbIQlHqo5zIs6Inrd5lVfMFlyNdyz8FDRZXtNS9SuM0MA
/hafMJIcngykzin6nMgBQDsZ0Z/P/Gbr6SOcQWK+K+HhSQFCEHpmWPNrGo21OA/x
5njidl90yJn7wRufXbDUCTjCEAXE2BBvAKkWKpU9vbG/7zshy8sUJG+G/Za0aO6h
18LQtvvJP+FKDKdJEuiM
=igyP
-----END PGP SIGNATURE-----

--Vs6r5beQVWevPlSD--
