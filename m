Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbaFXUgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:36:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47932 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169AbaFXUgx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:36:53 -0400
Date: Tue, 24 Jun 2014 22:36:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Davidlohr Bueso <davidlohr@hp.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] sched: Fast idling of CPU when system is partially
 loaded
Message-ID: <20140624203622.GB6758@twins.programming.kicks-ass.net>
References: <1403551009.2970.613.camel@schen9-DESK>
 <1403626551.2970.626.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cv++WRjpEUwHXUCE"
Content-Disposition: inline
In-Reply-To: <1403626551.2970.626.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cv++WRjpEUwHXUCE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> I need to fixup the code of updating the indicator under
> the CONFIG_SMP compile flag. =20
>=20
Yep, saw the bot email, fixed the patch and will push out a new stack
shortly..

--Cv++WRjpEUwHXUCE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqeFAAAoJEHZH4aRLwOS6XiYP/R1vU+Odw0Ro2FycfW1j+vYY
Z2Zt8qvzM17sqHE7/DMWdq7ow3TNrxhohtBP1XY4YD4yDwMQhxSZ5Jp06oibXQza
dxzmpZdMJZI6VYD/xPoBGMQmVNgVcF5EDCh+fVWZcdRPRSHZuMXXDBRyu6EBocxF
Oe54EDjgYLUP2IeGhNlIgAfblVyV929widjM5VEuFt7ixtvZb0l/gu+Ge/G0gD5J
y8Xcmn4JEqGN+G3+57OxGnopZ+ydfUNg6XhroHR/j2KEKBzPvWAcWrtD4HKnOabM
SXYD6me8lStM9k5mLaACgbDKqVGOVii6/L9OcMM+QCYFuunxfYqgL1fHuEW4HEGq
cf/uwM8Z0nitA69Li2Vtcg7Fz9IE+AMY+gTeJXQyM1uF7X8uCEwuY+w9TBgpixYz
G+lzj3LkiLPFHvItOWRrOndUN0PAfZLAbhBVl6hkaSxXQcP7nFhXPK5gEmwUkNuW
J0NL9OpuD9608sCFuhS8wS6FmQ+IGK9XVcZ6WVANpZtc312cF7PakCfys+QNEId7
hFFSl1f/jmoIolu2e+F6rdD6/mBfJNQnr1rZpcEPE8m/IofO5qZBzKm+q2z8eiIN
gxhfvP6pK3BBcORG+y6hjnwPVpqQAmtV3qq5A7DBv5Dl5sesSxShyMvgEjHQmwmF
SFf7qB/0DrfdoDeDVJiv
=Ioir
-----END PGP SIGNATURE-----

--Cv++WRjpEUwHXUCE--
