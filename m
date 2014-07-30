Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaG3KCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 06:02:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbaG3KCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 06:02:00 -0400
Date: Wed, 30 Jul 2014 12:01:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "H. Peter Anvin" <hpa@zytor.com>,
        "David S.Miller" <davem@davemloft.net>, Ingo Molnar <mingo@kernel.org>,
        Chandramouli Narayanan <mouli@linux.intel.com>,
        Vinodh Gopal <vinodh.gopal@intel.com>,
        James Guilford <james.guilford@intel.com>,
        Wajdi Feghali <wajdi.k.feghali@intel.com>,
        Jussi Kivilinna <jussi.kivilinna@iki.fi>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tadeusz Struk <tadeusz.struk@intel.com>, tkhai@yandex.ru,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/7] crypto: SHA1 multibuffer crypto hash
 infrastructure
Message-ID: <20140730100135.GF19379@twins.programming.kicks-ass.net>
References: <cover.1406033477.git.tim.c.chen@linux.intel.com>
 <1406066972.2970.804.camel@schen9-DESK>
 <20140725070800.GS3935@laptop>
 <1406305521.2970.851.camel@schen9-DESK>
 <1406672905.2970.940.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Np7vk93lNrw824dh"
Content-Disposition: inline
In-Reply-To: <1406672905.2970.940.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Np7vk93lNrw824dh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 29, 2014 at 03:28:25PM -0700, Tim Chen wrote:
> Peter,
>=20
> Is my explanation adequate or you still have objection to the implementat=
ion?  I'm
> trying to decide here whether to extend our batch processing by
> the crypto daemon (prolong our busy period)=20
> based on whether there are other tasks to run.  Pre-emption and
> resuming the crypto daemon is okay. Even if there's a pre-emption and
> context switch in between, we can still do extended processing if
> there's nothing else to run. Otherwise the cpu will go idle.=20

I suppose.. I still don't really like it but what the heck.

That single_task_running thing is hard to use and a weird interface so
lets hope people don't find more 'creative' users for it.



--Np7vk93lNrw824dh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2MJ/AAoJEHZH4aRLwOS61nkQAIz1gqbe+ZU7yU5FayjLIq3Y
pWk3CVoPDOJwi3vnfsn0Pt6KN41UD5nMAl2XL2INHN//HQEVOtYGcHjd4J3tgw4+
cp2cEr/jhttHZf5L/7EDOdp8vkyvjEGOEUp1qp7I6FKmv7L/1yhoFFHvJMBUwUV4
26QQh5JgWowYVF39TfUoFO5iGC7TB6gI4D7T5G5/QXsmXPcdR8pma/Xj+tnMwZkP
Ll8TUi9aOJP6sBSUbTO8x6d7cvE1WVtUslMQMqh0qXvoVOPDkFvoLZewRVLtuy6W
bioRNHIuelGhXfMGMOeSHhDD5m3qFYgmTSaV7nMqea3j4p1JNYmSUGe7heJwLOwP
17oudas83EQgk1cQ4Yc4+m2li5YevYH2FqtiOK0MyPkPQqKgxQo2WjJ0q420Lt5n
dBJW5x/L3bYyiuD3NvXHhdSwDXTN5Dz9DKKyQ+tekFjDHNnei78WUvD7GEu9c7s0
uyX8kN859Hwgc1d9SvvuyJGi0+tUUJv4kYSXNKqyqh2ldaVv+1HYIIZ3y6TzIWeN
8r8YwjfqArcKkSO8vN28JiP03Bj9D8boISnz6iYLD1ZpM6l4+Cw3bzcnE4Kh0pdN
neMgO7a19FgZi+VF1v4Nn84usGCGnzFJLCVJyRS0jg8zFDW8le+7rc8pru23AYe4
ZCMJVUS9qTY2Sl+xNo9i
=DSS6
-----END PGP SIGNATURE-----

--Np7vk93lNrw824dh--
