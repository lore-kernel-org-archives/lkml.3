Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbaGCQOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 12:14:02 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45132 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964984AbaGCQMc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 12:12:32 -0400
Date: Thu, 3 Jul 2014 17:12:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Rongjun Ying <rongjun.ying@csr.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Barry Song <baohua@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, Workgroup.linux@csr.com
Message-ID: <20140703161208.GJ410@sirena.org.uk>
References: <1404269142-3557-1-git-send-email-rongjun.ying@csr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4XBiSqiiHCIj6zoM"
Content-Disposition: inline
In-Reply-To: <1404269142-3557-1-git-send-email-rongjun.ying@csr.com>
X-Cookie: Semper Fi, dude.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 0/2] ASoC: add CSR SiRFSoC audio USP interface driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4XBiSqiiHCIj6zoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 02, 2014 at 10:45:40AM +0800, Rongjun Ying wrote:
> This patchset adds the SiRF USP controller driver, this
> driver uses the USP as I2S or DSP_A mode interface.

Applied both, thanks.

--4XBiSqiiHCIj6zoM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTtYDVAAoJELSic+t+oim93A8P/0+bY4t28ElyrfsZ0mfvmp3D
luvKqIXa0hUm3tCUTpr5NNwBv198XUB4P0CC1WMFPIVQYSWQCjF7h4AdYp2dpCQm
3YFIXB/t4Ub5upxkS6BAT+Q/ZcLlkIqtUg0xHeUxjuIxa8c/OiGiqN47zxjbXj11
LcPn+/cr0sTTKQFgFs+g9Gy6RArOqx3r7QFyrGmqn5TbytAasdtSzoBDxQy1dojd
u1HOLXyKaiN4fTH7mG66U9EKD5WGjm7yQ7T8jDjqyDD3/XoYhr/ObdF8kZxnDZpy
XjxzJmSruCsaLyGnqkNH8PoGCFSTckE5nsZOuBDjt4m4F7y62ULcyEY95pGNAem/
iCeqyxSkXnNd1m/Yhm1m2q/ekPeSOGdHkpH7SVmRwbeFG1M77Sh3/qDjm9Ls/D6M
JX+S4l1LNFPcJY4sWOuWRjCU3ocl4N5m88NYESQbNfST/GPStqzXQ/LAz5upv3KZ
lK9EGTmGSIveKGAGO9zYVpFEMJeb3JNl30EnZVrfpe/w1q5BlrMmUR3zqSZ+6kuI
IoR5eXEGkPo3DDOysDfE/HU/wVRo8OAHzLdANuyskYovMiCN3s1IiGbEmTErOwsc
WpaP7E+aXOXzXM/8wiv9vr78jglLcMpMIoJTd9mfsri6cabUXDpPBUcAOG+czj2D
epy1KMZ8xVPk03FMMxss
=9Fe3
-----END PGP SIGNATURE-----

--4XBiSqiiHCIj6zoM--
