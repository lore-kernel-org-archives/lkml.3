Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399AbaHLP5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:57:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:60090 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaHLP5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:57:43 -0400
Date: Tue, 12 Aug 2014 16:57:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: rf@opensource.wolfsonmicro.com, lee.jones@linaro.org,
        sameo@linux.intel.com, lgirdwood@gmail.com,
        alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20140812155727.GQ17528@sirena.org.uk>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com>
 <20140808133510.GC2665@opensource.wolfsonmicro.com>
 <20140812133458.GD15833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eECtmhemjMGdcB6v"
Content-Disposition: inline
In-Reply-To: <20140812133458.GD15833@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/3 v4 RESEND] ASoC: arizona: Add DVFS handling for
 sample rate control
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eECtmhemjMGdcB6v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 02:34:58PM +0100, Charles Keepax wrote:
> On Fri, Aug 08, 2014 at 02:35:10PM +0100, Richard Fitzgerald wrote:
> > From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>

> > Some codecs need to boost DVFS for higher sample rates.

> > Signed-off-by: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
> > Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

> Would it be possible to get an Ack for the ASoC patches here, Lee
> said it would be ok to put the series through the MFD tree once
> we have an ack? Unless you have any issues with the series?

Don't send contentless pings; if you want patches reviewing please send
them to the relevant maintainers.

--eECtmhemjMGdcB6v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6jljAAoJELSic+t+oim9fL4P/0wyYuLObz+rhZl64WaxZo3x
NVks79VPOICtUESJ99jU/bX9uo3PI3u4eU7NhlSUWxBivOwoAA6B5xZlNBXi1t1o
Ki7lSs8x4tOdqqfKmGJ+Yi5ope8r+FaFOcaHG4hzAtcwROyheGekC2NsAMFxgZ8A
v4jG9hCZNN+0c8T34RLV+Ga5lLN+6ejRgpGwArglf5ZwyCF2iwXWInT7j0kcD3Vh
yp9qUMIDvkKq2g4k0RQry0l6hU+KovmCLVunTDZy6gueZ7g+Eak61EFf5hz3UpsO
YPNORdhoOmjdwL9fPvq4ogleY1qjvBESAuWSzoPWfnuGlFRH1XsoCYuvIe8OXrdI
/K0NRXJRAdUr921ePusScci+4l9si01kTUT+4Q2X0vHZ9N8GdhlZq4au68pAZm1G
8PW7O2D1Tyj3VX3tL2DlJyp5V9Q+iwCCh8MAIz6EhPIf1lWGpBEIJXKCGNaPgwGi
gPNFAW+5sC6R/KsPAIBTaffgvf+kkyZzrJYgz3xwqctv9ePWWA0U+H+CK3q6RT7R
rCWL4GEzfxml98uH2zgWUDO+BBhFCXQuLKEe4dZOhDSqVebZUgRYvCCwunfvy5Zs
CSk6R1lAY+iYVFe5i5l0ZqGkRJx4aUUdY+aJUgDemEIHzbQe8xP3bUifqyzBsHT7
0cmCJnGaeGjBZMTlwBhL
=xmUG
-----END PGP SIGNATURE-----

--eECtmhemjMGdcB6v--
