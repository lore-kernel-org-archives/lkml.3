Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbaGNRY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 13:24:27 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaGNRYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 13:24:20 -0400
Date: Mon, 14 Jul 2014 18:23:55 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>, linux-spi@vger.kernel.org
Message-ID: <20140714172355.GA16531@sirena.org.uk>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
 <1405095208-14642-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ikeVEW9yuYc//A+q"
Content-Disposition: inline
In-Reply-To: <1405095208-14642-3-git-send-email-geert+renesas@glider.be>
X-Cookie: Vote anarchist.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 trivial 3/6] spi: topcliff-pch: Update error messages
 for dmaengine_prep_slave_sg() API
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ikeVEW9yuYc//A+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 06:13:25PM +0200, Geert Uytterhoeven wrote:
> Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
> introduce inline wrappers") changed the code to use the new API, but forgot
> to update the error messages.

I seem to be missing a lot of patches in this series and the cover
letter, what's going on with regard to dependencies and so on?

--ikeVEW9yuYc//A+q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxBIoAAoJELSic+t+oim9CwkQAIID5k7n/YReXQJ52QGpJH6Z
seMIbt6/DEKjpJeRd5UpP3Sn8ItIlX0EI/CeCT2OOQM064EoWawv6I9vR9yUIS3u
HdQSyXGyQ1BEP/DLX+0arvOm+Q8AZYxbKtLUQ5scHPTpMMwEOc7jfe+KOtgP8d+S
76Q07PrZu5qhf6U0E8KIUZbnNN+Gh4JY6ebj1vHd5eCxP987fDEcQdh0A4GxdoHV
GY3vBo1owffnIfpjePQnF3H6hEVg41O/FtSdrCgybdaGql1pI7vf3zj/ARi3/uan
io3AvKpAQU5unIFxS9JaWFBNRRqrvjXw0mzQnyVGuunCjI01vKqEjAbIz34Dn5/P
nl4PhkSzAFZMV1Yx09NFFFPpAJFsosG1PhZr+z/FoRtNqoSfepxtBzkaqwSxZiwL
MB02g1PngCk2h7/tXCZfXy1Ak2D8XvGiYk9gkzjdIGSa8hbviM1LJ+bleqDdV80s
OCkpXAK5ssM0NQxjNTPNK8tEnNGShXdyodM5hRcxxMGAjqImWo/h4/CKDr5c8nYl
KXG7sbGJJGrKD0f2PFPkctoxC/Eujns1sOh2GkxrhHAddxDPeGVNBprFCV0Q1ium
LfiTCMDi0Jcn+i9v0BAA+gB7OP8dPVj6z3qunmBHplaZzeDBu8TXmSiKLd6uFEkF
zFA8FjXXlOpklzN8U58r
=Dd7Q
-----END PGP SIGNATURE-----

--ikeVEW9yuYc//A+q--
