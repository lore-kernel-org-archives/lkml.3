Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759071Ab3DZFvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 01:51:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55921 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab3DZFvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 01:51:17 -0400
Date: Fri, 26 Apr 2013 15:51:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Chanho Min" <chanho.min@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "'Geert Uytterhoeven'" <geert@linux-m68k.org>,
        "'Bob Pearson'" <rpearson@systemfabricworks.com>,
        "'Richard Weinberger'" <richard@nod.at>,
        <linux-kernel@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
        "'Yann Collet'" <yann.collet.73@gmail.com>,
        =?UTF-8?B?7J206rK97Iud?= <kyungsik.lee@lge.com>,
        "'Linux/m68k'" <linux-m68k@vger.kernel.org>,
        "'sparclinux'" <sparclinux@vger.kernel.org>,
        "'Linux-Next'" <linux-next@vger.kernel.org>
Subject: Re: [PATCH 1/2] lib: Add lz4 compressor module
Message-Id: <20130426155105.337d821415d8bfa845bf23f5@canb.auug.org.au>
In-Reply-To: <OF6B440C9E.4A0516C8-ON49257B59.001BA689-49257B59.001BA68A@lge.com>
References: <CAOAMb1D8rokZpQpp6mEJw6KXcQq8fJUWBJoC5+ZfkNaE6WvAZA@mail.gmail.com>
	<CAMuHMdXXoaQjb9sRK=X3gEDwqQBJcJQtaJbUGB8cJmteHSN3vQ@mail.gmail.com>
	<5175014e.487a420a.4c58.ffffe0b9SMTPIN_ADDED_BROKEN@mx.google.com>
	<OF6B440C9E.4A0516C8-ON49257B59.001BA689-49257B59.001BA68A@lge.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Apr_2013_15_51_05_+1000_yD6n__.3PFlRcJN3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Apr_2013_15_51_05_+1000_yD6n__.3PFlRcJN3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, 26 Apr 2013 14:02:01 +0900 "Chanho Min" <chanho.min@lge.com> wrote:
>
>=20
> @@ -0,0 +1,23 @@
> +#include <linux/kernel.h>
> +
> +int __attribute__((weak)) __clzsi2(int val)

We have __weak in <linux/compiler.h>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__26_Apr_2013_15_51_05_+1000_yD6n__.3PFlRcJN3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRehXJAAoJEECxmPOUX5FEtPkQAJy8Kokc7jbRt3dNSYV5FDfc
u/8NMJibZwG1O75vR/z66P5tYRmaecOI1/2mK2aWeTA8IoraQirPKqGDNQ8fh0Uv
tdmLYJE80TmVpquruIkpp1qQ2IW+iy1Zs3LXY2hVkNCidKldrI+Y4mB4233oRruw
cSf/IWEg8Fms9bM9AhJRz4mxpLKBNF+FGANht5H2jWF6AUKw47RuhwxhIbPhJn5O
qQZKvudNHduRCyAW17vGMwMgwXrRS3+yrzBNixs2IK5Dv52qjWKuxBNCLT0gsqvo
ut8BTwj0oaRp0O30VTnDzMgSiqg5ggDg5P1q0kapC7tCBBSK11SFViWSke9/n9ur
sPqah71egLK2iuAlIkWbn/lI+TEMMaeo+SGdXJ7ZwmZ44yaNz2UGJt9TYA4/XHga
EfIUwt0Zpsvb7NBISHeHvttxYEG6GeMtZY2gAqj7rCdJgVXRW6ynZ/PITlzqqlMl
ByPLj4LxNNgQL+ulxwgVJOXj6SJQDeH4O10918764tRx6rVe6O3NNPkMRpA1eS2x
duEDv+BQ8U8pXXACuBd3zUH34LNTCPfFDGxvufIQUU81AiVZqo6nulShaxwvV949
M6KkurSrKeJovT84FhRDHFzVXbUq5b2rSkiLNdJpW1a6ZcYnByz2qNYRKBvmT3PZ
JXy4y6mIfn6ByclO1eKU
=duzo
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Apr_2013_15_51_05_+1000_yD6n__.3PFlRcJN3--
