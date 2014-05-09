Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228AbaEIRUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:20:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33895 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756798AbaEIRUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:20:53 -0400
Date: Fri, 9 May 2014 19:20:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Hogan <james.hogan@imgtec.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "luto@amacapital.net" <luto@amacapital.net>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Will Deacon <Will.Deacon@arm.com>,
        ARM Kernel List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC][PATCH 6/8] sched,idle: Avoid spurious wakeup IPIs
Message-ID: <20140509172041.GB30445@twins.programming.kicks-ass.net>
References: <20140411134243.160989490@infradead.org>
 <20140411135218.478299389@infradead.org>
 <CAAG0J9_q1KsUx10-XAb7AJnxv2ehctg6q1KME7ahsk1OZV8vZQ@mail.gmail.com>
 <20140509141520.GV2844@laptop.programming.kicks-ass.net>
 <20140509144034.GF7950@arm.com>
 <20140509145002.GW2844@laptop.programming.kicks-ass.net>
 <20140509145745.GI7950@arm.com>
 <20140509170234.GZ30445@twins.programming.kicks-ass.net>
 <20140509170649.GG13658@twins.programming.kicks-ass.net>
 <20140509170946.GN7950@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rpOPesfUXqAMaEty"
Content-Disposition: inline
In-Reply-To: <20140509170946.GN7950@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rpOPesfUXqAMaEty
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 06:09:46PM +0100, Catalin Marinas wrote:
> On Fri, May 09, 2014 at 06:06:49PM +0100, Peter Zijlstra wrote:
> > Subject: arm64: Remove TIF_POLLING_NRFLAG
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri May  9 19:04:00 CEST 2014
> >=20
> > The only idle method for arm64 is WFI and it therefore
> > unconditionally requires the reschedule interrupt when idle.
> >=20
> > Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>=20
> There's a tag with my name already but just in case you need another:
>=20
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>

The more the merrier :-)

--rpOPesfUXqAMaEty
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbQ5pAAoJEHZH4aRLwOS6mmoP/Rm1eGGyvRDgKuUezhUJFOkn
J6s9Gbh+SSg0leIz7Q6gVBa8huX8c6uUagFZOUqqSLkTiXSesZXt1sCs9XijmpYW
egl6uZWwItckVC+XuJ2A6TB/yxru/xIGPrwtFhFnTr20ig3FaVTAb9v7byqMzU7X
F9ZFJ6H2hLVCpRQ+XoUyYm3HyKNynngR/0/4nxYXkXmgMNJ+mWhhQENrSZ3+qE8I
SDmMmcDlPTUa54PX7m11YMZfpwNhjWJ43EtAbx3J3Jp5vTokaJ3ulngN44jJkGz4
53cXtQqPnvKc0fR+2mjnGoSiy32WQ9G89O3kIH5LtJpbGNL8VI47kcTKqU278+Ji
KUg/PoFU//LC1mYTaw6uUlrbuviEpWNUcOsjXe0vGxIMHAkBeXRvQqELKxdi1Rko
a+osL4LyDbUli86JcMSn/1wJI2/5Vo0ISUIBzU2wg9YjOOy0Ipz+2S97xjKv9pVP
dJvUNPayGGDwYKrTswOAeR0eW5mxB3+Q4z58b47p3qbUD9QieXS+H7DngbwOkdEH
Nxl+JvPRCatVK3jACZsv2OJarF+U285PTELn79kKa1HIRQ9p+8B3yRYThmwMpa7h
w/7O/DW9ybvgJJd+9C6uSuWRKqUspQSnv1Qd9P8YooPEYTe69TUvE7uhC2F8BCql
PyzSmsaEFh+8Wh8sQSAf
=Y7/b
-----END PGP SIGNATURE-----

--rpOPesfUXqAMaEty--
