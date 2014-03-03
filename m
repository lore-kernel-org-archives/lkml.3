Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaCCGjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 01:39:47 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54738 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaCCGjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 01:39:46 -0500
Date: Mon, 3 Mar 2014 14:38:58 +0800
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        davinci-linux-open-source@linux.davincidsp.com,
        Cyril Chemparathy <cyril@ti.com>, linux-spi@vger.kernel.org
Message-ID: <20140303063858.GT2411@sirena.org.uk>
References: <1393418614-3968549-1-git-send-email-arnd@arndb.de>
 <1393418614-3968549-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hdoY8pikdvrkIRAT"
Content-Disposition: inline
In-Reply-To: <1393418614-3968549-4-git-send-email-arnd@arndb.de>
X-Cookie: You too can wear a nose mitten.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 202.175.88.218
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] spi: remove obsolete spi-ti-ssp driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hdoY8pikdvrkIRAT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 26, 2014 at 01:43:32PM +0100, Arnd Bergmann wrote:
> The tnetv107x platform is getting removed, so this driver
> will not be needed any more.

If you get the acks you're looking for can you please resend with them?

--hdoY8pikdvrkIRAT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTFCN+AAoJELSic+t+oim9cYoP/j+u6ql/XwqS1q+bUJF6n0mb
jQXPmPeGmF7BZNRqd/P5AQAxoDdLmL9m7q8wle2VtQ6SsesxvWSXZyKDLX3D8+R/
ExXdo4ysQfeteO51jD4NsgobYOyRx/qE9xnj9FKdILv30FLE9qR73eXNM++nK5y3
fh6rRQ6SgXxuRETv7Yr78oTPduScyQkCuOgSoW/G6Xm4feEu7LoaxvVzcS3qVWUS
oUvu2rVU3kQsPfDWdEIoKpNXHll3XZuyf6bkiqwImiFq5rfIeQBzNMyxvZbFMcBa
SJWDTdNKMvflzA6L0GHJVZ/Emw1VAUsSRxyp8eGSz2qVcULBAp72CxfA0yTXvox7
lUpq75/tJe31ZFTt2f8qJzxRInJy5+l7otu2CvktziwiZCg6xykb9L19MgIrDiGD
MNqe7beEbIIz3C66/ILhVgzwBLKwzCwbaab8iaPK9CrEzesi1CgpESyHf31oZiOZ
TpYOl8rDwwVa6ewKqFkVVb1nM0P10lgwGIXmCx8+ofvLp4W9JsWVeo1A4wPWpD/u
LZVPqK3s4uvdHh6CoI63kqS4poJDy8yzXQhz0bMOAJnN7qWBs//krvxkY8S1BleX
2YOeXVeZQBIQbLXWJEOWUggUA1SjHYELt6enQxqUXfRQpd71/CPpXJ2oteG8VT/O
YHlIKsd4k/WBaW8DrJZX
=1MR/
-----END PGP SIGNATURE-----

--hdoY8pikdvrkIRAT--
