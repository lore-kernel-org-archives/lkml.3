Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841AbaASAxI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 19:53:08 -0500
Received: from ozlabs.org ([203.10.76.45]:33657 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbaASAxC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 19:53:02 -0500
Date: Sun, 19 Jan 2014 11:52:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>
Subject: Re: [RFC][PATCH] preempt: Debug for possible missed preemption
 checks
Message-Id: <20140119115253.d6974d9c188c6d9e88d04b80@canb.auug.org.au>
In-Reply-To: <20140118184401.48b32cb3@gandalf.local.home>
References: <20140116235751.084728c8@gandalf.local.home>
	<20140116211214.581197e5.akpm@linux-foundation.org>
	<20140118184401.48b32cb3@gandalf.local.home>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sun__19_Jan_2014_11_52_53_+1100_ymgX1Og70mCkidpM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__19_Jan_2014_11_52_53_+1100_ymgX1Og70mCkidpM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Sat, 18 Jan 2014 18:44:01 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Thu, 16 Jan 2014 21:12:14 -0800
> Andrew Morton <akpm@linux-foundation.org> wrote:
>=20
> > On Thu, 16 Jan 2014 23:57:51 -0500 Steven Rostedt <rostedt@goodmis.org>=
 wrote:
> >=20
> > > When PROVE_LOCKING and PREEMPT is configured, the preempt state
> > > tracking is active. Testing this out, I added a module that did the
> > > following:
> >=20
> > So I assume your kernel at least has no instances of this bug, so we
> > don't need the patch ;) It *is* a fairly daft thing to do.
> >=20
> > Maybe stick it in -next for a few months, see if anyone hits it?
>=20
> Do you have any objections if I add this change to my for-next branch?
> I'll do it as a merge as I do not plan on having it go into the next
> release. But this is an extension to lockdep that when both
> PROVE_LOCKING and PREEMPT are enabled, it can catch a certain bug. But
> as Andrew has stated, it did not find any in the kernel that I'm
> running.
>=20
> What I propose is to have this go into linux-next, as I assume that
> people test it with PROVE_LOCKING and PREEMPT enabled, and if someone
> adds this bug this patch will catch it (if the bug path is taken).
> Hopefully it would be reported and we know two things. One, someone
> added a bug, and two, this patch is useful to add to mainline.
>=20
> Here's the catch 22, it may not be worth adding to mainline if it never
> catches any bugs. But we wont know that unless we add it to mainline.
> Maybe adding it to linux-next might be good enough for now.

Given that the merge window will probably open today or tomorrow, I would
prefer any new code not intended for 3.14 not be added to linux-next
until after v3.14-rc1 to avoid unneeded conflicts.  If, however, Andrew
thinks it is still worth the (maybe minimal) pain, then fine.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sun__19_Jan_2014_11_52_53_+1100_ymgX1Og70mCkidpM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJS2yHqAAoJEMDTa8Ir7ZwVVqYP/ivnr1Hn39XD8IOhIT2BY9iO
Oplqg3lYCH/jdQgsMzQ3mgFEH6GzJWY3T5xI2Heibxl76vrbR9eAhyrGoXUt2NeU
jP81JdLcptIyBYig3bVNF5vV2xLmDOOIu5NpIlINtMK7r5FQxi0OPijoKBRiTWOu
ltfFlsg33ci+tCAfxq3nrkVXkUuC6NVe22HV7ywnVDlcLjdms219LGc5X3YFimh8
uJLRFhUswguztqAXvTdofTSI1ug9T/j/Zeg0CBBPYjuiORbA6vyuIdnVG6jDVuRS
NjbASZGFM/L978BUBHs6C0yuEhLoT0FFBsUB2yBx3QVBAFyVceD3SGBdiAhOQun4
ne9iJyBlBc7Hy3Z2Kl6AjRUiILWTAIde7bltG9NIsEyu4eq5wCQ4lAwyFtAy1stx
qfjHMDkXCiyFrhqwvfKzNFjTHjT2u8ya6vUMFZdRpQvuxmYCsS85Ko8dpKuOp58l
ZYZcyJiTX3puSLVZi8ieXOdwk9oK7Ssf8TOKqoK469rO8RYq7n5YNWplKOM9eqdv
4iNNp3pewyiePc39df03YE6dq3o/N2tBfRfXYFJPgjTZ+b7Hp6kYXbjOHWuCo39I
LrIb5VE39ndNMHeBiNeWHLeRzRfzS5Okm0TPE6EQDTa3W177xbCt0rCgAxUjSIWN
rZycRFGvztGrENE0U63w
=hMyf
-----END PGP SIGNATURE-----

--Signature=_Sun__19_Jan_2014_11_52_53_+1100_ymgX1Og70mCkidpM--
