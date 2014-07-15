Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933068AbaGOTD6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:03:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42411 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932827AbaGOTDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:03:55 -0400
Date: Tue, 15 Jul 2014 21:03:39 +0200
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
Message-ID: <20140715190339.GQ6758@twins.programming.kicks-ass.net>
References: <20140714181738.GI9918@twins.programming.kicks-ass.net>
 <1405364908.2970.729.camel@schen9-DESK>
 <20140714191504.GO9918@twins.programming.kicks-ass.net>
 <1405367450.2970.750.camel@schen9-DESK>
 <20140715095045.GV9918@twins.programming.kicks-ass.net>
 <20140715120728.GR3588@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1407151452370.24854@nanos>
 <1405435525.5744.29.camel@marge.simpson.net>
 <20140715145346.GM9918@twins.programming.kicks-ass.net>
 <1405447615.5117.36.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S4NLt4ipYM5IQHam"
Content-Disposition: inline
In-Reply-To: <1405447615.5117.36.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S4NLt4ipYM5IQHam
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 08:06:55PM +0200, Mike Galbraith wrote:
> On Tue, 2014-07-15 at 16:53 +0200, Peter Zijlstra wrote:=20
> > On Tue, Jul 15, 2014 at 04:45:25PM +0200, Mike Galbraith wrote:
> > >=20
> > > 3.0.101-default        3.753363 usecs/loop -- avg 3.770737 530.4 KHz =
  1.000
> > > 3.14.10-default        4.145348 usecs/loop -- avg 4.139987 483.1 KHz =
   .910     1.000
> > > 3.15.4-default         4.355594 usecs/loop -- avg 4.351961 459.6 KHz =
   .866      .951    1.000
> > > 3.16.0-default         4.537279 usecs/loop -- avg 4.543532 440.2 KHz =
   .829      .911     .957
> > >=20
> > > 3.0.101-smp            3.692377 usecs/loop -- avg 3.690774 541.9 KHz =
  1.000
> > > 3.14.10-smp            4.010009 usecs/loop -- avg 4.009019 498.9 KHz =
   .920
> > > 3.15.4-smp             3.882398 usecs/loop -- avg 3.884095 514.9 KHz =
   .950
> > > 3.16.0-master          4.061003 usecs/loop -- avg 4.058244 492.8 KHz =
   .909
> >=20
> > Urgh,.. I need to go fix that :/
>=20
> I'm poking about.  It's not just one thing 'course, just lots of change
> adding up to less than wonderful.  Idle changes are costing some, for
> obese config, avg goop.  The select_next_task() reorganization appears
> to be costing, but eyeballing, I can see no excuse for that at all.

How is the idle stuff costing, cpu-affine pipe-test should pretty much
peg a cpu at 100%, right? Or did I mis-understand and are you running a
loose pipe-test?

--S4NLt4ipYM5IQHam
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxXsFAAoJEHZH4aRLwOS6hHYP/1Nzpnj3WVlYHqazbhr9zLnS
sMD8MYSPfUTl5yrKpyGQusdXOI1OZh+drGRjUwbqhQlrPHC3fkEt9XKuR3i10hJ0
h67Q8eVfp6ySdnX/6OlsjaUeDEIDg+y0pYVlGELlQ9/1Np0NokO37KUhJgfrkbOE
QaL2FMYo6ap7OEuDwSMVsNmgq+2sptur9lStocC/nYdrMfw2Kt3BSRL9FZ3yE0Vi
+hLtBnWUS1d+jTqQsbC0ocTvPBMQAuKd6sK/YvrJSQ7VefDSOYKVz95Z0afVYl4x
SzOKiNVz6n/DYiItT7NwKXbLP+mlAoC45dgLEABi13OJQNpNQs5NB4EtMqrHdSJW
2WD823kRhVAhMMHmzyQDzP0gXJlom5dkLjQjmSs9OY34Q+m/AWDAvVItHt7pwwod
Vs9uqU8jkq3m6ax0mlnBVxY7+rJmtEW0x74l6FB9CMsdmZvcdF3qAdzl3tiFTm3D
Ga+PWBCyoBu5dUPRu+TKEigzaBQQ3YDwZBMIxk+gsRwkvn1SaQfQ89X7EZegLXRR
v2lxdb6hECk1suFgAz2gDR5AxB9LME/Bc8dwdK107AKe4K/aUCCkdKv+kziWbR8r
FbW8N86vBUJAtvFUtWhhDPxP17JElN2mVqR9u8B2+Bk3/GGt3fkOzOsQuLyEf2Yb
WWUK3AnVzRQvf4+uv1Lb
=ee5K
-----END PGP SIGNATURE-----

--S4NLt4ipYM5IQHam--
