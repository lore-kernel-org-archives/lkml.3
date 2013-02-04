Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563Ab3BDHgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 02:36:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:12859 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab3BDHgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 02:36:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="asc'?scan'208";a="286184089"
Message-ID: <1359963456.13791.10.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v3] mtd: fix the wrong timeo for panic_nand_wait()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, matthieu.castet@parrot.com, ffainelli@freebox.fr,
        gabriel.matni@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 09:37:36 +0200
In-Reply-To: <1359511436-12107-1-git-send-email-b32955@freescale.com>
References: <201301292200.14622.ffainelli@freebox.fr>
	 <1359511436-12107-1-git-send-email-b32955@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Mq6ZV8QeatpCqPg2jXAM"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mq6ZV8QeatpCqPg2jXAM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-01-30 at 10:03 +0800, Huang Shijie wrote:
> The panic_nand_wait() expects the timeo in ms and not in jiffies.
> But in nand_wait(), the timeo for panic_nand_wait() is assigned with
> wrong value(jiffies + some delay). The timeo should be set like the
> panic_nand_write() does.
>=20
> This patch passes timeo in ms to panic_nand_wait().
> And this patch also passes timeo in jiffies(converted by msecs_to_jiffies=
)
> to time_before() which makes the code more readable.
>=20
> Signed-off-by: Huang Shijie <b32955@freescale.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-Mq6ZV8QeatpCqPg2jXAM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRD2VAAAoJECmIfjd9wqK0OSEQAKySBEfCqdehlFoShCAth8YZ
qozatIYA1Z7UYmv8a7Gv7R/tCKNNUa+IGEqhRDtibwQR/LwVawfS3ZNSEKnsvGnJ
wHj9gajkNvToVAEiKpZrsRp72ifzoOTvg08zKOHZmJreQq0b16rhR+zHI6vNG+rT
+mo0h2OSZ2NxEf5G8wuvkCRyWSBrLxks5QknrSns1vP7nL2lh2ZKLW8sGbQS5qdU
KGnw/qggJMyZd/vTI4Hf33WBghdCYlBZGR9Sevzh10F+fY1+mUxZ7herm8B9yDEd
MEAIGYxgPv0xu4MBzIBLLiTHwCdYhXJUoJtv1FDMO4zF3sE1/6oVCZK4nZ8o1Jht
3BE1EvJ1s9nY3siTUC9dNS4EmF+WBGCqOXcf60pLs6iFEoaprjwE5K3wOmZjDova
TRmoyU+7pWhpT3g3zOf0laGU1G0CZ+PQ0qYdVcnnGhjAEwjWr16OMLOlqQTIfYES
e/f3r6/v5GK59YRbFA329m0kE2pdZmW7vOEV0dig3vlNK5GgANiUlzEgjLxypbIB
CLmBlDIiZ4S15ZwXT1n5E2dheuzOwoS+OcDXeVyDb3p4typipydpbb8qCo6wl+6Z
Tx6QO0NvmYNug9SR2jF9NgV7Wfz/ukJAA2uE1Tf/C4eEyD+FO776nZH5cAHYdyzW
lSSXodDEpE5fN0HhEq3g
=Pbqh
-----END PGP SIGNATURE-----

--=-Mq6ZV8QeatpCqPg2jXAM--

