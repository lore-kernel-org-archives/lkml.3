Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbaGBPnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:43:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:33104 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaGBPnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:43:14 -0400
Date: Wed, 2 Jul 2014 17:43:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] perf, x86: Revamp PEBS event selection
Message-ID: <20140702154307.GM19379@twins.programming.kicks-ass.net>
References: <1403910612-8754-1-git-send-email-andi@firstfloor.org>
 <1403910612-8754-2-git-send-email-andi@firstfloor.org>
 <20140702122902.GC19379@twins.programming.kicks-ass.net>
 <20140702153407.GN19781@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XigHxYirkHk2Kxsx"
Content-Disposition: inline
In-Reply-To: <20140702153407.GN19781@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XigHxYirkHk2Kxsx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 02, 2014 at 08:34:07AM -0700, Andi Kleen wrote:
> On Wed, Jul 02, 2014 at 02:29:02PM +0200, Peter Zijlstra wrote:
> > On Fri, Jun 27, 2014 at 04:10:11PM -0700, Andi Kleen wrote:
> > > From: Andi Kleen <ak@linux.intel.com>
> > >=20
> > > As already discussed earlier in email.
> >=20
> > Is an entirely inappropriate start for a Changelog. Do not assume prior
> > knowledge. If its relevant include it here without reference.
>=20
> Thanks. Do you have any other comments?

What Stephane said ;-)

But also, I think we should conditionally allow the filter bits;
possibly with a sysfs file like I had.

Back when we had to sort that SNB cycles thing it was tedious that Linus
could not just try things.

--XigHxYirkHk2Kxsx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTtCiLAAoJEHZH4aRLwOS6hvkP/AnQ9W7PFC8NOdo8MRdcUEbl
spBd7QOUDLDbRFQ2eqTqNQJ8ZN2O7FeBE0TMmoBtyS8oo5R8mmyjU2ME5Ro/rX96
qd08GcPP5t6cHO41yvw+xzCa6usz/BmgRQYeZAvK8qcDlySlc+r85+onNkaCZ0yD
bpFoOuKCxNXitHnyAEkAVLxp2IiVe5kPNi7BoPJZd2G9v9cDC393sAIQVGLtAOvF
0yRDt3fsspiw00NSdL66AE1UK7lvwz9voaVuH6O8/MAsGReDclTvzo4r+1O5TcC5
Z9mw4WkocFSB88g13r3XUO4Wc4Ldck7T1aRZLtZKJWfzVe8pxfanfq1Xo4XnqPHl
v6fOC8WRbeukRhOCskerI0dcnFg+tDOyr3CBR1Bv7ubr7YTiBywcTyZKk8DiXDcd
1DOAR7/i8jA0LlP5M1zfde26LKINmcCM0JpaubObjlsFkfL2ndLU/5VqfBh7Og8k
kbsS+pE95tOjcwHt2RR0oMa6ndjWDUoKk9t7diQUEjyPjDF+3ApojqyA4YdPsqGn
ODYf36uJhh7sC/kAM8Dop0HIrGvWYTArwoz2OuDc9SH6BY79zitudxDh9Dk9tCiO
zJ65bYRqD4hsjKmSrWt0itagXKghQSnkzl6krW451JqGIlpMIvxvejUp8RnLy/ND
8YZK1sgr7dSLTwCXQLps
=3BiY
-----END PGP SIGNATURE-----

--XigHxYirkHk2Kxsx--
