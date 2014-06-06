Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396AbaFFJgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 05:36:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaFFJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 05:36:21 -0400
Date: Fri, 6 Jun 2014 11:35:41 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Richard Yao <ryao@gentoo.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, Vineet Gupta <vgupta@synopsys.com>,
        Jesper Nilsson <jesper.nilsson@axis.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, kernel@gentoo.org,
        Brian Behlendorf <behlendorf1@llnl.gov>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH] x86/dumpstack: Walk frames when built with frame pointers
Message-ID: <20140606093541.GN3213@twins.programming.kicks-ass.net>
References: <1398535818-14217-1-git-send-email-ryao@gentoo.org>
 <20140427120820.GC22116@gmail.com>
 <20140430215606.GD17745@localhost.localdomain>
 <20140507164014.GB16034@gmail.com>
 <20140606081726.GT6758@twins.programming.kicks-ass.net>
 <20140606082420.GA28241@nazgul.tnic>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R92lf0Oi2sxyK3LA"
Content-Disposition: inline
In-Reply-To: <20140606082420.GA28241@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R92lf0Oi2sxyK3LA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 06, 2014 at 10:24:20AM +0200, Borislav Petkov wrote:
> Well, with all the other crap they put in modern machines, how hard it
> is to put a goddam stupid serial line out everywhere...? WTF do I need a
> goddam adaptive keyboard and other idiotic bling-bling if I can't have a
> simple serial line for debugging... Blergh.

This DE-9 is not esthetically pleasing :-) They could of course use a
different connector, its only 5 wires or so iirc.



--R92lf0Oi2sxyK3LA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkYttAAoJEHZH4aRLwOS6oMkQAJ6rmgdnJ14dQ6oaNGiVytvL
Bl6YLDAeUJsL4LmH1qwhLMm+Lar73/sLKC2WgnbMvorqgGBenn7rPas6uF/eOg0U
8Ia1cxum+csuof5evB4hp1UiPShah9yqM6Wshd4HiyA7P165L4HRVOUxd5uV35O2
FqBdQgUVlBL7ukUuFeyRdqb9o7m9aqVY9Y8X4p7Q6jSPAMOJV9nvgU6qbK9jgdim
ea7SZ9Ytfgefokp9fFNUibEphokg5t00qwkbJaG5gDP3dow03xVMY0DW/3RJ2aJE
TFQR9x0oC/pa3l1s3TX6dLncpyugIfglgQdbrZwCPltVM3p2nKVs0dqbTXUiN13y
9UgQRIM6QX6hSAyA+Y3Bp3KRDUH6dTnt0IqU3lP2vaoJ11ESiHdeFfKByDiZwDJH
SMyFNo64NWUJF3182lWNOxcebmKUyHTLOvS71YB58RyjTQssNKGHISwIPTOJPlj9
TzGZMDdAM0bnTeaXocw6xXk9nnFQeANPR7Q1LCD7zu0Vm/kgr0XiLxAsm1QItA7E
Yu3MINnq6N+0WYbBuiXc91Ee9AF8hrgSTmSm8q08bjQMHkoj6Gd3UHV/RcLnCUb/
UQUaNXSGORG8SDR8uexdo4WZNcx/4OOQAtQZ699NJSgnhkllLEOmuJoujAdw1IJl
LHHHB+BDPtkiKAKUpiCs
=aQV7
-----END PGP SIGNATURE-----

--R92lf0Oi2sxyK3LA--
