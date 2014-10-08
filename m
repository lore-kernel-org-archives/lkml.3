Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754200AbaJHSVi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 14:21:38 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:41093 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbaJHSVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 14:21:37 -0400
Date: Wed, 8 Oct 2014 19:21:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: Grant Likely <grant.likely@linaro.org>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org, JD Zheng <jdzheng@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>
Message-ID: <20141008182123.GH4609@sirena.org.uk>
References: <rjui@broadcom.com>
 <1412743127-4523-1-git-send-email-rjui@broadcom.com>
 <20141008112143.GT4609@sirena.org.uk>
 <543562EB.8060300@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SOtBRHVUTiB0e0Vw"
Content-Disposition: inline
In-Reply-To: <543562EB.8060300@broadcom.com>
X-Cookie: Everything you know is wrong!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: pl022: Fix broken spidev when DMA is enabled
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SOtBRHVUTiB0e0Vw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 08, 2014 at 09:14:35AM -0700, Ray Jui wrote:

> Thanks for the reply. It looks like you are also the maintainer of spidev.
> In this case, could you please help to confirm that you expect spidev to use
> separate buffers for TX and RX? If so, I can go ahead and make the change in
> spidev.

Yes, that would be my expectation for maximum robustness (or if it is
going to use one buffer it explicitly maps it for mixed use but I'd
expect that to be asking for trouble).

--SOtBRHVUTiB0e0Vw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUNYCiAAoJECTWi3JdVIfQB0EH/j/kNQG1QgTj6zKBsCfVYKBy
Zlyampo/pqtrRqo3+PSiEv4Kq6vV+VazJUgypVacC5LLFeiWTl1qQ4G6n8x345oT
SklY3cjCZkduKMsBOrPIzcUnP0CZYqVps/fl4nIf3rXjloed8Ch3V4+7ewDFyFH7
Q28NkW3bH3wvl83oGdKD4peh3M2N62lFKyNexebXYLv8vTDJb1U+WiMZvDkORA7W
FstTWQaWzOSM554SKE++BqJ+IWPKTZ8MYw8RHW7GdvSiy9gsnECS2z/YAfhXypIF
LE7/UY3peQlD432gCiJa9gyv+cDaL/HJLOURuimE25JPa1Ea2ZDuYvp0xFx2Awk=
=JBXg
-----END PGP SIGNATURE-----

--SOtBRHVUTiB0e0Vw--
