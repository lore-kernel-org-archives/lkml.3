Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754829AbbAPMjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:39:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:39021 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbbAPMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:39:07 -0500
Date: Fri, 16 Jan 2015 12:39:02 +0000
From: Mark Brown <broonie@kernel.org>
To: Ken Wilson <ken.wilson@opengear.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20150116123902.GN3043@sirena.org.uk>
References: <1421377847-3198-1-git-send-email-ken.wilson@opengear.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Tb77rFjxeKqknTuc"
Content-Disposition: inline
In-Reply-To: <1421377847-3198-1-git-send-email-ken.wilson@opengear.com>
X-Cookie: To program is to be.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv3] spi: orion: Add multiple chip select support to
 spi-orion
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tb77rFjxeKqknTuc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 16, 2015 at 01:10:47PM +1000, Ken Wilson wrote:
> This commit adds support for multiple hardware chip selects to spi-orion.
> Different SoCs support different number of chip selects (up to
> 8 on some platforms). The driver allows up to this number, and it is up
> to the implementer to only use the chip selects that are available.

Applied, thanks.

--Tb77rFjxeKqknTuc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUuQZlAAoJECTWi3JdVIfQybYH/2CLWtEiSU/it0DJVhBnzLly
QdPgZd0F+4Az+5chcy+A/XeKZvkWEDGSrwrVWUqBs2VTA6iY3BrHg4ActX5l5I8Z
3gy9xLx5M9/KJINsIVW0iMfiJLixWhzDrdwE/RYBcug4H0g1pOsTAWqcabnnPVnf
wb/9Q6wOt8gAgG0EfaWZCgcwlM7abrlMGnLaGq3Vd4fol4c7iwqfiiH2Y5UfvnNF
MvvJNdW9G90Y6HsXqfu0TNDbhV8FXnQR1f8wTO1glIm4mac9p7TMys58njYw3/3I
fVhN+9++KCtbbDmpy1n8VAjPezePA36nMepWnYCet6ObhoLWcZ3UGVewNUqOGRA=
=HqW0
-----END PGP SIGNATURE-----

--Tb77rFjxeKqknTuc--
