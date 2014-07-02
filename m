Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752717AbaGBKZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:25:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42505 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbaGBKZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:25:29 -0400
Date: Wed, 2 Jul 2014 12:25:18 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 07/16] perf, x86: track number of events that use LBR
 callstack
Message-ID: <20140702102518.GA6758@twins.programming.kicks-ass.net>
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com>
 <1404118253-19532-8-git-send-email-zheng.z.yan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24bywM+ZyrW0DJoD"
Content-Disposition: inline
In-Reply-To: <1404118253-19532-8-git-send-email-zheng.z.yan@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24bywM+ZyrW0DJoD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 30, 2014 at 04:50:44PM +0800, Yan, Zheng wrote:
>  void intel_pmu_lbr_enable(struct perf_event *event)
>  {
>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
> +	struct x86_perf_task_context *task_ctx;

This won't compile; you've forgotten to declare that type.

--24bywM+ZyrW0DJoD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTs94OAAoJEHZH4aRLwOS6SoIP/jbWou5suANT6dkdrnJGE6RA
IXGVwf+CYN01f1SeRiYvMgzA1CN4WSnoEgtT5H8XTwlb/fpsOsRKK0/corN5XPTe
Le+NW+IROHfJkXT8Z2rCmv6ONvjkb4HasVeXWRK49Yh67Ids+M7qu0jw4Z5tbUGL
RHSaQzFX8sFGRKL6+8k2dBKlHT8/e4WCDl7I9crTkS1WThmols8GwzTNNtQI6zD0
OW8uhLpNns1R7V/AssSSCh5TDZST0L8sBL/qmUq+RIsMKoEq3VWaX10MepLTbAXI
MVjCC0yzqzKE01T8t1I2l4tAc6qIvTVnUNxnGj0SxISaXQ/I7mFUFbqCqAMj6dMn
eAnpltrnD16NLmnw8hoEoZSEJ8L2YnyAI4lmRDOg82ZwR1s7oHDFYLxwx60zpVFb
wAqtOB3Fdd0UdwLM/G5g0tKYNmbh2mPc1t6nSalJ2q7WTIwLJ9D0YDDkPHQ7ST8o
dPFzsHbpW1BfFDHlseUJG1yChRPmpgNTouJBUukMTjdglt0yGGO6HfMoSxnJaJ6J
PxGCKOkK0chTz+UGQShWrerdeY5FN+q2tRphNQO18NJWII9gHZkcacE3baCjy9AT
E4YasQKTS+s2XRL1dijjnr6irQ8y1hbmL6LfAv0QGUylul7w9C2+f1sLDP8anoeF
bwl2dbTKmzBypkcLzZyL
=d/sV
-----END PGP SIGNATURE-----

--24bywM+ZyrW0DJoD--
