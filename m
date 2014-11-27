Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbaK0Khj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 05:37:39 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40606 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaK0Khi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 05:37:38 -0500
Date: Thu, 27 Nov 2014 10:35:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Zidan Wang <b50113@freescale.com>
Cc: lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de, lars@metafoo.de,
        ckeepax@opensource.wolfsonmicro.com, Li.Xiubo@freescale.com,
        patches@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141127103511.GC7712@sirena.org.uk>
References: <1417078388-1289-1-git-send-email-b50113@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B5GJtDArd/slIW8G"
Content-Disposition: inline
In-Reply-To: <1417078388-1289-1-git-send-email-b50113@freescale.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel][PATCH] ASoC: wm8960: Move register initialisation
 to I2C driver probe()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B5GJtDArd/slIW8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 27, 2014 at 04:53:08PM +0800, Zidan Wang wrote:
> We must ensure that the clocking configuration is valid as rapidly as possible.
> And do software reset before the others registers updates, or the registers
> will be reset to the default state.

Applied, thanks.

--B5GJtDArd/slIW8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUdv5eAAoJECTWi3JdVIfQZpoH/06iAJE6OiN6mFYSKHk9GhCA
GB/eedAgleSxP5RGjD0XM5QNktpsHNPfJbuoI1tPAdNyPXEKXCh/DMRdNYMH1YW8
u51kQyJUnjPVjnkZFeUVuX0apcWvR0lfLeWr0MgzShy3EgzEoMLF/Pfzp+UMSBc3
WyFeQfsC740XjFPEf3BJ1vndmoNfcDPevY0b9YU8fTM3HpRFXdwDtYpCcAlAyAJ5
moGMOL+YLwTuMA9ZnF7EYFDj0ihz1FwmGaoJbJQq1Lo9tw+aAbmqc0JVhgF4wi56
cYmZYAgyYChEeklIubMHtC5X+Kbxm/ohlBZwncsHCuQUMDg6HNc90j0U4/C62Gc=
=k9Fk
-----END PGP SIGNATURE-----

--B5GJtDArd/slIW8G--
