Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab3BAQyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 11:54:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:15659 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756871Ab3BAQyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 11:54:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,579,1355126400"; 
   d="asc'?scan'208";a="251524928"
Message-ID: <1359737697.2942.16.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/1] mtd: physmap_of: fix illegal dereference
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Stef van Os <stef.van.os@prodrive.nl>
Cc: dwmw2@infradead.org, wfp5p@virginia.edu, gregkh@linuxfoundation.org,
        sr@denx.de, plagnioj@jcrosoft.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 01 Feb 2013 18:54:57 +0200
In-Reply-To: <1358446932-7238-1-git-send-email-stef.van.os@prodrive.nl>
References: <1358446932-7238-1-git-send-email-stef.van.os@prodrive.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ebqknbQGuq9xXAtlwDkw"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ebqknbQGuq9xXAtlwDkw
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-17 at 19:22 +0100, Stef van Os wrote:
> d68cbdd introduced a new way of getting the name of an mtd
> partion. The character pointer is not initialized, and only
> checked against NULL, not at other random garbage.
> This patch fixes the resulting panic.
>=20
> Signed-off-by: Stef van Os <stef.van.os@prodrive.nl>

A similar fix already sits in the mtd tree:

http://git.infradead.org/mtd-2.6.git/commit/7dfe4be351e81656ca1068e5d4ead23=
5c7ba94b1

--=20
Best Regards,
Artem Bityutskiy

--=-ebqknbQGuq9xXAtlwDkw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRC/NhAAoJECmIfjd9wqK0JKEP/0SDnKu9lwYhKKbREIxhh4Mw
KHqHQFzio2R5KCEJ0ZV8hgtCg8irKze9Rd07edJqZvtL7icNPcyX0lIGAgK9plUq
wwFw7o8L33IsLHl57D3BnnBRZaNhX5P5cWW/w3jz1/xvdvcluhbLW8o8EnGuHDrg
EsTehuTYU0iYfA+UTJCtOFFLxKz0CYsO7MNfQMDvqTzW8PrxHdLx/0hPu7AzKE10
e7pBaqtNnom5m1mJf0eycqtQxJE2yg1tjVFFRJx4PaQ78mti3aYGw4JUk9zYq97N
5Tcku34BghBXidpqPgREemciEDWo19q71TpMtgJ2u7wnD5P7up3+EN/N1TAPL9El
bTk2kMwWijsBw+9yXF3NIHEFId8FEQvCYMuLgsZ4Q3Im8W5PUT1zuAr6vYddLqwI
ghT9Ip29wpBhf8Za7xMX56C3XcOLc5oREwlxh7X4X6/PqLv/e6WXt/W0s9eXoiw6
Ek2tEqObzf0wlNl/EEoe65yOJcCGU8Wcv+oxshDXw1v4d57LvQnKs6IBZXKDObdJ
Iyt1qgf1g1VNrgZ/I3LqKt+U2zmfyoRXqnGy3lgESYe5mizLN3Ts59m9G1VHKQJH
Wi4XVcTjOEQTMhiR0/rfzswZGP+zTqFLa7Ty3MSzPvsQZIh3akhoVT783RTwlF1Q
p+wcCRdFhYsgMnFV5yuY
=LJTR
-----END PGP SIGNATURE-----

--=-ebqknbQGuq9xXAtlwDkw--

