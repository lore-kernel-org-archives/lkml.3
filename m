Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118AbaHKL6D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:58:03 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:45635 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbaHKL6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:58:00 -0400
Date: Mon, 11 Aug 2014 13:57:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140811115706.GX9918@twins.programming.kicks-ass.net>
References: <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140809182400.GJ3588@twins.programming.kicks-ass.net>
 <20140810012924.GO5821@linux.vnet.ibm.com>
 <20140810081425.GT9918@twins.programming.kicks-ass.net>
 <20140811033048.GT5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="iZdB8qX0qQjXwPd1"
Content-Disposition: inline
In-Reply-To: <20140811033048.GT5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--iZdB8qX0qQjXwPd1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2014 at 08:30:48PM -0700, Paul E. McKenney wrote:
> On Sun, Aug 10, 2014 at 10:14:25AM +0200, Peter Zijlstra wrote:

> > want want want, I want a damn pony but somehow I'm not getting one. Why
> > are they getting this?
>=20
> We can only be glad that my daughters' old My Little Pony toys are
> long gone (http://en.wikipedia.org/wiki/My_Little_Pony).  Not sure I
> would have been able to resist sending one along.  ;-)

LOL, I _knew_ someone was going to propose doing that ;-)

--iZdB8qX0qQjXwPd1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6K+SAAoJEHZH4aRLwOS6P8EQAJ6saqlPE6znOgHsk0EC/APS
7trhIafkZmP9a6noOgwENMhsBXOUsmkrVv9+s4J2m09qj2I8zLYNuknGHpfAgQLa
Thu8+N0pGNd2dvbBBD6YLAH1duo52Bl6Mu6qRVGPuabzq4++zbaBu2ceDn6CURsy
xh2tu3hKTx3dUZbaA+zlsPsMe9o2Rs3Vp2zYQ7UkxsT1re8/BNxJ7LoAXlQDPZJv
XHAcU2p0pM3Kj4S8zXwt2gWtwjGWrAQ84fg6iIe5bYQv5hvJNWivhrE7e3VkX7xo
RfLSNGaI+X+KxgFoD76VgTCrvY2zpsR6Vdw7nwFWV1JqyP+DgQvP0Y0JQNji1W9q
cJQPI3XTn5hm/KeOtCowrXD8OgxEaz/k2Fu+7Ay1K83mPCM9j0hOfn0m5P3Byq7P
UdOfC7nck7/aV+nidPPbEOkVeUmrZ0EXlNKx9oWuBhZTVq8NAi+UdvmO6O8V/6Vu
NHbNQtwpzLoCbIP9x5d49TJSMhvifJoeMEKilyX/oBi9mi1mu+zCVcf7IcL2HmM/
aL30vguq+fCqJ2G6MnRR9uDyP0Kqgd1TxpF4LTtoiYB4ilpRG+O2OnlDrcpmU/Al
zshhCXYKc5gdLeJtyVH3CAeDUGt0Laot94CCyAij4A9y8mEvrbmy5xQyyhciTIL7
fbvedWMDdkOOMnPMcuLG
=w+i9
-----END PGP SIGNATURE-----

--iZdB8qX0qQjXwPd1--
