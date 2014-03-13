Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753403AbaCMNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 09:46:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56953 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbaCMNqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 09:46:13 -0400
Date: Thu, 13 Mar 2014 13:46:01 +0000
From: Mark Brown <broonie@kernel.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org,
        davinci-linux-open-source@linux.davincidsp.com, joelf@ti.com,
        Liam Girdwood <lgirdwood@gmail.com>, Tony Lindgren <tony@atomide.com>,
        nsekhar@ti.com, Jyri Sarha <jsarha@ti.com>, mporter@linaro.org,
        vinod.koul@intel.com, dan.j.williams@intel.com
Message-ID: <20140313134601.GU366@sirena.org.uk>
References: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="L2YZAWjVjAQ1Un1Q"
Content-Disposition: inline
In-Reply-To: <1394702320-21743-1-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: Some assembly required.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 00/18] edma/ASoC: dmaengine PCM for AM335x and AM447x
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--L2YZAWjVjAQ1Un1Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 13, 2014 at 11:18:22AM +0200, Peter Ujfalusi wrote:

> With this series AM335x and AM447x will use the dmaengine PCM for audio. The
> daVinci devices will keep using the davinci-pcm for now since I do not have
> means to test them but the code is written in a way that they can be switched
> to use the edma-pcm easily (DA850/OMAP-L138 has been tested and audio was
> working fine).

Can you please not resend the ASoC portions of this series until the
EDMA portion is stable (and ideally committed)?  I'm not quite sure why
but every EDMA patch series seems to go through lots of iterations which
gets rather noisy - my initial reaction to seeing EDMA in a subject is
to just delete the thread.

--L2YZAWjVjAQ1Un1Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTIbaWAAoJELSic+t+oim9nV0P/jZm8E1g0rPBCTOkKqf9ombY
Hdqm9g6GzkSN8Pga8f5Q1UN3lVpIReLCiwsYxoRTT//Ovtmy8y2mOZ4FlwmlOyaU
hWw0QENFV6Tk/SsAliX2gSgIrqbnLUF/RsEaubA2DWPx3kpATEI+5+YijjAxJHfs
0fIApxzB/x94EC/wcCPJIpSBP+bwW9UCRjN1iF7yX60nO3A7iXBbBUx2UnJPK4Oi
Z8Hto5G78cQIMpowTukO74cUqTvqrrdQXgIKhcPBfRl0aL9qWpMVPxuDlnE/ofne
37zZeq4I0DwvDRSRSAqwhEJXVz89hc565Zh7PwdE2NAK3fCJQjH8/L5s3S/eTVPP
kpVkKZzwNEJ4WtPQs2aFocfJFnnTMhF4TVTbl/XCUTn1sM+VHkwiFZb2MzfgVX/c
opPJT5uW5ovp/4XvCHmRZrhr4bnXNgX5+ri+AbOXlvLywsHSHxYoTHypVM+op6ad
U4RYE5dx6fANKcq8efrxj0Kiqjgb5opd/YPsgL/u5fQ7Sk7nuWJvVEXhmPwN3QZv
6konQYpMlAZVNHBltxxfpY1rbXAJ9Q03/hIAAm0vdfzYoui7bNGFBFHI6/ZZ9mQl
UEooOae6mAemGS6WQYh35TBLgoSMy1FssrDCzVQcvCpBX5xikCG4wlcYHxtnBi+c
UIV7ENhW3HZkfw2jFD6g
=bZlj
-----END PGP SIGNATURE-----

--L2YZAWjVjAQ1Un1Q--
