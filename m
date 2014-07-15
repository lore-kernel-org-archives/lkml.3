Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbaGOOyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 10:54:01 -0400
Received: from casper.infradead.org ([85.118.1.10]:57857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaGOOx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 10:53:59 -0400
Date: Tue, 15 Jul 2014 16:53:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 6/7] sched: add function nr_running_cpu to expose
 number of tasks running on cpu
Message-ID: <20140715145346.GM9918@twins.programming.kicks-ass.net>
References: <20140714161432.GC9918@twins.programming.kicks-ass.net>
 <1405357534.2970.701.camel@schen9-DESK>
 <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <1405367450.2970.750.camel@schen9-DESK>
 <20140715095045.GV9918@twins.programming.kicks-ass.net>
 <20140715120728.GR3588@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1407151452370.24854@nanos>
 <1405435525.5744.29.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YZ2gLtJL3Gv805BH"
Content-Disposition: inline
In-Reply-To: <1405435525.5744.29.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YZ2gLtJL3Gv805BH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 04:45:25PM +0200, Mike Galbraith wrote:
>=20
> 3.0.101-default        3.753363 usecs/loop -- avg 3.770737 530.4 KHz   1.=
000
> 3.14.10-default        4.145348 usecs/loop -- avg 4.139987 483.1 KHz    .=
910     1.000
> 3.15.4-default         4.355594 usecs/loop -- avg 4.351961 459.6 KHz    .=
866      .951    1.000
> 3.16.0-default         4.537279 usecs/loop -- avg 4.543532 440.2 KHz    .=
829      .911     .957
>=20
> 3.0.101-smp            3.692377 usecs/loop -- avg 3.690774 541.9 KHz   1.=
000
> 3.14.10-smp            4.010009 usecs/loop -- avg 4.009019 498.9 KHz    .=
920
> 3.15.4-smp             3.882398 usecs/loop -- avg 3.884095 514.9 KHz    .=
950
> 3.16.0-master          4.061003 usecs/loop -- avg 4.058244 492.8 KHz    .=
909

Urgh,.. I need to go fix that :/

--YZ2gLtJL3Gv805BH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxUB6AAoJEHZH4aRLwOS62NIP/163Nghkyg1sahnk3HEHkTqd
atv713v1bvXPFcE48nm7vNp3P7umWOtTnRqMucIa40QGHkxiFMwYB0vyqfneBZ/W
BCAC5ZXJW5aw6Itw6Gc8Y7MU1x/ziPwy1VnexN4U9FJ4bScrSL+CRgx0agOpEYBP
ZvatKMx9UVy15UwViMaT63gK0z1mOWH+lh3D7ZcqOqdcjPhrOfAjPvJx3iTL+qMw
yPFUu0m2m0qKEafthj6hjMJFtlEwTo63hE77TA1Gow7uJ3OfRjKTp+ctLCkIQpIQ
L1imR59qneK7Q+NB+eTR9ZGaqvUgr5MuOxp/RyrZ01A6t9dEi94Us0nxbcblSuxD
Ar924ZDiZulIhuq1LP6hYuTkR6qx2OJWDqGBjS52Ppxr3UCbEb29EKkhG5aObu/6
bQPHVClo7/95qzCnT+AjE5gU0c20FVURyg4p3XQAwZOVGe1E/53yjN6dsmNhf2LU
DnKI/KQqbR7fuCuD0Dr0GaS1byxRfORkKF1bT4KgrvmVTpGCh0O2ayodogdUJsvW
UjUVzTV9WDZXF6COzyoLBBVc6YB1GPMypY3As2ZDM/dwthE3l5V+EKDscJP7M7oB
kr016tNopWdvHadHEhSncpRY05a+0pBRZuPQTtPgZ4HK/cC95drDiWY1F8gIkvwp
CZVgKEt6Gr9qGXLPlR7p
=YTUx
-----END PGP SIGNATURE-----

--YZ2gLtJL3Gv805BH--
