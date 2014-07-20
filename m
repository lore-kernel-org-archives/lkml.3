Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaGTUe5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 16:34:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59279 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348AbaGTUe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 16:34:56 -0400
Date: Sun, 20 Jul 2014 22:34:17 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH tip/core/rcu] Do not keep timekeeping CPU tick running
 for non-nohz_full= CPUs
Message-ID: <20140720203417.GV9918@twins.programming.kicks-ass.net>
References: <20140719165350.GA18411@linux.vnet.ibm.com>
 <20140719180120.GA20887@localhost.localdomain>
 <20140720114759.GO8690@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="owRCMvbHJBIqpgHE"
Content-Disposition: inline
In-Reply-To: <20140720114759.GO8690@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--owRCMvbHJBIqpgHE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 20, 2014 at 04:47:59AM -0700, Paul E. McKenney wrote:
> So we really have to have -all- the CPUs be idle to turn off the timekeep=
er.

That seems to be pretty unavoidable any which way around.

> This won't make the battery-powered embedded guys happy...
>=20
> Other thoughts on this?  We really should not be setting
> CONFIG_NO_HZ_FULL_SYSIDLE by default until this is solved.

What are those same guys doing with nohz_full to begin with?

--owRCMvbHJBIqpgHE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTzCfDAAoJEHZH4aRLwOS60oYP/R7BP7SFlj6SxxdOmqa2T/Iz
54ZbjJbvYbJp5luvVOjBo8k8jOpaHIHF3fZefsjVswM+ROZQp2ka140fndjkI7NE
bFneD6wvA8lzcu3QzoQe06xlijI2ozYvdUXrgVtuuI/h8KHyNjhEv+UU5qA52wcD
xuwt9j656IWZ3lWjr5Gur3c9U8K/ZaqHkHXjQxJNZn9g5H25dGh1MdsXCIoEsFGN
Vc5KYFn0n1ANvwCNQ5QYe6uhf1bNECZ5YON4rMnp5i4CtcBDEvUnnk//GxYClEQT
0iPri4UFz4vRQ/M24INH3f3TwaMXRpah0DqksWYqYQ0Cy/m4e8MJqO8SkbN7sNDP
z/QyrJK0HqzLC6OqUqLNDKRnF6xSIjqwBs3yViIE3uJjWoX7MWiRM0vRg5Xomm+N
2n+235DIYES260JwAhsGT76VIBpbS0saWRGJfGx32MI0XS1GB2qlAtX3oOTLm72o
m/e2ETzo7CCUJT+Ffd5/wzFIJhOeo2pK1OsVWO6lwQHEjuS2Nec7qto4sm4DffL+
7DsxnTQAxdILi+ePtO15rV8VVj79MTcpLN/pglPjUrSnYmiblTPU/FmPTP2TTNmT
Vu5cpUWKG8JN77thlpjDv67CVcA9OCIaiVpb+DWqu7fhCqDzcqE1fowcP7vqOBjA
9Cc8m+J8kXUFc1odmafc
=m2Z3
-----END PGP SIGNATURE-----

--owRCMvbHJBIqpgHE--
