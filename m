Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748AbaELP2Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 11:28:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:35938 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaELP2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 11:28:23 -0400
Date: Mon, 12 May 2014 17:28:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dongsheng Yang <dongsheng081251@gmail.com>,
        "yangds.fnst" <yangds.fnst@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com, bsegall@google.com
Subject: Re: [PATCH] sched: Distinguish sched_wakeup event when wake up a
 task which did schedule out or not.
Message-ID: <20140512152818.GS30445@twins.programming.kicks-ass.net>
References: <1399341154-11785-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140510152902.GW11096@twins.programming.kicks-ass.net>
 <536F90BE.2080806@gmail.com>
 <CA+qeAOr_PrBuo+qfjNoaZyHF21p=8UgQy1oZOjAxahhYTyrvLQ@mail.gmail.com>
 <20140511163531.GG30445@twins.programming.kicks-ass.net>
 <20140511145224.00412e59@gandalf.local.home>
 <20140512064730.GI30445@twins.programming.kicks-ass.net>
 <20140512100908.07cc50bc@gandalf.local.home>
 <20140512150950.GP30445@twins.programming.kicks-ass.net>
 <20140512111748.1c2f6cd9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EzakZlbiokRMC/se"
Content-Disposition: inline
In-Reply-To: <20140512111748.1c2f6cd9@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EzakZlbiokRMC/se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 11:17:48AM -0400, Steven Rostedt wrote:
> On Mon, 12 May 2014 17:09:50 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > > Point being, this is useful information, why not pass it to userspace?
> >=20
> > Because it adds code to one of the hottest code paths in the kernel and
> > so far nobody had a sane explanation of WTF they were doing.
> >=20
>=20
> Is there a measurable difference with these extra tracepoints?

Dunno, nobody tried and reported. I suppose its sitting there along with
the coherent changelog.

--EzakZlbiokRMC/se
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTcOiSAAoJEHZH4aRLwOS6Z30QALI+G1SQl0X+lHCZKsro2LWC
gdEiWTVuWX+/VGfJotyIqFmu5JtgfBTd1hxPcRO2p/5980kGt6HsoyjWNERwZsRv
Q6pOFkAxUZE33gbUCFGGgmQisPzuNG7EWIVZCB2kBZG31DHDvnWFPxQ2NA7+90yV
/l1VYaofSDy7QymJxvyFzTD1GRgeYPJWJ6xlg9FN8fYFrieX2FBfayp8xfvsxE7e
uQGSMSjTU86ue8Ljs9LTQVZnW6E78nvcLfbwFwZjW07lf5s+ebFVvfWjVJ+Jw8y7
x1umWR79UytCbr8N28b2ACuIvISmMfwaGHaZMxkg4KI1lhSo0GooGtHTwHrBFTy2
wU1vw5K2xIcMKb/PKBr9aj8srqgZuEPDBhQLlP42ynuRDIqGXJZDyNwffsZh6LW8
NDONohaXTyhhJ8S5Rq4CFPtR6jtIACF8QNMFAlYmiMs0VWubooX0/Y7GTkJjSxTP
CpdqPSW6vZzhqWbbAkq2AFkvEq9ARk+2wyFsRKcJZdApT1oEH0I1W9N1FbA94AeH
SwW6614aXpTc5+7iWJ/OUAxwNX9fIsNfAhhEdysC/ltk/Uo2iQ1faU8IkvDwD7In
LrqIxY48Q0hJab4HVUwmxUmwDYWRm6IMX6xiv2BRuh8/0wsv3wYBAC+6v8qV3DlD
dQXXdXSy78xgprF411/X
=stGF
-----END PGP SIGNATURE-----

--EzakZlbiokRMC/se--
