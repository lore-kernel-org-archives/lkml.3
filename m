Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab3CCNxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 08:53:18 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:46533 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab3CCNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 08:53:16 -0500
Message-ID: <513355C5.2010505@kernel.org>
Date: Sun, 03 Mar 2013 08:53:09 -0500
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: webmaster@kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git.k.o] gitweb->cgit: Re-add Git snapshot tarball feature
References: <CA+icZUUWqeHdgjP-Hi630DDwO65evWUUCX2tBYfj=Cn1w3dEAg@mail.gmail.com>
In-Reply-To: <CA+icZUUWqeHdgjP-Hi630DDwO65evWUUCX2tBYfj=Cn1w3dEAg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2AFNCBDEFAMWAHDFRIPGN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2AFNCBDEFAMWAHDFRIPGN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 03/03/13 06:34 AM, Sedat Dilek wrote:
> Hi,
>=20
> unfortunately, the Git snapshot tarball feature was dropped when
> switching from gitweb->cgit interface.
>=20
> For example the Freetz router project extracted the Kbuild-system out
> of Linux-kernel sources.
> This is no more possible (see old version [2] and new one in [3]).
> Freetz introduced "git_archive" checkout method [3] to fix it.
>=20
> Can you please re-add?

I've cautiously re-enabled the snapshot feature. I'll keep an eye on the
impact this has on the system load and the cache size.

Regards,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


------enig2AFNCBDEFAMWAHDFRIPGN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQGcBAEBAgAGBQJRM1XFAAoJEI6WedmufEle8t4L/11Zc+YfBziUPjip//3pWUPF
2BgtmQR0MAfr6AIamlsCGFozJkYXGU4Joaux9Hsk9+/sJaM1Vof7bIkltwDhN9Mq
4jY2wKCxijKXtKJHGyKpg8IN57S3UHSuqVshgZiBx8QMsBPe+PVro1h5+ufYrF2w
paNrf95igV5FbZIVIEnSoOKtvd2yK9pRzlOmeGQVMnu0wm7hAThdNGi+MdCwoRws
HhTA3YZkD+uY9jFVBbF2BHZRHHj2IObPTDOpDDL5yYB2tCLR2B1vOO3Far8+RBU7
O8WjUKxIoi5WnyNJDzkXjH99CDi5NtzBVHT6KCcIb5A2knJMmxq8M4oe+ZdytR4/
2uWt4dO4ICmy/NjAuHfJxCsoW6sJKxPc8ZUWmFoxWVZre8L3WCVvKmCC757KwUJw
iBpGSk/9txN5Jr8NHJbLQ4yacBzSm7NtRhbkj+ma23+wwU22KBh1yWChJ/omRmEM
0hVVkLVSDgFUwuh9W2J0vM5WTw7GeeuWZPoJbXBROQ==
=3wx3
-----END PGP SIGNATURE-----

------enig2AFNCBDEFAMWAHDFRIPGN--
