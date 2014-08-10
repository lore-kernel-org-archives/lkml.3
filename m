Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbaHJPFT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 11:05:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:58621 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHJPFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 11:05:18 -0400
Date: Sun, 10 Aug 2014 17:05:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140810150503.GV9918@twins.programming.kicks-ass.net>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WpsXmqqNSa2+xZ2i"
Content-Disposition: inline
In-Reply-To: <20140810105413.GA29451@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WpsXmqqNSa2+xZ2i
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2014 at 06:54:13PM +0800, Fengguang Wu wrote:
> The "brickland1/aim7/6000-page_test" is the test case part.
>=20
> The "TOTAL XXX" is the metric part. One test run may generate lots of
> metrics, reflecting different aspect of the system dynamics.
>=20
> This view may be easier to read, by grouping the metrics by test case.

Right, at least that makes more sense.

> test case: brickland1/aim7/6000-page_test

Ok, so next question, what is a brickland? I suspect its a machine of
sorts, seeing how some others had wsm in that part of the test. Now I
know what a westmere is, but I've never heard of a brickland.

Please describe the machine, this is a topology patch, so we need to
know the topology of the affected machines.

--WpsXmqqNSa2+xZ2i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT54ofAAoJEHZH4aRLwOS6HsEP/R1d64V9ypDIPDYZOAW2b52l
KS8im+JiQ5yIydVJ/8Qq29GWHnuHerT9UQcjK4wgutKQbZ8DysSUSERzUGFtLz2E
KKGRJzfutB9epUnMAhkWek1rt1KZHl27xtQCD4WE34OmSOZ29Fz3/IDGNTY3wv0q
lFIeyTQNXvaSDzhLYqbHsoAfGddeOxPT1tAT9TU25Qd5gvd75VtHVC99EWs2RCc2
a/tAd2nFBilzhIydafWE226TRL5ht9nuXan8ZbQXe1/sqTE3Fu+thTpfWN+2U403
MaYVJSXej2Wm6kQWG42iGBgyipIt43APZGDdCIyttCiJjvURJjcgxDGhDa6Yck8v
4bqL7s+4wVaqft03IBaug+rcb81Px51LP9yeiAoAmBcAw3sK9Pj25w51NgDbZj9s
cCI9ejYAxe/Lrb7O+7z51BmUheLZvgybOflQOiBaLN4nDH2iSyHvSgZ0LZQrIqnZ
qHcBLcpG6cYiPbRHQEPCMU0r2AbzfYTLLqaBAXQUj8EVc9EWXorIBS1mvqILZFm5
23iYCi+coQwjSr684jeycBjJud+8fjF+VWOmZX6azSi1OglwZwSjV3U/7r+YeRGh
sXIMLH/nC9PjCGEake/XZgRTyxlLRQLlDh292rfQGhyAIPzNwVG2VKYbmp1GCNPX
M6ihmn3wYuC6nll4Uhdi
=L2Mm
-----END PGP SIGNATURE-----

--WpsXmqqNSa2+xZ2i--
