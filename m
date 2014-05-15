Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaEOIOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:14:20 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40024 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbaEOIOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:14:17 -0400
Date: Thu, 15 May 2014 10:13:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515081357.GC11096@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9SzJfJEKNI6APITJ"
Content-Disposition: inline
In-Reply-To: <5373D0CA.2050204@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9SzJfJEKNI6APITJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> On 05/14/2014 03:03 PM, Michael Kerrisk (man-pages) wrote:
> >> However, unless I'm sorely mistaken, the larger problem is that glibc
> >> removed the futex() call entirely, so these man pages don't describe
> >=20
> > I don't think futex() ever was in glibc--that's by design, and
> > completely understandable: no user-space application would want to
> > directly use futex(). (BTW, I mispoke in my earlier mail when I said I
> > wanted documentation suitable for "writers of library functions" -- I
> > meant suitable for "writers of *C library*".)
>=20
> I fully agree with Michael here.
>=20
> The futex() syscall was never exposed to userspace specifically because
> it was an interface we did not want to support forever with a stable ABI.
> The futex() syscall is an implementation detail that is shared between
> the kernel and the writers of core runtimes for Linux.

That ship has sailed.. for one we must always support old glibc which
uses the futex() syscall, and secondly there are known other programs
that actually use the futex syscall.

So that's really a non-argument, we're hard tied to the ABI.

--9SzJfJEKNI6APITJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHdFAAoJEHZH4aRLwOS6FGIP/RnuUWGDKHSWd1/lb+o0HsfS
fBsoln90G+VX0A/JNwuIZm0b4g75djllUBPKqskws2h8xhOA1Tq4C8W/aPQGkV/o
+vRGFKUE0V/XYZ2eRvMq/TQBSWkVWzI7w+5rMwMYYEhzqux+KdEA5wqWf9APCbEW
xMpVV7wXT8H+XPCE9YzEKKtFGhUUSPKAW80aXvkDKNtIf1vwOxD2n3/mS/ijMAgc
/Djrh/KvIybyTX1JSankaQQwmOzEoXmwaD3afm9KhIMs+tITBYUfetpiamPMY+87
LV7vMQ5wFJaDI/5YDYpNabOiv7sSawb6kgt4iC6y0JgJdgyBoAYsXbozdUgdtDMs
AudO5enG+qbWoCwfTACIO99LagE6LsGum9OBCRcwS1qEABuRqYHrWJQW8cp/R8LU
0y9FdWtbI3nFbFb0mJsyyONi7RQ4euSQg45CP7it9HXMAXQPa1BgnCBWurJxqvDe
2ZJuPSmHvHP0FiUxCkmrDBQKifU02cJIaKOtPpPhOICFlIwNLHLyAP3tisWW3fIc
bAuyGbbuirnB+BrKU/8xEaOS3rJaCGZx5d1UuH08iwJI5zVmJt/o5cwppB+jmumB
yoTzPHIh1WPQIkewbbhGH+y9uWR+DBfIOmLDk2MS2S4UDTpdYyRxxkZaqefPtdfT
xdOIlGUdVMPbvmddOlQ9
=OLsD
-----END PGP SIGNATURE-----

--9SzJfJEKNI6APITJ--
