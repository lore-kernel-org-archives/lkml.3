Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbaLHM6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 07:58:50 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:52024 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885AbaLHM6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 07:58:49 -0500
Date: Mon, 8 Dec 2014 12:58:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Laurentiu Palcu <laurentiu.palcu@intel.com>
Message-ID: <20141208125815.GX11764@sirena.org.uk>
References: <20141208230517.13ebfe4f@canb.auug.org.au>
 <20141208121342.GW11764@sirena.org.uk>
 <20141208125447.GJ3951@x1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XLTQE3HqOi3RIrZG"
Content-Disposition: inline
In-Reply-To: <20141208125447.GJ3951@x1>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: linux-next: build failure after merge of the spi tree
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XLTQE3HqOi3RIrZG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 08, 2014 at 12:54:47PM +0000, Lee Jones wrote:

> Patches re-sent without COMPILE_TEST support.

> I will re-enable COMPILE_TEST when Will Deacon's patch to fix this
> kind of nonsense lands.

It wasn't the _relaxed() stuff that was triggering, it was implicit
inclusions of the pinctrl headers.  You need to directly include them
rather than relying on some other header pulling them in.

--XLTQE3HqOi3RIrZG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUhaBnAAoJECTWi3JdVIfQlvEH/2mD1Z8Q3CgPtqsluUesAdDA
REteyJ5d/gATAnmpiqFh35USgzOxl/N28Y5yHnabk3TL01pY1J8AJtiny437Z0Lu
H/7EKmizfCre9LH2r9sc3lz52NurcZ1Tif200EDuvGjK1VfNgdzJ10f71IRhRMk2
aEyEnJEnktkgqa31kPzXT7nIN4JEi9OkIXlXKJyWcnIdRESC0QngWFIKQdSz2QUe
8Pm4d1HLqeOcfK1UJKxFLpWgyJq+0XZKudOwkADwrh743vNi/TqG7k9sQsfobq0b
eFgx0XoqJIyxm2OU+YgGgXBU/Pf4cV2JRAjGgqyBB75ErjZSFGHDF7YO4X8ij0w=
=KwPc
-----END PGP SIGNATURE-----

--XLTQE3HqOi3RIrZG--
