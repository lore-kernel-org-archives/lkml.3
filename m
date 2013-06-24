Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab3FXOy4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:54:56 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:56330 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751854Ab3FXOyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:54:55 -0400
Date: Mon, 24 Jun 2013 15:54:29 +0100
From: Mark Brown <broonie@kernel.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Grant Likely <grant.likely@linaro.org>, Jiri Kosina <jkosina@suse.cz>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Masanari Iida <standby24x7@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        rtc-linux@googlegroups.com, Russell King <linux@arm.linux.org.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <20130624145429.GP27646@sirena.org.uk>
References: <1372077594-17052-1-git-send-email-t.figa@samsung.com>
 <1372077594-17052-3-git-send-email-t.figa@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dUQzTuC3g77BtMOt"
Content-Disposition: inline
In-Reply-To: <1372077594-17052-3-git-send-email-t.figa@samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3 2/3] regulator: max8998: Use arrays for specifying
 voltages in platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dUQzTuC3g77BtMOt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 24, 2013 at 02:39:53PM +0200, Tomasz Figa wrote:
> This patch modifies the platform data of max8998 to use arrays for
> specifying predefined voltages of buck1 and buck2 instead of separate
> field for each voltage.

Applied, thanks.

--dUQzTuC3g77BtMOt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRyF2iAAoJELSic+t+oim9ISUP/A63q66B/nINTYgi12ojJvef
5LO4dFpSrY5pqw9k13e6zXBrtvkxsIER/ulS0g2ZXlXkhOwFFsBk1e4zKC+YYDR4
yx+dda/KECmbLwip5Tu4T2G2CaWEap11UXTIdPlUEqWiyT49qd2JFPmWTcXcvORQ
jm1gIztRYC/IHCeS5or3I3koyoAFs578dhkWfoZD4VWSPTEWHZmbKcxL1NVdIUnE
oGBPJCe9ymqyVL6MHIr9vZLR2uFE1FewygwxJSauwpe0Euto5elb8kvvTlXJ9Ig0
NUm7guC0LJ/9sBOXi1Ua04ORglIZmvQ4JnubnpT7+ieGU00n9Jv/yKktuTg8UYBL
PzUEV5u2krNb4V/DCPvnmr8SpjsREK47gXI9pFPdWywiIG8AXTajG06zQTAr1F9Q
Bdqa61yHZKsE4zsiqAepLUdSiwyFg5XS3kGyJI4jbDqge89GQiMNVdhKJKCHy+iF
RB9S6z+uX9AyylpwgWO2agn45vmrY+bVLiLvjmWbIe7bcD57MBtXCwsp7uAOPCC1
0T9bLyprBbLxIlWLZkKOrGEEjAu+6Og3qG6Z+Bm+/4CXV5qjfTtJlISbkWSjy37F
oeVjghzZnd2UsQH3iy9AWo1JdSUIC7vQqWf38252lW6+dFFWbxNyXxzLOY3n10sf
AjNOAK3Vlv0posVwtrzn
=0NTq
-----END PGP SIGNATURE-----

--dUQzTuC3g77BtMOt--
