Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862AbaEMKAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:00:22 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758818AbaEMKAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 06:00:20 -0400
Date: Tue, 13 May 2014 12:00:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: perf,tools: Remove usage of trace_sched_wakeup(.success)
Message-ID: <20140513100011.GV30445@twins.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <20140513072208.GB7980@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i7ycZtlzmcz6MFrW"
Content-Disposition: inline
In-Reply-To: <20140513072208.GB7980@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i7ycZtlzmcz6MFrW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 09:22:08AM +0200, Ingo Molnar wrote:
>=20
> * Peter Zijlstra <peterz@infradead.org> wrote:
>=20
> > trace_sched_wakeup(.success) is a dead argument and has been for ages,
>=20
> Always 0, or random value?

always true, we couldn't remove it because it would break userspace :-(

--i7ycZtlzmcz6MFrW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTce0rAAoJEHZH4aRLwOS6SiIQAJEVJwTljLaSqkSWwMXmqj7k
WnFkrEwlkFr7ULaVqn/z+JYPVdVT++W7vd4enTfZJJfubqSXngSZH6vJ4mCXlgI8
z/V8Zd0K9FlFbQqIa/2niDzmQIE+cUynG2VJWWDeoGpAs3B3IqtQPCzLhZmqaYre
ui4rFTOtceGEZYWUjK7drVJQFrDSKVhjra5zEnGbXh3xuzPqF2TFHoRYAI6PAlCl
T3Sv0CTbtJtl10Yw2nKgOfCSTVn7CiMtdowFyQ4zDhoXtl5oyCvSqmpKL6JmHuUe
nGKuvEA/oV+ROJDZCUO4SXPtHJUvuyfA9mUeXv6s6JP1bT+vx8fpHoJKaiGx6r09
JBFfxszRrooSzrsYMXhWHR1vLt0OJH91FSy2RzsLU+DFr5MT58U/gZidEn7dG8Zs
7isUcyhFaBx2dmBPlnKlCSZf3nZYHkW0KYPy8RgLTozlEqKCQiEETKFITbrpFkiV
zFTcLm43EMYNfJvAFnEJJrpdo3yQy6rFrID1+n5M1FtiHNMolnVyP2UtcRhljt5t
41uc5oFuMoWsp1O6oUZY74bhWrVKkC6/YmWDYXgmKiscgPfXBB+822AnTkBZKkPE
jzb+dXldK6Ja6BqvO1uHDAEZYN0P1g2Mc6qh6gNaqzxojQvHa89NG4a+1R/mjBtd
f/L/CqO3YQYiNuNfPqk1
=Ok2/
-----END PGP SIGNATURE-----

--i7ycZtlzmcz6MFrW--
