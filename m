Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab3LKHip (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 02:38:45 -0500
Received: from smtp06.online.nl ([194.134.42.51]:52920 "EHLO smtp06.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779Ab3LKHio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 02:38:44 -0500
X-Greylist: delayed 654 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Dec 2013 02:38:43 EST
Message-ID: <52A813C1.8070404@meshcoding.com>
Date: Wed, 11 Dec 2013 08:26:57 +0100
From: Antonio Quartulli <antonio@meshcoding.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>
CC: Kees Cook <keescook@chromium.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        "David S. Miller" <davem@davemloft.net>,
        b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next 2/3] batman-adv: Use seq_overflow
References: <cover.1386738050.git.joe@perches.com> <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
In-Reply-To: <e7104b35287b1e1ec456734c1b5e1aa98dac99f8.1386738050.git.joe@perches.com>
X-Enigmail-Version: 1.6
OpenPGP: id=43FD7307
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="T9RiPpL6d9kUP2kj5H5iCLKUgUwIs1p7M"
X-Online-Scanned: by Cloudmark authority (on smtp06.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--T9RiPpL6d9kUP2kj5H5iCLKUgUwIs1p7M
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/12/13 06:12, Joe Perches wrote:
> Convert the uses of the return of seq_printf to
> instead check seq_overflow to determine if a buffer
> overflow has occurred.
>=20
> This will eventually allow seq_printf & seq_puts to
> be converted to a void return instead of the often
> misused return that is often assumed to be an int for
> the number of bytes emitted ala printk.
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

I assume this patch is going to be merged with the others in some tree.
In that case:

Acked-by: Antonio Quartulli <antonio@meshcoding.com>

Thanks,

--=20
Antonio Quartulli


--T9RiPpL6d9kUP2kj5H5iCLKUgUwIs1p7M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSqBPKAAoJEEKTMo6mOh1VHyAP/jCSeWzDq+NDUQzZ7l2Wf9Or
2iIN0wzyHpEy8YJxZb7Lzbpr78zaROWZPYAyIwqGHTi4fuOGXvYAAA61PpQyzfIH
gA7m7iqp3D95SFN2Dn47ymQKJBTsoaMty6iCA1wElk9xaD+jBLXAQsg1VTD0eYjk
qCoNLUqyznNh3yMlid+eGckwdlaiispZBl9Qgm2nVZBD0/crWMPdM/K+nwIrE7su
zQ3LTIMkjMt0+Qqp8MwKK0QOL/nzl+lauwyb7biLSeX9bpaWWkxicuzOfNgmeJ5R
rbLy42esJDhgJLyDb2zWTW9q+WAFBVvf/kmWXgi2wrIuThZmRdkhAZhAsv44IjSX
gdJ0EANYVOXzEaV15hnP87ykHxSqfHQRyzdiEgUumeh5dWi9cW7u2o5o6j8CCvs2
RVDS/hz/ous5VTljuiCACbo23SWi7UATh84xOMsrAY59RTXhbfX0nd4r1vgALOwv
W/mja1z6G0aL5wYV+3jn07oqKcPXhfnpfoGq9pM+W6uxgzXWgHVomFWVFvfXBfzO
qgowRpgHSJf5quthncFnQ5PrMX6FfQgAqbswsJfzZX1nulgbHwmB3D/9tpKaFut5
qlFnGMOOsXib+ntdZlaTI+mVM3nRY7ThErCezcMGDW4ChMRkQc/Xb04Wf+1UhGAS
8iez/gKHwAiMpB5drjQU
=Qmot
-----END PGP SIGNATURE-----

--T9RiPpL6d9kUP2kj5H5iCLKUgUwIs1p7M--
