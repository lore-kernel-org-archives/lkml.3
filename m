Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EMORH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 10:17:07 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:46445 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab3EMORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 10:17:04 -0400
Date: Mon, 13 May 2013 18:16:49 +0400
From: Mark Brown <broonie@kernel.org>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net,
        Stephen Warren <swarren@wwwdotorg.org>,
        Grant Likely <grant.likely@linaro.org>,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20130513141649.GA16673@sirena.org.uk>
References: <1368453886-6852-1-git-send-email-silviupopescu1990@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
In-Reply-To: <1368453886-6852-1-git-send-email-silviupopescu1990@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.247.243.210
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] drivers: spi: convert to devm_ioremap_resource()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 13, 2013 at 05:04:46PM +0300, Silviu-Mihai Popescu wrote:
> Convert  use of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.

A version of this patch has already been applied.  Please make sure to
generate patches against the relevant development tree (or -next) to
catch such things.

--n8g4imXOkfNTN/H1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRkPXNAAoJELSic+t+oim98OQP/3eV9cT2GCnZBPD2vGKcLUkk
zBuK81IT0kHRNyRmsyXmtbDV6Jm7D17vMD4hxZRUoy27vJGk+avuXnetF9uHnbtf
hknd6+NGTonTNt9Rw/FjCC+M0QrQkW3DXVap/XELEsYPBN5aHgzAVwtVbvHG9VXS
mYK/NExUYgJcFIr6gSJHE/HWYStpkJv4G+zpsoSR180m2JncXooVqoT4NArsTgAr
rErcv4utZM7vj0UK7s6C8wST9Zbr02auRt2XkiphKrLIjQqIoyKL1re/I2BmqjgQ
UoJDm5E/b9GAkrT02z58dWqK9T3fCUHJqUJDgRyn7rzGLHQImrmaxGKpp0OS74iU
3EoVhktoUTR1g40qraQBGqn4oEBjfnSJZAqk99+rp8N4SBd/uBJT2DFhqdcqWuQD
m5LtftQWAUQ3WFkrkc4YR92yuvo2ABHIBAxhfkAWClAe7fBS504WN94TUpXZ/fhq
r5/+ycZwmeFWd5vTng5dlsurL5keUAlZph9em0xgptWLIwElidlwLNjMrRKs99Gy
s+eXFt37wPbQiojKi1WCeeFe8P1XMWgA8qOs/XA6oZJkzbh0CilTyoSRb9HlyUz9
N71Xla+VNRNqaQBkAd3+d8WyVolrNrjdAGkdcwI1lyFb8PhqjOusxYgNOgVYBlDc
DSfJQzQLd/N3igPGMKqH
=7ll1
-----END PGP SIGNATURE-----

--n8g4imXOkfNTN/H1--
