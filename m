Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429AbaCLTUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 15:20:41 -0400
Received: from sauhun.de ([89.238.76.85]:43329 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbaCLTUj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 15:20:39 -0400
Date: Wed, 12 Mar 2014 20:20:37 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, naveenkrishna.ch@gmail.com,
        kgene.kim@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v4] i2c: exynos5: configure fifo_depth based on HSI2C
 module variant
Message-ID: <20140312192037.GC28891@katana>
References: <1385100851-32254-1-git-send-email-ch.naveen@samsung.com>
 <1391748195-12490-1-git-send-email-ch.naveen@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <1391748195-12490-1-git-send-email-ch.naveen@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 07, 2014 at 10:13:15AM +0530, Naveen Krishna Chatradhi wrote:
> fifo_depth of the HSI2C is not constant
> Exynos5420 and Exynos5250 supports fifo_depth of 64bytes
> Exynos5260 supports fifo_depth of 16bytes.
>=20
> This patch configures the fifo_depth based on HSI2C modules version.
>=20
> Signed-off-by: Naveen Krishna Chatradhi <ich.naveen@samsung.com>
> [For finding out the difference and initial contribution]
> Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>

I know Tomasz said differently, but I prefer the patches squashed (and
the commit message extended).


--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTILOEAAoJEBQN5MwUoCm2SJ0QAJSPkdYOcxMYaMIWG+1/uDQs
+XlFCEn8V8WGIHGgSCZVAWvVXSzNz51+2gAhO5+yzUs5zdqqBCHCc7P28Gabcv8z
227qskI0K9TA+s3Ekv1m5fWE9/TIvfK9X/z6n8ZE3VE400Ww0cyw4gvitqcZRyRL
ShEKxjXk++XpPV3jdePI2JTa+GDmLkvHKTMzDG6PBPqCiusxKBcp3kw9jYofwEKj
RVVuL2pE9a5Gpt1SECzP8rMFw8K3k5rCngG0551QRtp2gZ+5MRXN/0Pxx/bNkaJM
j5PncySeky65AsnehaZQLMcR1IWAuK2wY2HW+aY58+W3Q93q7gFcpIO37aWfITAg
bU8k52Pu63Mp+61oNBnaO/bwdBzwNSArIbJQRBOwz9tnztuDYlWVMraXXz7QcCmw
xCOa7fA4QYSozy8TEBZ/29pfIbOdbFkSI3zGvjog1TRk6iQ6q+o89GHFD5uoYkv1
H75r3sr0kDMtLj6Ry6LQE6eAbH3Mkkmz9u+TbsAaRF7ScXjLiZehKAI76iua0T8q
9WJRyuQhK7V+eEWqLW3oSR8TTmrEjH+2zPa6TEIoYKyFWlvheH+U7RJkuhnCkOO3
A57P/XQ1n9E1WQaY5FasgxpslpuHZa46KnO20jK4MFUB9Ug3Pdg9eUvsWXqS7alQ
guubUUmFqvFell4G+Au0
=m3+Z
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
