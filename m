Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaI3JmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:42:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50961 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaI3JmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:42:06 -0400
Message-ID: <542A7ADA.4010500@ti.com>
Date: Tue, 30 Sep 2014 12:41:46 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Maarten ter Huurne <maarten@treewalker.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
CC: Apelete Seketeli <apelete@seketeli.net>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fonts: Add 6x10 font
References: <1410263188-10532-1-git-send-email-maarten@treewalker.org>
In-Reply-To: <1410263188-10532-1-git-send-email-maarten@treewalker.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="UDlSolON19TWuRRWfmEWPpkjnquSHgruB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UDlSolON19TWuRRWfmEWPpkjnquSHgruB
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi,

On 09/09/14 14:46, Maarten ter Huurne wrote:
> This font is suitable for framebuffer consoles on devices with a
> 320x240 screen, to get a reasonable number of characters (53x24) that
> are still at a readable size.
>=20
> The font is derived from the existing 6x11 font, but gets 3 extra
> lines without sacrificing readability. Also I redesigned a some glyhps
> so they are more distinct and better fill the available space.
>=20
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> ---
>  include/linux/font.h  |    4 +-
>  lib/fonts/Kconfig     |    9 +
>  lib/fonts/Makefile    |    1 +
>  lib/fonts/font_6x10.c | 3086 +++++++++++++++++++++++++++++++++++++++++=
++++++++
>  lib/fonts/fonts.c     |    4 +
>  5 files changed, 3103 insertions(+), 1 deletion(-)
>  create mode 100644 lib/fonts/font_6x10.c

I think the patch is fine, but there hasn't been any comments or acks
for this. I'm a bit reluctant to add this much data to the kernel if
there are no users (except you) for this.

So I'd like to hear at least one "yeah, I could maybe use that font"
from someone =3D).

 Tomi



--UDlSolON19TWuRRWfmEWPpkjnquSHgruB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKnraAAoJEPo9qoy8lh71fk8P/jKgB82TJc1+03Us6dAi3TI5
Z3rVogoMsrqTp2xH3VvjfCC+KwM0RonZ4AaPUTY4p1545sZ+W9sRK2C+5XMRJ40q
cL8NcdppWe6Mm/5ADaDKB/a5zQOXNwCTd+/yEtENV9YWuLZkVvi910diDR2uJiJ4
3Kfl/FjST3No+6VqLKKrrqX4VJ25jUl3KK0SXRMhKUd6SIYrEUbsvIQQAhAdZcpl
BqZyoKS3/X3m0HrQQC5dRsyOkpTZxIHA/Ia0uXqAYCFv4utif2hjSILWdAOvqTMH
Ty9zbaIMn5vE2ZzMJ0huCmCpwk7ofeHFtqEKdITGhXyrmxXsw5vsz0ht5WQ6TJPy
ZZLYqmXHqKZiMEZR4GyCUzD2oK/DHcRT9sgqNqOX3XPnIDrCOhGuLjeDiQfMwQsG
vP9u+Lrvey8vi8E0EKp5h/grN85bT4ciAT8GLT4CWJOPILj5Kw5YgPNV38glnxxb
ctvu9dxqYBd4TlQEKP4kFDGUTqyi8PSCBVsUGKu4GG8quUFtZm1j6Q69PGYVl0IV
7/sdleCMS1iSe+bi4OpAyKuqMXSYu0W7XA+3CFh74MwTnO+40vLxj5YheIjffaaw
WBZFBbT4QK82SX4+IyImh8fgx3hgo9h5xjgY85CNBeHESWuRL8q1CoFdujsjDuxT
iHC6IFbOhMzw5CgeCgSu
=G5oz
-----END PGP SIGNATURE-----

--UDlSolON19TWuRRWfmEWPpkjnquSHgruB--
