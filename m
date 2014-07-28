Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaG1Qyj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:54:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60726 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaG1Qyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:54:38 -0400
Date: Mon, 28 Jul 2014 18:54:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jason Low <jason.low2@hp.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
Message-ID: <20140728165426.GT19379@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
 <1406566175.2411.13.camel@j-VirtualBox>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mz8526KdLG8dDlKA"
Content-Disposition: inline
In-Reply-To: <1406566175.2411.13.camel@j-VirtualBox>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mz8526KdLG8dDlKA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 09:49:35AM -0700, Jason Low wrote:
> On Sun, 2014-07-27 at 22:18 -0700, Davidlohr Bueso wrote:
> > ... as we clearly inline mcs_spin_lock() now.
> >=20
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> > ---
> >  kernel/locking/mcs_spinlock.h | 3 ---
> >  1 file changed, 3 deletions(-)
> >=20
> > diff --git a/kernel/locking/mcs_spinlock.h b/kernel/locking/mcs_spinloc=
k.h
> > index 23e89c5..4d60986 100644
> > --- a/kernel/locking/mcs_spinlock.h
> > +++ b/kernel/locking/mcs_spinlock.h
> > @@ -56,9 +56,6 @@ do {									\
> >   * If the lock has already been acquired, then this will proceed to sp=
in
> >   * on this node->locked until the previous lock holder sets the node->=
locked
> >   * in mcs_spin_unlock().
> > - *
> > - * We don't inline mcs_spin_lock() so that perf can correctly account =
for the
> > - * time spent in this lock function.
> >   */
> >  static inline
> >  void mcs_spin_lock(struct mcs_spinlock **lock, struct mcs_spinlock *no=
de)
>=20
> Likewise, I'm wondering if we should make this function noinline so that
> "perf can correctly account for the time spent in this lock function".

What's that about anyhow? Surely perf can see where IPs come from? DWARF
has inline support after all.

--mz8526KdLG8dDlKA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1oBCAAoJEHZH4aRLwOS6f1MQAIIro4EsfK0g8xSxO2V7w+nN
qYGr9JgRtTbAZSjJCZydS9t00gxB9GOcawS14RDkNYe5R9VLOzYm7mCyfwXAbRhL
mDCNeqVQmRMNFG5F8XRdt26ZPgRPS1XTkG7tWdI2gPjxU1WtMF4TV6TePiq4JxLA
CkWtrWnQeFlJ5qki0f8Ry9iswX82wSh2c6YttMTn8lG+RvqpmSbXjiLjQ2z36qM6
iAARD0mhPWIOEWs3fL/4ZSHCtSPl40GmfG3IppKY23qff7Xo6MMYfy11Ij5fHNnb
5fgRqpqdR7PsfX3CO9ZmiJMrUMxa7MtK70lerNWJAp+RI8jUdtalR62gs/DTLa8H
f9HHW8HQKv3t8fj9gK7yCOCe//geYntGlSj9BJjralrSU7xOwwqRkb10chkRNwzQ
M29KWKGFOfQATsZ6ve0Pn4ItCT+s1JzeR5RXCk/76PK7Lrvbjy+9aIbAj2YkmOtq
zIgTy8jZvXnqTOMR7+157w07BBSN3+sCbO7WEngdxoQQPb2/xM0yA7McDgzsfnWg
Dp/Z8zoX+7BLVMFH+GvDnS8jSPCXIBi36bJRki5u+wvxl6uDKbq1Xm6geJ5cSIeU
ANjStYFcdfjO1cSUdPWVNtLZE14EgBmouVLFPmQFY7qWaRUSV9AxVlG/HEABYwYp
QrJZ6S6r7Z9IzbMyPAE+
=hGes
-----END PGP SIGNATURE-----

--mz8526KdLG8dDlKA--
