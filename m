Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbaJMLHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:07:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50318 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaJMLHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:07:46 -0400
Date: Mon, 13 Oct 2014 13:07:26 +0200
From: Mark Brown <broonie@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        JD Zheng <jdzheng@broadcom.com>, Scott Branden <sbranden@broadcom.com>,
        Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
Message-ID: <20141013110726.GT27755@sirena.org.uk>
References: <rjui@broadcom.com>
 <1412878765-29088-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="80FmgzPrdF8O9k7o"
Content-Disposition: inline
In-Reply-To: <1412878765-29088-1-git-send-email-rjui@broadcom.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: spidev: Use separate TX and RX bounce buffers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--80FmgzPrdF8O9k7o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 11:19:25AM -0700, Ray Jui wrote:
> By using separate TX and RX bounce buffers, we avoid potential cache
> flush and invalidation sequence issue that may be encountered when a
> single bounce buffer is shared between TX and RX

Applied, thanks.

--80FmgzPrdF8O9k7o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO7JtAAoJECTWi3JdVIfQczgH/33EOoph6nnr17oswSdKgMe0
V1ToWcU3XovTDlHV0uVcZqfpdOAMzXfcz4xd5gB2si2rrVfDlDwgYVyVgGG41FJo
m8nVSg43dBwcKmf07se2gF2JHRQeZShDktoD/1pIrHWmBhZj7ZXxw/lrVZ1kEh/7
f4MgJPC8CVuQ7kWMr3vO18fY4ZLhySD5Lj4NYysl0euxhzzc22xFxxDyXD4LJeMz
n/bYmW+aNg5OVpHoxfYg27W0TGmLcUscmJDTqELFS6+XaBqq7kQhUXOT7h4pHQpL
2QBu80OMCf89MfUBg7E4e75kttQ47azCxHHWTXEh3sQBrA7gKfAWsi3B0GF7orE=
=rRC8
-----END PGP SIGNATURE-----

--80FmgzPrdF8O9k7o--
