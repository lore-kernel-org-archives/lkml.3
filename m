Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754379AbaGNJ6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 05:58:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49058 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753446AbaGNJ6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 05:58:17 -0400
Date: Mon, 14 Jul 2014 11:58:02 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: sched, timers: use after free in __lock_task_sighand when
 exiting a process
Message-ID: <20140714095802.GQ9918@twins.programming.kicks-ass.net>
References: <53C2FF4D.3020606@oracle.com>
 <53C31A34.8030500@oracle.com>
 <20140714090449.GL9918@twins.programming.kicks-ass.net>
 <53C3A430.9090508@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ccJhwVfaC+fHwTsl"
Content-Disposition: inline
In-Reply-To: <53C3A430.9090508@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ccJhwVfaC+fHwTsl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 01:34:40PM +0400, Andrey Ryabinin wrote:
> On 07/14/14 13:04, Peter Zijlstra wrote:
> > On Sun, Jul 13, 2014 at 07:45:56PM -0400, Sasha Levin wrote:
> >> On 07/13/2014 05:51 PM, Sasha Levin wrote:
> >>> Hi all,
> >>>
> >>> While fuzzing with trinity inside a KVM tools guest running the lates=
t -next
> >>> kernel with the KASAN patchset, I've stumbled on the following spew:
> >=20
> > WTH is a KASAN?
> >=20
>=20
> It's dynamic memory checker, detects use after free, out of bounds access=
es - https://lkml.org/lkml/2014/7/9/990

How is it better/different from the existing use after free stuff? That
email fails to tell me.

--ccJhwVfaC+fHwTsl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTw6mqAAoJEHZH4aRLwOS6K8UP/1vgxkNRs+5iCip+ey3OClfy
oD9yhnvLW/Xm0dOw1ZTO/i4LX1l5CkXaUKUcn+3UM07QTyLbEV/Njadi/UwX4qgR
uZfWxJpQ0U7fPWF3zmYVFP8nkmKq8m3wrTlRLrw7ZtO3pr2jg5BS3xwHni1WmyJc
/u4FT9amiBQwt6K1cirHi46xXcmzPDY1K7MoC8TKBfAxdU902SnzuDuTnPlqvI1F
LtdJ0jaSrYbnGMwZM9Z4WJvPxgeaC8IHaXSz8qnbNtQCmErNEz+2v2AzTG5mPO4w
NOCfEKFzVLRcXxI7XyC9hlh5dlqZsYjwj8+cMvbNiEojDnFrMsXVTAZfk/ZL7cwh
HSMjwYrczCwe2sI7XK9Kz7N7K2W/LohBuxRIwISjv6TneL2vCz4YEI/SOpVnbiqe
tOFUtFbKakUSSexIKE7ldvsfjMHm6lNp1LPWVlcmjQprSB83DXCePLSe8h5ANKt4
NKNvGgEFaNQbXFJ2UJeQKpwChg6tvRfvfvECfo201NsgI5azIOJJ5DpzU59TXP9Z
p3XScGlWVnJnylIkHr+KewO4EJykXKCJRx+873+i5bQq70MsRLj7m/HQ3F3k0Lro
cIucJVnOWNpFQNcSYuYBZWsfrCuXgBrU4+fouuJW4KFhnuS8Z2nj+/PdQs0JMH5L
UniLRXG+AGRvwawLzDAL
=LoqN
-----END PGP SIGNATURE-----

--ccJhwVfaC+fHwTsl--
