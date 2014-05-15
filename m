Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166AbaEOHhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:37:46 -0400
Received: from casper.infradead.org ([85.118.1.10]:56285 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724AbaEOHhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:37:45 -0400
Date: Thu, 15 May 2014 09:37:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Darren Hart <dvhart@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Darren Hart <darren@dvhart.com>, Davidlohr Bueso <davidlohr@hp.com>,
        Ingo Molnar <mingo@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Clark Williams <williams@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Roland McGrath <roland@hack.frob.com>,
        Jakub Jelinek <jakub@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [patch 0/3] futex/rtmutex: Fix issues exposed by trinity
Message-ID: <20140515073734.GA30445@twins.programming.kicks-ass.net>
References: <20140512190438.314125476@linutronix.de>
 <20140513035404.GA68181@dvhart-mac01.local>
 <alpine.DEB.2.02.1405131100510.6261@ionos.tec.linutronix.de>
 <53731608.3010803@redhat.com>
 <alpine.DEB.2.02.1405141155260.6261@ionos.tec.linutronix.de>
 <5373D94E.5030800@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="awGZH0NYyyipry6r"
Content-Disposition: inline
In-Reply-To: <5373D94E.5030800@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--awGZH0NYyyipry6r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 04:59:58PM -0400, Carlos O'Donell wrote:
> Nobody has looked at this code in years, likely because all parties
> thought they were done, but had in fact agreed to distinct expectations
> and assumptions about the implementation.

That's just not true, we've been >< close to hijacking all the
libpthread functionality from glibc through a kernel DSO in order to get
some movement.

Glibc has been known broken and unwilling to change for years and its
lead to immense frustration with people.

> I want it fix, and I'm in a position to move resources to fix it.

That's great news, and about bloody time too :-)

--awGZH0NYyyipry6r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdG6+AAoJEHZH4aRLwOS6QP0P/1Sk1WRBUzoYXqDg+3/jRQ3H
V/EE7AMTUJv56x3Swm9Nw7WOrMc74y755ew0m75W9N6uwIPLM2IRwi3EHTR13Yne
5FbKxDcvwxmK3bi1Tyz3BrQFw0bp1IojGN0K3TKIO8Lop/nJ/RkU2ApTfDBFOSFe
aX6u1g97AL4Y6HUpxNMWY5tZbo1RnImZqmrffQvOjagbTweR2n4EMNDLm/d5XEBd
rAzR8B4sJRI8LdzAncj/H1XMtdssRNwYX9cKKqGmvp1M/UsghT6QrJMdpikzLUIf
/+I1x3FBx7lRLQM/LGpfCU2sMzeF61BJXoYkS2+hayH11EntDpLpt3sMxIna99He
FR8Vg8pvKv051k8uAxUmk2hkzLkvHzW/Fr7Xr48RDcS2Ggz1l3nxfs7U61kqAgUW
P+OznDKXj+LOhL6kk+cxyTZBNw1Sd5Rc7G8cH8dwLhE+L8Rqzh9TteT3DBqzTUsw
mG0LQxOOfUliAoA5f5ls/9bNXpe0BV1oxWSrD3JFeyRleidF2sTryudO+c6BB9ap
GNWhLKRq4M+5wNwwngY9nxAUTWL9tVaHprctL1dFIfvbz5N+O+0rAyDefZGBRbHI
OPonYQ/HALXcYA37G2TEv0QMkQ0cOE9w9rwEzqGfhSpK2iMCwztTMPUVLgxctrwe
J2iWC4Te6Pu9grmefqyI
=jcw2
-----END PGP SIGNATURE-----

--awGZH0NYyyipry6r--
