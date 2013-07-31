Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265Ab3GaB12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 21:27:28 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49512 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab3GaB11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 21:27:27 -0400
Date: Wed, 31 Jul 2013 11:27:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ext4 tree
Message-Id: <20130731112715.5ef90f220e6f6be184dfd665@canb.auug.org.au>
In-Reply-To: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
References: <20130729110816.12958c3a26400f444a9a5012@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__31_Jul_2013_11_27_15_+1000_KIbf27aXg3_MK8Ze"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__31_Jul_2013_11_27_15_+1000_KIbf27aXg3_MK8Ze
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

On Mon, 29 Jul 2013 11:08:16 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the ext4 tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> fs/ext4/ialloc.c: In function '__ext4_new_inode':
> fs/ext4/ialloc.c:817:1: warning: label 'next_ino' defined but not used [-=
Wunused-label]
>  next_ino:
>  ^
> fs/ext4/ialloc.c:792:4: error: label 'next_inode' used but not defined
>     goto next_inode;
>     ^
>=20
> Hmm ...
>=20
> Caused by commit 4a8603ef197a ("ext4: avoid reusing recently deleted
> inodes in no journal mode").
>=20
> I have used the ext4 tree from next-20130726 for today.

I am still getting this ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__31_Jul_2013_11_27_15_+1000_KIbf27aXg3_MK8Ze
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJR+Gf5AAoJEECxmPOUX5FExMEP/jwdQpnVGm0rLiU56HaJPsMz
Kpm0AZCi4wv7tkAk8gElnha8fWSOUxu9IqRQv9+uAW6d59N6vNdN1QcDNHMBhEz9
+FUHZW76Sm+GKqEfBLEf6/Xu5i8J6XMM05/45291Zckb51Iivki2A00XYFz2AZbw
hwqTMsTYGVyjngJIWvy4JF5M1GQpCXMq0lu5Xfg4k1i3NkKoyKqV6ETrdHZv6l3d
6JVXulen0fi/J4XrTUTmwPT0zj6LIjfxngAyIsU9/G//tQ1g/yzjJJwkPMp/cATp
IzK42imU81kbih/oo/1XHAxJs3+GME7NM+OHftg4fGECJxbLAF1XIJM560B776fD
HtUJ180TteoEmXabh/axrt1omYQ5Ij6/lBSPifcjw0TjX/zhchWuKkkmJbXXgls3
yRecs4RMSUXtKxtNRwBMAWHXiHpEx7W7cxIRPU7/6J6E/9JQQIrohBJTr60PxBqH
djismcs0Jf+ME2bDyfhgiKZcTLURImKEtyTWyiV6FNMomxvczfYV6dbOb7qUuKKM
yr2nss3ce2fyZPXFfTb6yH+cKD14zSkOEY7D1/4lerV6JPqYJsH9kEUa4w50FPjX
THQE6+Mw/w4oIxCbNgMVxwYuhJ1ERmCwo7V79mijhkXr0d49v8/cK/4URVUK9jj0
B9H16nsMWBjWok6F4j2h
=+I1q
-----END PGP SIGNATURE-----

--Signature=_Wed__31_Jul_2013_11_27_15_+1000_KIbf27aXg3_MK8Ze--
