Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbaEIJMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 05:12:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756373AbaEIJMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 05:12:48 -0400
Date: Fri, 9 May 2014 11:12:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: minyard@acm.org
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] sched: Initialize rq->age_stamp on processor start
Message-ID: <20140509091245.GN30445@twins.programming.kicks-ass.net>
References: <20140508161337.GF30445@twins.programming.kicks-ass.net>
 <1399574859-11714-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FexDM9E/OpjgUmaq"
Content-Disposition: inline
In-Reply-To: <1399574859-11714-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FexDM9E/OpjgUmaq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 08, 2014 at 01:47:39PM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
>=20
> If the sched_clock time starts at a large value, the kernel will spin
> in sched_avg_update for a long time while rq->age_stamp catches up
> with rq->clock.
>=20
> The comment in kernel/sched/clock.c says that there is no strict promise
> that it starts at zero.  So initialize rq->age_stamp when a cpu starts up
> to avoid this.
>=20
> I was seeing long delays on a simulator that didn't start the clock at
> zero.  This might also be an issue on reboots on processors that don't
> re-initialize the timer to zero on reset, and when using kexec.
>=20
> Signed-off-by: Corey Minyard <cminyard@mvista.com>

Thanks

--FexDM9E/OpjgUmaq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbJwNAAoJEHZH4aRLwOS642QP/RSRwLinBj7c6bxXYpZvQtO/
d9DvVxxjSXYFq7C3Dq80B09BrXUbWL4RKJxdK42YVqdBVfwSWYGw9spiRZ7+u777
7YR8SU8RAU2t//F32lT+DUlHMM4iYCpP5AgxI5j4TJIn4/o7eZ1McHc/4LTAHIQp
4wCwbvBclqmJNOpC3hzNfg+3CKYYPcnZiob/9my/oM9D10dVV88PGL557tayvB3A
887j73KncplvNRV6wdMM0p+lCwKEWYDMHD+PDDYOk98M/ybTAPnNEQkoxXZGk7Ny
xVRO3alHbGEHkuSI65A6RAOmyHFHM8D5hJSD9xBXRWMpFcQc01aCOENfNAnbsI70
cSDcVu+d3wF5zQiZ5kHeuSafh4rCW6xJzRUhB9/Z4mSy2Ndeoa56A9g/ekzCXCWh
7+5De1LNtHP9krvGYmm/L6q3vqUmkbliEW7LlVKR/E85eA0wMcsi++rU4+GtlIWJ
muJZbwBJ8pNEGkcoo5l/1HlGjtXwjRvLu/TfgZFD6KhqelgWUFuWwHxN+YfrK4c4
dlDaZ9fQtO6KIHbA14pNq1j4LpC+vVyWedUEeZJYP4pBZQ2PImwszv0/l2X/jl7+
1a5tergvbAOeCC24L00jngTKrC2mT32i813650c49bbPUHIXj8gLtia2jRXMIElM
d6GeUx+M7iq1MVrNoaMX
=6E+m
-----END PGP SIGNATURE-----

--FexDM9E/OpjgUmaq--
