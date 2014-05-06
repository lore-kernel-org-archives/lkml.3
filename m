Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbaEFNkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 09:40:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34059 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbaEFNkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 09:40:32 -0400
Date: Tue, 6 May 2014 15:40:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
Subject: Re: sched,numa: invalid memory access in account_entity_dequeue
Message-ID: <20140506134016.GL11096@twins.programming.kicks-ass.net>
References: <5364EC10.9090900@oracle.com>
 <20140506110838.GE11096@twins.programming.kicks-ass.net>
 <5368D43D.5050601@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G2d+m75Tjo442KmM"
Content-Disposition: inline
In-Reply-To: <5368D43D.5050601@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G2d+m75Tjo442KmM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 08:23:25AM -0400, Sasha Levin wrote:
> > I suppose you've scripted this addr2line -ie vmlinux for all addresses =
in this splat?
>=20
> Yeah, I'm trying to get that script upstream (https://lkml.org/lkml/2014/=
3/29/1)
> since it seems to simplify looking at stack traces.

Seems like a nice addition to scripts/ indeed. Although Linus doesn't
seem to like it much:

  http://marc.info/?l=3Dlinux-kernel&m=3D139862933908922


> > Could you maybe also do the same with the Code? -- that is, script an a=
uto-decode for it?

> Sure, I can look into that.

Thanks!

> > la-la-la..
> >=20
>=20
> I haven't seen it happening again, so maybe an unrelated memory corruptio=
n?

Yeah, just the thing we need :/ In any case, let me know if you do hit
it again this side of the Sun burning up.



--G2d+m75Tjo442KmM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTaOZAAAoJEHZH4aRLwOS6jMUP/Rr7XHgtsdWwZJ/LAoZdDCqW
RyKoaKqRj4OxXC5B2FhKs348d04wKaYrnq6YOewOiAItSuljwdkwT5+9E1VvBcj5
uWmH3tVZirLfLoRM+gTFdJswgTRtgRUIQDkNW2K8DBfRZQyyJxVnibExvqiYPWU0
WlFn+NLPnZVDYtUMVVXypyY3Tptyk8kUH4/YtdY5CD4jLp54c1tODvwtV9Rc2Njd
ePX2j49RltVYQmPB4NCSTRVaTSrY0EXWh+puzzDnI+sZwZeNzWapmgUHhahQWG4A
Uee2JTy4WQI22X/HpoAKhmi1Uzo9Tql9H/aZNruWTRyQLjqWM4ZcPfyN2pwzp2la
GjbV15ifj4qzLuS7Rx09B7nInSQvdB8YBnk5Hdc6CrmYujM6DHySIGVjgwgmDOPd
UTZVghr7q3mZTiAmRjiZ25o7+yU+yLRyxMgGJebTjRodox6cbq/AAxS18RCTovu7
TLd15T7f7FctkYBhao5/l/JCthU5yhHmDcFPRQ6OJeGFQiuVsLFkqQqZl1LOxxIY
X2SZQDODzgyRXZdQ6294IhianEsM46tEF/Zp0I3OQmoAPAs5mNtHLNxT3Qj1z9bX
c5s6UzB6WCg2mKb/Irh0+FS8x5FZrT5FgE3RlkI8CGpTwdY23cAKSX0orXYCrl1w
kKctB51L3GsBRmQAaMfw
=rV4s
-----END PGP SIGNATURE-----

--G2d+m75Tjo442KmM--
