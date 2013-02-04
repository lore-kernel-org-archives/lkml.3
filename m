Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab3BDL01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:26:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab3BDL00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:26:26 -0500
Date: Mon, 4 Feb 2013 12:26:22 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5,RESEND 7/8] ARM: tegra: Add board data and 2D clocks
Message-ID: <20130204112622.GC595@avionic-0098.mockup.avionic-design.de>
References: <1358250244-9678-1-git-send-email-tbergstrom@nvidia.com>
 <1358250244-9678-8-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QRj9sO5tAVLaXnSD"
Content-Disposition: inline
In-Reply-To: <1358250244-9678-8-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:RYX9pQORNECG02QIWKHskQmOMd50Tf2ddg8+WDZnY4v
 00tMVzqFPTIF+DLn7uzIU7WRFhWzl3nPStaJXLO3H0WsMWX5zG
 uFHrBmnTzOygPaqcyDIWgcxhqjfQOCGm+AihOx3bMEJTJNHjOT
 Y6NXPX4D6tlviJER8XywMyxvX52Q02ZIvOECwrOZ098o3Z3NDj
 TEdtH1nBXCOShGQdgRCxUWpuQeiyu58FlPndYRUmhYuLmLsXbI
 KXS0qz7pF+Ggln9+kwLw2BtYD7/rZQQ6L9TtmgBv4UB62k3JQ7
 NO5rCrPy7PVEP5UOKAt9tQkzVu+eePHR9ppVGbo2IrWOPRCZRn
 bIAnBME3ndLEg9bs5pvJULoyKnbFopNriRaxJAjJS8Pck5UhFz
 b2FBJLLOtrpp/gJGK0U21x8BdKzh02EgV4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QRj9sO5tAVLaXnSD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:44:03PM +0200, Terje Bergstrom wrote:
> Add a driver alias gr2d for Tegra 2D device, and assign a duplicate
> of 2D clock to that driver alias.
>=20
> Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
> ---
>  arch/arm/mach-tegra/board-dt-tegra20.c    |    1 +
>  arch/arm/mach-tegra/board-dt-tegra30.c    |    1 +
>  arch/arm/mach-tegra/tegra20_clocks_data.c |    2 +-
>  arch/arm/mach-tegra/tegra30_clocks_data.c |    1 +
>  4 files changed, 4 insertions(+), 1 deletion(-)

With Prashant's clock rework patches now merged this patch can be
dropped.

Thierry

--QRj9sO5tAVLaXnSD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRD5reAAoJEN0jrNd/PrOhQTsP/1SHqWbU5vGVye/MiuqGVFAf
AG/oTf8vLi6wn/+qa8tsM/ADvEfyi5E2/xH4xeMCVMQnw4C6zebAiI2gQdrajVIp
g5OciSWhWyFT9vXsQtky3XLMVm66C2amOVfwuSidIVrs/9phLcGy9MwLQu1b92xq
Khokhc3O/Ddd1vU1x31vbfklwG/9HHRPxgEY1h+XpK6WJAUPH1fGx7vxbGJyWhb4
+UZlEUk8gF5YwrBwvbtw1f3Kqo0z9JdvMoXh34tiptTJ91ihZq6ajOjBLheK6oxj
kJXiXuZpOnkORLZBiAk2wADJr3mKSGC2lD6o2exgPnNMPc0XW0gMn/PcFSwcJZPZ
XJrZbh93Vx7eyzH7xe+ECOHWOl5SA0+v3ED5Yf0UtYZp/DbEqx3MSoRr1V7U+I0Y
wefSfh10+GdgSUQJ3hhcO37LNaG9N74XOGHXsF7IoOXWyVGKHdOwJ6UXpkXDqVHv
SrdffLSMU+bA9J0CxziVQbDnfkGwC5mZH5jlLQM5FEingei3pctA67eaHrmneYil
n28uRy3C8ZnZePgPItG9gNiikfU6qsufi56Q/wYWnhfUaxuDJHrEB/ZEXx00lEfa
dRPSrf95QV1vy6oaVfDe/GQqXCa1S4zpg6pFGuqszT8xLBrfDGFjNopVhF+EcM7m
MhfqFPg6nPfnN3rUoHQi
=bOV1
-----END PGP SIGNATURE-----

--QRj9sO5tAVLaXnSD--
