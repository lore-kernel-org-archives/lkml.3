Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaEWP4q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:56:46 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35624 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbaEWP4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:56:44 -0400
Date: Fri, 23 May 2014 17:56:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "monstr@monstr.eu" <monstr@monstr.eu>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140523155626.GI30445@twins.programming.kicks-ass.net>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
 <1400777250-17335-17-git-send-email-will.deacon@arm.com>
 <537E30AF.4070501@zytor.com>
 <20140523144604.GF21319@arm.com>
 <537F60E0.1060307@zytor.com>
 <20140523145758.GG21319@arm.com>
 <537F6728.3090600@zytor.com>
 <20140523153409.GI21319@arm.com>
 <537F6C85.107@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SIhMtSQSYpXpqifs"
Content-Disposition: inline
In-Reply-To: <537F6C85.107@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SIhMtSQSYpXpqifs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 08:43:01AM -0700, H. Peter Anvin wrote:
> On 05/23/2014 08:34 AM, Will Deacon wrote:
> >=20
> > There is also a documentation patch [1] in this series but, again, I di=
dn't
> > CC everybody on it. Sorry, but the level of interest this sort of stuff
> > generates amongst kernel developers is close to zero so I only included
> > people I thought cared on CC for the entire series. I'm stuck between a=
 rock
> > and a hard place trying to CC interested people whilst at the same time
> > trying to avoid spamming all the arch maintainers.
> >=20
>=20
> If you are sending me a patch, please include me on the cover letter for
> the patch series.  You don't have to send me the entire patch series
> (although for something like a Documentation patch which affects x86 I
> would consider including the union list as well.)
>=20
> I think regardless of level of interest, the definition of
> cross-architectural operations is exactly the arch maintainers job, so
> it isn't really out of place to "spam" us...

So the one issue I had with that, is that if one tries to send an email
to all arch maintainers + linux-arch + linux-kernel, the header gets too
big and vger chokes and davem slaps you.

So while its possibly desirable to do big unions with 0/xx and the like,
its practically infeasible.

--SIhMtSQSYpXpqifs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf2+qAAoJEHZH4aRLwOS61y8P/R31PO3PdXkwzC+dChd1vVwF
7vC9OX2ibOAj9GdYUPwfU6mromo9192lBMT7cfKLtd+Bvf59AFnkA2udQBJ3wvZe
Y11fJ7WkXqzukgO+FfDFVzPbmj1poKn/ZGt6snm8PJIkqOhL9kwPz0ZnuVaunpC4
UiF7vWKrkyDCCnFvPrMS6Y+/GiN79tJFrhlbGian5s9QmacDE4RsnCEDyniWjt7k
dDY6Y49pxW6OPRUzuuqrE+mQZucPpA4CENYvSMk2akJADbvlhlHDKv6GkhkwSUwD
l5NSeCPRkHvK9PLsMysbCWdEWl7Fr3M3quxGIJeioUFYlxzM3TglGv4A1WFxY2dj
FjDqoV7fcVCZ1nVogIQ/Cr/wjIV3eu1AmKHGsFwqVh0ErvdZeSmE2FQp6kvRjXGJ
oGioGkPkGtFHK6SbWrkvAKzrmAAkkq5vI6vS/6u154D8ywV31O54kD2GpuIkfWfj
4yTJL+v0W75jPoOQXcqFJmknE7gJkVuqnZp/+xk0caWNeuzgJnCjtpu+Z6TYynON
yIURM5UVhzOfJUg/UtFfykgBOEfnUc6Tn2bvXtgesrgeidJc0VOjM4vVreF7Y23D
ZyLCB6SFXxPeZ4bbl40l8Foi4mqp3cNRgDxjGA0ssz2mUPzcRP+qU99nWwgYVtc4
OH1DzyZCHqrCkDnhb85O
=hxID
-----END PGP SIGNATURE-----

--SIhMtSQSYpXpqifs--
