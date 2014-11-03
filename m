Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751027AbaKCXTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:19:04 -0500
Received: from ozlabs.org ([103.22.144.67]:39562 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaKCXTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:19:02 -0500
Date: Tue, 4 Nov 2014 10:18:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Nov 3
Message-ID: <20141104101854.2cb9b8f4@canb.auug.org.au>
In-Reply-To: <20141103214943.GA20210@roeck-us.net>
References: <20141103161403.79bde878@canb.auug.org.au>
	<20141103214943.GA20210@roeck-us.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/.P7Qt5hgny_=IfAgGLnvoR3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/.P7Qt5hgny_=IfAgGLnvoR3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Guenter,

On Mon, 3 Nov 2014 13:50:01 -0800 Guenter Roeck <linux@roeck-us.net> wrote:
>
> Something is fishy with this tree. I get either warnings or complete fail=
ures
> with qemu runs on all platforms.
>=20
> x86_64:
>=20
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 1 at fs/dcache.c:255 __d_free+0x43/0x50()

This should be fixed in today's tree (Al has fixed it up).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/.P7Qt5hgny_=IfAgGLnvoR3
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUWA1iAAoJEMDTa8Ir7ZwVURMP/Ri2VaBl7jw0wroMIZ5YDUx8
VOcGk5fgZlVZizVMdgeJPFNbajY5ZUEFYdhMaHE8mEDq/YUo+ClF6gx5bSYMG7Op
XvMsBkTD4/VpUk7w8getmIL6ODNKucwqMcqZW35WjBn+FoQw+UNeBx6Ol1X78eo4
MmXqKbJWfQGhhRzfDMOn4BaW6K1mIVimsaHcjOXmfyVnG1Mi/Pvqlz/3l2N3qDQ7
lVV5Beg77cupwLuqPzI2uymqrs3cwq+F7w4xtW4HM9ZEhWBm7O2X0MKWvLRy0PeB
es+J8hE0bwPSiFVIhe6VzrRGzsS/T+90exOTG4xks33vNd9dsGDn45HbeG8tR0Yr
+YV2mmWiapYrJYwuMs6OIzW11lr3KDHUrPD5zSF+kSSp9MXAF19+LuQ7roM3k203
z05VzwcMdsWfqU/jFicaWxCS5Oy+SbT7PQKz/ic4XLiGK0tLbCgd4GklAfTey9zG
EE0k9ogE9ReVPjvPh1vZyaXVtVJAIvQbmgOldBu/pz50yhgjghCXXIvgaONysswi
X8BFjOZCz0O9rX7gPWxghOnFisGc0tqhbS16JjwRzd39DI1VCAYwJSqPXxlOHPco
i53tO8D6AiQQkUzKwW8Jvu0wTsB5ElYBEMXx895LNIqe/QTlAUkTK5sKi8POO6OW
qEicyvaVpCkp21esRzX+
=Q3MP
-----END PGP SIGNATURE-----

--Sig_/.P7Qt5hgny_=IfAgGLnvoR3--
