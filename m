Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbaFWNPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:15:44 -0400
Received: from ozlabs.org ([103.22.144.67]:44093 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752787AbaFWNPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:15:42 -0400
Date: Mon, 23 Jun 2014 23:15:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: linux-next: build failure after merge of the crypto tree
Message-ID: <20140623231531.26c67841@canb.auug.org.au>
In-Reply-To: <20140623122747.GA21213@gondor.apana.org.au>
References: <20140623114942.6a937466@canb.auug.org.au>
	<20140623122747.GA21213@gondor.apana.org.au>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/kIw4ZiB1vFNer6GCZoFjEbd"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kIw4ZiB1vFNer6GCZoFjEbd
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Herbert,

On Mon, 23 Jun 2014 20:27:47 +0800 Herbert Xu <herbert@gondor.apana.org.au>=
 wrote:
>
> That's weird as it built correctly here.  This looks like a
> make/gcc issue as the missing header file is meant to be found
> with an additional -I.
>=20
> Could you do a make V=3D1 for me and show me what the gcc command-line
> looks like?

Not until tomorrow.  In the mean time, could you try it with an
external object dir i.e. "make O=3D..."

If that breaks, I think you need to change CURDIR to srcdir or some
such ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/kIw4ZiB1vFNer6GCZoFjEbd
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTqCh6AAoJEMDTa8Ir7ZwVBSUP/Atj1EXxH7+hhr+GkialxE72
ZPbXFUcKINbyUURlxRZOhlFYrRy9/rGatt14p72nHOX0Z//G9kACO9WsJDZx8W34
py3Ln65cQ1brKAj4rxqcQuMB4iJDj6Bp0VU/ZMt5jcdnSZFzKaL2/SSgWOVMpoc3
ypXgU8tyhOqzvl7durPYWKOBNNLzUhHpqX+SzQHYsYa3rOqpaMADY+Ra45/fd9zz
LPRvoeBzhamKTYT+7qs/3baRo6ndFpZBHgYx4ouQ/BmHhcSzjnyLT4g4aSVRJex/
4pgJDUc4FJKMaZgO8agqqtt7uPXk7toJa2/VdwupAiJY6ZdHW8NL58D4soWogXaG
jrAAjFPxI/+vtKMBYvrZ5JBtkXctiEtSQ6owSxE15j5FyRiBPCvI5nWCZs4YhBKg
3RjtH5b6gTKJfKMAs9fMqclnjiTy7kBONjfu5rx+bWgwVyY2vTKdl+FFNGvjWKfr
qdHz1ElD9Cf94BtrGd2syguprY+TAUcDVQpOwc5yxK/dt9usenyiEpvZn95oHLf0
9m4tuVzr9GZ5g3q7o6cwOefWn+VpOcd9MMr6YzQHYma+69BCw+yyPP9hVQLZb63H
BFStxVrkva63g0Az+SZJMsw9z/+2SFBn2OwVe/HSv4LnLYVQIDFCM1SIXLNomIZb
jvVlB8nc+4u6e7OSxc2h
=ORUO
-----END PGP SIGNATURE-----

--Sig_/kIw4ZiB1vFNer6GCZoFjEbd--
