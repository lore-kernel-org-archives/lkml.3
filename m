Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752759AbaKJMPN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 07:15:13 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55930 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742AbaKJMPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 07:15:11 -0500
Date: Mon, 10 Nov 2014 12:13:35 +0000
From: Mark Brown <broonie@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: pali.rohar@gmail.com, sre@debian.org, sre@ring0.de,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, peter.ujfalusi@ti.com,
        perex@perex.cz, tiwai@suse.de, alsa-devel@alsa-project.org
Message-ID: <20141110121335.GO3815@sirena.org.uk>
References: <20141109120222.GA3815@amd>
 <20141109123753.GO2722@sirena.org.uk>
 <20141109194151.GB7852@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aSkGYfF7HpsxURxE"
Content-Disposition: inline
In-Reply-To: <20141109194151.GB7852@amd>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: ASoC: omap: enable sound support on n900 on devicetree-based boot
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aSkGYfF7HpsxURxE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 09, 2014 at 08:41:51PM +0100, Pavel Machek wrote:
> With device tree, it is possible (and encouraged) to build N900
> kernels without CONFIG_MACH_NOKIA_RX51. Update config file to enable
> the driver build in this case.

Applied, thanks.

--aSkGYfF7HpsxURxE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUYKvvAAoJECTWi3JdVIfQOJcH/jRWtopHWQXLRmtMwMSulTnO
OAxN8W7BpEVooUKXkXk6xjDX3Z+hm/uaH+oXj7qkAxMm3nQ2SU6oJGrVSZlEhgSe
+8zF13EO7J+MLE63atBXwQGujPMMsVpKGSsprNgIHEdZ+AHfB2kgmN0ZEjBG+lM2
kE/DJwrtnwojVVC5YFrJYeoD9NvGF2ZLMyxEcvh4Dceq111hVSUgcENoEI+h1hJM
W4DqOmxHxGRWJt538N4UehxSu4PCqS4PplTynHkzYoPh6ODLtD/XhRBeQl2f6XBn
GJHggItkcNK70TGQyrZXjLYWwdbbV7MDYJGJvZflNrPqCYwmfgBwQ1TDRQVhPKQ=
=VBi2
-----END PGP SIGNATURE-----

--aSkGYfF7HpsxURxE--
