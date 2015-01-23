Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbbAWMpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 07:45:46 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58492 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249AbbAWMpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 07:45:42 -0500
Date: Fri, 23 Jan 2015 12:45:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Esben Haabendal <esben.haabendal@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        Stefan Roese <sr@denx.de>
Message-ID: <20150123124529.GU21293@sirena.org.uk>
References: <1420472564.803.9.camel@gmail.com>
 <20150105154834.GV11764@sirena.org.uk>
 <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2DJuma0xDHN2clgl"
Content-Disposition: inline
In-Reply-To: <CAOR3GqUBWyfUvNG-8JiPVkis6b_25Eq_REtcp=kLN3CUoqsG6g@mail.gmail.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: Backport of spi-fsl-spi bugfix to 3.14.y
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2DJuma0xDHN2clgl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 06, 2015 at 10:15:47PM +0100, Esben Haabendal wrote:
> On 5 January 2015 at 16:48, Mark Brown <broonie@kernel.org> wrote:

> >> Please consider commit 4302a59629f7a0bd70fd1605d2b558597517372a
> >> (spi: fsl: Fix problem with multi message transfers) for inclusion in
> >> stable kernel 3.14.

> >> It fixes a regression when using mmc_spi driver on top of spi-fsl-spi
> >> driver (tested with powerpc mpc8313 based board).

> > Has this ever worked?

> Yes, I have used mmc_spi with spi-fsl-spi on the same board with success
> with in 2.6.33, 3.0 and 3.4.

> I have no idea what has caused this to break.  Maybe mmc_spi driver was
> not doing multi message transfers earlier?

So, I now see this has actually been merged into stable without getting
to the bottom of why it's helping anything...  this is a bit worrying
since it's adding new functionality and not really a bug fix.  It'd have
been good to at least get a followup here.

--2DJuma0xDHN2clgl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUwkJpAAoJECTWi3JdVIfQPo8H/RffkPqLY2puXJqYxZVPSKSw
sJMTg3QCJ9I7FW9FfU2wz4wrDFtV8hvMmfnnjZgv8uQVlbgkAGxO4S7K+UuQq+z9
g+Yu7AYzgJC3n9OURVc9u1S3tFUULFM3isbIW7eTQNHa2De3GfEEjIjAepfAy2uE
e7DNgA3OHceEBQ3LHflonH7qyBzPl6wEGxMp8BYfT4fmxEGeYn7aKZJlYT4rXDa0
MJoSgkeK3XmhOt2VYwKXRLwccvMHn78MSEsR2g23EY6txWsJmYX/K3gNUvPAcT3K
xzTplu/mOgakJgQ4aOwsqHBnkGSs0Bo1g0DZj3eN4UrNa4m0AsMIkd6McUAU9rs=
=QO5v
-----END PGP SIGNATURE-----

--2DJuma0xDHN2clgl--
