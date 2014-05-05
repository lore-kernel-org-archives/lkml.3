Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbaEEHrs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:47:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:54024 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681AbaEEHrq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:47:46 -0400
Date: Mon, 5 May 2014 09:47:36 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Juri Lelli <juri.lelli@gmail.com>, Dario Faggioli <raistlin@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        rostedt@goodmis.org, Oleg Nesterov <oleg@redhat.com>,
        fweisbec@gmail.com, darren@dvhart.com, johan.eker@ericsson.com,
        p.faure@akatech.ch, Linux Kernel <linux-kernel@vger.kernel.org>,
        claudio@evidence.eu.com, michael@amarulasolutions.com,
        fchecconi@gmail.com, tommaso.cucinotta@sssup.it,
        nicola.manica@disi.unitn.it, luca.abeni@unitn.it,
        dhaval.giani@gmail.com, hgu1972@gmail.com,
        Paul McKenney <paulmck@linux.vnet.ibm.com>, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        linux-man@vger.kernel.org
Subject: Re: sched_{set,get}attr() manpage
Message-ID: <20140505074736.GZ11096@twins.programming.kicks-ass.net>
References: <53020C9D.1050208@gmail.com>
 <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com>
 <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com>
 <20140430130937.GH30445@twins.programming.kicks-ass.net>
 <20140503124355.5d927080518051ca507bc381@gmail.com>
 <536735E0.7020204@gmail.com>
 <20140505072114.GY11096@twins.programming.kicks-ass.net>
 <53674094.2020307@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e5bfZ/T2xnjpUIbw"
Content-Disposition: inline
In-Reply-To: <53674094.2020307@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e5bfZ/T2xnjpUIbw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 09:41:08AM +0200, Michael Kerrisk (man-pages) wrote:
> >> But, in that case, I need to know the
> >> copyright and license you want to use. Please see
> >> https://www.kernel.org/doc/man-pages/licenses.html
> >=20
> > GPLv2 + DOC (not v2+) sounds good.
>=20
> I'm a little unclear here. Do you or don't you mean
> https://www.kernel.org/doc/man-pages/licenses.html#gpl
> ?

A variant with out the +, just like I do my kernel code, no greater gpl
versions. However,=20

> (Note, I'd really prefer to stick to one of those licenses
> (without variants). (My personal preference is the "verbatim"
> license, which is the most widely used one.) There's already
> do many licenses in in man-pages...

Verbatim is OK with me I suppose. Its only text after all, who cares
about that :-)

/me runs for the hills.

--e5bfZ/T2xnjpUIbw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZ0IYAAoJEHZH4aRLwOS6Ob8QAKQtWPqArQKnlVJ+Ghvw3pqe
55Qo2do1MzM8NUGZ/lkGYReqtspIyVD6llhYLq44h818vF1lQgrE9tKG9kLDXdtI
zDfnqak8XEBRjq2Xu+aXBdTrJtX8Soy+jpGirjcUm06nHWBoYMytLc1nuPzPLuhE
9UjW/6Dhc6ijpCB6T7EpSjlf7ceCE0I0clMi68jmV6AI9+jwl4QzV9likh1/iqKB
G5JoII0qngenSYPP4z2d1yr03KV/JADSB8EFtY1GD9uS3oY+Ym19mBtB6mNfwQ0Z
W1XTDbkuL9jvb4LdMcbwRJxFeQ78bXHQKTl7WHpXms3Jt3MCkjv/w8dUd6uOk/bk
LHQWxSHWKhpTjAgc6LwItilFER+gaP3rea1meuq8MMl2SeKMpzQLY+xPl82n8I7P
6fFvmVFW/q5hj5M6GYDNgpdLLxritYmvexLpUj30umS7LpPLwzvUR4gifrtByznM
L/WKQn1ajbPsvxptfs6yiIOKcC5bPb2fVN9wvC7a80szPj8h4QODqtcTwZ/xpsPf
LdlODf/5z7xS2oMYww449nGApbn/OJ7z1WoF8w4+ymB6pY0s6cdvLpVq8cstP/mH
a4ofv1yzt3WyFHT/aNH4SScHCdi2SRrgQNOMynUyR/tS1I1zCzkfWnpe4X8ohTso
/nerT4RSFwvnNPb1RlR6
=nK7j
-----END PGP SIGNATURE-----

--e5bfZ/T2xnjpUIbw--
