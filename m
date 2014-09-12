Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbaILHj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 03:39:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36163 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaILHjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 03:39:24 -0400
Date: Fri, 12 Sep 2014 08:39:00 +0100
From: Mark Brown <broonie@debian.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: IIO <linux-iio@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DEVICE TREE <devicetree@vger.kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Alan Cox <alan@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>,
        Hartmut Knaack <knaack.h@gmx.de>, Fugang Duan <B38611@freescale.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Zubair Lutfullah <zubair.lutfullah@gmail.com>,
        Sebastian Reichel <sre@debian.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>,
        Philippe Reynes <tremyfr@yahoo.fr>,
        Angelo Compagnucci <angelo.compagnucci@gmail.com>,
        Doug Anderson <dianders@chromium.org>
Message-ID: <20140912073900.GP7960@sirena.org.uk>
References: <1410215046-31751-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1410215046-31751-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <20140909112516.GR2601@sirena.org.uk>
 <20140911152650.74767024@ultegra>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hHiQ9nAwW5IGN2dL"
Content-Disposition: inline
In-Reply-To: <20140911152650.74767024@ultegra>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 92.40.248.237
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/4] regulator/axp20x: use axp2xx consolidated header
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hHiQ9nAwW5IGN2dL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 11, 2014 at 03:26:50PM -0700, Jacob Pan wrote:
> Mark Brown <broonie@debian.org> wrote:

> > but is it really worth the effort of renaming everything?  That's
> > going to cause problems for things like the stable workflow.

> sorry for the late reply. IMHO, consistent and correct naming has
> longer term benefit. how can i help to make the stable workflow easier?

Not do the rename - it makes doing a git cherry-pick easier.

--hHiQ9nAwW5IGN2dL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUEqMTAAoJECTWi3JdVIfQq2sH/30hPjsGPESzE2pIVY1cIi19
pOKvb0WfjbYwyS1/nkGnNvHas1rvGWlFbm0TalnzMQ5yj/UPaYJBQCRbuFUFzEnJ
h/jVGSKcawpVuMcmworDupOY050ueHbZ3B2quuyoIi2jUy+k+941eg8/tWcO0ZDf
++e23Vwm+YQ5QL52Glr2dVCqfiAtP4jg/SSw/r4PJ1BfmwnQO0Zj0xJ4kMVy0ecd
OxZHwqxHXQxppXxbwqt+XrecCPN9o29DKu9dEurkpqXkQLDcFdX6Qq682Rp+vPdH
E9FrNuIY9MjD1aME0pPmfnEcPPZGxJw/yrCdxxGF13ZVbTdrG1xawhV1tqnOEoo=
=wIrp
-----END PGP SIGNATURE-----

--hHiQ9nAwW5IGN2dL--
