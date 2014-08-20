Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752551AbaHTPWp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 11:22:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:51088 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331AbaHTPWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 11:22:44 -0400
Date: Wed, 20 Aug 2014 10:21:54 -0500
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140820152154.GW24407@sirena.org.uk>
References: <1408500257.5309.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0zDq8CFkxn2hi9iJ"
Content-Disposition: inline
In-Reply-To: <1408500257.5309.2.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 63.139.182.64
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max77802: Remove unused fields from struct
 max77802_regulator_prv
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0zDq8CFkxn2hi9iJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 20, 2014 at 10:04:17AM +0800, Axel Lin wrote:
> Both num_regulators and *rdev[MAX77802_REG_MAX] are not used, remove them.

Applied, thanks.

--0zDq8CFkxn2hi9iJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9L0PAAoJELSic+t+oim9C2wQAIeJs1dwG6b2aV2RgeS7now6
af6N5AHzbzSCyF0JtFYosAvoPoXX8YpOLUUaAt6DnJf3GOgEAMluQOTKooZvpfI0
0S0x37gpgSyYS0IGPpID2XHEcGRD359ECqyfIKOKrhDo4gkrQTTH6sbNA47JY2xE
AHuEgkt/C40oq6ml39paxdLu9h7jEKCK7CSYPwt2DoePyKTdfcE323Xr0gsp1QkW
nv0DKcldXhu7+FDYH1GDwoC8mP4NzGD7o4EB/6HS0Ei+XN/GrX7FMrcLwLNUFEIU
VLkJLxfKDOgU+03aVZKajIYdlwUEJNBgnZcadlMkA1VzN1y4mPRv95eF0o9HADz5
f6hZYFAEnfy+8549OfhDPlk1lOvLhsDW7Vydm4Nh60KBK9SYfBKrE/5DU1wgjWzX
3d0sa6KqMaFa2ezdlk6qBBL+5RLAXwIP0am05UCcj4H4FdGTr7hs8TBKBA005J5M
UCSFDU5n+5S9jCSLXkLX8E+u3KcJewxTjmgmFctRgGVWvrmvDOp3Bp5vjoLYNR2g
GnyqCXsAUd8nR+spFYpwfLfVp+PVPe6ho6heewF0Slk711NfOtHJQSpPeXNfsuKZ
xHtkeaEzpjYCY1AnJo0UjmCCjFTUHtBlMtEWU14WMgHB/L95Yh6P6xa6Xx89HS9i
2/6okSs0LabK8nMlVGGV
=o2tG
-----END PGP SIGNATURE-----

--0zDq8CFkxn2hi9iJ--
