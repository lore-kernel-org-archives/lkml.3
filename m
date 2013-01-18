Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab3ARIDG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:03:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:58751 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750759Ab3ARIDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:03:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,490,1355126400"; 
   d="asc'?scan'208";a="245510453"
Message-ID: <1358496270.21816.3.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/2] mtd: cmdlinepart: Make it into a module
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 18 Jan 2013 10:04:30 +0200
In-Reply-To: <1358298770-20286-1-git-send-email-lkundrak@v3.sk>
References: <1358298770-20286-1-git-send-email-lkundrak@v3.sk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rzLx6FuqsGZfH6/ryiD+"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rzLx6FuqsGZfH6/ryiD+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-16 at 02:12 +0100, Lubomir Rintel wrote:
> All other partitioning schemes can be compiled as modules
>=20
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>

Both pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-rzLx6FuqsGZfH6/ryiD+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ+QIOAAoJECmIfjd9wqK0+CsP/2hylVPVFT5wfFU54C6wkOpa
49juJcm1IIFppBGOoQ5KSI/GzZyvzWldcaYsKbxGiAG38Oqc+HdK3IiUc4nLk5Ow
LzpnuMQaBq6NEkZi5IEN0e5t3CfYe5w/iabY3JpoZcO1Ii8O5XXypm5SLWnrkEEG
FkNV7vgea+qNHwHsR5DUGCfvbzd/9eX8Z9JcpQUhfdTcI0DMbBr0PcagQefLbr9H
zwhDwsqbHoUf7Q3TSFA79Rh5NV3vqOy8XdhVZXZCCBLwj2g24seKh9G8wjf74GgF
f1nhda9oUyYu6At2/iRX6854SA8aCV09snWk9bD0zg1zsrYDBcP9ZBCR/7rg2u2I
K6OEZxBH3M9imh5wUlpRC58YHgqjFKkTiCFqHNUdUGp+na9s/sjiG6lVHcu+mm58
+gGEqtWQFoyvREpb0qXZgvGWNks41Rzgx+ZW914X+mCSGZY+uUIYLPJhYpivny0D
sRMNfDJ4UEvL6vvodZo5hdmCi0oWngiMBjO+4smIzHgIDX7SNZBYltHKeET3Euyv
y2lxn4wY4nO0RHgbEnfzov5fO24cBvuozjVUcPGbsRtSX/+hkPk801va/WPzixn2
7J33bn97xiN7gi1nyBsVPKwacWlzeCY0CWIXh0fLvIFwSosl7YK9y9rguMgBD226
4W8ySrVXp6ifkC0p1VzU
=cn7o
-----END PGP SIGNATURE-----

--=-rzLx6FuqsGZfH6/ryiD+--

