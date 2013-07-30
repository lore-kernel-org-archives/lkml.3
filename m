Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab3G3LaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 07:30:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:34064 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3G3LaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 07:30:14 -0400
Date: Tue, 30 Jul 2013 12:29:49 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Genoud <richard.genoud@gmail.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Bo Shen <voice.shen@atmel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Message-ID: <20130730112949.GP9858@sirena.org.uk>
References: <1375180329-4860-1-git-send-email-richard.genoud@gmail.com>
 <1375180329-4860-2-git-send-email-richard.genoud@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mdlWJHP8WUkO1oOu"
Content-Disposition: inline
In-Reply-To: <1375180329-4860-2-git-send-email-richard.genoud@gmail.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v6 1/8] ASoC: wm8731: add rates constraints
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mdlWJHP8WUkO1oOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 30, 2013 at 12:32:02PM +0200, Richard Genoud wrote:
> Depending on the mclk (or crystal) selected, the wm8731 codec have some
> constraints on its data sampling rates:
> e.g. with a 12.288MHz or 18.432MHz crystal, the authorized rates are
> 8KHz, 32KHz, 48KHz and 96KHz.

Applied, thanks.

--mdlWJHP8WUkO1oOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR96OpAAoJELSic+t+oim9KD8P/jufnid8JfAwCFurbaWmciex
ASQ2UuNfKZxhunDX0IdQ0byCdXA56HRgJap9zhWlE9YrlAflPhcseAO8SkhPaDoB
Bcxgtc3Qhwq4HhJz7sux8fjijsDfiFqSL+ZaJG5GGJTW6tNCu+SnhtGcj8zztYyw
hseY5H9Us/fKmMbXcWqg4U9KpPVCi8V1U6oEMlGTCLHBKAJGtLYq//LaC8Gdenc2
xW8568EeylLF9rOPiB8xtvDEO4arbd+xIWQLJLG742iERJyI8r0yx7NKkQ4+m5ek
0mDOG1ZpwArGuMztzrXDIw0RO8TKB570pq1Z4xz1eMWqOluONEY+BXVBP466DmEN
ORryiBQcSXhfQzgIZHduTqWPlKUapwsYuwif3ODvPmKTxagzFt1gQe9zrgKES2mG
Lx/6TfDjVlW3u64L/5sK6dSEE9HeX4My5ehr8oxoNSaZpLat+S+bPWdi2YZnbYGE
1E55WN9UMH01FtxBsAsdCdDBVZJm1FNvqGwfgi6lQYE8b9RHNYIuHB0kLu2Hsmia
s9r0awsUtdjGreC1nD3XHiB24PlFGF3rm6koMF2cH39DBF35aTc6r9bXQ1veP4qy
gNnUs0uiVKWG1de1bc/QM+zWTRu33pgAZm29hvWvbMIeezdDcx9/w+oTOFhLDDFd
+bdN/0oqyy76wTWOGkKq
=urka
-----END PGP SIGNATURE-----

--mdlWJHP8WUkO1oOu--
