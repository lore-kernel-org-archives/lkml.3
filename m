Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab3FQQSZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 12:18:25 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52554 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723Ab3FQQSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 12:18:23 -0400
Date: Mon, 17 Jun 2013 17:17:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@ti.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        linux-omap@vger.kernel.org
Message-ID: <20130617161752.GI1403@sirena.org.uk>
References: <1371475866-9647-1-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tNAYc2YbOB0rJD4X"
Content-Disposition: inline
In-Reply-To: <1371475866-9647-1-git-send-email-illia.smyrnov@ti.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4] spi: omap2-mcspi: Add FIFO buffer support
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tNAYc2YbOB0rJD4X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 17, 2013 at 04:31:06PM +0300, Illia Smyrnov wrote:
> The MCSPI controller has a built-in FIFO buffer to unload the DMA or interrupt
> handler and improve data throughput. This patch adds FIFO buffer support for SPI
> transfers in DMA mode.

Applied, thanks.

--tNAYc2YbOB0rJD4X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvzatAAoJELSic+t+oim9b/MP/3IQ+uSE3C14YNAac/ZZbrk4
+y+Bw/CuDouuzQIBB1RgOzvY3Frv9Et4Mn+DdS5eXhPgDzGJRRujNA9OA/3gAJVx
ygKiUmlFo0i+sudW3Oa0hgTbu8vgV6LVvNUvrrHbNMW8Z+Jk0l+yasbfXHtlFvlz
hpL6spaIBAkCy4u0VYvcP8WPgJwl6nr9lulaHjFq6gvKFRpSM97+EzU2m6eoQnEr
zOp6tNvflGolmZn1aWOoIh17eTA0qBZaO+DONMBgZqTb2zYYEO+tZrf6VbpgDdZR
bdt6rCs39xN0iCNuf1t/eCgE0DzcpKI4FhzCSbQc8Nhms1VIS5C4ycWR9o5p4nj4
vAa+ERWpR7FqiLhVObFDur15LO1jw8GLdor/s3E5a11Uh172y+4feJsMuicvg/+x
1MejAu8Ow9WCeOUpTx91juDolqEExjtM+mPRL97gWp4cRpEBg9MBCaf3DTp9E+Lh
Mvkh3bRhksPEdeTlTSsjRht+KuHjRbu8rJxAycTR7pxUDmASQq0Thw5oQVq4+nfX
y3gUqY+A6pmEQVL90dkTgBuveHqFmq2zQ7SOp3Rk1A+aFO1jsC66JxA0id+sxABE
qmqC02wdq6WWwEYNG49qlEXv1p31SguN21yA1m3hCDQchU+56e481YO0pEudfVde
PsJ4XBAbvyI03mWIcjUj
=vHgD
-----END PGP SIGNATURE-----

--tNAYc2YbOB0rJD4X--
