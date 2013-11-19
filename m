Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3KSSuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 13:50:24 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53049 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650Ab3KSSuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 13:50:22 -0500
Date: Tue, 19 Nov 2013 18:50:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, alsa-devel@alsa-project.org
Message-ID: <20131119185004.GH2674@sirena.org.uk>
References: <1384859269-19801-1-git-send-email-lee.jones@linaro.org>
 <1384859269-19801-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9gXqgVhKaPB5h51M"
Content-Disposition: inline
In-Reply-To: <1384859269-19801-7-git-send-email-lee.jones@linaro.org>
X-Cookie: Drive defensively.  Buy a tank.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 06/10] ASoC: ux500_pcm: Extend Device Tree support to
 deal with DMA data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9gXqgVhKaPB5h51M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 19, 2013 at 11:07:45AM +0000, Lee Jones wrote:
> Soon we will strip out pdata support from the Ux500 set of ASoC drivers.
> When this happens it will have to supply a DMA slave_config to the
> dmaengine. At the moment a great deal of this comes from pdata via
> AUXDATA. We need to become independent of this soon. This patch starts
> the process by allocating memory for the associated data structures and
> fetches the MSP id used for const struct indexing.

Applied, thanks.

--9gXqgVhKaPB5h51M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSi7LZAAoJELSic+t+oim9w6wP/iU45AxHAtr/MgDlYQh2QxUq
rKIEGVcV3sKfIDk2P1Yo4R1w+aXqqDxVeA/pK3VsiYaZyCdZEWlsxeaVvnlJOEU7
61cULcR6/CtLtbc71Dr8nydixS7vt8pgMcOIssXam+cBOJef0Z3tfFtB9Eoh0D/3
dR3F6QWT9sXzyfYhheIhLV+qE99fTUw/KigufKSxDwu7gqjl8Xdbed9C1KhCof2b
lfhGbBSdMbt84+wFn/b4Ys270UIXV9VwdQLi6UpYzEHuPUiMu1ZZwb51NR1W9Quf
cjQ+gv2dat+EW9mV5z8vBJ96VNcwSKLtq9bjA3bQkflFi393LmdwgIzRLBamSrVK
3PXtxQFpv+aR8YUnNlU7mMe1hdDL4TuV02KQiWjwF5CxMRIq9Wb9b7oMSzFcNpdP
ukmo8b9DTtL3NLhNAqwmDClJ6duDHTNuOlghzYZxOvMSh3KVRZ9kFbbmEJ6mFLWU
TnhzPawYGpuWM1L2JhzAyZ+HgnpLMAqh8Ilb342EYJ8+X/cqnObd4jlz8hTnjhI1
gYHZjiSxnJH2yz3Zagf4LSBIMPuXzMjA95yM3OGqgKSJCoB5/GHAKJOriVPfLt0V
rlr4rOb8fVUmdhKO+M18hmAaSpq0JocJzDuxJeJeANZaZOdpyFCsQDawwMKXT5TB
0+U8RIMV/1xvmviEAVES
=FuQg
-----END PGP SIGNATURE-----

--9gXqgVhKaPB5h51M--
