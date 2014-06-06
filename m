Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbaFFIRw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:17:52 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52176 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFFIRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:17:48 -0400
Date: Fri, 6 Jun 2014 10:17:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Richard Yao <ryao@gentoo.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140606081726.GT6758@twins.programming.kicks-ass.net>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
 <20140430215606.GD17745@localhost.localdomain>
 <20140507164014.GB16034@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pd495SECmvzXpBRb"
Content-Disposition: inline
In-Reply-To: <20140507164014.GB16034@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pd495SECmvzXpBRb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 07, 2014 at 06:40:14PM +0200, Ingo Molnar wrote:
> Agreed, that's a very good point.
>=20
> Also, consider the following holistic argument, what is easier to=20
> achieve, when looking at an oops and not seeing the bug:
>=20
>   - if only I had more information
>   - if only I had less information
>=20
> we cannot put in information that we cut out, but it's not=20
> particularly hard to skip overly verbose information in most cases.
> =20
> Yes, there's a line to be drawn with verbosity: scroll-off is a=20
> concern when the oops does not make it to a log file.
>=20
> So I don't really know.

So it really stinks its so hard to debug laptops, and it doesn't help
the ehci debug dongle costs an arm and a leg.

Hopefully the EFI pstore thing will work out, but I've already heard
that can wear out very quickly and render your machine a brick :-(

Me, I simply refuse to work on machines if they don't have a serial
line, but in general that's not a tenable position I suppose :/

--pd495SECmvzXpBRb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkXkWAAoJEHZH4aRLwOS6h8gP/At7ksJPLulxaZAb4ruWbxPr
9+Y5gGnT/QEctyT1E8doHs3SBiKXmCjdq87GG78XTbwfzltC+NsJcB6eh7ClkPsn
YG0JGiekhAPa3sNFGxpvH2Yg3+JhihBBT8RSQmRFHXX9lGvllIQaAMniLSyC3h6w
8mnZdOR7O4crkUG0xEKvauWD8Fxh9KMVzoYjziXpv1AKYWRZzVnZ59coO95bZrte
g/8LjxfCQ4oFQ1kUeG2U4dpEGogXQ/xMyMrk1uvIrvBarStw4ObwFfMnhxPB8gel
GFBZUG705tV/MKABJNlsvh2DmzPrkNq56uxyxrX6ZpYgvM/blwZ+wDDWLdk+CXqO
ZIWBwUbIiOOZztLvCre4VEyzkV5k9nWHGNd7yi3d0Vhu5m89MWuiNjq4N1xlEwzr
pE5Uri4MT4eoIvZoCL4IMDoT/Nj3u9iNwoKJCVRnXvG6YxCtKFNwghHh1EmKsz8q
va9JfN/DHmd/QVq/ABTcU5swguXTQwN5ezGZ3KlgXfP49cdau8FI3LBD9JCEE0OQ
cC081Q4kwbUAmfWJ+FB86qdoW8oy9VPNC6SXW3nOG2M87g80eo4I4h3wRujyoLMV
Y3zryey83XjtjlXVenFK52Zj0v9WdVciod9JcJkkXyItAVjvvKVi7+4ps7KTJPE0
1VxvXj/28sfNBqaTjwzB
=6IhC
-----END PGP SIGNATURE-----

--pd495SECmvzXpBRb--
