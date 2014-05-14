Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044AbaENQ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:29:54 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51645 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703AbaENQ3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:29:52 -0400
Date: Wed, 14 May 2014 18:29:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, acme@ghostprotocols.net,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>
Subject: Re: perf: use after free in perf_remove_from_context
Message-ID: <20140514162943.GR30445@twins.programming.kicks-ass.net>
References: <5370EBE9.6@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="U50CbOr64UnCgK/4"
Content-Disposition: inline
In-Reply-To: <5370EBE9.6@oracle.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--U50CbOr64UnCgK/4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 12, 2014 at 11:42:33AM -0400, Sasha Levin wrote:
> Hi all,
>=20
> While fuzzing with trinity inside a KVM tools guest running the latest -n=
ext
> kernel I've stumbled on the following spew. Maybe related to the very rec=
ent
> change in freeing on task exit?
>=20
> [ 2509.827261] general protection fault: 0000 [#1] PREEMPT SMP DEBUG_PAGE=
ALLOC
> [ 2509.830379] Dumping ftrace buffer:
> [ 2509.830379]    (ftrace buffer empty)
> [ 2509.830379] Modules linked in:
> [ 2509.830379] CPU: 47 PID: 43306 Comm: trinity-c126 Tainted: G        W =
    3.15.0-rc5-next-20140512-sasha-00019-ga20bc00-dirty #456

Any particular trinity setup? And would you happen to have the seed of
that run?

--U50CbOr64UnCgK/4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTc5n3AAoJEHZH4aRLwOS6ERsP/RVGMA/gmN90F7/HQgf2jBrm
uVqWKGrPePqrfb8Pu+RMAemylajvBi9J0CTWPBOEi0HECtFIcs6wurGsXD0VXCrc
5OXqVlxMmvawqFN9khPOfzU/lacIDtf9735Cxubx9iNmxGkThlORvQ0s9U0GXG5z
6Su8hOMvrJHjfrDBoVYEmDJIkKSf1J4kvOG4pQG0bL/tP9WJvXanrvldlWtp+Drm
evwBerfUjIirqlKPGnUFbJLBOZlho9l1Ab4srR+4Vj49IZ2Sza3TTuIZx6vrwzhP
UyfKLdIueamKtH2fhIy1CZVBQF2vBLAixFRufT96ZJgT6EsqgmNuGoUNvFHoh/Af
FWDTD1bLODy9pL0HnXw64A4a1JfzLuBk55iKQEBcMVspy5+xg9hX9VbuOhbglNxC
RrqUYSJ+I+lqGN9lyyWhCWFzsZ5YWPWM23qKGn3/h9fUcaFN1GGgLoq8VRCEo0uI
FCX5sTUFeMt6d38ilTr96h996lPJBGs4qP5TQ3vLWVgf+Hix+DEkeXli+qbib9yp
7+q0J9ywIUeXsEMPwCYkOIYuagClKOz9N01VgfSrssL4Xbl4yXS832S+r81AA0Xy
BO3jthQbrfjkbzK85SvByt12X3pTj0taG584IB8rMfy4wZ2yswXyENx5Y2uhZT2j
u/6KS+CxW3KLcjOw6BT/
=HDn0
-----END PGP SIGNATURE-----

--U50CbOr64UnCgK/4--
