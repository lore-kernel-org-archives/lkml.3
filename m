Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932335AbbAESXB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 13:23:01 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36623 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932093AbbAESW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 13:22:58 -0500
Date: Mon, 5 Jan 2015 18:22:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: SF Markus Elfring <elfring@users.sourceforge.net>,
        Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Message-ID: <20150105182228.GB2634@sirena.org.uk>
References: <alpine.DEB.2.10.1402251840450.7035@hadrien>
 <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net>
 <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net>
 <54A9355F.4050102@users.sourceforge.net>
 <54A93B5A.9050504@users.sourceforge.net>
 <20150105143551.GQ11764@sirena.org.uk>
 <s5hwq51fe8g.wl-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <s5hwq51fe8g.wl-tiwai@suse.de>
X-Cookie: What's so funny?
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 6/13] ASoC: Intel: Delete an unnecessary check before the
 function call "sst_dma_free"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 05, 2015 at 04:18:07PM +0100, Takashi Iwai wrote:
> Mark Brown wrote:

> > I'm missing aptches 1-5, are there any dependencies?

> No, all individual fixes.

OK.  SF, in future please always send at least the cover letter to
everyone getting patches in the series so they know what's going on.

--3lcZGd9BuhuYXNfi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUqtZjAAoJECTWi3JdVIfQeNcH/3X8H4IzkkQQ5jiXGlyJmMh5
PNJuWtY07rolZEkeAOIz0VmMwEST1buBcrqUIvhvX0UbsYeQsqOzhtZMqzgMkK4Q
ZaytOezwik61dmI4fNXAzUTyU0vQ+ydYFwulygLYi/t5D07wp2UeAziPRrCcAHal
rfRR59FAzaoLmsRz8zrEwsf3aMip993bU9Yemf1YAM6X8+8zjRor4P+AtGPZCR0z
7f1kOsk/P7HSEW6KC6egCOHNxM1dHOCP3zNO+nnUBBPDiqOxBtMxQQODy/TuwMro
IVclQPJTDr91gOKMAnr9vmEgKXULKLtp/4eXZ2LWXn9n7ao96vd9KPTHWWaSQqc=
=xW1v
-----END PGP SIGNATURE-----

--3lcZGd9BuhuYXNfi--
