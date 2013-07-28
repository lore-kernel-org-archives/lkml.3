Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab3G1MVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 08:21:43 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54688 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab3G1MVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 08:21:42 -0400
Date: Sun, 28 Jul 2013 13:20:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gg@slimlogic.co.uk" <gg@slimlogic.co.uk>,
        "kishon@ti.com" <kishon@ti.com>, Stephen Warren <swarren@nvidia.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Message-ID: <20130728122055.GO9858@sirena.org.uk>
References: <1374833754-19659-1-git-send-email-ldewangan@nvidia.com>
 <1374833754-19659-3-git-send-email-ldewangan@nvidia.com>
 <20130726164122.GT9858@sirena.org.uk>
 <51F39F9F.5020607@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V7gLWA+uOry9OxZJ"
Content-Disposition: inline
In-Reply-To: <51F39F9F.5020607@nvidia.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] pinctrl: palmas: add pincontrol driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V7gLWA+uOry9OxZJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jul 27, 2013 at 03:53:27PM +0530, Laxman Dewangan wrote:
> On Friday 26 July 2013 10:11 PM, Mark Brown wrote:

> >>+	gpio4_sysen1, gpio5_clk32kgaudio_usb_psel, gpio6_sysen2,

> >Would it not be easier to just name the GPIOs gpioN rather than using
> >the full names with the possible functions?

> I took the name approach as what we have on Tegra.
> But I think I can put the name of the pins same as what we have in
> datasheet. So pin name will be exact same as what we have in
> datasheet. That will be easy to interpret.

I was thinking more about ease of typing than ease of understanding
here!

--V7gLWA+uOry9OxZJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR9QykAAoJELSic+t+oim97TIQAJRfxCeUcj852LpOWf43QDJt
ltoWfgWuGy9ezWkf+gOjh24s9mXugAOrGDdX54hO6qd5UXusxI/7KHYeMbgtLmX+
zlbEkI2FwY4NfZhiRAB5W36sp4DIwi7e3KuRR5npT4yhNL1hXOE/ACS8019VY048
k1Mm6PQiedMEMs4IG7Xd7NLRi6vwxLQH51WGn7kYndno/OxgiPprwNaiT0BXYgv3
m/x9EeMNWi7m6x1sfWdDglS/J73DcZ7sdqaguGDj/o9QgkAUEuc6vi6xFfDslgw0
VEXYH5NRrNlxc3uwQg06/LEtApnLuGfCgxuJysBB84IS9ThrHNoi0e3btWKou///
Adwe7Y/yjF/UqH924GihLZ8ByHwTLT0tofIYSNCdJGTUpt14gPUCR9LHHr/+YQjy
xxteIkAGX7XJVgA7TWDv5RWMFb0JCcWA37OLTcuAaCOr9RHNLj0twRlKXcn9m59B
Lr3T34M1uclxg5Tqwu7FORW12QGyyIkjk+6yd6coOvaQE81VC2NC4xuH+4Muiivs
lndurhFp0P8RCbTgL+/Yftwl1jbg4IYs+y0Ev4rsUBHZw7UlUQ557b+8U/ZCy+aR
EXMG1O+RR5a9Bhn6N8jHvouTi/YTw8E+ifZgNFbn2KK2OOIpf9vrD9p0+b/ANKCq
I74TNJjiq0AjAFWzEoBX
=QJgV
-----END PGP SIGNATURE-----

--V7gLWA+uOry9OxZJ--
