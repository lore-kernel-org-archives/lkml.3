Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757123AbaEPLEV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:04:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:38329 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072AbaEPLET (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:04:19 -0400
Date: Fri, 16 May 2014 13:04:14 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-ID: <20140516110414.GO11096@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
 <20140514140034.GM30445@twins.programming.kicks-ass.net>
 <20140515104055.e91844a5b75529edc560349a@gmail.com>
 <20140515085156.GG30445@twins.programming.kicks-ass.net>
 <20140516104336.GR13658@twins.programming.kicks-ass.net>
 <20140516130153.7064f895a282055b3e28533a@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8QANErTbuLtKTfKg"
Content-Disposition: inline
In-Reply-To: <20140516130153.7064f895a282055b3e28533a@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8QANErTbuLtKTfKg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 01:01:53PM +0200, Juri Lelli wrote:
> Are the comments I proposed to add overdoing?

Dunno, might be helpful, if you post them as a proper patch I'll press
'A'.

> Apart from this,
>=20
> Acked-by: Juri Lelli <juri.lelli@gmail.com>

Thanks!

--8QANErTbuLtKTfKg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdfCuAAoJEHZH4aRLwOS644MP/3y2DR24L4FhugCJPFWkfLCW
Vkny43Cckz6mQMYsMvIi2UYjjKAvt7xiJwXkwWSmwpCM6DGRLBtO4R3tWi0N1+5X
RPNC17Vi0f/Q2xIKrPLYbhJRHF6FHOOlEn15d2dt0Ff6lNzBt1UEDn/1+ihoumdI
2GEX4K5+sYGPDn3dUYkOtpLZNN9/dlWBrOFPua+oKf0Y2m8AO3FIGl6VPejw9uwo
E3ul/766ihrvj6qyneaFrCjk8e8azRs98SUEkTH5V+r3yXDMKlpaR4F9Uf8/Y4nl
Qz+dmu7uAHfh2/LAcoDRQoToJpUNavWyut7iMbWnbP6uW76CyhsdsYWG36yIghtr
GKfcvqpgRN62W7445kPT0fAcePxsMB5EUqV0kTvHycLmCw0u3tefHpFjbWiepCFA
ZL5aCuszyYEKfNLUEA0f0EUZiH05DIo6bdELREAaZtBH2mdG/kUJ0adOsWk6cS3n
1C2CMTRDeXlvaHxFz+ChVfjuQwcT0yy65wrUb4JgmB/0Tib70AFHc6fTELhDDSaB
UIEYavG4CZhID5jegOKG+EwS8MgbvtMLQgvI4rp0dMogIUZK1deXQD9JinAnRqFE
Jxql8jk3gWVM3yST6f70GT9FlucCfHx8IFsl3TUXxtfwo+BvXaPd9Qoz90q9UwbJ
kFpvrmeu3jW4ROwd88X5
=/H/t
-----END PGP SIGNATURE-----

--8QANErTbuLtKTfKg--
