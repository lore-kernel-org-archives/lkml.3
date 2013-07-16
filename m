Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab3GPCAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 22:00:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39410 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753466Ab3GPCAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 22:00:41 -0400
Message-ID: <1373940029.31067.99.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 03:00:29 +0100
In-Reply-To: <1373916476.2748.69.camel@dabdike>
References: <1373916476.2748.69.camel@dabdike>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-55LGVEgZqBWcUrNLRO6n"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-55LGVEgZqBWcUrNLRO6n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-15 at 23:27 +0400, James Bottomley wrote:
> Before the "3.10.1-stable review" thread degenerated into a disagreement
> about habits of politeness, there were some solid points being made
> which, I think, bear consideration and which may now be lost.
>=20
> The problem, as Ji=C5=99=C3=AD Kosina put is succinctly is that the distr=
ibutions
> are finding stable less useful because it contains to much stuff they'd
> classify as not stable material.

Well, some distributions may find that.  Some distribution maintainers
have taken on stable branches, officially or otherwise - Steven Rostedt
(MRG), several Ubuntu developers, and myself (Debian), and of course
Greg was working for SUSE not so long ago.

Myself, I suspect I've been too eager to backport fixes to 3.2 and that
this has led to some avoidable regressions.  I hope I'm striking
approximately the right balance now.

> The question that arises from this is who is stable aiming at ...
> because if it's the distributions (and that's what people seem to be
> using it for) then we need to take this feedback seriously.
>=20
> The next question is how should we, the maintainers, be policing commits
> to stable.  As I think has been demonstrated in the discussion the
> "stable rules" are more sort of guidelines (apologies for the pirates
> reference).  In many ways, this is as it should be, because people
> should have enough taste to know what constitutes a stable fix.  The
> real root cause of the problem is that the cc: stable tag can't be
> stripped once it's in the tree, so maintainers only get to police things
> they put in the tree.  Stuff they pull from others is already tagged and
> that tag can't be changed.

Sure it can.  Subsystem maintainers can reject a pull request and demand
changes that include rebasing.  (But only reasonably for leaf
repositories.)

> This effectively pushes the problem out to
> the lowest (and possibly more inexperienced) leaves of the Maintainer
> tree.  In theory we have a review stage for stable, but the review
> patches don't automatically get routed to the right mailing list

This is a simple matter of programming.

> and the
> first round usually comes out in the merge window when Maintainers'
> attention is elsewhere.

That is a real problem.  It's also a time when those changes have not
had much testing together.  (Yes there is linux-next, but I seriously
doubt it gets as much run-time testing as mainline.)

> The solution, to me, looks simple:  Let's co-opt a process we already
> know how to do: mailing list review and tree handling.  So the proposal
> is simple:
>=20
>      1. Drop the cc: stable@ tag: it makes it way too easy to add an ill
>         reviewed patch to stable
>      2. All patches to stable should follow current review rules: They
>         should go to the mailing list the original patch was sent to
>         once the original is upstream as a request for stable.
>      3. Following debate on the list, the original maintainer would be
>         responsible for collecting the patches (including the upstream
>         commit) adjudicating on them and passing them on to stable after
>         list review (either by git tree pull or email to stable@).
>
> I contend this raises the bar for adding patches to stable much higher,
> which seems to be needed,

I think it would be an over-correction...

> and adds a review stage which involves all the original reviewers.

...but this is important.  Also, I'm not convinced that the current
standard review period (48 hours starting whenever) is really long
enough.  Especially when there can be 4 large series at once (for 3.0,
3.4, 3.latest-1 and 3.latest) or even more if other stable maintainers
start overlapping reviews.

Ben.

> Oh, and did someone mention plum brandy ...?

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-55LGVEgZqBWcUrNLRO6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeSpPee/yOyVhhEJAQrVWw//eHzU2XAyHhuzaVgFlNP7ixt7dYzJZruF
3fAawW56Ltn7eZlXRE2E5VTxIs2lqS/m46yR586uVV+E8hUxTHxGWCfJmaRYoBWx
Y9VjAhYJKd0ZeNykR+p3A3KvTy34QkW+AzWczInaNjDU6R/PJ9yrQIiE6Hcxed1M
Ttn3QLKB2vRRmh0QRP1ucO3/LcQ1SMvRa/QvbcaOcynl4iPEKBH2k9v52YnJHmPl
McfItxq0MQogRIL1z741E9mYHKjtNZW23DQbHnj/+EgokOfvMw//OtxB1zRuS68D
r3MuWJe5aXwF+k9dagBe09lX9sM/4vGOKL8yWf1eC3cYedNkSKzXSz+4fxLW3LMG
LnuPtWJoQULNsLginXerC6+asnQwQbj0qigZXw7GIKW2SQbG5CnucVEPj18UcnbR
DJn6DPtwjvYqdB4yFaWsWIHW+oCnL8oRejL9JL5aivEhs9rqRx2As6CBmENemM4k
ryqJzWxqukJUQeXIoEBaD5IpNaQBKkkrS2+qbx3m7drUbWkUgMe0hCEfc+eRslXo
SJGn8o80w8DTvKyb+ij72KhyLGIUlK/1AhN1/M0Z46oe7Xdq9bNcKEQmc5k4Xv6L
SUi2O9Xryia6rEizUkU7yFilLK7M9H1Daxxce/DNLFdvfZ/lh2tfbTYKGzmO4ord
FuHtOjVW0nM=
=NosU
-----END PGP SIGNATURE-----

--=-55LGVEgZqBWcUrNLRO6n--
