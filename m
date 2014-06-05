Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066AbaFENNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:13:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFENNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:13:19 -0400
Date: Thu, 5 Jun 2014 15:13:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605131313.GA3588@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
 <20140605125321.GG6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20140605125321.GG6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 02:53:21PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 01:11:10PM +0200, Ingo Molnar wrote:
> > Unfortunately even with the latest bits from you the breakage I=20
> > reported weeks ago is not resolved:
> >=20
> > In file included from include/linux/spinlock_types.h:15:0,
> >                  from kernel/bounds.c:14:
> > include/linux/spinlock_types_up.h:19:3: error: conflicting types for =
=E2=80=98arch_spinlock_t=E2=80=99
> > In file included from /home/mingo/linux/linux2/arch/x86/include/asm/par=
avirt_types.h:329:0,
> >                  from /home/mingo/linux/linux2/arch/x86/include/asm/ptr=
ace.h:64,
> >                  from /home/mingo/linux/linux2/arch/x86/include/asm/alt=
ernative.h:8,
> >                  from /home/mingo/linux/linux2/arch/x86/include/asm/bit=
ops.h:16,
> >                  from include/linux/bitops.h:33,
> >                  from include/linux/kernel.h:10,
> >                  from include/asm-generic/bug.h:13,
> >                  from /home/mingo/linux/linux2/arch/x86/include/asm/bug=
=2Eh:35,
> >                  from include/linux/bug.h:4,
> >                  from include/linux/page-flags.h:9,
> >                  from kernel/bounds.c:9:
>=20
> OK, That's UP + paravirt. The one I fixed a few weeks ago was SMP +
> paravirt.
>=20
> Lemme go kick some headers.

OK, I got {SMP,UP}x{PARAVIRT,!PARAVIRT} all building now, /me crosses
fingers. Hateful headers them.

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGzpAAoJEHZH4aRLwOS6x80P+gPALEZSLJAtBE8DyXXfL3eF
ZtN3fCeCjcqnhrp58Lna79SgRTTP4nCTnNDSI2Ei6b1kPCNxFKakUl3YW47/8F+Z
RgEXCyoK46Mq2j9LrfWcEqUTWCu6iRU41gGPzPStPt5zKb0u1VZAi2IL1jlze2hA
6a4nexvWAdMv1re1gpUmOJwW1ntjeI1Mtu833LKXh5llcloAr6rIY+JoVddd79kf
QwgKre9kBdWf7RPRG5Vn81A7yrLO6LlMDRQMPypnHRDS+XsEymTUY39c3ZiGQnhm
uxQfkr/mW+BATnRniZ9bLu1hyFsvWms9hPVxicMwuww60AHO3Emn23JZRrsM2P3g
2RR9qTWkqaI/nmf0YWPT/F9/6UWNzd3eNeXlKLZDhmYzHAQxm0B0Kj/xbQpVx0h+
LzCDXBPBDlXpkljwWyN6QgMY8aruyKBedFlFNjoqumJXIqVWog8K2zeYKTi3r4Nh
wfUzST4F+8mepLqLKgtESHr6oPZ+hz2JUGw4QVeZMJWQP4UqoVmkxe+Et2iR9tit
8CqaBHkoMIPNpiMCj9vi33qYXP9mtrFvfPvqtCUNGGHMxDizcwoXR7fJSNtTuTxY
DtlFOQAIKtsWpG+lWdvKT+NPGz6muPzuC8HFbm/3AcuV9k7f6Ab4ycbxpaeesbmz
yzYrybP0Zwp7cIE72mN8
=Ls5h
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
