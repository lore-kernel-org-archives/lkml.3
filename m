Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751162AbaG1Qmf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:42:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:59863 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbaG1Qme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:42:34 -0400
Date: Mon, 28 Jul 2014 18:42:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Waiman Long <waiman.long@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
Message-ID: <20140728164223.GS19379@twins.programming.kicks-ass.net>
References: <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
 <20140724064353.GW9918@twins.programming.kicks-ass.net>
 <20140724084126.GB19239@pd.tnic>
 <20140724122513.GM19239@pd.tnic>
 <20140724125814.GX6758@twins.programming.kicks-ass.net>
 <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
 <20140724183643.GM3935@laptop>
 <53D16EC4.1000801@hp.com>
 <20140725161002.GE6758@twins.programming.kicks-ass.net>
 <53D67C3A.1060401@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/rZOC7/CNMPM7mYb"
Content-Disposition: inline
In-Reply-To: <53D67C3A.1060401@hp.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/rZOC7/CNMPM7mYb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 28, 2014 at 12:37:14PM -0400, Waiman Long wrote:

> I am planning to take out the check in check_deadlock and only have the test
> in lock_acquire which change a 3 to 2 when in interrupt context. Now my
> question is whether to do it as a new patch on top of the existing one in
> tip or a total replacement. I also intend to use symbolic names for the read
> states for better readability as suggested by John.

Send new patches, the patches magically went away from tip.

I don't care too much about the symbolic thing, partly because the
actual value is not irrelevant seeing how we're peddling with bitfields.

Also, its an unrelated cleanup at best.

When you do re-submit extend the locking self test scenarios to cover
the new semantics as well.

--/rZOC7/CNMPM7mYb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1n1uAAoJEHZH4aRLwOS6hYoP/3fPQIZsEJw7YIwZ5Jash2NO
415PgeWTPkXAhOb3Sx8d4BeTSGsNnRzpT7HxoW9v0i5sSagxgAoB0oiha8A6Xd/i
RY61eRA123K1MAhoGzb6K5ZuNGcGD8TsO/nY4tWmSJrNnsLIlNzgTnQDpf7/nVTU
VEkFenrCwAS4/Z/WP65Qmcn2FJoai0WgQD23GNQ34Saf4qVuvQsaOAHfnJEnR7wc
pvtI+Ob0fKYUXFK52mluChb4t/Cj7dfuiesw7xuSC3hAI3YWgZB3R4XnK1KMMQNh
VvKf8teLMSY8m0NLJKs2sq8NDmHx+ycIxiOi/KZ5BY2MAWhSW7X5+ogiRUpl0JQY
xQ/OAPzelERRKesIEiIpkI2k7pqYnRJ8299HeYQxmEYVJi5kkqjQpJyiFcB45unq
mTBGD2rPtw1GsHe0OmDAzSm6cGk9EH/mgdD6aA5aHM+2ijJgwdb2ee+lCuxvWixq
tYRPvVe4sT7prz0uMoLnJyil958Xws71tbrmUVNfD+9EpUEXa/ai7mGPWDHSFjme
3Gdm7MRhJMb1cghzEh+1hhPIe0Oh2dQbWoTCAm3OVXFBraYK3wYPhCbuq91hqhCK
lU/JrbaJxB7Ex7+sBvN1oChSTCdzTX6ArpXzmtHWKHMj8dxmUq1GT5P+OuMUK2BD
qICmhTnhjENpoev0gd4k
=pOkj
-----END PGP SIGNATURE-----

--/rZOC7/CNMPM7mYb--
