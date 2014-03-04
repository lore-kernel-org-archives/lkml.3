Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256AbaCDEDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 23:03:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55060 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756074AbaCDEDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 23:03:39 -0500
Date: Tue, 4 Mar 2014 12:03:14 +0800
From: Mark Brown <broonie@kernel.org>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140304040314.GC2411@sirena.org.uk>
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com>
 <1393662801-17950-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5AMDinkw1evBROKu"
Content-Disposition: inline
In-Reply-To: <1393662801-17950-1-git-send-email-sebastian.hesselbarth@gmail.com>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/5] ASoC: kirkwood: prepare new Dove DT Kconfig
 variable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5AMDinkw1evBROKu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 01, 2014 at 09:33:17AM +0100, Sebastian Hesselbarth wrote:
> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig.

This doesn't apply against current ASoC, please check and resend.

--5AMDinkw1evBROKu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFVB+AAoJELSic+t+oim95nwP/1uyEm3ESYlgB3peebEZKl1T
Pmqq4L8g/mE78JLRE5iLYbmIlDQ5KVVFRLHba4wG/ODNrobAAtYuGKPea9XcpHFA
a4HQknEjvfYa+Wx6Um2Dzq5OXXc0SoW66CLZON/1Zv5zfSO/2k8kv4RtV8w14mlL
/o0ybTWSthvWCw/xaNLEXlQc16xpLZAfApQexi62ykNAawE/K7V3j6ZC9PrzQomv
CG8hA0s/8EY3wWmB1KvUYY59qodKuzanP9vd68LzW/0mHUA8cACKlIzT0GFeNFW3
LAFYFk32Vt3lilcWBB580o6VOHLNDS/Xs+ALYy7UpUZffesGT+BsuIwB8gFSE3kT
0rSGgYTicKx4GBeFkjes4dm081SffHk7nwBjkUzWrk+n+0KgdKNUVHLXlUxAwBb+
NVy8tqouvd+xgq5GTwBBH43w+MQbGAPhHEzX7kjElIlMLwKfgUMt02+lvxALVgSP
3zM2bA3HZoTadvVck+V2Td7h6U+HSFZ+ZrNOiDfT2xkkhZI+ZdEp1uVs9NT1egWc
if4aljVYvCEXTo9UY4JXINa/de/N26UeHlKNRPCP0lOl2gdKoTSmHos+teRNUJgK
Qb5xzvu8Q6Ii1vRwbt3HowHAjunflqkTWCSvv7mPOtlAGks1bCrwVaU5mbzOu5PM
IXxhHOGb/p3FQBD6D4aM
=06RQ
-----END PGP SIGNATURE-----

--5AMDinkw1evBROKu--
