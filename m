Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbaHDRSb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:18:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:34613 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbaHDRS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 13:18:28 -0400
Date: Mon, 4 Aug 2014 19:18:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH?] x86: reimplement ___preempt_schedule*() using THUNK
 helpers
Message-ID: <20140804171814.GU19379@twins.programming.kicks-ass.net>
References: <1407158386-6201-1-git-send-email-dvlasenk@redhat.com>
 <1407158386-6201-5-git-send-email-dvlasenk@redhat.com>
 <20140804170519.GA17466@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bTEFy8KkmVf9O7nJ"
Content-Disposition: inline
In-Reply-To: <20140804170519.GA17466@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bTEFy8KkmVf9O7nJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 04, 2014 at 07:05:19PM +0200, Oleg Nesterov wrote:
> Hmm. This part looks fine, but with or without this patch this all is
> suboptimal, we do not need SAVE_ALL unless I missed something. Can't we
> simply kill preempt.S ?
>=20
> Peter, what do you think?

HPA right, not me? I'm never sure on these details, if hpa thinks its
fine, I'm good.

--bTEFy8KkmVf9O7nJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT38BSAAoJEHZH4aRLwOS6MLwP/2LfcqXCoOAy6n40bjQj0zug
kD4AlCVNLqAntuA+L9pdlKkv9ve0CboepbVX0JFH+tXdfQJPoWdzNZIkKWsolgFI
OicsgBtzrrTnQKGC1BYfxJ9OGfLY+ti2pKEG4UT61egKUg3jlCvLqyu/ql337xNM
R1FdcvuwOqfnTwkWhYMgBKAm7wLQ7UKJUN1i7jAquaKnKJEUs3xA+pAwfHT7hXvf
u/qQ0Fvmoei9YRtgC7QkMRRA639Ba0uddMjZfDHABH63Au7xqiWwP5GF85t4MIbG
rIlyDmw+DuDzf2nVFFMKrRXLlIn47pEyXG5ErhUcLm3n+sAB9Z9GEY+MbA0EQmlM
529YchLkTYCz68SfoUU5wB5fbH2wpVbwG2lFO5OEUuHG1UToS24v46xiOfUs7fKw
o3jmHF/d97CcYKECN+qy3mh3LiFXz8/+SnR78qsmNQyjw4NlsKu9unaCcjzTcibT
rSrgEOZ9UC7u9VojAZFizktwuPPhyZwCIRzxX6mkb9zAfzny3PcdUlCPu0NPQjMJ
c5XmVjrpQo1MDF5HEeLdFLUOdCme4ddv9J2iQB/U0nlBmo0orgiQSU7wy9KRzST6
wc77SInpymgqR55/G3xEL7iZ6hR79dXp27Tw8fJbI8xAN5lWh59fAnEq1S/DmKZ9
XOHKmhGegeQJcGE+qw4g
=wMs8
-----END PGP SIGNATURE-----

--bTEFy8KkmVf9O7nJ--
