Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755310AbbAFM4Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 07:56:25 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:54199 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242AbbAFM4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 07:56:23 -0500
Date: Tue, 6 Jan 2015 13:56:18 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Walmsley <paul@pwsan.com>
Cc: Vinod Koul <vinod.koul@intel.com>, Paul Walmsley <pwalmsley@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        dmaengine@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dmaengine: tegra: add slave capabilities reporting
Message-ID: <20150106125617.GE31830@ulmo.nvidia.com>
References: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="//IivP0gvsAy3Can"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1501060640220.28771@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--//IivP0gvsAy3Can
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 06:44:56AM +0000, Paul Walmsley wrote:
>=20
> After commit ecc19d17868be9c9f8f00ed928791533c420f3e0 ("dmaengine: Add
> a warning for drivers not using the generic slave caps retrieval"),
> the Tegra APB DMA driver causes this warning during boot:
>=20
> WARNING: CPU: 0 PID: 1 at drivers/dma/dmaengine.c:830 dma_async_device_re=
gister+0x294/0x538()
> this driver doesn't support generic slave capabilities reporting
>=20
> Fix by setting the appropriate reporting structure fields that are
> passed to dma_async_device_register().
>=20
> Signed-off-by: Paul Walmsley <paul@pwsan.com>
> Cc: Paul Walmsley <pwalmsley@nvidia.com>
> Cc: Laxman Dewangan <ldewangan@nvidia.com>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Thierry Reding <thierry.reding@gmail.com>
> Cc: Maxime Ripard <maxime.ripard@free-electrons.com>
> Cc: Alexandre Courbot <gnurou@gmail.com>
> ---
> Applies on next-20150105.  Boot-tested on Tegra132 Norrin FFD
> (with a few unrelated patches not yet in mainline to get the board to=20
> boot)

Tested also on the Jetson TK1 and it fixes the same warning there:

Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--//IivP0gvsAy3Can
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq9txAAoJEN0jrNd/PrOhbAwP/ROKNrxF/6CykfvEbKzroMvo
EzOmLHErWJveQzvLM8aWNtn/QkOSiN/uwuGFoozBrVCG5aP16xqHb7kiK06sk35V
0A3YK935+x4fR/CccVbWd9ry6W00NfutswEKfLDJBENtHwW2/UjcvLHreOTXfcnp
Oj+cvUqh869Vwk6TC3i+NbXaXg9lsxE4UJTIJNHvKiR171aYksEgRlbtoqMI7YdX
BrOWzcDNkzumluU91zZEJhPmn0T8Hjig1nR0BkKKKR7FkhN7rVymB5UPzu5YBqnF
+2/gYNFzo3/fngXM/cGnEMQs7Zdh93cmn9aEqy2DpDgrBSEz8GBX+hGuEaGle3pM
h0iy9WfVY2sr8lwqTn+igq7WZ2jHOhwV2wQ9ybushPr0bYZrsqgM8hhYl9k/FdRR
t85Hn5tHR0jc1OEZKqte96uXkmvM3vNYvx9XhzM63LqklH8hG4HY2zQ607jFavPG
+uJhF/7g0NdIFTwmRvv6zovg7h8IcSLT9Kbj1WNKIPRJ9kzYQMq0P+Nplqy10M5c
7eCJINPsuWwEP6Gisl7KSDvezimAbSDoKWiTNvjl/a2aYpN6gDSPaXQuMV7putPZ
9H6WAv7zjlHYDCn5Z2hXcjHrbD3dr5Mm73BAxPb36cy6RS9clLAPGNjcsoYtLW0C
FcTNiKwO95gGCVWt2Jd3
=jwGI
-----END PGP SIGNATURE-----

--//IivP0gvsAy3Can--
