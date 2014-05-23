Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbaEWKrS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 06:47:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43744 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753752AbaEWKq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 06:46:58 -0400
Date: Fri, 23 May 2014 12:46:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] sched: signedness bug in yield_to()
Message-ID: <20140523104648.GC30445@twins.programming.kicks-ass.net>
References: <20140523102042.GA7267@mwanda>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3tBQ62Qve5jUyRDo"
Content-Disposition: inline
In-Reply-To: <20140523102042.GA7267@mwanda>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3tBQ62Qve5jUyRDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 01:20:42PM +0300, Dan Carpenter wrote:
> yield_to() is supposed to return -ESRCH if there is no task to
> yield to, but because the type is bool that is the same as returning
> true.
>=20
> The only place I see which cares is kvm_vcpu_on_spin().
>=20
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan!

--3tBQ62Qve5jUyRDo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfycYAAoJEHZH4aRLwOS6zRoP/3qj10vYVhd6BCBcxmxgG60z
ILeADetiXfLbT+EjTEk+2wDw51tE8e48rJJaWI57XRDcQpG+L1UDuIKr/6pskGOx
XYM4ioDtYa2RNve2fdFvawekzg69kxrhX9jboCwF8cUARPcltcQFhTqzCuCjlKvS
2UlU1IWSf+l3bDDseUBUCYkqkxxUVk0fv4QoQyPiTOoZFCTkuEgp1B1rFwlONb3O
zMBGkoIt+wN9UmiE15fq3/OEWQFkaLYmaQKcSObSBSTSsTXH+1l1AuKy5QIKV3gr
0NGzw/quJB/PUb2v3QmE2+unZPvD+u1fx/rjcRvmVV9rc+o86fUrn6zeT924HFUY
4y9ep1VcQsR75WQcVABOaUhx/T1/yOCwVRnh5h/lUjkkSvV06mA6ujA02c+06cbG
yAnc00pUo8P3newSm+yo6kKIAkBrzKT6uPAc1nHes8OeccJUShQUkj9RszmwX5s+
0S3PHVQo9DDNEmiUhrz2XTY8Nf+eEHf/5FB5htBUlxC2w6WvEI2lMyxnq4Tm3vO9
LD3Uhn4A/0NprLAp89DDqwe+s6+qp8EThCN7lUtvzMEGDyIIjGsGXucg/9M2+tR7
iD55umd19usfUryAGlVVMmuPzLH9RU5fK+1KU4oKOhmTFKn1WuK9WqJD/bVr8Es+
SQz8aMx6O4Y2arQy49a9
=dxlD
-----END PGP SIGNATURE-----

--3tBQ62Qve5jUyRDo--
