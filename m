Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933605AbaKMRiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:38:16 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36833 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933584AbaKMRiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:38:13 -0500
Date: Thu, 13 Nov 2014 17:36:31 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20141113173631.GI3815@sirena.org.uk>
References: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4iouofAvTJq54EyQ"
Content-Disposition: inline
In-Reply-To: <1415848096-20079-1-git-send-email-abrestic@chromium.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 0/2] spi: IMG SPFI driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4iouofAvTJq54EyQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 07:08:14PM -0800, Andrew Bresticker wrote:
> This series adds support for the Sychronous Peripheral Flash Interface
> master found on IMG SoCs.  The controller supports up to 5 chip-select
> lines and single, dual, and optionally quad, mode transfers.

Applied both, thanks.

--4iouofAvTJq54EyQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZOweAAoJECTWi3JdVIfQQQkH/RBtbEYZLe4dZ2uS+T/8OcKx
RO7apd2IBJL1IU9jHX5kwsKbjulXl/YhAIpA5r2oVxH3GxhfqG3+lu8ReezBvm2I
DXXg+cHHPMb4XfvbHnkuehcgGc/+ri/wyDs1W+PgRNVSjCuIV2xMrpj8z1Ctx1Dk
3EEt4Ff9gNI2yKK6KMfJnjnChK45C6QJfVc5eiLu1jR2DalgTpNGu4kcdjhM5wKK
lqOL9OyOgmw1MmWYG92TLJRYUIACVajA6NLD7Gd3xle+9W4VNLx1dlP/WBbk7H5L
YSunWxnf/2czLckoqnPhYnPBjO7BKyNtMsN3spw/4xGpV60J6IZ2s7FXHA5l1M4=
=2lzP
-----END PGP SIGNATURE-----

--4iouofAvTJq54EyQ--
