Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab3DVMei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 08:34:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47023 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085Ab3DVMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 08:34:37 -0400
Date: Mon, 22 Apr 2013 13:34:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] regulator: palmas: Fix off-by-one for ramp_delay
 and register value mapping
Message-ID: <20130422123434.GI30351@opensource.wolfsonmicro.com>
References: <1366626169.3800.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wZdghQXYJzyo6AGC"
Content-Disposition: inline
In-Reply-To: <1366626169.3800.1.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wZdghQXYJzyo6AGC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 22, 2013 at 06:22:49PM +0800, Axel Lin wrote:
> Datasheet says:
> Time Step (TSTEP) selection, when changing the output voltage, the new value is
> reached through successive voltage steps (if not bypassed). The equivalent
> programmable slew rate of the output voltage is:

Applied, thanks.

--wZdghQXYJzyo6AGC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRdS5RAAoJELSic+t+oim9Zo0P/2dNrn3bxyLv9kcSy7F4W9xz
IAy0zgbTePggwuBAonKyTUQL1n/gqswmhjBl41+KRuqFhHlsuM0clewhRA+T5yDU
KQkHcMwP+JNO2C+o3JhUzdTGkvJD4HJEnTPgPeuNRDFnvuAVkgLwDnUoyrXTp1/B
Pdf2TxzG4DFBcA/5fEJKUpBwgqPy6lFUpEJc8BiBFc75Begw4SPang3UaJviimL9
guU64PWTgtBSUOmzkDpwfkMUbNsf0niKVAA5Yw97wjRtrdYhQ+WgzN6cVTW3/XPv
5EQnMGdwn4V52+wEHaHRLUJQhb4rnXch41c3sdf9r9vtuIzxNictjhXj7p+xSqgp
1f3CZuscY2iq4+NSbFEiay3miSHHbgdC0Xd2AQDDrSk00bRwYZoFZ9LEy/Tj026z
CGKX737DEwBIFHN4KRDofdcfhD1mAG+3sDnWjuNoAvu5ZhsynUTd2m496pEuHMNB
D56/slmXHhEyOAaJYSpeH0bmDhCpjyKUmkzCod27bvm3eqBOrfE/UL6mVL8F6PpS
FIUAougaH/PMxF+3OHevOoLK6v4FRpncyHKX4gUgWaZwlYHU0kYW4wXXoLJOMa4B
FCUaq/xrYqQT/VBhWoU4BPHUUYW4TSaRUhQKTbSzEGDT5+hITmW4jZ6zvF1zjxka
BM2sTYYpLeGUUFhRCf0y
=AdJD
-----END PGP SIGNATURE-----

--wZdghQXYJzyo6AGC--
