Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbaEHMIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 08:08:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:43311 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391AbaEHMI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 08:08:29 -0400
Date: Thu, 8 May 2014 14:08:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, nicolas.pitre@linaro.org,
        tglx@linutronix.de, daniel.lezcano@linaro.org,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/idle: Reflow cpuidle_idle_call()
Message-ID: <20140508120826.GT11096@twins.programming.kicks-ass.net>
References: <tip-cc6vb0snt3sr7op6rlbfeqfh@git.kernel.org>
 <1877683.4pfeUuvFZ2@vostro.rjw.lan>
 <1591569.1rC3xo6G18@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hqsgWuDCGoNNiKsj"
Content-Disposition: inline
In-Reply-To: <1591569.1rC3xo6G18@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hqsgWuDCGoNNiKsj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:56:18PM +0200, Rafael J. Wysocki wrote:
> The cpuidle patches I have queued up so far are on this separate branch
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm-cpui=
dle
>=20
> in case you'd like to pull from there.

Ingo, can you do that? I think the patch I just posted should be enough
to fix up the conflict.

--hqsgWuDCGoNNiKsj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTa3O6AAoJEHZH4aRLwOS6jbEP/3EQx7CB7Geubla3cU+oU8Hh
e2+k3vrypqvqwKVrpzPdLDJz6D/aMSR5lmFmBB2AGxVO3vcuXmudppqIXH6TnRKG
C+nQNCDSxaTOjsQA2ENBmA7Vd+kV2fzkzAanFZPO35O0ywSaCdjr9LOpbKvZnUw8
5MpA9nSupIX187Jv/7Y7Cy0DAYvfcs+yLSVs5hO+iB7qEW2Cvk4oQHeIOifYbzkh
MznJqkzOJMFJWSEyN8xleDhQr6Yr2COq2CiIsnAmxW1dFDWFLHf9vgloshxWi5fW
dHdVFvlCaB7bdpMSwIjdyXsqmi2Ks2yN12tjOd0moRVNv9znd5QlejS/sC93Nm7b
rIYiQXqaVPfRc5Ij9//g0bt0n9LdCzzyZK8CgVsaJ8ZQ1ezDY0CPHBCGSNW54opZ
CQPyTcZBPNkvILNw+55xz5CW1531Xstr3TS69ljSEbryxlUPIBbrY1PmzikA6S7A
3SP0MFnDwX9cy01WXPnlIb6KVYXI7mWboXHkjebJ6po/4A0H4ECKhdKsLs2deZeM
nWpEkDaHWniBnAhOLgUL6xfbAWEWoznLP9HkqJYRVBA1D64z+74M+yScOjMdDR7o
YzlalTo7+JW5P51zTC08SjPeBDZRbW5KO3/P+Tg9fMFYAhIRiUUqxXerVDoStdbK
wA2aRY6P56EHhvT7jypw
=ojkG
-----END PGP SIGNATURE-----

--hqsgWuDCGoNNiKsj--
