Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965655Ab3DPXZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 19:25:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44470 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965610Ab3DPXZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 19:25:13 -0400
Date: Wed, 17 Apr 2013 09:24:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/5] mem-soft-dirty: Reshuffle CONFIG_ options to be
 more Arch-friendly
Message-Id: <20130417092459.a574ebb81a734973ff7081f9@canb.auug.org.au>
In-Reply-To: <516DABC8.1040606@parallels.com>
References: <51669E5F.4000801@parallels.com>
	<516DABC8.1040606@parallels.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Apr_2013_09_24_59_+1000_3u_Bxfn+37=1Py.I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Apr_2013_09_24_59_+1000_3u_Bxfn+37=1Py.I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pavel,

On Tue, 16 Apr 2013 23:51:36 +0400 Pavel Emelyanov <xemul@parallels.com> wr=
ote:
>
> As Stephen Rothwell pointed out, config options, that depend on
> architecture support, are better to be wrapped into a select +
> depends on scheme.
>=20
> Do this for CONFIG_MEM_SOFT_DIRTY, as it currently works only
> for X86.
>=20
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__17_Apr_2013_09_24_59_+1000_3u_Bxfn+37=1Py.I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbd3LAAoJEECxmPOUX5FEPV0P/jUT5wL3rPRxphjllQCmkem1
wXZNWrurjURGK3mAC/ChCBaRyUgqyqR+CnuQaKb9YLSDpGohVaLfhLjDlN+ElRuZ
a+XCdZg1NBCQOayNGaL2nt3AepiI+vlbs/QmodkOMz/uT/xzIOQl3F4XoIW2Nvh4
s1tu5By9awUhH5F5p4dFiOjsFl2yv2X/O4y+6uZkcwk3e6h9Dzp58WY465SdYSIo
E/heCwqwCFai7plmzbFmEyWnpHL0VN6Y/S9WoRo2YEWk2D2+PdLdCChv/fgJxCw3
QtD7rHpUSNGY3ZOr9a8IiNd6dPQj+T72xkGC+oaDcf5u8YvOryC2R2RQCyHmZUTs
5aOOJkdUdtXufECGp5T1dR9Ii4pOB8q7SAsz9oGmzXTyBqXGF7FjuaK4rej2ZMcg
U9FfRDVFsWz+QrTQlMR7IfGCvMsoORyp7JcvUai9bzbLfSexkxwCnaqbbeAD/C8H
vuCKcfHTXDu3Zp/HzN6W1AFVxbx5DH+32te5izZhruKIhJPxAoCVjzM1k4FEa+H7
+2JyucLISZiSXqSU7QoGzvu8cK5kXXEjt06ccCzJ7ns9W9qMHfl7yjYdTAL89MP6
gz8rEVD1gbFgUxqI9/r4GmW8isgXOcckhE275zjyV6yCJ8FOdQGPqod5GiwTHrep
M/MOVZCd3bknOmRUzXWk
=cYpe
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Apr_2013_09_24_59_+1000_3u_Bxfn+37=1Py.I--
