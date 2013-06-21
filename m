Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965657Ab3FUL3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 07:29:03 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48017 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3FUL3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 07:29:00 -0400
Date: Fri, 21 Jun 2013 12:28:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Sekhar Nori <nsekhar@ti.com>
Cc: Sourav Poddar <sourav.poddar@ti.com>, Joel A Fernandes <joelagnel@ti.com>,
        Tony Lindgren <tony@atomide.com>, Matt Porter <matt@ohporter.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Vinod Koul <vinod.koul@intel.com>, Benoit Cousson <b-cousson@ti.com>,
        Russell King <linux@arm.linux.org.uk>, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux DaVinci Kernel List 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>,
        Linux SPI Devel List 
	<spi-devel-general@lists.sourceforge.net>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <20130621112832.GS27646@sirena.org.uk>
References: <1371762407-24544-1-git-send-email-joelagnel@ti.com>
 <1371762407-24544-10-git-send-email-joelagnel@ti.com>
 <51C42A71.1090403@ti.com>
 <51C42CFF.10002@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="szdyR02yM8NCQUEm"
Content-Disposition: inline
In-Reply-To: <51C42CFF.10002@ti.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v12 09/11] spi: omap2-mcspi: convert to
 dma_request_slave_channel_compat()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--szdyR02yM8NCQUEm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 21, 2013 at 04:07:51PM +0530, Sekhar Nori wrote:

> We can resend the patch if you don't have it from the mailing list.

I'll probably have it assuming it's been sent to some mailing list I
read (the CC list here looks absurldy large...) but if you don't send me
the patch and/or ignore bounces then it's going to take longer.

--szdyR02yM8NCQUEm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRxDjcAAoJELSic+t+oim96z0P/29SA62qwncC4OoCOsCTXDfE
WY0WEnpjbPZ683bTorI3W3akXAvqpSgklbuqiu6ky7QzR1o2Z5ilBRlUa5F3ojRR
qwlkRtWDPjZkfGGLCXDnCuAyzngC/5gNB+IuWWJ+Yi8Ph7SmwUuIVnRBLULKJr6E
5Hc1awJHQCNfFxtxrTcPYKXeWn4uW9EUFDpQAY+eodLO9268BYybgjmf5qNUEOG+
sXHwNMvAkt2wolb9Levc0/xgeCv2qhmbvXd3VTnfxdhO9uJcbmocdt8iTkOKsAin
8gve0lFVi2gZpLSjBncz/wDavycoa1z4sefLN0BjbclmsRlbC7WxUK0NnRMr93rY
IcgSqRsb4BQKQKsJOSIU9TT/0ZJKV3oj99/azpEZs4TdaxrUiSZmu3sEIxkbq3ww
RLF74i83qXlVCUeNw1tA9GwiZmak09Eb2ydUmsHvapK2sGDz+ZYiD5OxgwqeT2Kf
Kiu7PX8Ec0dSD4eANrn27yHWx+oB6VEjKS5Ow/zni9kk9qcWWDwnWv/cYA4BlF5p
4kn2wQB6hHIJvttbH6eIJQwHFOIm68oHOyzfJokrPQIO74r2ouqC4dWsawfNl4Dc
ujokrGoHThsnxszYzxmIMuh7SyQcR/8CssURVDJrzN8+NH5DdDl2TCM0oycz9EWO
ERLp3bN3J5E89cBwqKtx
=Amay
-----END PGP SIGNATURE-----

--szdyR02yM8NCQUEm--
