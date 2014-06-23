Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570AbaFWLuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 07:50:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752481AbaFWLuX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 07:50:23 -0400
Message-ID: <53A81470.5030606@ti.com>
Date: Mon, 23 Jun 2014 14:50:08 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Julia Lawall <Julia.Lawall@lip6.fr>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
CC: <kernel-janitors@vger.kernel.org>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/10] video: use safer test on the result of find_first_zero_bit
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr> <1401872880-23685-4-git-send-email-Julia.Lawall@lip6.fr>
In-Reply-To: <1401872880-23685-4-git-send-email-Julia.Lawall@lip6.fr>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="AS9LdoLUjc046qPhunBEpHguJ5vrk7gNj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--AS9LdoLUjc046qPhunBEpHguJ5vrk7gNj
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/06/14 12:07, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus ma=
y
> return a larger number than the maximum position argument if that posit=
ion
> is not a multiple of BITS_PER_LONG.

Thanks, queued for 3.17.

 Tomi



--AS9LdoLUjc046qPhunBEpHguJ5vrk7gNj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqBRwAAoJEPo9qoy8lh718xwP/R6CO6ppHG/R7S1XjZ4GaqHc
7mnzgn4M88x/DiCZ5Zsk9QuMn1iPY87cdNuXizIlphrnSW0fxGBTKiuzvB8BZMdu
y+ZVS7HaqT1u3dviAMnES1mJtBJMEnNFYUVAwzszDZyn9uoFAB1jZt3hdXqo585T
tg3qsrh3DH9MNT5fMlheyx9D2vFVW5T3tPmBtlafKTIgVVeZHaBbPbmZeLq/xQi0
zoRzWZVkTuHn3803HJHpMD+gncjgkkFH+jGGNL+P/fwHfxZS8zyTJ3QhI4s245XW
FqmKYQHsUCkZrr8249NMff4+TUiFURjS93OeS0WzuECV1IWdYL8JTmTxAqI1XilV
R8rc9M2B5QW11MYy35xzzrOwWJLiwtwh7HRl8ZFof/7VKM6AX3syh8Xhe1HwyXgo
1AIzkiadXs8ArPLM21Vsudvp3KdmX6FRlZmx9jAabP3+aBydK4/Oqd7HzQfR3cdg
y1IpDneCTycHgwbnv3fojqTVt9U+h8yKDNjrfPQxxnUrmxD5Q7air9sSy0vS9iC5
0lNeiCtKTT+Pb0ed5YRqrdekTAcv5B80F6HrXuZoDHZ5gyo2sdczqass2nJtBBQc
ZfgceVPwJJNZzxsmSzM16xWLDZnkXTdcQqALZQIr8LiNeA4iziMgGq7COOcuT2er
kqGf9fpjSZ0BLlW8VJbS
=o5gy
-----END PGP SIGNATURE-----

--AS9LdoLUjc046qPhunBEpHguJ5vrk7gNj--
