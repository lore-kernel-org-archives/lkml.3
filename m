Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382AbaHJH7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 03:59:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34752 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJH7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 03:59:46 -0400
Date: Sun, 10 Aug 2014 09:59:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140810075915.GR9918@twins.programming.kicks-ass.net>
References: <20140810044127.GB11810@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="e/gjZozG3RDP5HMW"
Content-Disposition: inline
In-Reply-To: <20140810044127.GB11810@localhost>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--e/gjZozG3RDP5HMW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 10, 2014 at 12:41:27PM +0800, Fengguang Wu wrote:
> Hi Vincent,
>=20
> FYI, we noticed some performance ups/downs on
>=20
> commit 143e1e28cb40bed836b0a06567208bd7347c9672 ("sched: Rework sched_dom=
ain topology definition")
>=20
>     128529 =B1 1%     +17.9%     151594 =B1 0%  brickland1/aim7/6000-page=
_test
>      76064 =B1 3%     -32.2%      51572 =B1 6%  brickland1/aim7/6000-page=
_test
>   59366697 =B1 3%     -46.1%   32017187 =B1 7%  brickland1/aim7/6000-page=
_test
>       2561 =B1 7%     -42.9%       1463 =B1 9%  brickland1/aim7/6000-page=
_test
>       9926 =B1 2%     -43.8%       5577 =B1 4%  brickland1/aim7/6000-page=
_test
>      19542 =B1 9%     -38.3%      12057 =B1 4%  brickland1/aim7/6000-page=
_test
>     993654 =B1 2%     -19.9%     795962 =B1 3%  brickland1/aim7/6000-page=
_test

etc..

how does one read that? afaict its a random number generator..

--e/gjZozG3RDP5HMW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5yZPAAoJEHZH4aRLwOS67UAP/Rq3DGLtFajSWsifFKeJpXoz
SY9K9fO2K1iojW0lsQfvIRWd20WZmx+4ui9pWUKDkNbeo8d7lku9By74BQZzqWq7
ISA9egqnBUiXSwTE/R//qnk0OOX9YmQr0I8M4BX/8895awsi5MlmOB+DhSrVE/QF
+/EW85rAl0mA9OGB7o0t44l1LiVPPge4dahrSj+GygqhYsuUyAbZLC2xQjiUqAlT
POjComPXJK5nJkOyIjt1iBOjiIy2dxjtEJz9VWc5Cm/JGSk7m8e9jV1l6+wWU2nd
6anGol3W4tA0u/1Yh5ak88J8EH+zkwksyi/YWNtyYeCaONz4pdJbzOusSU7RriqZ
Tb4ktlri2CcewQj+8kui1vkuNUT1shWTY6XuDnzasoQp7nztUhLRnqpLI5zEXzzE
XTL4AAjQX+N7iOy4uTa09iiA+wpfiW3zrj5w+tmVDNh8b0dkyd1QrEpJs62/EMNk
0OShIVluQIEKWTccYRFVvTmKJr0NspQWMqcKT7Ds6Vc0Db97bVduYxFoNqB6fQ0A
4t1kTrN+W7TXYYPBwZjZy7AGPXySnWvF2C0zZza1AxXCykZChEQ84yPUcXpS5o43
gOm6gfkBjjqhrXfSUv6HUpVzD1tMC2yxeLrc3JpR6Iz161A5JjcScc2ukoqca9gd
edS/aF8UUPeXdHjYCpg0
=6fNB
-----END PGP SIGNATURE-----

--e/gjZozG3RDP5HMW--
