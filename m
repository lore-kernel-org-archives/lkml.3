Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937030Ab3DJXnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 19:43:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:56372 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936571Ab3DJXng (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 19:43:36 -0400
Date: Thu, 11 Apr 2013 09:43:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failed to fetch the osd tree
Message-Id: <20130411094325.1fef833c1192fed81a70a6e4@canb.auug.org.au>
In-Reply-To: <20130326101717.36b4a4c2e23b108a9592b32c@canb.auug.org.au>
References: <20130326101717.36b4a4c2e23b108a9592b32c@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__11_Apr_2013_09_43_25_+1000_stqFS6aftvva2+cR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Apr_2013_09_43_25_+1000_stqFS6aftvva2+cR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

HI Boaz,

On Tue, 26 Mar 2013 10:17:17 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Fetching the osd tree
> (git://git.open-osd.org/linux-open-osd.git#linux-next) produces a time
> out and this error:
>=20
> fatal: read error: Connection reset by peer
>=20
> I will continue to use the last osd tree I fetched.

This is still happening :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__11_Apr_2013_09_43_25_+1000_stqFS6aftvva2+cR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRZfkdAAoJEECxmPOUX5FEmYwQAJjZ2cfRj8Mtgeo2TVpwZzqw
gG7OlIvewHUJlv1wodr6mtO97J4Kn60mawEc0twtVG9uKQNqWD/PVgPrOz/jouKe
YcBZrmmQJawl67fOgDWpyDzeDnMtEYGZh9D1NUDb9wHY1Yn5pcBVqI+hvc4i0KpD
3PDWiWxcRN2jGZNKIfnL3xoVgYJTG13JM//tpYhRhhSOrhCDXobjqhJlGvHY6SQU
SFlWuOvBzXGYnIV8n06o+DmXsnNEFO98xhgaYyjOkx/kq1AyB9HnHVFwVRGoTMZe
af+tSKFREco2ZC0KeKATlLRjC0y3aFYbCuhDHp4XuQcgN8BqU5czeHFEQLf8VgIy
Tg3J8AjBHi+PFjgaK0KCvOlhmdOhcOv24METE3GNtmJoUvqdTCEDONUDrQ57Q3Gq
2L8n35jjuaF8ACg+L7JPj/34bO1j/W/M0SLQNkGuV2xfB90ivHaSE7Gt1xKXLIXC
jPhjAQi9sJwEhqv17raJ++R1OgDAk/g5hLC8JcIlqX+UMkRE0Y2wGJBTA86Ez1+x
fn8q1aQV+EufXp9wf2aLWKaWfq4rbHKYjkq3fcwBAkZQc8Ohy/gnxPeVAJ3xx3gB
Wo81ZeiI4wOE1KuvufzjdPb/T5WTOqGLlVk2u97aBASfcg+hzHzF4iJJOppREKG/
nebLqtH60mpxWA1S7lFq
=obwc
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Apr_2013_09_43_25_+1000_stqFS6aftvva2+cR--
