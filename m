Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaFEMxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:53:25 -0400
Received: from casper.infradead.org ([85.118.1.10]:52061 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926AbaFEMxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:53:24 -0400
Date: Thu, 5 Jun 2014 14:53:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] locking tree changes for v3.16
Message-ID: <20140605125321.GG6758@twins.programming.kicks-ass.net>
References: <20140603114821.GA23711@gmail.com>
 <1401832251.8843.3.camel@buesod1.americas.hpqcorp.net>
 <20140604103003.GE11096@twins.programming.kicks-ass.net>
 <20140605081742.GC4926@gmail.com>
 <20140605111110.GA26771@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fCcDWlUEdh43YKr8"
Content-Disposition: inline
In-Reply-To: <20140605111110.GA26771@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fCcDWlUEdh43YKr8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 01:11:10PM +0200, Ingo Molnar wrote:
> Unfortunately even with the latest bits from you the breakage I=20
> reported weeks ago is not resolved:
>=20
> In file included from include/linux/spinlock_types.h:15:0,
>                  from kernel/bounds.c:14:
> include/linux/spinlock_types_up.h:19:3: error: conflicting types for =E2=
=80=98arch_spinlock_t=E2=80=99
> In file included from /home/mingo/linux/linux2/arch/x86/include/asm/parav=
irt_types.h:329:0,
>                  from /home/mingo/linux/linux2/arch/x86/include/asm/ptrac=
e.h:64,
>                  from /home/mingo/linux/linux2/arch/x86/include/asm/alter=
native.h:8,
>                  from /home/mingo/linux/linux2/arch/x86/include/asm/bitop=
s.h:16,
>                  from include/linux/bitops.h:33,
>                  from include/linux/kernel.h:10,
>                  from include/asm-generic/bug.h:13,
>                  from /home/mingo/linux/linux2/arch/x86/include/asm/bug.h=
:35,
>                  from include/linux/bug.h:4,
>                  from include/linux/page-flags.h:9,
>                  from kernel/bounds.c:9:

OK, That's UP + paravirt. The one I fixed a few weeks ago was SMP +
paravirt.

Lemme go kick some headers.

--fCcDWlUEdh43YKr8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGhAAAoJEHZH4aRLwOS6EnUP/1FcdPQib9m8jvdV6tCYaQ2e
vJftIhjAZ142uyyMQ0kwA6qZplfy+n4RpeVx29Px9aZpDr5OSmjk+XxoF3drz0KW
aCmMVAen6wVUstcrGZXh1sh4YrKyEgYHC8kDfaLFUjd9LlmV8Y7qiKmpQd0koDW9
yo/WodGAUkdxY1oLZ6F5JIKxNUcBXhvo4+bHH0v8XwS6t5KlZL0ETPZ5U00joBsR
eA0ZXnTHgCgBGMacGQKg5Bah+hdIi/Bx0Vu3D7SWszLc3AkjHNfOgmBiWz2qHR0M
cARuVuYCR2oWSOWw6nJL5YsC+sHvCB/Whx5SQbCuTDRUaUiGb1Fkv5UJOeEIHpe8
1sSP0/enZODoYFvm9RGUJ4BtSi6gT+gAmmM79/3NJnpLs/5Rst+5E8omb+/aAQvM
nEt3TG0zBv1p77Qj+TsKus5z01kspzWBE7J6H5bPHSg346eaSgBjmJ1lcfF+IINJ
M6Wb7dMDa2YcN3ITJR+HMGAkAH58is4TIB7a9Df2qRO+m/cp2EuMTvViGgvAtzWI
JmJZ8+k29tYjYcQz6NUrQs0pjUZAW5yipqrYG6/3lrCXE931cMyIVRHnLrLrtJgz
3tuDJt+gMQ9GJuyAUx8w7mC0J3Fa3ZFFUaRCn3f8KubDe0BdcNK/kNoEd5IHXDrF
ZBBJge3towPWZH7s5oVW
=CXnK
-----END PGP SIGNATURE-----

--fCcDWlUEdh43YKr8--
