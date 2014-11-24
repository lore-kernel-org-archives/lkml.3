Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKXH26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 02:28:58 -0500
Received: from ozlabs.org ([103.22.144.67]:55579 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752348AbaKXH25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 02:28:57 -0500
Date: Mon, 24 Nov 2014 18:28:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>, Stephen Warren <swarren@nvidia.com>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Thierry Reding <treding@nvidia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: linux-next: manual merge of the driver-core tree with the tegra
 tree
Message-ID: <20141124182849.185fd5d6@canb.auug.org.au>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/XrWHbgS9nsKoEbuPbzlZdiY"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XrWHbgS9nsKoEbuPbzlZdiY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/memory/tegra30-mc.c between commit a2257374a4bd ("memory: Add
NVIDIA Tegra memory controller support") from the tegra tree and commit
0f0d7e7b022b ("memory: drop owner assignment from platform_drivers")
from the driver-core tree.

I fixed it up (the former removed the file, so I did that) and can
carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/XrWHbgS9nsKoEbuPbzlZdiY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUct43AAoJEMDTa8Ir7ZwVQc4P/jorOe2x7aXt4oZsa+uXh2+s
Bh2SMKglw8Ln2r519dXv1wdOlCAdm2isfRL5RtcvL0y7jfDB9J4h0KYqvNsyBn0r
zwa0zkTLmdU8gYHSw9E4jIJUUaozCwRGTI5bWuoZ4/M82o3/WpSX7/0bYsySpwYK
75HxCJbI60NvwG3N/+N0micXgUzhmtJQfAVhECnpyrwcVu5lB/nhqIy9yV0krzHp
uRkybamo4bqWWTpgpO2gi/XmmuuwbcVhLsQUtk9y5W44H4gJF0EMkg8fayAtn3qt
UTB9Q+/6Yw2oKVvY6PVtBURLRKmbS1LKHiovrEarzndUZrr7ZPkcrk3TPHBlUUvG
k/0Am3cTgMLhCr45U4kh3burwhofTJXtil9fLEMhOPLTWZDTOAT5K1sIfo1xLvzs
5jDsRkovEiLWHmQH1hFIxuqvBxaeYoK7relrRbYOA0mBRR8hyxDZZqZ9ntZVHkmt
/dbRvtA39Nj4IcfD/o5oqpmUlN1aZFQzYWosC6xpmsrkNRxAWTXwWYcWK4ldLxy2
m4dG0uhlPYQzQot2KDS8VehO8sHIWh3rjGxmLdwG6wHWccBjr84C781lL9MrWyHL
jOz2H62ArjYR+IoYmdYU03kR7+8RjpJpx15yA3ksA6v7nQZ7W1xprpHf9TaxSxqq
WuU3dT0neXGIWb3stIZJ
=+jq4
-----END PGP SIGNATURE-----

--Sig_/XrWHbgS9nsKoEbuPbzlZdiY--
