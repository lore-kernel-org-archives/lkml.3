Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986AbaG1Izh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:55:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:57958 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaG1Izf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:55:35 -0400
Date: Mon, 28 Jul 2014 10:55:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Mike Galbraith <umgwanakikbuti@gmail.com>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, pjt@google.com, bsegall@google.com,
        arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [PATCH 0/2 v4] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140728085525.GN6758@twins.programming.kicks-ass.net>
References: <1405639567-21445-1-git-send-email-yuyang.du@intel.com>
 <1405835183.6512.37.camel@marge.simpson.net>
 <20140727193453.GA23367@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uP6ApTHNnWVQNpGq"
Content-Disposition: inline
In-Reply-To: <20140727193453.GA23367@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uP6ApTHNnWVQNpGq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 03:34:53AM +0800, Yuyang Du wrote:
> Thanks a lot, Mike.
>=20
> Ben asked for this test, but actually I don't know how to get pipe-test, =
still
> not even after google it.

perf bench sched pipe

I realize that's a mouth full, but there it is.

--uP6ApTHNnWVQNpGq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1g/9AAoJEHZH4aRLwOS6kkgQAKO8VW5U4tAxEW3MfS1koy2i
Vnd6CGtOPPrludbh4ons8OxucW5Wz7w5wdrXSp+NOZ/VJpWiJV/ggRogFom7+F5D
ZKJLlG4y+2sARgb2pQKq6z5ig8ataojHFdNOF2WOLwP2t6zk+hFHvBFrNHv81Eqe
8NQXDDx6Rsurt04kDddPDLqfuiBy9VvQHFOQ721gS/BGjajJyiivhmrNz64wHp/D
lFRxHnI52d0M+yK0xB+q4PiGQcVGQZHB7PBt4Jj4EIDOnpKbfDl8/+Z9QNlOkABR
om8tcFzFpI3BfvqCx2SYipsV62Q3p9bMLQnWATN+ucSAPSfYf61wS8baV9FaNA8X
+HrdLyACjMh0vbqZMP+B5q4esTeu0FfLiimKcAzZ1jkRHbmQEw7EW1uMnc+L3t5U
JXdTGRwhMvBGS6U1TptQmVD3WWbfUMUFsLQ/3F8CRnE2QUnesBhmf+irom6llb33
jG9AYeVB/o3J2nUk294zhVPVQAZiDSnmFLog6+fgOFqTkWNDrd2NVk9bT/e+Tush
7/MAQdrRpQ/mXXdjCteZUSe+xMMvfsbdLrB9mMJWwbsJ3M1hsp71U4EZZ7y/jZCg
xS6FFJZ6oB713m2DXVQ2GXlXmZO0H1ES11K8KaxcNr3u+gc8zHuw0wA1+GBvFKaI
WtURmtB/szrRYfNYufez
=sRMF
-----END PGP SIGNATURE-----

--uP6ApTHNnWVQNpGq--
