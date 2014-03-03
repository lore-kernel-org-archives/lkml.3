Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444AbaCCFSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 00:18:12 -0500
Received: from ozlabs.org ([203.10.76.45]:59107 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaCCFSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 00:18:11 -0500
Date: Mon, 3 Mar 2014 16:18:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140303161803.ecbd9b124b5f2cdf79b8cf51@canb.auug.org.au>
In-Reply-To: <20140225143246.914c9732966764234bc51de2@canb.auug.org.au>
References: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
	<20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
	<20140220150508.79bfff95fb5d93c651801ffd@canb.auug.org.au>
	<20140225143246.914c9732966764234bc51de2@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__3_Mar_2014_16_18_03_+1100_GdqpDeYVT4xhCHqg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Mar_2014_16_18_03_+1100_GdqpDeYVT4xhCHqg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Tue, 25 Feb 2014 14:32:46 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Thu, 20 Feb 2014 15:05:08 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > On Mon, 17 Feb 2014 14:14:46 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > On Fri, 14 Feb 2014 13:42:17 +1100 Stephen Rothwell <sfr@canb.auug.or=
g.au> wrote:
> > > >
> > > > After merging the mfd-lj tree, today's linux-next build (x86_64
> > > > allmodconfig) failed like this:
> > > >=20
> > > > In file included from drivers/mfd/max665x.c:19:0:
> > > > include/linux/mfd/max665x-private.h:31:1: error: expected ';', iden=
tifier or '(' before 'struct'
> > > >  struct max665x_dev {
> > > >  ^
> > > >=20
> > > > Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
> > > > MAX665X devices").  Clearly never built by anyone :-(
> > > >=20
> > > > I have used the mfd-lj tree from next-20140210 again for today (sin=
ce the
> > > > other version had other problems).
> > >=20
> > > Still seeing this error.
> >=20
> > Still ...
>=20
> Ping ...

I am still seeing this error which means that I am still using the
version of your tree from next-20140210 i.e. Feb 10.  It is a bit
disappointing that his has not been fixed in such a long time even though
there have been other updates to your tree which means that those other
changes have received no exposure in linux-next.  It is a trivial error,
but it does indicate that noone ever build tested that particular commit.

(this is now commit 2fc7e7d25bee in your tree since it was rewritten but
not fixed on Feb 14.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__3_Mar_2014_16_18_03_+1100_GdqpDeYVT4xhCHqg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTFBCPAAoJEMDTa8Ir7ZwVj6IP/iq1rx6Cs4vVI5ZJHiU5TgZ2
lENe5DoA684Wwhx2UzxdgL4Y0QCuXBePG7jIk1X3urN3p0rago5SZQT5m41FKZ4y
i/XSQxVpaNgbei6b4fdscbVTDt47s57/k8IiGc/bGHKsQGCr/6z/JG8Qp1nBRta3
PzOuPlWxH7t1qkSgZqRnm9n90sPqCcdhEVhWo1O32ptj59EL4OF9941zyd+ZxwLQ
NH+OJBDYJ8nULE0sR9gKMCxLYvjjMqQ2rU4dZTiL5NeOWE9Twu0uVTcRqbyigNDs
t06YB/79OR4DZAau+EXkoyPHC/gJDYfgC3nXdfgT3ArLcYKYNztqec+6ol9yvznP
24Ac6blC30DlrT++WRE+ct8ePVB7K5lWnXQLe0wpC9E0A+3UwkfYJINxmsX7DsMJ
mGxuXva3aABUvH6L7BSa2UydZiqC+nvjnUhUdBm42hY7OspfnKyvX3aSvOWhcbrR
kjqkzVxz8HHtEC0uYQyqxJLhsvGrFePp1DQ4T3bpRndBzQvCrGkKuEh0UTHATp4p
UHEoeF7UybhMfOmmZFRitMwIRNchO7ol8IMCNmFfDukYPPPtmnatihs+2RBtQxoF
1dLW18jbXRURN30E69Zl+XjOXRUW8pOPCRjYKTvtlRXX2vngPwRtTFm+JmW7OM3H
64wLCi9mnnD6G4nR1qPW
=YcD1
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Mar_2014_16_18_03_+1100_GdqpDeYVT4xhCHqg--
