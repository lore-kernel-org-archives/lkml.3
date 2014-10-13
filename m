Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678AbaJMLJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 07:09:12 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50333 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136AbaJMLJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 07:09:10 -0400
Date: Mon, 13 Oct 2014 13:08:51 +0200
From: Mark Brown <broonie@kernel.org>
To: Ray Jui <rjui@broadcom.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141013110851.GU27755@sirena.org.uk>
References: <rjui@broadcom.com>
 <1412880294-9860-1-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J9FDM06y/La6Wdcu"
Content-Disposition: inline
In-Reply-To: <1412880294-9860-1-git-send-email-rjui@broadcom.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: pl022: Fix incorrect dma_unmap_sg
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J9FDM06y/La6Wdcu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 09, 2014 at 11:44:54AM -0700, Ray Jui wrote:
> When mapped RX DMA entries are unmapped in an error condition when DMA
> is firstly configured in the driver, the number of TX DMA entries was
> passed in, which is incorrect

Applied, thanks.

--J9FDM06y/La6Wdcu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO7LCAAoJECTWi3JdVIfQxuwH/jgj0dqO8NNfa17Bxm9iBxOv
IAyvpMdcJCBYoRwyplx08xwSZjDRNJZhPnl3VZ3mm8KzCDsRya1eV+QKrb5peQRP
fQLbKpUwA+f4XEf8CeLP/nxQaej+KlS1oAxfkRGnaTZL1xqXqSrax5mLlK3R1a49
ZXzqWXMZUF7ksBwATX4BsiY0lR/2yyNLyCoekcMD5yqAwpVsmtGJ5jB3dW9E3o5D
B7TOD2otj+Qd6cuCiYs/MplWEtHYMty6PjbaxW9zfMXY0lMDzx9WjOeVXOnkCyPF
RHspo7diIKz7VirFFZM8lWSMF3PesHUXMFwzaBO+BAqmx1GxAu/p2s7b0iuf7dg=
=2Ypm
-----END PGP SIGNATURE-----

--J9FDM06y/La6Wdcu--
