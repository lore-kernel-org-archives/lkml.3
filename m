Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbaFKI7g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 04:59:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:53510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753032AbaFKI7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 04:59:30 -0400
Date: Wed, 11 Jun 2014 10:59:21 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@kernel.org>,
        hpa@zytor.com, konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        davej@redhat.com, jeremy@goop.org, paulmck@linux.vnet.ibm.com,
        raghavendra.kt@linux.vnet.ibm.com, tglx@linutronix.de, oleg@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [tip:locking/core] x86, locking/rwlocks: Enable qrwlocks on x86
Message-ID: <20140611085921.GJ3213@twins.programming.kicks-ass.net>
References: <tip-r1xuzmdysvuhl3h86n5fbxi7@git.kernel.org>
 <1402474451.3798.44.camel@x220>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4N29bJelYIMOTi0e"
Content-Disposition: inline
In-Reply-To: <1402474451.3798.44.camel@x220>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4N29bJelYIMOTi0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 11, 2014 at 10:14:11AM +0200, Paul Bolle wrote:
> On Fri, 2014-06-06 at 05:20 -0700, tip-bot for Waiman Long wrote:
> > +#if !defined(CONFIG_X86_OOSTORE) && !defined(CONFIG_X86_PPRO_FENCE)
>=20
> X86_OOSTORE was removed in v3.14, see commit 09df7c4c8097 ("x86: Remove
> CONFIG_X86_OOSTORE"). So the first test can be removed here, as it will
> always be true. Should I submit the trivial, but probably untested,
> patch to do that or do you prefer to do that yourself?

I was completely unaware of that removal. Yeah, I'll queue patch
removing this new instance of it.

Good to have it gone though, one little crazy less.

--4N29bJelYIMOTi0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTmBpoAAoJEHZH4aRLwOS6OtUQAKj+YsEb+vnZZBElw6HEFLzs
2ft/9IArxaM8Ki+tsEwYwMg1MeiHsHAv8vZ0dtlkL/QPAbDN1VSimKSnYeHlXzUp
H27CqWSQ/6xpuzHY3bcpD0NHWN4fnT2t40zXcE0RljGMQmihTHvFI/iSGJVAadEQ
BvlwwUu0JyHhUx52Y+bYVKdPMYMUweRLbo84WV1coydZlIf+ZVPrrQLuWDr6xybs
F45h0BjzVkSAhg1y1ZcklQ7yFqcUXYHbsSleONitGCH4pcb6FuS+wvQqpndrdhWd
Muw1QAyik9nzTHgY1/mViolqmjpmb0eQtbvYnjO0p9fES2gwTUisxMeVqC3yTN34
JoHiot5JcfzTnKu+47TkcVXON04x5PTlv2iZg8hNrVic+pvsCntX4sruQaB9R3Qk
dl4qYrjO95MV5pZSVqyQGtjCMeHiH3RDXWtz5oL+9jbbvnpbny+5B+ryo5ATyZe5
2yUOl981d3YLw5j+BWQ4Mau1wX0qbeuJlm61ws4/xGK2MG9QO7KBrcXjWTdH49ip
Tz05h2Qi9majMWT+J+I/LnV2o06NmgHvhvoRUdwZbQOVtJFj0iY3u8MpDka5DSeJ
NHDYbiFXF005CDccsNRinETvRYpvsv7Ovd56JBT6MRezWFHxnKO1SFaFyIAE6XCI
BdHj7XwnwryalV6D+Mhi
=C4Wq
-----END PGP SIGNATURE-----

--4N29bJelYIMOTi0e--
