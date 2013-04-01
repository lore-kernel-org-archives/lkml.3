Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758071Ab3DANDN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:03:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39721 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757545Ab3DANDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:03:12 -0400
Date: Mon, 1 Apr 2013 14:03:09 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH V3 1/5] spi: s3c64xx: modified error interrupt handling
 and init
Message-ID: <20130401130309.GH18636@opensource.wolfsonmicro.com>
References: <1363157014-9615-1-git-send-email-ks.giri@samsung.com>
 <1363157014-9615-2-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+Z7/5fzWRHDJ0o7Q"
Content-Disposition: inline
In-Reply-To: <1363157014-9615-2-git-send-email-ks.giri@samsung.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+Z7/5fzWRHDJ0o7Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 12:13:30PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> The status of the interrupt is available in the status register,
> so reading the clear pending register and writing back the same
> value will not actually clear the pending interrupts. This patch
> modifies the interrupt handler to read the status register and
> clear the corresponding pending bit in the clear pending register.

Applied, thanks.

> Signed-off-by: Girish K S <ks.giri@samsung.com>

This and the committer e-mail address (the From: above) really ought to
match up with each other.

--+Z7/5fzWRHDJ0o7Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWYWFAAoJELSic+t+oim96/AQAIl37xvCkADZTcmF/B5U4YZD
6+6llVqjwQl2QK+vrbSRx3NVpyi6cxfq/gDSBBdFe1k2SEDB1lCmNq7Nxc+NBNXo
n6/UKDyHjJvFwlb3d02ZITPv6G7u5LI9j4ob0oEmePFphw1eljhH0Nl5Q6HSMPnk
15IWvXmR0nSlpaZZMQcdG54I6emxKJysP5MukCxv56R/yIYyzG6pfcYHMTXvG+D2
nMQsTWjL1+S81H3QDqf3deN6/ZJIwNiNLOZokprYK17kDFdjtmWN1uC7ibYmbBF3
L0y9izTz3+iUbT/9x040zV07V6RjUpVV4w/8t/nUEOcMwHCFH4/2a13xm2I4P4O1
4tPN15hPW6yW1Ur2oNsZwYf7f/k+0x1StBsvKQNY4bve0jQ+p5G3L2v1UKlEmlYk
7MN9N0Nt4DJH5P7JtAB4ZAQSTlNjMmJgOLPPXryiOcQsiRAzoPBuXJF/IKwQ75Bd
0wTo6ybA1/xoYUz2i3nIv7j/7A53ZqwClY5GKl8lzesrspXOs+haj+hvBB5USoZP
d59VNfyq2frOA3scjYH/dNnreh2LJrYYoZqZa+baHNSAK32vtdPw4QNzMk4IWbE8
GRsPN9b8BFAV/g3jtWdvXdxSGjZIeNqNsdM0jsjeUypRqbO6H3ziAmYOISFnVDXl
0zhvGBNtsxoUK4s1EMPD
=DegY
-----END PGP SIGNATURE-----

--+Z7/5fzWRHDJ0o7Q--
