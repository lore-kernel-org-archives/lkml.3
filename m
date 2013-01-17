Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab3AQOeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:34:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:29911 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab3AQOeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:34:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="asc'?scan'208";a="273275154"
Message-ID: <1358433343.2731.254.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] mtd: gpmi: dump the BCH registers
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 17 Jan 2013 16:35:43 +0200
In-Reply-To: <1358147969-31878-1-git-send-email-b32955@freescale.com>
References: <1358147969-31878-1-git-send-email-b32955@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-dLgDS2nTpVnFBGZAuouM"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dLgDS2nTpVnFBGZAuouM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-14 at 15:19 +0800, Huang Shijie wrote:
> Dump the BCH registers in gpmi_dump_info().
>=20
> Signed-off-by: Huang Shijie <b32955@freescale.com>
> ---
>  drivers/mtd/nand/gpmi-nand/bch-regs.h |    2 ++
>  drivers/mtd/nand/gpmi-nand/gpmi-lib.c |    5 +++++
>  2 files changed, 7 insertions(+), 0 deletions(-)

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-dLgDS2nTpVnFBGZAuouM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ+Aw/AAoJECmIfjd9wqK0k3YP/2hhD2v2sRGj4/RmLVQNjBdl
Ou2sE/u0zK3kdlVTDasmhOZ03NgNjp1UKWiC9basZuTDHD+oWmy9rMwtMN1zLWza
2hTJ2hWEgo5EGTbN8WEnD8UXjMKctVBLB8/IPXQ8YZpyu6VL8vTWbA5AvN9cb8Iv
74uASlKLgQJVIjHZONmi5ohUIoF9QG5TG0QlupYYs5MY+Ch+xPUtvY5D8NcO6mdh
b22zdPMN9bAjIqUoqPCjDV8O8qBPFWjR9G6yHZ4hM3mszYduTGId8b34Elt8TgFP
GfQ1+mpZEycGzsxSnEKbSHoUK0hFUIgeN6TOpVbXQhcqqeGmNLXs/u5OT7CGSasr
8gQkH8+b2HOY9NKrVaI+bn3EuXVkEWADFh/+KVyDmbH4l9zwDAto6uzdqKeXrGrj
DR+8cwrIXoc4sZGgS3UmsM22YPor7lhTsx5yOK7W6Gn5sZq94ESYCRKO1ialdSsv
AMpkRziPRO9R/kcwjKLEFKBv1s/WCUBMrRJXR8flcDP5Bmxr2iEt3aao5D9Oy69I
rTmVv6/9aM7es11/pC/WJwl072Caj1mNLrkL5+7mt0zy45NE0WOJlN+G2P5mXe5J
i3bw0mPsLCYaoMaintlKmNTDrKyjQCcjQofxNel6gxPbIbicJjI9hE03HfTL4vzr
S9Crk9Pn0b1xGYWpp1wB
=W+fs
-----END PGP SIGNATURE-----

--=-dLgDS2nTpVnFBGZAuouM--

