Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbaEWQVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 12:21:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36377 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaEWQVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 12:21:30 -0400
Date: Fri, 23 May 2014 18:21:15 +0200
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
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        davem@davemloft.net
Subject: Re: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor
 macros for writes
Message-ID: <20140523162115.GJ30445@twins.programming.kicks-ass.net>
References: <1400777250-17335-17-git-send-email-will.deacon@arm.com>
 <537E30AF.4070501@zytor.com>
 <20140523144604.GF21319@arm.com>
 <537F60E0.1060307@zytor.com>
 <20140523145758.GG21319@arm.com>
 <537F6728.3090600@zytor.com>
 <20140523153409.GI21319@arm.com>
 <537F6C85.107@zytor.com>
 <20140523155626.GI30445@twins.programming.kicks-ass.net>
 <537F736F.4070002@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4zpRouf6TsWqWFjU"
Content-Disposition: inline
In-Reply-To: <537F736F.4070002@zytor.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4zpRouf6TsWqWFjU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 09:12:31AM -0700, H. Peter Anvin wrote:
> > So the one issue I had with that, is that if one tries to send an
> > email to all arch maintainers + linux-arch + linux-kernel, the
> > header gets too big and vger chokes and davem slaps you.
> >=20
> > So while its possibly desirable to do big unions with 0/xx and the
> > like, its practically infeasible.
> >=20
>=20
> ... or at least requires the use of a particular advanced technology
> called Bcc:.  Not that I like Bcc:s, mind you, but it is probably
> better in this case.

That's actually a good idea, I'll use Bcc next time.

> I have no idea how smart vger is, but it would be interesting if it
> could ignore addresses from the MAINTAINERS list...

I suppose we should ask davem, although if such a particular loop hole
were known it might get abused and we'd all end up with more email :/

--4zpRouf6TsWqWFjU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf3V7AAoJEHZH4aRLwOS6OSsP/09cbytBwxUUP3FTGWtxDoE2
J+cYI9RJR3w/H0eESPMEw2gmNiFA6YV4xCzioz7uv7B0RipeTRyhxfGM9dsT0nIr
MKYY3QpMc7u8LJcmcQCZ2Fx37LiEu5XWV/p446lRxihgMAVWYYiP8KzzF0wrNpvr
2gMvtdLfXLSkhIJN99CzOaNCwkWaHmfG+gqTg++p2owcU/9ax5hQwrdyvJpLKkVN
sBeYqbxeNn7XOB08yZ61EUmpJlWAdVBBlq4GugQZto6MhyvMyNQkuWwCzegwxKAM
9IiznNoa3jWDbonBOyeNtq1fG6O56bZm9MblBvvmPk0BAA8CVl2dglpR2gt81cnQ
RtE1i+EmeOQv89uZ/JxKcBGmVxmpT+TlevoSiJtuexr99uVELlLTtP5rOHUCY+FT
RgGkdcJSWl+eoL0NDV8RtxdQxjCxsyo4AbvNHl9gfV/0bOsusUDaGKNstJyF86/j
mTWbctcm8KIOTySGaiL2JkoPu7dCnsmE5npJzTrLZmo1gzOKoane1/BQYvc3Sr4d
cr25D0Af2syYwNOGZNBzJbaZcNDDBe1SUQOu4pBPoapFvbV74xPUKF+F1O8LhGQf
6X+Tu767OoSA+fpRqfRy1fuvtjNt0aqtwMYkuuSGgjjcWPdKGGvTDDae415vqig3
QmkwIYEPKVbdiHs/kQak
=OBIj
-----END PGP SIGNATURE-----

--4zpRouf6TsWqWFjU--
