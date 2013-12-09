Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932876Ab3LILlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:41:15 -0500
Received: from multi.imgtec.com ([194.200.65.239]:53773 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568Ab3LILlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:41:14 -0500
Message-ID: <52A5AC11.8050802@imgtec.com>
Date: Mon, 9 Dec 2013 11:40:01 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Chen Gang <gang.chen.5i5j@gmail.com>
CC: Seth Jennings <sjenning@linux.vnet.ibm.com>, <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/zswap.c: add BUG() for default case in zswap_writeback_entry()
References: <52A53024.9090701@gmail.com> <52A5935A.4040709@imgtec.com> <52A5973A.7020509@gmail.com> <52A5990E.2080808@imgtec.com> <52A5A7B5.2040904@gmail.com>
In-Reply-To: <52A5A7B5.2040904@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="fgxWaTIwlBRUUL7oxeBw70PfkIQJB051R"
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_12_09_11_41_13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--fgxWaTIwlBRUUL7oxeBw70PfkIQJB051R
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 09/12/13 11:21, Chen Gang wrote:
> Oh, I tried gcc 4.6.3-2 rhel version, get the same result as yours (do
> not report warning), but for me, it is still a compiler's bug, it
> *should* report a warning for it, we can try below:

Not necessarily. You can't expect the compiler to detect and warn about
more complex bugs the programmer writes, so you have to draw the line
somewhere.

IMO missing some potential bugs is better than warning about code that
isn't buggy since that just makes people ignore the warnings or
carelessly try to silence them.

Cheers
James


--fgxWaTIwlBRUUL7oxeBw70PfkIQJB051R
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAEBAgAGBQJSpawYAAoJEKHZs+irPybfPOYP/jZo6ZOVy7+HFL0VH322lUmE
oTGu4uTF74wrxPgUFcjErgenr72+vQtJyoXGvPvEj/YihisJfJlGS5uC4yKEoDBp
N6f5hFqVjkUjb5wGavtAoetnItvJMDmR8SU9gQr7xNSH6e22k8BCfxlKg0B8ckjD
/DvjEVy14h3MWwR9GJrxIHgjJONc6VPHrm5F1l24ucCnPHEmiExJYYfsZP1fmJ4f
fQymG/ImLs0/tG6igcYOoDmNkqpAgikASzZfAkKoW4LDwAUSrvZoyTi1TJzAgRBv
ApT6fjLVooLXPh8u0r5+kXMyRKzRAQwwqCH/z/kUCNdESgB1Hh84RVgdqKYmk3zO
hKZtW8aedZxC3L5UXTKh4kvyW5kLeaF6REeYN01/gp5jh2fC5rGKq0eUGl2P6rib
IfrWnPM6QSz0yCTxL8yeoY6VO0UZP1t0chbG8tnCFSEjOE8qqIFLIlWIWA72TXO5
EUmMX0CYn5LMB1LlbPWCiFYap8Vo3q1x623z+ouQyiOcZ4IwvFpfBPgo0OD+icLP
Y0HTXzkwyUCFu6qQfjy2Q5esTJPqJzTMbkPu5uYBURBe60mKzWnjkNSUDrMkKEXc
klI6oArj4J0L1CG0hDE39+OVtuMcOwDLYlfZly4EiFWvHCAobh0zjNLl9uLIbn1O
dZKerMGqJPqco9m0fJTD
=Ub0h
-----END PGP SIGNATURE-----

--fgxWaTIwlBRUUL7oxeBw70PfkIQJB051R--

