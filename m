Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaAPOIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 09:08:18 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55695 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaAPOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 09:08:17 -0500
Date: Thu, 16 Jan 2014 14:08:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-spi@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140116140806.GF17314@sirena.org.uk>
References: <1389876655-5484-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ni93GHxFvA+th69W"
Content-Disposition: inline
In-Reply-To: <1389876655-5484-1-git-send-email-mika.westerberg@linux.intel.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi/pxa2xx: fix compilation warning when !CONFIG_PM_SLEEP
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ni93GHxFvA+th69W
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 16, 2014 at 02:50:55PM +0200, Mika Westerberg wrote:
> CONFIG_PM will be set if either or both CONFIG_PM_SLEEP and
> CONFIG_PM_RUNTIME is set. Compiling the driver with !CONFIG_PM_SLEEP causes
> following compilation warning:

Applied, thanks.

--ni93GHxFvA+th69W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1+fCAAoJELSic+t+oim9PFkP/Rg3s8cEtdwsOgx/KpLHk4/W
qGmEDiOYFllaxKz3ktCX2DMYiNFMw9oNNwPJZzP2mzEvtS01LLHleDW0PbiOcwRE
wMGzwbde92of31qmX/VirC+ELYEM/llOXG6Kx2Pi3tReHdBFZ3CfaAS/0MWjoR+u
IGUmYXf40XjaLyiSTjZOzUjT5gg7HPmBN2Fgqv+I1Y+widRgkkdpgdRdKnlWsiw2
LSxAzJp4TUAFOmUuoGwCqutf4OdmaBWaEQ9Nk0DWik4Fp2M2MIC9z05deyJFBKRA
LxS9zT7VB0pfTI968SOn5caRn61Bd/IjTluTgPsZbZ5TyT0OGbwjOoK1wVMJu2WP
Kc5sdoFivhLPrvNyklQpU9DUG1weYpls+njWLGvsIp21fmRKrT9AUUYCe5DKFWuS
75vluVRAeZ8YuN141w5wB+FXwFzSn/W5arBkO63pruwod73O7MzMbrLxbjd8weOm
Wn/Zh1393FS3q7rS8Gg5shQ+bJ9lt5jlUfVJQCc8KM2AvLP1mslaSM1hbZJHiNh8
AFR1HjcqWwPZeEmIaFeYOIN+86FaofctLBR9gj8cbga/Z7t3NCU9LxirW06ud4q3
B9Rf2wxLfSX4XruU2fP+xudOmgquEtba3xFvBpu7p4K6WeieYvk+YRYuxf2gZY4Q
XI8/FCg3uKCePz3yTaLr
=eTSR
-----END PGP SIGNATURE-----

--ni93GHxFvA+th69W--
