Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934293Ab3BTR52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:57:28 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52266 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759097Ab3BTR5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:57:25 -0500
Date: Wed, 20 Feb 2013 17:57:21 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] spi: tegra114: add spi driver
Message-ID: <20130220175721.GW2726@opensource.wolfsonmicro.com>
References: <1361281115-20436-1-git-send-email-ldewangan@nvidia.com>
 <5123C18A.9010604@wwwdotorg.org>
 <5124C18F.6070108@nvidia.com>
 <20130220131112.GE2726@opensource.wolfsonmicro.com>
 <5124CEF5.3060605@nvidia.com>
 <512506F9.2030508@wwwdotorg.org>
 <20130220173109.GU2726@opensource.wolfsonmicro.com>
 <512509A9.6020208@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DWqF7Vcvgq9cBwZ0"
Content-Disposition: inline
In-Reply-To: <512509A9.6020208@wwwdotorg.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DWqF7Vcvgq9cBwZ0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 20, 2013 at 10:36:41AM -0700, Stephen Warren wrote:
> On 02/20/2013 10:31 AM, Mark Brown wrote:

> > Since we can extend the list of clocks it doesn't seem like there's
> > much issue here, especially if some of them are optional?

> Yes, there's certainly a way to extend the binding in a
> backwards-compatible way.

> However, I have seen in Rob and/or Grant push back on not fully
> defining bindings in the past - i.e. actively planning to initially
> create a minimal binding and extend it in the future, rather than
> completely defining it up-front.

That sounds like the current stuff with a minimal definition is OK?

> > Though in general it seems like this sort of mux really should be
> > in the clock stuff anyway.

> How do you see that working: something automatic inside clk_set_rate()
> seeing that some other parent could provide the rate, so the clock
> could be reparented, or ...?

That'd certainly be nice as a feature, but it'd also be good to just be
able to define this sort of multi-parent mux in a generic way in DT
since it's pretty common even if the actual implementation of picking a
parent ends up getting open coded in individual drivers.  A library
function might also be a way of handling it short term.

--DWqF7Vcvgq9cBwZ0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJQ5tAAoJELSic+t+oim9KnwQAIYLf5JCLQJ/C567yBrG+Hvn
wUOkz37o0sMPlX+uZbhI/p56MweF3OlJrr0Xnpek3AsTaAbU3+2TbR21bpGFPK1p
v5fkHqIjNZC+Sys6Wx4/JM4eU5GDHNq2j++ynM0UvG+SJ5lM12GQ8TYbDbGWEd/s
Vm3q+u5/5tCz5UYM4j+82viLynLRSNspW8vHU3ExKEWg/DkC1K4rnOuNL/ExiYDQ
EShUfKoemK6cBNyxZWM9TaVvK+SSLLs7Qft21cvAuLXkOfH+oN8p5a/5smMWukWv
j9G/WKmvaEcecDFDgHxxHQ2QQEUezhBgO18U1LYxf39PrVBuUooZYU43vEFEC2ie
yyvdkEzvqM66QMUecbHTfKQxt4mrEsOOuwMTdhluxrLYzhGod49mTRQ86LCzVWvc
SQ5Ybul1xAOHFBJZf4H332QwCP5BXaUarmSI9KxyDWWXwXJS0AxidVpvKiWi+rmo
Zl1A6NJl/Z5cg0b5I/4prOLaiu9ul+MM/6AC/+1hn3hclDtigUnLn9OeSQB+2a1U
23fpFGxAPAmBmABTGOlLVS0EZF3DuNesoIAuJHqezJQqtq6V9Er8iNNz0uFdZwuM
m7zMx0c4GqgkHSGZvkTvkA5S4iOkB3YpX69TrMBO+cm5zWeR8CfTPus7uXk8r+xO
NWm/Lii1mIFNN+NgCvo4
=yHvQ
-----END PGP SIGNATURE-----

--DWqF7Vcvgq9cBwZ0--
