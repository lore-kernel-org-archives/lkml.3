Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab3LBL40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 06:56:26 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59614 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446Ab3LBL4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 06:56:22 -0500
Date: Mon, 2 Dec 2013 11:56:17 +0000
From: Mark Brown <broonie@kernel.org>
To: Nicolin Chen <b42378@freescale.com>
Cc: timur@tabi.org, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, alsa-devel@alsa-project.org,
        lgirdwood@gmail.com
Message-ID: <20131202115617.GV27568@sirena.org.uk>
References: <1384532729-6588-1-git-send-email-b42378@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YDTWxoC2E3hrC6hC"
Content-Disposition: inline
In-Reply-To: <1384532729-6588-1-git-send-email-b42378@freescale.com>
X-Cookie: Boycott meat -- suck your thumb.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2] ASoC: fsl_ssi: Add monaural audio support for
 non-ac97 interface
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YDTWxoC2E3hrC6hC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2013 at 12:25:29AM +0800, Nicolin Chen wrote:
> The normal mode of SSI allows it to send/receive data to/from the first
> slot of each period. So we can use this normal mode to trick I2S signal
> by puting/getting data to/from the first slot only (the left channel)
> so as to support monaural audio playback and recording.

This looks OK but doesn't apply against current code, can you please
check and resend?

--YDTWxoC2E3hrC6hC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSnHVeAAoJELSic+t+oim9gXYP/iyCgeTlIkEq2tvHUKNxZoCT
tHOlo3ymeCohXd6nMUQ2bBO0NrpnLphny24jBHuLPFVps1enGqoNRU6TT8d3Pjfm
VTpi+9eTxgwF0wRsN5Lf0deKo/7iLsTtwffNw8K7ll8QNUl0YRIMwvqXIgpxr93Z
NqOYieIZsJSII5Aulw8cMu1fXeJVo66H0V6c4YUHrNKRqb+XZbIEZZJuWBzIaLXC
yqJKIEC7a5fu+hPicxTsf9LdMp/Z3fL6g7rIZq2bmiadcDAAtm97tAR8oYKDb1yt
dShn0dgTnexuamhCCfVI4iExnY70rBvOiz+Zxk3vM4Ub3YCJ5Pkr+DTQngk2Ynhw
RYX6jHjLBTDE3gBW/XTnzEQTMS4Q+1hQdy7sEsJFT6tTUOTWSRZc5A2O6WUtKUtz
j5Rpbc8yb5qCGExqFmTNUL1VlltOXzgPqGNaZljxcWJl5JwJUzxAisNXGT6rc3kM
xdUM/RtDu1nCNjaYebFBn7bpgvqT6+9BO8cCNoPCdGOIhUJRQURKasMWfyUHiQFQ
eQNAwZdYqjK1yfOQrYd9aEa8czH7BwgiYPGhsnT/GhMZloNi7ot7uPvf4XIf7a4x
LdonCKGVjt2yCrbYQ2ceZHyexBLW3R8HwxNWUHcI/hIQuAfaCpFwVQk+ton91Adw
MiDOSDbYsip7Y/0kQss7
=+D7z
-----END PGP SIGNATURE-----

--YDTWxoC2E3hrC6hC--
