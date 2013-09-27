Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab3I0OCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:02:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:50960 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab3I0OCP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:02:15 -0400
Date: Fri, 27 Sep 2013 15:01:51 +0100
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130927140151.GH19304@sirena.org.uk>
References: <1380288314-24064-1-git-send-email-nm@ti.com>
 <1380288314-24064-3-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LWVQOr/QoF/fPPTS"
Content-Disposition: inline
In-Reply-To: <1380288314-24064-3-git-send-email-nm@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regulator: ti-abb: Fix bias voltage glitch in
 transition to bypass mode with ldo voltage override
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LWVQOr/QoF/fPPTS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 27, 2013 at 08:25:14AM -0500, Nishanth Menon wrote:
> As documented in Application Note SWPA117 v2.1(NDA), LDO override has a
> requirement that when switching from Bias active + override active
> mode(FBB/RBB) to Bypass(nominal) mode, LDO reset must be performed
> *after* LDO transitions to Bypass(nominal) mode.

Applied, thanks.

--LWVQOr/QoF/fPPTS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSRY/MAAoJELSic+t+oim9P8EP/jv7eJCO4rHw4sIVOkH4dZ7a
1LzT+T9N+rTWgCTtkfQge2vh/Ur+FvdR/76neMrsb8l90wU4dmPfCAsk842f9T+P
C64LwhPgyW2eIKYbWgyHCefX36S/Un8qZ44oTzgtch3MD/0sZAjUHYRXWK/UNysC
8IlyTw7eXVgN2FE7y+yzQAwbTR3kFJY2gLLmkIoQK04d7j6OD+23rxsgTlnbylWT
wYN2ZFJiJMOIs97TF9ycCivQkpZLZo8UR5PCPmY1EIOpF1+Nu43QMerUwz+gLG7y
41e5/P7rbjpp5rRtFkbUL76RAJgJ/L82zFWyTjF/g+n32hamV2vJYD2J+87n8s7j
IZlyICjPMCDvVGEXBL9AOesLfpYqbVSESLKtGNQHODBeFJDrJBIPTO7v9Dvx2ROq
RO2AZh9qRf6R4qhhYnCuySDvhblvPuXP4VN1EZKC8H78v0biQ8ZMFvRctjKf2x6x
F7WTdb4HHF20J9f0Nxjb+nA4XISZGxKhKvjZqLZ/OO89anubtRrX0dRE+rLnQr4N
y8TBz9T6x2uYm0wUJ0NWwyVACM+k8lEs61PT8b82cqCmNu3N+b8asGxfXsVeaV8y
jQmMtviZgzdJsRpe1OHTciAb7RzfhCPQyVW54S9Vot2w1ATk9CQV9rbPYvBI/uf9
2vhw55NNeLjEW2TmOCk1
=c2dV
-----END PGP SIGNATURE-----

--LWVQOr/QoF/fPPTS--
