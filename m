Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab3AVGdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 01:33:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36344 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750936Ab3AVGdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 01:33:42 -0500
Date: Tue, 22 Jan 2013 15:33:33 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 05/15] ASoC: fsl: fiq and dma cannot both be modules
Message-ID: <20130122063331.GA1766@opensource.wolfsonmicro.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de>
 <1358788568-11137-6-git-send-email-arnd@arndb.de>
 <20130122035028.GB29677@S2100-06.ap.freescale.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x+6KMIRAuhnl3hBn"
Content-Disposition: inline
In-Reply-To: <20130122035028.GB29677@S2100-06.ap.freescale.net>
X-Cookie: You have taken yourself too seriously.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 22, 2013 at 11:50:30AM +0800, Shawn Guo wrote:
> On Mon, Jan 21, 2013 at 05:15:58PM +0000, Arnd Bergmann wrote:

> > Without this patch, we cannot build the ARM 'allmodconfig', or
> > we get this error:

> > sound/soc/fsl/imx-pcm-dma.o: In function `init_module':
> > sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `init_module'
> > sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here
> > sound/soc/fsl/imx-pcm-dma.o: In function `cleanup_module':
> > sound/soc/fsl/imx-pcm-dma.c:177: multiple definition of `cleanup_module'
> > sound/soc/fsl/imx-pcm-fiq.o:sound/soc/fsl/imx-pcm-fiq.c:334: first defined here

> I sent a fix [1] for that queued by Mark.

> Mark,

> Is the patch on the way to 3.8-rc?

Yes, should be.

--x+6KMIRAuhnl3hBn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/jKzAAoJELSic+t+oim9X/kP/i8EFPb7LQrbiwnZqMWS0cej
iDutEzyMsuVFb0AwX5xOgIAzsR9hrDVa9sSSGFEDCEezkTGeiqCGErnV3raBjvv/
3SwTbZonf7xCo/ir+hLw/HN/6c4g/G+q9GEo32JoV00QKWcWorTegJPEIKZ95g0d
ESPLepdj6mzcd0fN9Oum4InF3SGtPDPEmKLKYN79ybzEtmYhsKvKCKuAXkXB+UDw
x0OWOe1owwB8EDk+FYbMOj2MKkLdq/D3puFznNp03Tmj5LfmGwd6LkaZG9VlcdAG
DKGQjzzxTWNE/i3FpDe+7Cv//bNhBhbNi7Qr62XHV9/F5uHqnsaBGnYKPapZ2ske
s3IhuuZT2D/TPfi1q9cYZYIPdzqGSElodDc+W4MfhLvYfrBOLhKfQCaBo8oSOqdQ
XUWYkyK6wDBFLHN1S88zuMTzUQVghHojtv5E+4h9Rgcpm4MOtteDPWi0z5qLo2AL
fq/My3XEiqL2PIcSbBbUqNpaTbjBbKaWBSXIlEsLRpaUzO+rQemlq36pqBQTItVR
SCRSaXhqvL5BTsSOoRuaNdDORP7erjVOIWG0f3268Fzkb/PIRYPjpnOCCp2Ii5v2
tGfAXuCRZpQl/nrJAlvBvcLfkvPc5XB4I4jHM0AD2VOHWdJVuoXvs55M2KZ1DniD
JwcejlAV10IcEHl4Hvai
=cINT
-----END PGP SIGNATURE-----

--x+6KMIRAuhnl3hBn--
