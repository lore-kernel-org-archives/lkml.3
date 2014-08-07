Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbaHGNEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:04:06 -0400
Received: from ozlabs.org ([103.22.144.67]:59628 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754413AbaHGNEE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:04:04 -0400
Date: Thu, 7 Aug 2014 23:03:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stewart Smith <stewart@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the modules tree
Message-ID: <20140807230342.52e3a52c@canb.auug.org.au>
In-Reply-To: <87tx5ocyz3.fsf@rustcorp.com.au>
References: <20140807132017.2ec9e2ad@canb.auug.org.au>
	<87tx5ocyz3.fsf@rustcorp.com.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/bRDHPQnNVMcYpHa06iQ.CaC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/bRDHPQnNVMcYpHa06iQ.CaC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Thu, 07 Aug 2014 21:07:20 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Ah, crap.  I really hate that macro magic :(
>=20
> I amended to the minimal fix, so we can pretend that never happened.

How about arch/powerpc/platforms/powernv/opal-dump.c as well?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/bRDHPQnNVMcYpHa06iQ.CaC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT43lBAAoJEMDTa8Ir7ZwVLM8QAIFkK9bA6NGZHdKtyE7WV32T
s9uJ9MiZJ+/NSdKzaZnGdzN5b1bLZjYbergn1Gy7KG/HNqkzHKeXzDMVryQi9GDL
zIKuBcXrB3Xb9B/rDTtUCxYbH/9X7DcpS4uEeb7qf5JqLxrichWj2qLlZpCa69oW
mv5dBW3CB0Sh+RfWqDgbzpA4IcuWRXTCjNhNqs6LfhPIpAAKAhuXinzzN6sxvvd1
ErwBJ9Co3faPmuOgOp/PNHyesEUj9RqoPMAQBQx5uU3Ipx/v9Dusuk7WbWwM6o2H
e1L9c+CaSUH7V8WjaSp0iKoNiQIv/PIUrsOSqk9j5gWuj2/HZksIpWANOhtUA5+r
4wxzUsSsTD1+ERPg8IKjYEFTWqEPbNrhrQBOhQ0BsI5WwStGZPmbOIuWXMBda5yz
0thfpFXaWYnhi5txdpXv1U6iw+gQKjDayly8t1QA7t0ZsbCPHN65EFGG+0eUyiNw
hX4/9oyb1MSNBIXSjotFaCMExSMdOG3WJPZ++O/wLz2KoTRHUFHJGWX35ZEGO3d3
JI/d5oZM0Rhp98hs6BrLJa0hnMZU7f90XnhY57WNexsPJZ9o2TqlKRmWXbkK7yoc
2q1iLcRr+f9MkX43lAkx+HM79DLTzwlpoenwCkO25iT06PGmnhZ3pWgKtR7o4yM7
2r4skL887CgGHRCaXtd3
=swws
-----END PGP SIGNATURE-----

--Sig_/bRDHPQnNVMcYpHa06iQ.CaC--
