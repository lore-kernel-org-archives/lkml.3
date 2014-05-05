Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbaEEHV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 03:21:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60287 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660AbaEEHV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 03:21:57 -0400
Date: Mon, 5 May 2014 09:21:14 +0200
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
Message-ID: <20140505072114.GY11096@twins.programming.kicks-ass.net>
References: <CAKgNAkgw+U44SH0wd_06ZMXaCC9nCX4NZxZHkMKUdC7E7YxBhQ@mail.gmail.com>
 <20140214161929.GL27965@twins.programming.kicks-ass.net>
 <53020C9D.1050208@gmail.com>
 <20140428081858.GX13658@twins.programming.kicks-ass.net>
 <535FA467.2070403@gmail.com>
 <20140429160441.GU11096@twins.programming.kicks-ass.net>
 <5360D9E5.9080206@gmail.com>
 <20140430130937.GH30445@twins.programming.kicks-ass.net>
 <20140503124355.5d927080518051ca507bc381@gmail.com>
 <536735E0.7020204@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8bBEDOJVaa9YlTAt"
Content-Disposition: inline
In-Reply-To: <536735E0.7020204@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8bBEDOJVaa9YlTAt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2014 at 08:55:28AM +0200, Michael Kerrisk (man-pages) wrote:
> Hi Peter,
>=20
> Looks like a good set of comments from Juri. Could you revise and=20
> resubmit?

Yeah, I'll try and get it done today, but there's a few icky bugs
waiting for my attention as well, I'll do me bestest :-)

> By the way, I assume you are just writing this page as raw text.
> While I'd prefer to get proper man markup source, I'll add that
> if you if you don't :-/.=20

Well, learning *roff will likely take me more time than writing this
text + all revisions so far :/ But yeah, I appreciate the grief.

Is there a TeX variant one could use to generate the *roff muck? While
my TeX isn't entirely fresh its at least something I've done lots of.

> But, in that case, I need to know the
> copyright and license you want to use. Please see
> https://www.kernel.org/doc/man-pages/licenses.html

GPLv2 + DOC (not v2+) sounds good.

--8bBEDOJVaa9YlTAt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTZzvkAAoJEHZH4aRLwOS6dioP/3vnUKo7cZ4mjrphiaN1YzqV
a/YdxCb3LJ1XbNFr/eTW/XB1MGaXm8lWEI5CwKIM+2QnYJd2NNUa69DY3H1wAWBZ
YDr5Tg9CH2LN7+bvPLE2UD+TS+MOOvMfS3A3bWZ3HByru99eOouarQwLYA8FXsPf
wnql/6FcULcpuBen1xeZVusoljMoA8UbhbsrQ8InNYiFSBeoUDThDoNv9vIhSGov
UksHZeRckZBNOFxTVJVCPf73o5/mXDYoJTZ3D+8WWO99pCeEsDfpo+VTquCxsNo4
BXi5xCbH0YuAEyQBgkPwcwUWE1sjK35RPQpWXC303FcpM0iNJ4yKycyMEFtcaj2z
ZMBlHnTNXTnLZFN2qPfXUEqqfeCbV04seJgeDHWUgqTiDDRZABa1e8Y2OamhFnJC
rCA1SmE1/ejZwh+hj5CFLZlwLiLjN0sxRhMSuOgGTQmoME+SNJBlsG6iLPHDtSlM
EC7AFKGe9PdGiCfwO3loLQXmE4MfTCp0YPCkrpT/XL+f4WRzm+6G0IQt+X4pGnyR
s9IpSFujEdvFVVkUy1hwLSkc8dxos7EnRgTOeI/fuJknFIHQZHsdgdum591bgJ+P
tnTppxET6rZaLwm54LhwM08ZzfhkajVbVwkgidNN3j0aRTJ1zFwYS9lPrXogeVCR
ijKIGCvoaxkQ8SdqWwem
=9Rws
-----END PGP SIGNATURE-----

--8bBEDOJVaa9YlTAt--
