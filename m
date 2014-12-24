Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbaLXMUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 07:20:48 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47104 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbaLXMUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 07:20:46 -0500
Date: Wed, 24 Dec 2014 12:20:32 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Sifan Naeem <sifan.naeem@imgtec.com>, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20141224122032.GW17800@sirena.org.uk>
References: <1419276916-28433-1-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IjgjYm7ZLtdx4pCv"
Content-Disposition: inline
In-Reply-To: <1419276916-28433-1-git-send-email-abrestic@chromium.org>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.173.220.131
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH V2 1/2] spi: img-spfi: Increase DMA burst size
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IjgjYm7ZLtdx4pCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 22, 2014 at 11:35:15AM -0800, Andrew Bresticker wrote:
> A 1-byte burst size is rather inefficient and has been shown to cause
> TX issues during testing.  Increase the DMA burst size to 4-bytes for
> both RX and TX DMA when using the 8-bit FIFO.

Applied both, thanks.

--IjgjYm7ZLtdx4pCv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUmq+PAAoJECTWi3JdVIfQ4zIH/3TaZkULbIsI2aobqE4g+wf2
Y3SRpHtwO42Ff/ZuHLudCQe6zRM1ol+WhtXm5Q9sbCJMIVJoNx+LGkYs1GQKU5Ln
TIdCCEhBem9NZtS0ygt95DTTM9n5LQvDKZJZuQ+9+wMytN/carhKt8dFQBlC9+Cx
lCkYPrG+1/nShpHBRtOnQdDYcZsTAlEb2vhwHoLViHTb4xjiN6OziIqSUFncun5g
7Y0Q3pxhbtWxJuQOcO7HbQeFJ95h0QrEK7rguS3hqaCHo575h4zV2M0LbwJsKulO
Mp70M6z7DH4FmKo9i6HdVYdoGGGo+98+MYz3vHvyrl7X19exB6J0m90xrihvNKE=
=ntnq
-----END PGP SIGNATURE-----

--IjgjYm7ZLtdx4pCv--
