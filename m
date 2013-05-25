Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3EYPQR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 11:16:17 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33254 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756762Ab3EYPQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 11:16:14 -0400
Date: Sat, 25 May 2013 11:15:47 -0400
From: Mark Brown <broonie@kernel.org>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Message-ID: <20130525151547.GH7660@sirena.org.uk>
References: <1369384162-25196-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0OWHXb1mYLuhj1Ox"
Content-Disposition: inline
In-Reply-To: <1369384162-25196-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 107.18.111.72
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Make regmap-mmio usable from atomic contexts
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0OWHXb1mYLuhj1Ox
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 24, 2013 at 10:29:22AM +0200, Lars-Peter Clausen wrote:
> regmap-mmio uses a spinlock with spin_lock() and spin_unlock() for locking.

Applied, thanks.

--0OWHXb1mYLuhj1Ox
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoNWaAAoJELSic+t+oim9C1cP/RaJaRDHSFSjrvXdpnkjutXL
+STvmayXwXGIrVyJxYnC6pL7Rk5VCd+/c9azfngq7qUd/sbWXFpAVFWx5yi3izfV
JOOGIedYJ51nBfhn4c2A3j9LorEtAWarRUX5a850EnAfgUksgJpbbRJL1ItV6KsP
bLQhdcNgHaz6wGo5kQbNmqh/+YXK+rWAd1bh+9flGPYjc43QipgiTNVIFpr7wzDC
FCH7nJjDHszv43WTAZS1JQg+e2IJda6iSIDYwuWS5ky5Skh4zRT7PTgwlfyVE3B4
7KInKsq8xMZ4iowaacujinFnttvzLJpkPoccDHtF2m7P2i7mxLDTFsJQ7ayHXnma
bM3Iowgx/napIAnAofQUldeT2Z7yYxFaafKHBRb7Q7X5G1OOnmyfjtpnRdt8jof1
80lq7Fqj8LGBGzisEenKd+auvTriV6vgbA29zypsSB2czmVbeuZ1H60noTkwpLGr
6Fol1+67ZGmECfi/3HAtFCcM7GGEEUpPWsqfcSXYYZ+li3sKfAapp7Tse8h8DRg3
2uDYv3Nx1nfXFuih2GGRNs9uq4PZ2e/gi+D0gJTbBEMREYJXBHV4+9b79QTH+G6v
0Ug+Pr/DTcz/qEl7tD4vjdXlvmWMXDsTMH1r6vAXwa5omWeIdF0E9Z51qEy7qgzM
MWtazqSb66GDXP3KQK2H
=TRsT
-----END PGP SIGNATURE-----

--0OWHXb1mYLuhj1Ox--
