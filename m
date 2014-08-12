Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbaHLGmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:42:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49498 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbaHLGmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:42:16 -0400
Date: Tue, 12 Aug 2014 08:41:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org,
        Ingo Molnar <mingo@kernel.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [sched] 143e1e28cb4: +17.9% aim7.jobs-per-min, -9.7%
 hackbench.throughput
Message-ID: <20140812064156.GK9918@twins.programming.kicks-ass.net>
References: <20140810044127.GB11810@localhost>
 <20140810075915.GR9918@twins.programming.kicks-ass.net>
 <20140810105413.GA29451@localhost>
 <20140811133352.GC9918@twins.programming.kicks-ass.net>
 <53E99117.9010500@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RHtQWnsJolAsiBtD"
Content-Disposition: inline
In-Reply-To: <53E99117.9010500@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RHtQWnsJolAsiBtD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 09:29:19AM +0530, Preeti U Murthy wrote:
> On 08/11/2014 07:03 PM, Peter Zijlstra wrote:
> >=20
> > Now I think I see why this is; we've reduced load balancing frequency
> > significantly on this machine due to:
>=20
> We have also changed the value of busy_factor to 32 from 64 across all
> domains. This would contribute to increased frequency of load balancing?

Not enough to offset the changes in min/max. Lowering it makes sense
because we've increased min/max for most situations.=20

--RHtQWnsJolAsiBtD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6bc0AAoJEHZH4aRLwOS6nnoQALDmXgeh5FGzpgUgQXpOP5LC
HFTCNOaiAAnh2KmqJbWtuHFeiCBMsbSAmxtjeInyLiX0AC5NgvMlQb2zDu7GEjFJ
e/oYwY0lxz+slMuU6iiFpSk7+85bQCCpNIlkZuI5DHqRCjIEvcaZ+pvw8i+JOZfX
Ij3PWBzpo/7OLr6X74gH0BRl1qABrn8640gQiIC+xpXcpU7AtPSJZIbJG5gLg2ID
V7niMKHvubREEa3tovftF7VKBWBZckzOB3d47Tm+J3muh16VTee9t75ujwAjQJ1s
1LLK+CQYVt54TRdMH7KJPhffTwZ0sdO4k7mMqw78T/HTEoUE8R6Sg6JMoa0Gx2FB
OGiILIp6jBxUq0WvXmAxf7sB03s+SK3r6KUzHxA7/tvZ7vBbpLjjtPQDN7w6Fw+l
eENcw7OBXydUgsOyZ/bztUQukZkUBapJSCOTc5wEFPZbZji/xtSvLqU0GpR6f+vJ
tg8Rkjht0v2XPjTRdKYROUW0GlSuqplxMxSiZ2LOFN+Lny2y2K76mWD4WlKIRL1o
n7XG8TxI1ZVEj7cQe+XZ8AO9D4gKZWgd8JFmeYpcANRcYiX3KOrkmOiqHCEFAndm
yjKtsuE4iuy9EhFrmlPWlhJEpIbGH0QWkJCFbYv6IMd452MzW3IqOe7gek3cjDHe
aDMlrOUUVThqVrAiwrnr
=Wy2m
-----END PGP SIGNATURE-----

--RHtQWnsJolAsiBtD--
