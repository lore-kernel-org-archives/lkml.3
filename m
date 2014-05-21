Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077AbaEUJZd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 05:25:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59920 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaEUJZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 05:25:32 -0400
Date: Wed, 21 May 2014 11:25:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>, acme@infradead.org,
        jolsa@kernel.org, rostedt@goodmis.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_tools/sched: Remove nr_state_machine_bugs in perf
 latency.
Message-ID: <20140521092523.GG30445@twins.programming.kicks-ass.net>
References: <20140512181946.GG13467@laptop.programming.kicks-ass.net>
 <1399945101-21736-1-git-send-email-yangds.fnst@cn.fujitsu.com>
 <20140519115957.GF5027@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yemHoCqAZaCul8x8"
Content-Disposition: inline
In-Reply-To: <20140519115957.GF5027@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yemHoCqAZaCul8x8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 19, 2014 at 01:59:57PM +0200, Jiri Olsa wrote:
> any ACKs?
>=20

Acked-by: Peter Zijlstra <peterz@infradead.org>

--yemHoCqAZaCul8x8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTfHEDAAoJEHZH4aRLwOS6c6cQAIXr7m4AX7RIpD5g/kfcL6aQ
XrSgrk4oMBuZ7t3Z1KDuigtyo8b+4mf2phxoqWuaQH2+dC1b6kTdOvvPtD/BP9Qd
u5ceKtJG17CFEOMvuQgupctG17Ek7cnqbYsdcCdLFQ8Vh9pQ8K+DyJosDw6D+18g
F5GFT3CTdjr6+yyQzTOsWqlnKx5HVcXnRuOHymvQV3LdX4CDnjZP71JjC+3AjG2v
ufqtWQPV3sATvXKZIz9yBGJQsGRzhvx2W6zttPPa0+lr9HRThm2XqGSkS7SbxqPj
CZrbHbngUdfcD8y02zKez/PfNkiak9/2IFcQJ58iNqm5v4NCF7UeCRt7VFg/5PtC
gI+mitAljiS154LIlQNTNNfnOd6AsVDSjeKkJwT0CUIRDYnLlJLl1LgIhx2wAwt5
P6u/MAfAskgwzf8b8R9aGMFXjJHBCD7tbYLVyyBRHHTsFKlGwOG/2Qh8Xc6K8Z42
c8+mp1Lw69/NjZEuo16phe/uOGUsLDSPNXgyWTWPiw5qb+NJJjCc2+41A3wE8/Ek
RxlbrHIXWSsfj14eIUzQWmwkUe0/EkoPzVGSl3FaB2BefJCkM8cdiUxiJs8FhxaE
TSvrB89uKpSL4boi4Al564JyPLt4rN3eRNFnlpr6bEdbS7HF0ZncQK7wHutalkyG
xC3f1/+nheceYruaDWnb
=tzn5
-----END PGP SIGNATURE-----

--yemHoCqAZaCul8x8--
