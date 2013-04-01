Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab3DANyE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 09:54:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51721 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757595Ab3DANyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 09:54:02 -0400
Date: Mon, 1 Apr 2013 14:53:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 10/14] spi/spi-atmel: correct 16 bits transfers with
 DMA
Message-ID: <20130401135359.GB18636@opensource.wolfsonmicro.com>
References: <1363678866-3567-1-git-send-email-wenyou.yang@atmel.com>
 <1363679341-4087-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BKMA2OjimIttCqMD"
Content-Disposition: inline
In-Reply-To: <1363679341-4087-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BKMA2OjimIttCqMD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 19, 2013 at 03:49:01PM +0800, Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
>=20
> Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
> Cc: spi-devel-general@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org
> [wenyou.yang@atmel.com: submit the patch]
> Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>

Shouldn't this be squashed into the dmaengine patch?

--BKMA2OjimIttCqMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWZFmAAoJELSic+t+oim9Z94P/2ryXkTFZ13wHy4iouAFosnC
tZLp+QSizSreVYCzAFzXXUNUifpiPVGVMMEdrsKEhAqAQ9zv5dyNtKj71L1ETsoT
SoYPvL8A3NxwkINftoLwnD0oqRLjrwFgRU9pBHsv5qMwYZ3cI8Y7j3dcPcWyKBlS
X0xNxKB4SKNNFdlA6kpp8qh2m4f2M6rPYc+StfaCO8M2N9llQaLSaxqrJ0ztUIwM
1rRb88dhZLrdiFG8mS0gMXQeYIcC7+SYfhEUDgcjwgAvxofvV6IlZvQj2X96PGOZ
PGv4NJHDjR2xL5M7TyzjuVy2TMRhfhgTHxc7UfY4hadAnQxKcP8/GOVxptXkVqNv
zUwOf+bSyxQ8W3sDrfJCcAyERhv07nW8GO93UYhsebiNmGySOz7Yf6o2KkaYrmCv
z0o4AnVGEnETbEqrEGeZmF705W4k8ds3nGaqvKZNQfIWAP48V2fzZcdVDK2l5yAL
CJSVo4g41PQsCQNQmmMB5ZYqTKIakSGKwKZ8zaGiV/MeTOPSQTwKlBcLoyBdXuM/
V6HL75McLPiPZWGLwPZGECRMYxctyUw1zdU5oXHFjjunH/4lzV2z5zdeDukbVx6B
D8QA/HKKh2oESTs95xK3lDgyb4dMqBM370aoxO/MAcdazEQBs2EXSh53MYmlOQno
gBqQlBFz3n9I/6WWjuFC
=/QaB
-----END PGP SIGNATURE-----

--BKMA2OjimIttCqMD--
