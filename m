Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab3K0SRV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 13:17:21 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:44660 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3K0SRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 13:17:18 -0500
Date: Wed, 27 Nov 2013 18:17:11 +0000
From: Mark Brown <broonie@kernel.org>
To: wangbiao <biao.wang@intel.com>
Cc: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Vinod Koul <vinod.koul@intel.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Dan Carpenter <dan.carpenter@oracle.com>, di.zhang@intel.com,
        patches@opensource.wolfsonmicro.com
Message-ID: <20131127181711.GZ14725@sirena.org.uk>
References: <1384996978.19494.7.camel@wangbiao>
 <1385088270.20782.12.camel@wangbiao>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E27WtheCsaqubncA"
Content-Disposition: inline
In-Reply-To: <1385088270.20782.12.camel@wangbiao>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2] wm8994: move dcs done irq request to the end of
 initialization of completion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--E27WtheCsaqubncA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 22, 2013 at 10:44:30AM +0800, wangbiao wrote:
> once code return from request_threaded_irq, irq was setup enabled by
> default, but completion var dcs_done not got initialized yet, if then a
> dcs done irq was raised, system will got hung as the sync mechanism is
> invalid now.

Applied, thnaks.

--E27WtheCsaqubncA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSljckAAoJELSic+t+oim9cloP/iddFYz6I809DH5Q1wXzA7WH
2SgMlh4JFBGFx+GQ61qNURTB1jOGdHgNwCT2lYSWSya84b34M3keCxA6s9uW3LTG
xdhHteJxaZUrtu8d1He7+1HeDDGEo3n+UGAyLb2OnjPN1OFLy6USmg3qA8q88a7D
8yruakAF5cuafX4bk2ESnfrgIPJyBqbt14jQzS64QS5w5vm76ilGDZlCjjOZ1dIw
U0AsywsuykhmL4CyNloz9qSgcQJ51wv0+QdNnwld7lSFkY7oVUnLYXOSr5PXffBd
814wSvKiiy9U7/Hb+dX7iIaSILzqN/+LycY/RBA7fOv1qaVxEmgcibrEkSo1stst
rZW1+Lkp/odMR/Hn2H0Mbn1VsSgG4lbDm1xgixq3urujxkUmwmTj5YVMf66cuEEf
3xnVtpXL17dgnDqHVJD/kZHnC4J7d43y6bAgJY7wxxp2g+zTEQBJv4ZllAQvjkTi
BtHMGwxhWOQgM5v7N9sujf/evv8ZNYMntrQcfp0hEPgbGZIMUABkDvHDSwMAtx0M
1I3ZwLFsOFCu3AMh9fvFbOj19myUw6xIYt2P9x1m22xlFTKxdthaAS6+Fua1ETJ4
7HGfh9qQvIdCUOgFHsmOicaeYz8Dc7LCf+qYegpUQS19WNm7qcIiSdel1B7TE3yZ
k+GJ1iwLD1IN/ZKRoYzs
=QOdN
-----END PGP SIGNATURE-----

--E27WtheCsaqubncA--
