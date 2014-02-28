Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751813AbaB1BzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 20:55:25 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53377 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbaB1BzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 20:55:22 -0500
Date: Fri, 28 Feb 2014 10:53:10 +0900
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Chris Ball <chris@printf.net>, Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <eduardo.valentin@ti.com>,
        Wim Van Sebroeck <wim@iguana.be>, Liam Girdwood <lgirdwood@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        alsa-devel@alsa-project.org, linux-watchdog@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20140228015310.GC9383@sirena.org.uk>
References: <1393536486-3827-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tUxbtEzdJc4sX0sj"
Content-Disposition: inline
In-Reply-To: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Cookie: Q:	Are we not men?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.126.181.153
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/4] ARM: dove: prepare new Dove DT Kconfig variable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tUxbtEzdJc4sX0sj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 27, 2014 at 10:28:03PM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE to mmc, thermal, wdt, and asoc Kconfigs.

I'd be much happier merging this sort of stuff individually through the
subsystems, we already have an annoying conflict here...  Is there some
bisection problem with doing that?

--tUxbtEzdJc4sX0sj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTD+wCAAoJELSic+t+oim9SEEP/1dJP3BuVMcQbukxUy5f13cO
42+7SE32MruC+GG4JGjZnatJWYyQJp0kqqrcTSgIMDzeobR+Pw4yKcKuZ+jWOVyO
Wj4auHvwgNl19l8spX3Un78yUkOxQ9pleauSNz6TnjJwdgYf04LsZD8o4D9bgWIX
ALbMtaK9wvHZv74gILwTFSS+p9DMNOqaZv8bNh62fU8+beVHNRboYQ9RVeVIoQvR
AtVHD1eo+LrNjQrsSqEFJ5qWKOpxBdaOXXLzcPjosMjkQBG9nvgGHnG8ttXWHzCl
9F+6yHVGgKVpD0xbEmk6rv6z8DuJLuTCJYS6OxV4YT1/tOHmcF3ZSsTyxCstxhCb
iQyH8Apu+OPzHbpBjtgdj1bcQAs+I7IgQgDJ+Y3UJ99tsk3DV3rX6DvaJCzUdUVZ
SGej68k03AZ1EkP9lwQcjjO529ysu44SYVMH/zK0a0roAcAfbzvzwaE70rlEEmsb
RQpDhwFc4hDknZJc9JY+FgfyWs7Umxru6bVnycfFL6bQOtEgtFT2N4vpLgybko80
e+oShZ0VdZSqdUi0DvLDd/O64A0angoiBQ8MzDbQMFoIe4nm0uV1yOR1NO0B1vYu
cOjFewsTB+FC+mOQCzJ8CARQxdyDaAfLVXhLnFL5BtUn0c/TK3u28hAGItJocAow
PRSrWqdlY+LRnAJBUtz+
=XrZQ
-----END PGP SIGNATURE-----

--tUxbtEzdJc4sX0sj--
