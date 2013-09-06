Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568Ab3IFUrz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:47:55 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43775 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab3IFUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:47:53 -0400
Date: Fri, 6 Sep 2013 21:47:12 +0100
From: Mark Brown <broonie@kernel.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, swarren@wwwdotorg.org, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Message-ID: <20130906204712.GK29403@sirena.org.uk>
References: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tu8ztk+XgTAiG9Id"
Content-Disposition: inline
In-Reply-To: <1377082096-22296-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V4] regulator: palmas: add support for external control
 of rails
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tu8ztk+XgTAiG9Id
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 21, 2013 at 04:18:16PM +0530, Laxman Dewangan wrote:
> Palmas rails like LDOs, SMPSs, REGENs, SYSENs can be enable and disable
> by register programming through I2C communication as well as it can be
> enable/disable with the external control input ENABLE1, ENABLE2 and NSLEEP.

Applied, thanks.

--Tu8ztk+XgTAiG9Id
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSKj9NAAoJELSic+t+oim9LI4P/3Qb7pv8EVyN2uT9RUSXN4Lp
1XJLaBZnsZ6/WrivXD7nBZGUIvLvvdHJ04XMWQip7XEjuWE9F6oKk0HphdlGt+EE
+97ZI5rcAHlllTQ9aEipMfpzY+ZWsITZZabPjAi1pTPTVuzhBBdCjiaSabpuVV12
tTfgZRsbnRqpEcXkx2PS5x/TowEovsfRswmOJ1p1Ob3+upTJfuy0g4JIBMHBFPLO
1u8poY9rxO3UTg8YpxvtLiVR5y1lWCaQcqR+uzzvzXc2MkJM27aYr1bSj2bw9pZa
w5lvXYQSm+05bny++cbX98jfjjuCMOpJfSpZvEWChyaINeZWSVjo0h9pb9UeUNCX
OHgl8rRh2vxHJFGp/T2jCmnEjQEFFEz07B4lH/f9YJ2hHfDn2rSuA6JRrK4i+JZY
0+HUhZuw1JwDm0A84/S+PrZFSKILtg+g+YmGqendoFnQHCZG8w6rwssuHwwvsywY
bDZELb/U2C8o7YFzpuvbWJreYCDbMmUr3GYYSICiwQe1yyGVXgX1RU3M9hQQ2fi/
Z+0iU4LV6Y/IXHJv3mBXeUi/SZ2InxCVNi/MQ2bHCpTXsKfEOl3HW3/ZLdrudw58
/X5H84/jjumVqitkCF/Rm8Vyayn3SXhq8MxNKrlBvQWLAVsXsa5IBNIFZDAdP0kC
0xli7Fl1xL5zBfcvOZ6x
=BwM7
-----END PGP SIGNATURE-----

--Tu8ztk+XgTAiG9Id--
