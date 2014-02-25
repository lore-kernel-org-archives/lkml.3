Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBYDcy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 22:32:54 -0500
Received: from ozlabs.org ([203.10.76.45]:37848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaBYDcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 22:32:53 -0500
Date: Tue, 25 Feb 2014 14:32:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the mfd-lj tree
Message-Id: <20140225143246.914c9732966764234bc51de2@canb.auug.org.au>
In-Reply-To: <20140220150508.79bfff95fb5d93c651801ffd@canb.auug.org.au>
References: <20140214134217.aa7e1994b4cab7ee563c8307@canb.auug.org.au>
	<20140217141446.454ab86eb19621fd397be6ed@canb.auug.org.au>
	<20140220150508.79bfff95fb5d93c651801ffd@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Feb_2014_14_32_46_+1100_FyNMutQDxv8dKUFb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Feb_2014_14_32_46_+1100_FyNMutQDxv8dKUFb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lee,

On Thu, 20 Feb 2014 15:05:08 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Mon, 17 Feb 2014 14:14:46 +1100 Stephen Rothwell <sfr@canb.auug.org.au=
> wrote:
> >
> > On Fri, 14 Feb 2014 13:42:17 +1100 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > After merging the mfd-lj tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > In file included from drivers/mfd/max665x.c:19:0:
> > > include/linux/mfd/max665x-private.h:31:1: error: expected ';', identi=
fier or '(' before 'struct'
> > >  struct max665x_dev {
> > >  ^
> > >=20
> > > Caused by commit e77bb5297293 ("mfd: max665x: Differentiate between
> > > MAX665X devices").  Clearly never built by anyone :-(
> > >=20
> > > I have used the mfd-lj tree from next-20140210 again for today (since=
 the
> > > other version had other problems).
> >=20
> > Still seeing this error.
>=20
> Still ...

Ping ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Feb_2014_14_32_46_+1100_FyNMutQDxv8dKUFb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTDA7iAAoJEMDTa8Ir7ZwV5MMP/0M7mq3uYEsLlxYI3AZ6ZcRd
3z8WyE6bAjH9sqElR2EXuheG47H0IxBEvcqVYEeSVaw6NNGIvVbLnCtYsmDSaVf4
yaPsrMqe3+FWkeW992B7tZ6aE1fkVHJktPoWAuqsagsEwQ3CP6GMkRFRsR8Tyvf+
W8OL6W83ZOtQWsD6DeCR2de/HNl+Aebc7JxYPhLAwenExUAFrbTJFYSj/11yizcF
Cp8qgGEkVNqRY4zwKzwKayRJTnfVswrw4zr/EyUxQxirT2rpyCKQmHOQZJOpVOkM
2zYZJfNzR6zZtZzoQeS/Aq8maNRa87F8QPSI1tsp6EYghWG6QskzCZQNVM5le+50
WTtiQ6bfR6XsaU7cpGuGVF5of3aqgB2JHszVA08NzPNPBTvHNgOUTbhf/M5IFyI8
yH0IEL6sgHVQBCArg6LbAYzzUrHn01v8nxz0mWyyia9tB71GvugStG2i0qrtwPzI
h2F8v2bAt/BA2FLQAyh+SSoX7A1+9wg8EOK+hy6YEcgf8++hYHUjf3EW7dAOklHL
/n1GcyoWiu3f71IDkH8WgEKSbi9thKZ+V0yCQ0PJX6/S+zGhRgI2PMQFid64Mlgo
TS1cIKxaSFy7MX9nJk9U1Q1Qhc9IK8V/yG9d3WvUNQ5GLo/Xod4f0urAhPZDRB92
d8T7JzWv36c2ppJ7bthG
=oZ/M
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Feb_2014_14_32_46_+1100_FyNMutQDxv8dKUFb--
