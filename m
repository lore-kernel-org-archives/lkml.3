Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595Ab3KSSju (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:39:50 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34539 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSSjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:39:48 -0500
Date: Tue, 19 Nov 2013 18:39:43 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131119183943.GE2674@sirena.org.uk>
References: <1384858698-19027-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DRp5/Sds4nAqvQzf"
Content-Disposition: inline
In-Reply-To: <1384858698-19027-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] ASoC: ab8500: Revert "ASoC: ab8500: Explicitly set
 I/O up"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DRp5/Sds4nAqvQzf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 10:58:17AM +0000, Lee Jones wrote:
> This reverts commit 2245e3c31c15c2d2a26926c4b734f4d3a37ae252, as it
> is one of two patches which stop audio from working on Snowball.

As discussed in person someone with access to the hardware really needs
to figure out what's going on here properly since this code does need to
be fixed, the ASoC level register I/O code is going away - I'm aiming
for the next merge window all being well.  I've applied both squashed
together for v3.13 though.

--DRp5/Sds4nAqvQzf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSi7BsAAoJELSic+t+oim9mB8P/33zGX29j+aySL9nHwxDhKzJ
vuAnc/91hXB2gn3PUwBDy0yxu4KFwrRXVmdq1B/WiIXwYtDZDhVFfshyyCWQWZwu
+34/QPoOhDnZ/EHF7hbANvyT4CvsQ+L3SvtvJ0Bzx4WZmKpLGrQYEAFOf7IfwQau
fV9xfhwhcaoiznwVjaWTIH1q9cIjeBLiRvqpxTxI0Gi1sR7k3HmeoAosFLnt+Aso
e4wY0oAAudXsWdgHOLAYnJHjjlsLglGmvl0a1g0gpdxd/c+vhRW4E1SBl0ThG57l
uZx0W1c5H8N5t2HDAh/e+692RKvL9ebjQ7T4fNqD1C1Rm8B3iEHXvhDwkX80lxrn
qGy9+kXvpxj5IN3ArMumGRhpYw39NvcpA764iexqb8VMVxBJYsSpQSsy2XJWCwj4
4WiPOs5/tLvbT6CGkukBdhr5wGBW1P9opP2Eo5ClzB/h2gGE4dpjChBhI7wFjmfX
U0dgwXNvMciqMqvviNtxBWcpACcxjJnda5Efz8Ihevng/GeCVSEcYkVaStTGaV40
UOnUtl9WhyzalojFIROSTOOGfOmx0zcu00h7isviO7tRh5cc+un1Tw3knXAWTydA
HoDky2tTn3vrpmgOgtkMs0wgWgswYYlLsAdqfCFjN3ymsPQo/xsUqnxlD5+OZnCy
dUraaxlLxxvlm3rQSxQH
=TbJ+
-----END PGP SIGNATURE-----

--DRp5/Sds4nAqvQzf--
