Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965122Ab3HHKna (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 06:43:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49943 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757747Ab3HHKn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 06:43:29 -0400
Date: Thu, 8 Aug 2013 11:43:26 +0100
From: Mark Brown <broonie@kernel.org>
To: Daniel Mack <zonque@gmail.com>
Cc: linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Message-ID: <20130808104326.GY6427@sirena.org.uk>
References: <1375956138-12677-1-git-send-email-zonque@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UEl6xVrmin0CpRyj"
Content-Disposition: inline
In-Reply-To: <1375956138-12677-1-git-send-email-zonque@gmail.com>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulators: max8660: fix build warnings
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UEl6xVrmin0CpRyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 08, 2013 at 12:02:18PM +0200, Daniel Mack wrote:
> Fix a build warning for !CONFIG_OF and a cast from void* to
> unsigned int which is invalid on 64bit machines.

Applied, thanks.

--UEl6xVrmin0CpRyj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJSA3ZLAAoJELSic+t+oim9Co8P/0DG8qxR3pmK2EacCQuPInjY
lon4PdKtO1HAUfGs1y1UftrSm202BXAlFT5MU3WIzpm+/527s0wXq4Hvkx0x7uhH
ntVoNF9nVQTaEytwTh4X5l507nspQcAcjfPfDn1GqoaxXGMvNyEA78+TT7nA2EeW
e3GPTHhoL1dU5c7wlpYFB4hTdxUkQunDZPUCmV4VgWK57jMS1/yR5v8HN9dGfJGJ
o+G3Y4a0KnlzUmSEfm3qPNT2objlo1/p25yO3Pk8ht5dzSlRHl9B3LXcJJYOPYAH
TvaVGn5ebL//PAliPsgAIPjsYDpkhgAAIBK68sIs6phX2v2DBCrUjuboNx9xxzAx
jaRTYrkKB6E/uVKCECOYHbb+h/dDGj72e0CHlVj6CBiS9FYaHGDTi4iuR9qFVRy4
eJlbeQcY3UFX6Do+u2li4arMzao19gRA+no0nMj0Im8ffHJt+oSVOINqdKLErgXu
5liy8zeIKcBCAFlKOsW3HR2+6Vr9GqGAe4fmSPLb5JeC1KMakT6YKPW0EP0cCyG4
hrJG5KZu0KbygAe6VA5rNpAm0nBOqBjdJpuSlxgs3WMGOSmoQZ3xTzysiqrX6nx3
jOOmBPVVHNoNC5aqYZ+Qy0UqyL96FyRLTaW+SjxPv4ERMMSi71o8Z9L6zEjTOdki
f+heBYT2P7uYROSNTmYv
=rMCC
-----END PGP SIGNATURE-----

--UEl6xVrmin0CpRyj--
