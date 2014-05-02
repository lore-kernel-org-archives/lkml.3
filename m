Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183AbaEBRFN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 13:05:13 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33657 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaEBRFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 13:05:06 -0400
Date: Fri, 2 May 2014 19:04:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140502170454.GJ30445@twins.programming.kicks-ass.net>
References: <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
 <20140501150948.GR11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011147340.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.02.1405011829190.6261@ionos.tec.linutronix.de>
 <alpine.DEB.2.10.1405011315250.19082@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011443410.19874@vincent-weaver-1.umelst.maine.edu>
 <20140502154217.GW11096@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405021304460.22556@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405021304460.22556@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 01:06:52PM -0400, Vince Weaver wrote:
> On Fri, 2 May 2014, Peter Zijlstra wrote:
> >=20
> > Can you give this a spin?
> >=20
> > ---
> > Subject: perf: Fix race in removing an event
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri May 2 16:56:01 CEST 2014
>=20
> Nope, still shows the bug pretty quickly:

Curses.. back to staring at traces I suppose :/

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTY9A2AAoJEHZH4aRLwOS6D4gQALK5aOdaRZ1xaAVZjWSzYdgv
Zd7+ifQAOLtvWqGq/iiulHxeVmtxrFWE+9Dhd4mzhh1Z5IAFLIJO3FOZ1w5mwsiZ
09cy9VxC0RwfjkevwX8mBvuIsw0SmYtG4SNu2oUMtC9cDAlYv0KO1JsKkTpMYWdn
Z95sAEcI2+CYblWCPkxEv7r4TtrlWjvSqYb8VjD/AcUIFHySfyTke67e6sZtAhOr
0bcBFS9/vFYQcP0qQVdSDxE0F4rdtqo7d53dhJ72sHVZyZyTvGmSEQMbp/60iZ9m
iHO+UvWDRwkvMIlZ/+wGrTIV9zLxSdNfAdY6Rmvqwt/POqMCq55KYsRsBqcaMcUi
7PpRN7yqvqEzXvvEt1HgR+y8hgF/hXfxI29kkb1NrRf17oY4Si3ci9cDrTGMUzqx
dWddONsL/3OZZyhGLNT/K9dXoP/K94bTKL1AeLdfI1g6WmshMqqzROutY9/uk+zn
PqKt+r7HDwzA8iWEOc/6ogXTdRuCYQQXrlBQtgoA5LfFyI/Ozc2X7VbBhEsj9WH/
mzSK1xTtKbV7GB+9/27xcAXVHX6mSEET5drwH79VqAnnFM2gas6InUwu7dJXEnLu
SdTQOgOhX8qCc+cA+5qx4lRLk8Y9h2Sd35eHIv+Xw5x2NSUbzgJXn1GiQ3LhrWhh
5qxUYU0sowKd4U5QsryU
=8+vA
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
