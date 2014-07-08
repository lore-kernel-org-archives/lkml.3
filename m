Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475AbaGHHxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 03:53:50 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617AbaGHHxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 03:53:48 -0400
Date: Tue, 8 Jul 2014 09:53:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 1/4] documentation: Clarify
 wake-up/memory-barrier relationship
Message-ID: <20140708075325.GL19379@twins.programming.kicks-ass.net>
References: <20140707222345.GA6320@linux.vnet.ibm.com>
 <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i57Ucs80xkCVE1Ce"
Content-Disposition: inline
In-Reply-To: <1404771862-6904-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i57Ucs80xkCVE1Ce
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 03:24:19PM -0700, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>=20
> This commit adds an example demonstrating that if a wake_up() doesn't
> actually wake something up, no memory ordering is provided.
>=20
> Reported-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Thanks,

Acked-by: Peter Zijlstra <peterz@infradead.org>

--i57Ucs80xkCVE1Ce
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu6N1AAoJEHZH4aRLwOS6izAP+gO3PP7cTZBe85Kue4cdvTP8
+deOR8dY5CQUUwiDdHnrl/H02R5tzZjDoy8hLZx5XmAheA5irSJPz62EJuhWnm0a
pz92E1ozU8sKMwFX+2fyB1xEv2iL5zNTBU+VOJmOwz9u+WegWLTNxC5WCwjMxbaG
amzRWWceyjPArsseuQfpGi5efOrRPPW8m0IVu8exuwfbq2Iud2uhEabEffUnHAd5
LA26yx7l1fcuCZ3RqQ7CTLTfYUwG6Ci+xvHTgQ1OTf3rvsEEJXSzLm2tvISZeLRM
tj4e7j9U62v/wddDaUS0/hoIpLTXsB1JO8xx+jaXXNvqFBjy4RQMeVu6E0C/XNmL
zQRS4l2x2STznYsLLp5s9Axl59TDKeYK7+wmhx4ysKyhyWtBUr8jDix5ID/CZtbU
47/gQk5Y2CRallK1Z0BwpyB0Qd9JuEoTGpnSNE7+ff+DaouaT4UpGNdI9+OExFF+
RCquJJEww1F0nXMGsughEfbXdSfbwpznQISiYN0IBH3PaLP16p/Js7VHB/c+CpO+
rpGKuQBFnqnENonh9p2cwXr/hxeOMwtX65PDQh10/FD8KCReHodT9hWWgLMnrnCI
x1vgMS69eT5++Gm3gnTk+IvkFTHUXdYWgVuCU/pF64ypmThQmUocoB9LFleB6a7f
+sjudnJ8CFwxJBSGBx6l
=Exn7
-----END PGP SIGNATURE-----

--i57Ucs80xkCVE1Ce--
