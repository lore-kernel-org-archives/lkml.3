Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990AbaEPHsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 03:48:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:36966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbaEPHsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 03:48:14 -0400
Date: Fri, 16 May 2014 09:48:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Michael wang <wangyun@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@linaro.org>, Paul Turner <pjt@google.com>,
        Mel Gorman <mgorman@suse.de>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [ISSUE] sched/cgroup: Does cpu-cgroup still works fine nowadays?
Message-ID: <20140516074804.GK11096@twins.programming.kicks-ass.net>
References: <20140513142328.GE2485@laptop.programming.kicks-ass.net>
 <53731D12.7040804@linux.vnet.ibm.com>
 <20140514094426.GF30445@twins.programming.kicks-ass.net>
 <5374387E.4080802@linux.vnet.ibm.com>
 <20140515083531.GE30445@twins.programming.kicks-ass.net>
 <53747EE4.3020605@linux.vnet.ibm.com>
 <20140515090638.GI30445@twins.programming.kicks-ass.net>
 <53748A5D.6070605@linux.vnet.ibm.com>
 <20140515115751.GK30445@twins.programming.kicks-ass.net>
 <5375768F.1010000@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doRsZBpDQ+I4/+/t"
Content-Disposition: inline
In-Reply-To: <5375768F.1010000@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--doRsZBpDQ+I4/+/t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 10:23:11AM +0800, Michael wang wrote:
> On 05/15/2014 07:57 PM, Peter Zijlstra wrote:
> [snip]
> >>
> >> It's like:
> >>
> >> 	/cgroup/cpu/l1/l2/l3/l4/l5/l6/A
> >>
> >> about level 7, the issue can not be solved any more.
> >=20
> > That's pretty retarded and yeah, that's way past the point where things
> > make sense. You might be lucky and have l1-5 as empty/pointless
> > hierarchy so the effective depth is less and then things will work, but
> > *shees*..
>=20
> Exactly, that's the simulation of cgroup topology setup by libvirt,
> really doesn't make sense... rather torture than deployment, but they do
> make things like that...

I'm calling it broken and unfit for purpose if it does crazy shit like
that.

There's really not much we can do to fix it either, barring softfloat in
the load-balancer and I'm sure everybody but virt wankers will complain
about _that_.

--doRsZBpDQ+I4/+/t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdcK0AAoJEHZH4aRLwOS6LMsP/jJBZTfPRr4NUEXCks0aemCU
dtqK+n6hGy02clUPIL0peE2/ptIZvHJizg9B21aTKJKOBna8q9FxbkUTW177HLdt
zUNCvjBw/VopPacBOpWNuhowP48AlTzx/ftKIE7tiGyIdJt+c8acHDQRKUV491WP
fQfFS3Ge59Oc2XuT023+rNPJ9MgnKOG3OUPip2eLPbztEJVXpBVKX/NXg+97vTRG
vuRG+nV1Gh7t5Sz64jrCCLcAUQvJnT5QoFnpPt7iGRlJ2ybOcls5TTVtTY7WV4fs
3EDpWPK6FJDny3JgH6DLaqos4R2tUd8hWW/BJKtBOYsfYfXgqJPq7B/8RRkq7lsn
iPPTZTh/au4YU8xN6sDK4Hga9YHZDxLi0Y38UNZ3YZRy8OewIK8Gs40OKvkxQ004
OlX6kwCy7koLF+w2d8dQpC8z8EnxutBCXVNa4jnxOGRK9kI5Dg85CEvadawKvCfS
GCMtPDJ3kgNJNFp3HnnOP/Ou3katSI5qvObYTSHZs1JtB4cBOcFKC5gSPv4u4Dxg
8InsUDsAz9TbjjF9aLgzQlg7aUgCNP1PbkCrU1VmART7D9McF0dN+vy51wz6Z0tP
mSe7OMA/shNAC0eq5tD0863iUF6eB58pAFeFI7TUpZmkw4UbIJsG0G1HPTBDWNyz
qCXJUaWPxC8lBKuS7HzD
=W2Af
-----END PGP SIGNATURE-----

--doRsZBpDQ+I4/+/t--
