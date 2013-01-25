Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab3AYXqr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 18:46:47 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42461 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3AYXqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 18:46:46 -0500
Date: Sat, 26 Jan 2013 10:46:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        KVM <kvm@vger.kernel.org>, Avi Kivity <avi.kivity@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: linux-next: Tree for Jan 25 (kvm)
Message-Id: <20130126104634.997ac68f6971397b9f4d09d3@canb.auug.org.au>
In-Reply-To: <5102B8A6.3090200@infradead.org>
References: <20130125162606.edff84fcf6f62ed2b7c4d719@canb.auug.org.au>
	<5102B8A6.3090200@infradead.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__26_Jan_2013_10_46_34_+1100_oqjkoucQE=vUrPhq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__26_Jan_2013_10_46_34_+1100_oqjkoucQE=vUrPhq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jan 2013 08:53:58 -0800 Randy Dunlap <rdunlap@infradead.org> wro=
te:
>
> Seeing lots of this error on i386:
>=20
> arch/x86/kvm/emulate.c:1016: Error: unsupported for `push'

Caused by commit 9ae9febae950 ("KVM: x86 emulator: covert SETCC to
fastop") from the kvm tree.  cc's added.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__26_Jan_2013_10_46_34_+1100_oqjkoucQE=vUrPhq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRAxlaAAoJEECxmPOUX5FEs48P/js9+YPengJUeAsrWrt6gAYJ
hmDuwHKGqbOqsUnj+nVj6yz/i7n7MyzDUpWsB4JO4N6X0o+ZPB6L7oE/2ROmOyiu
9n8Tsb/he6rWVupIZCL3H39jI+wEv295WioB/nQkvJo9wobTYtcyt/t46Cqquo7A
sfPb6lBgQLpsd2REK/i0ZEpOnd0TE2Hm6n5yU7CX0qssOnwAf4huuQkX2Jkl0eng
+V6d9gR+EAPHlidjqGw3n5pTs8QkREmq7htTiRJ0z5jeBvs03GMC/78QZ+1w02Yg
Aq5DIET7VBBz6rYmIISimP834Rukj+ybiAR4U6hJS7pTcc59Sni2oUhAY/zAq24M
4VnWLHSNu2dwZWKYjsJ17mbvSUS7JpeQBlcA7Babd2CUNqQXd+I46fPth2JqnVD0
1kO3VSLpw+ifnU5xnpzlzEHP4MsQIU+nfeT8ck9l7S8nX3TjfLDkgXKbQ+L+7Q7P
RuAJa6YlmB53VqIgC50HTQwGPI/iOHgkBCoZMDISvktBKCSRKlBKX0/9vz1gcmU0
67pnQOwBgJZQPNdBtx4ejaea5m26V6G133rLXZXzU4GffFVjoDnNyC+aKdFlJqjt
GCK6cGItBPq8gqcc3lj+GrPFgW79CoLdHfdgRritbX75ChYGC/m/S6gIdV/8dCRd
qyo7T5Jl4eLFUxZRmXXb
=lEXd
-----END PGP SIGNATURE-----

--Signature=_Sat__26_Jan_2013_10_46_34_+1100_oqjkoucQE=vUrPhq--
