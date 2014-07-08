Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbaGHIJV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:09:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:53484 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554AbaGHIJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:09:17 -0400
Date: Tue, 8 Jul 2014 10:09:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu, joe@perches.com
Subject: Re: [PATCH tip/core/rcu 2/3] rcu: Add designated reviewers for RCU
Message-ID: <20140708080908.GN19379@twins.programming.kicks-ass.net>
References: <20140707224146.GA9118@linux.vnet.ibm.com>
 <1404772924-9423-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="n8rALO501tkk3VWH"
Content-Disposition: inline
In-Reply-To: <1404772924-9423-2-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8rALO501tkk3VWH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 07, 2014 at 03:42:03PM -0700, Paul E. McKenney wrote:
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1814075c0e74..92f2bf91eec1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7405,6 +7405,9 @@ F:	kernel/rcu/torture.c
> =20
>  RCUTORTURE TEST FRAMEWORK
>  M:	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> +R:	Steven Rostedt <rostedt@goodmis.org>
> +R:	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> +R:	Lai Jiangshan <laijs@cn.fujitsu.com>
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.g=
it

OK,.. so if we're going to do this can we talk about the syntax here.

I would like to also use this for SCHED and PERF, but since both are
rather big I would like to be able to subdivide things. Now I could of
course go create many MAINTAINER sections, but that feels artificial.

So I would like to be able to write:

SCHEDULER:
=2E..
R:   Steven Rostedt <rostedt@goodmis.org> (kernel/sched/rt.c)
R:   Juri Lelli <juri.lelli@gmail.com>    (kernel/sched/deadline.c)

or something like that. And here I've already done concessions in that
the above is machine readable. Ideally I'd be able to say things like:
'for sched and numa related things' add 'rik and mel'.

Hmm, maybe we can look at the patch subject tag like: sched/numa or
sched/rt or sched/deadline etc.. instead of the files touched.

--n8rALO501tkk3VWH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTu6ckAAoJEHZH4aRLwOS6jKQP/3MjOjpPXcHN5MkJe9DuAfRf
pfp3v5bh8XE2draCzW1SvRQ+q+QkTfg9jpl8pBr3Yhqcm8C5DAs0cticytWG68Wh
Ly7DHlWyTk4JikGWOVhJ6BxY26U8ZNtB7wNw+QxFrIJxx6k0kXqhFs/h8EdX3i64
0z5jq/D6grZTp3L8gxrAK5ir13ZdTaLlXPkisPj1KK+Y3r5hlt6xeC57gmrJ0zGP
FvgVLSBtSVNI3BQ1+4iQSqr1wsxQdngi/4bvHJeWVQCeFWz/cdimHKExKqLheeSA
WhwM6h4pIHcLDqywSEsvCIeBbAkUl2umDFF7u5HppO32ywftvYLtw0alAjTIhfIM
/zYmmNelQ+OlmOoKOqot/b495eE6UMTZILYlcY0acbMA8xrnTa1j2eE2fX/R/luR
TQekCWwSE+46tJ/F/H+OZeCoiMX1toE2VOz8GMJ5OinEKltyXUWxrEcmK/GMCiLK
65K7c3kC4KBKkh0LpnW5xrsaUhuAhLrWjts2eu6Ws+3jHxjZDIkY+ufXqRBUXbau
apWIgPJijNeBK4DEI89oz8ZLqPfqzy+WWJPJX/UtZ8fWJu7BGIPhnS3oCPrXNE5l
uzXB80DgrNxM6DxLR8IE2I5gWqSX3ihZ5s2tj0kRFQcxurat5zEsoxRLT/IVYmyi
BFd8t1CKC6/fB88uI2Xu
=f5TK
-----END PGP SIGNATURE-----

--n8rALO501tkk3VWH--
