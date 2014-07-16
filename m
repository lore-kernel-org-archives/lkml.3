Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483AbaGPWXc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:23:32 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40871 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754328AbaGPWXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:23:23 -0400
Date: Wed, 16 Jul 2014 23:22:59 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>, linux-spi@vger.kernel.org
Message-ID: <20140716222259.GM17528@sirena.org.uk>
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be>
 <1405095208-14642-3-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a58rN+WbXIGauCK9"
Content-Disposition: inline
In-Reply-To: <1405095208-14642-3-git-send-email-geert+renesas@glider.be>
X-Cookie: 98% lean.
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


--a58rN+WbXIGauCK9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jul 11, 2014 at 06:13:25PM +0200, Geert Uytterhoeven wrote:
> Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
> introduce inline wrappers") changed the code to use the new API, but forgot
> to update the error messages.

Applied, thanks.

--a58rN+WbXIGauCK9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxvtAAAoJELSic+t+oim9dtQP/1U4t7TkGni1oHWiD95/Lu7L
LZYib4t9jwcvqOGLmFMBJNUI2Fhmg54yu1pOKhN/yLFyrBWccaVs7x78qOytd7LZ
sSVf8xirL3UCxYAJvuvpeM9ZYQnSIaLpzdr3y2hlagNzummKWSgS0zIlc5jCJmV1
qIL3yeePJNUG1KIkqbbrYkhWvIElkkba9PhMHdlC8xHuYcU7yNnoE0oBR/1NZNG9
zRVgbVc8LZU7hw+If0AxtkTtYX5/Mcuj18vWq6Rx//Na6N8900hLl2EZJUclFumR
ItVJEwapEVvyyYIi12HblDpBozuVUhbPs003QgGCy5Vpc6hvg7c5rYyBkQn28zWe
tEW7zwodmB5MCKMvYYJ0gr2LmoQ/J/2wQXfop2GHclN+/IPOM/nXRHjeHG0IBo6X
M3SYQ7BLCMuBG0o1Pc44HdvFevqTRqx3dMHdpQX8ZY7D+t6fRZJdKsc285YujQnX
SHBUVWwTlExx2IBXibaDtg+dBGRgiI3FyBWLg+v4u+5jGXUQSO5nzBgcDD1djuJE
2iObN1gq/tGsEWBUt7SSAOUkKK4n9BNwDfTCykiFRqGp3+CGNML/bJP216H+Upjd
cTQ7P8rBTkypFyBK9WqaP4JhsPOXqtI6hp4JeOkqMBnsSk7mO+kVWd4pz2ZbbvnZ
PNzMBKfpu9T34FszEGbp
=hfoY
-----END PGP SIGNATURE-----

--a58rN+WbXIGauCK9--
