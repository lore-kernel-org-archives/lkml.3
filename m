Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbaIKI2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:28:34 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49232 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbaIKI20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:28:26 -0400
Date: Thu, 11 Sep 2014 10:28:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Catalin Iacob <iacobcatalin@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH 0/8] nohz: Fix nohz kick irq work on tick v2
Message-ID: <20140911082812.GU6758@twins.programming.kicks-ass.net>
References: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GGmUCDo093wrvFwp"
Content-Disposition: inline
In-Reply-To: <1410384808-14760-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GGmUCDo093wrvFwp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2014 at 11:33:20PM +0200, Frederic Weisbecker wrote:

> Frederic Weisbecker (7):
>       nohz: Move nohz full init call to tick init
>       irq_work: Force raised irq work to run on irq work interrupt
>       x86: Tell irq work about self IPI support
>       arm: Tell irq work about self IPI support
>       arm64: Tell irq work about self IPI support
>       nohz: Consolidate nohz full init code
>       nohz: nohz full depends on irq work self IPI support
>=20
> Peter Zijlstra (1):
>       irq_work: Introduce arch_irq_work_has_interrupt()

Looks ok to me.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

--GGmUCDo093wrvFwp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEV0cAAoJEHZH4aRLwOS6FzUP/0J88PqGn+4zTmnTkgD+JbHU
YQo1hyNqInub+e/5xMhxQBwwIgL94CPuzvC59NVIYTDYD8InRW+9531Lr4BuHkNZ
aWFKVasfykRMh/moDFO051aJ7+8ozXnZKmApjbiuqhqGrH4iVD/dJVoTq2SlzD/1
4vrEERYYrSGfSQ38nq8YNePN1Y/EG08SLIB/sATLw264Xcl6/HEIY4zQmf+MaD18
shVvnUCJwzuXGLS1bj/ztiptT/2q7umfh+qHiN7BQF6RR+lHaLNbq1OlqtVlfXk+
VPSbRaOCMM2h+RzJmtSpxgrdz4XBKkilLLJ6/j1vCjAaevyTOUNd0kWNXTnUSMu+
BGZbwg8XN6yJ8Ng+zPcgqdDu1lDHwZVmLEUEVhKAK19mQ4hIoo6fG4kS6ouOw/Zt
frg51gP62lnYmNInVtATjmVnZ5u5FE2zVkGdWhqOrnPd6YA8IYRB2y0mUSqwR6mI
uHjS8xaol4qUMjSzpaI5/zt+rgZ2Brh5nHBIZ5yRVnpI76exFhwCVfyN0jAY4sdw
HZ8ZhyIdRTerY9KFWDUPFjo0w++Ux6VHrulr/ktf3GJGWYcuPlIAhOgbHwh+uAOb
eJG8aupQvhfBzKYmWh4vrzrWsLhr+0m2P5IKp2nmaHRypJ5sLPoW8eyQ6ImoqPVx
kvLAqp48ZHB78CzzSjKU
=7914
-----END PGP SIGNATURE-----

--GGmUCDo093wrvFwp--
