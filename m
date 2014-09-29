Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983AbaI2QMb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:12:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53055 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaI2QMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:12:30 -0400
Date: Mon, 29 Sep 2014 17:12:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        davinci-linux-open-source@linux.davincidsp.com
Message-ID: <20140929161217.GT16977@sirena.org.uk>
References: <2771900.ce8bYznKIN@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6axCafNXXMM8qu6Q"
Content-Disposition: inline
In-Reply-To: <2771900.ce8bYznKIN@wuerfel>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: davinci: vcif must be a module if SND_DAVINCI_SOC
 is
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6axCafNXXMM8qu6Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 29, 2014 at 05:32:17PM +0200, Arnd Bergmann wrote:
> It is possible to configure a kernel with SND_DAVINCI_SOC=m and
> SND_DM365_VOICE_CODEC=y, which results in a link error:

Applied, thanks.

--6axCafNXXMM8qu6Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUKYTgAAoJECTWi3JdVIfQhSoH/jeEOwQkwtrvFGYV/24eEZF1
ujE9yhVRtVnvQmhcYqFdTce8/cberOPg3w41nuqzTadyssOMJEXw3vuYVCoCwdE5
ITaztKCarG+Q4TnRuzWe/uTuqUBYCVbPaBHK/zfTHR1yj9yEfVUqDl1Oe0ZyyRHj
cFYSpV/LvwvXStJt0GKlGofcrlCNGXJVm3/Toaa6jiMcBgaKiBtHTs2gzxKAuK7g
71AXh6/A6EBRdyONLa5djNV5DZd5PmEj5h7V+BquWA0jaf+65REwMnLObPllY4Yk
HhynbNXCEFo/mDLBSvg8hndidPxZR1iGJqXFEgHh87PBsnaAqK5OrxkyNVNk8H8=
=2imw
-----END PGP SIGNATURE-----

--6axCafNXXMM8qu6Q--
