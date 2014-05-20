Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073AbaETHN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 03:13:59 -0400
Received: from ozlabs.org ([103.22.144.67]:57307 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbaETHN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 03:13:58 -0400
Date: Tue, 20 May 2014 17:13:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sumit Semwal <sumit.semwal@linaro.org>,
        Thierry Reding <treding@nvidia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: linux-next: build failure after merge of the dma-buf tree
Message-ID: <20140520171351.736fb238@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/J0fndYs2/RSBcvfXwq2mqU4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/J0fndYs2/RSBcvfXwq2mqU4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Sumit,

After merging the dma-buf tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/gpu/drm/tegra/gem.c: In function 'tegra_gem_prime_export':
drivers/gpu/drm/tegra/gem.c:423:15: error: macro "dma_buf_export" requires =
5 arguments, but only 4 given
drivers/gpu/drm/tegra/gem.c:422:9: error: 'dma_buf_export' undeclared (firs=
t use in this function)

Caused by commit 8dfb1f0f8103 ("dma-buf: use reservation objects").
Grep is your friend ...

I have use the dma-buf tree from next-20140519 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/J0fndYs2/RSBcvfXwq2mqU4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTewC0AAoJEMDTa8Ir7ZwVj+oP/0iOZ9sXcZOUoMkkvXFqrVPj
7syGnb6v5acqlJ9g3y/8Kcsu5tgUkRK6YvPMZbL6NKly5+IllSCDWlIht77HvI96
Je6ezJv7tFOG7myX0Ff037b/sXsodjiOXGd9Jx7ib9ljbqFlyHaqCfsFaeociDA8
lnO+x/DqKneTpmOwFhbLFQLa9rhehnSi+J/gIjPpJTkNh42yW4kBLEubKmn5J8+W
6912c87VE7A3t8pzZZoSuXpencGveEgqEcn6PeHU03Wme1H7J646vzKHqqNFuoTH
JRDE0JuubtF5UTKiJLWakhjEwH1zrdiDuA5uUSeveksV2KskyB+kViIsXItsJ3HT
xLGYbTnbjINECwEuIEScmPw/AsZu6zMrJBMqUNi+0z+qoK+IFM6GqbhuKzh1gvzt
b7uQJ7YUW570zyl3isAPsj3tTtwM1g2t6GUD3gCQiM9JDrT6f0P+cOyWnk0TgnxD
SUXi3lgF8btRz0EmOMyFqY6okmnvu7lf/w3lgDwbmV9a/t+eLdnJRW5UA1I3qtgs
1AZkuZjdQRi7nRiVJTY9aGU9Ol3kPtnB6/mWKLmxO2NcqmSpra0R/WDmAGwsAiM0
nS0O1qGmlFFd5TnxyKJ1AWxAnxLKJasNp/lBAU58+l0nozVrDvRs4/qlKf/X6SeB
UgCTNN9v1PewM6ul1M3l
=Epdz
-----END PGP SIGNATURE-----

--Sig_/J0fndYs2/RSBcvfXwq2mqU4--
