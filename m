Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752059AbaIJIkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:40:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54796 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaIJIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:40:02 -0400
Date: Wed, 10 Sep 2014 10:39:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/2] perf, x86: Use INTEL_FLAGS_UEVENT_CONSTRAINT for
 PRECDIST
Message-ID: <20140910083949.GR6758@twins.programming.kicks-ass.net>
References: <1410310148-26260-1-git-send-email-andi@firstfloor.org>
 <1410310148-26260-2-git-send-email-andi@firstfloor.org>
 <20140910075926.GM6758@twins.programming.kicks-ass.net>
 <20140910075954.GW3588@twins.programming.kicks-ass.net>
 <CABPqkBQBVRph9+aXC6F3=QxkVXXYVH8wM4rPwKBY8dpCtf1z_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GjzT7NpwwiYGuc/0"
Content-Disposition: inline
In-Reply-To: <CABPqkBQBVRph9+aXC6F3=QxkVXXYVH8wM4rPwKBY8dpCtf1z_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GjzT7NpwwiYGuc/0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 10:37:14AM +0200, Stephane Eranian wrote:
> On Wed, Sep 10, 2014 at 9:59 AM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Wed, Sep 10, 2014 at 09:59:26AM +0200, Peter Zijlstra wrote:
> >> On Tue, Sep 09, 2014 at 05:49:08PM -0700, Andi Kleen wrote:
> >> > From: Andi Kleen <ak@linux.intel.com>
> >> >
> >> > The earlier commit 86a04461a made near all PEBS on
> >> > Sandy/IvyBridge/Haswell to reject non zero flags.
> >>
> >> What's magic about nehalem and westmere?
> >
> > And core2 and whatever else we support PEBS for, for that matter.
>=20
> nhm, wsm, core2 do not have precise distribution (PREC_DIST) umask to
> inst_Retired.

That was a comment to 86a04461a, I should have spotted it at the time.
There is no sane reason to only change PEBS for a subset of chips.

That needs to be fixed before I'll take anything else from Andi.


--GjzT7NpwwiYGuc/0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEA5VAAoJEHZH4aRLwOS6W8oQAI22c5oPeMwyiwaUZeqfbLtd
+xmMNqHm8whSXhwTfS209iBd5OQqsjJIV9UO4mrIHW/W/1yS/LMFUjmTQcQ8W0P3
k0JvPQXnqC1s7QzbMxbxxcF0pryMc6saoz+1jyKdQqNkhuRaQUsQpvJF/DTMrCcP
Qq+HOt4Oi++cgDf1/1tDVmLMzzskqwk5ZMsd8X7/6CZBNVkNorXgS/KtFuo7tCMJ
WAqYHgjpVNiZP1Sw7aGppIq6I/WEw2MbYsRrXghQdq9PZrLyb771upP+5XrIZSy4
yZYweLfZ94E8K2NnD4UUp/nCH19anCYO2m+e+GCv0TGiARSsM6Lyl+SbmZzAz0B0
9pJfIg96Sfh12BKIrycDdje76msspr3er4vC4GrUVSYKCIqYuC7G4F+N9rmf1j0Q
jjTtDQtxgbBYBqoSPUVUczoXkEPJ39jJmvCT7nY7C+JCxh9dywAeJZMruiNGrgnV
inozQtI7/P3KJy+fMbhfOm7o490QDAjRSxqoA4VFk9q/pUbX7AMcVp0m5wQN4VU3
e3HUWeNNpAOx8LZuqNThOW52rQ6BAPS6Lykwpu6Cf9v903h3L/eL9o0S9Y11wblt
meEodOQEyRdNuf1qvedEqiFoypAD330+MpCUEaCo62Fk1NzEm+GC/ruGA+8ODZtx
9+CSxWnnQi3gaOcTi2VS
=LreO
-----END PGP SIGNATURE-----

--GjzT7NpwwiYGuc/0--
