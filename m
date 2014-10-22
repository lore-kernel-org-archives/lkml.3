Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaJVGyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 02:54:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37856 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751022AbaJVGyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 02:54:05 -0400
Message-ID: <5447546A.8070800@ti.com>
Date: Wed, 22 Oct 2014 09:53:30 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Maarten ter Huurne <maarten@treewalker.org>
CC: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-fbdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] fbcon: Fix option parsing control flow in fb_console_setup
References: <1412848110-12734-1-git-send-email-maarten@treewalker.org>
In-Reply-To: <1412848110-12734-1-git-send-email-maarten@treewalker.org>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="sj0NFaMBx5725hebH183id5JplDNGmxVc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--sj0NFaMBx5725hebH183id5JplDNGmxVc
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/10/14 12:48, Maarten ter Huurne wrote:
> Since strsep is used to tokenize the options string, after each option
> match the code should use "continue" to get the next token from strsep.=

> This patch applies this pattern consistently.
>=20
> Previously, for "scrollback:" and "map:" the parse code would return
> (unconditionally: strsep ensures *options !=3D ','), causing any
> following option to be ignored, while for "vc:" the parse code would
> go on to parse further options within the same token, which could lead
> to invalid input being accepted.
>=20
> Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> Acked-by: Paul Cercueil <paul@crapouillou.net>
> ---
>  drivers/video/console/fbcon.c | 19 +++++++++----------
>  1 file changed, 9 insertions(+), 10 deletions(-)

Thanks, queued for 3.18 fixes.

 Tomi



--sj0NFaMBx5725hebH183id5JplDNGmxVc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUR1RxAAoJEPo9qoy8lh717esQAJvxCPlq+L4JgggEeeU4t948
yrEVN+5jc9zXboLuYFokfUVpqoE9zl1XuzT6ZKHOpwvf/gGQjL8KGRkAW15MUZAH
GzkBIT4hVzOBOc4HqQEUbphg0JfS9JksthMaQXNWLs9SJ0Qh7+tgO72UD9PX1AQy
yrhCQBjK7XCo08IbW3MBDO+RdseXALYy8Qm2z0pr+eAtzKbir2O1qg2PPzeTvAHj
0MRv80vfgghXjj1zmK+72/64OP2w3+yYEMfdMwKg9uQDo8WU9vwtL+bI6IRP4EIv
rtgxOsiXLg9GLrIjDU046RNwL9b4kJWQYmuKPY9SLTXUfkxPje/T1tEGekJrV1px
beTH3ncZhToo6EOFqPS5tF9qecr4DaCqkR3FDjFJEHeqH4KZdpXJV9pt/DdKb/6Q
G/AHU9jw7D4b2BH1qf8eG2l2kd95Q8k6d4LHd30c2syCrnaBxpPn8Oif+pyy9p1V
zE0QRC1y6goBrumNJuiPODZ6faR1rtvCa2yFSFNUuarDMYIq9g9Yfa5n5RCuMPs9
yhFf/DSe9WJDM0KstMxlg9NwhcuwPRdGEpYdoKAzmQvnTqTlpXDVM0wcGyuWfiRT
lAPKjWbML1sGzQQSzGck30yLVOThjEnIG5E1G8iiBrVHG03KrYAg4afZL27yHWtR
JdsO7OKQZkhPArVE5EfN
=P8Y9
-----END PGP SIGNATURE-----

--sj0NFaMBx5725hebH183id5JplDNGmxVc--
