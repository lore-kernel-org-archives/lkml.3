Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284AbaFCLua (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:50:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39319 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaFCLu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:50:26 -0400
Date: Tue, 3 Jun 2014 13:50:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Morten Rasmussen <morten.rasmussen@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, mingo@kernel.org,
        rjw@rjwysocki.net, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, preeti@linux.vnet.ibm.com,
        dietmar.eggemann@arm.com
Subject: Re: [RFC PATCH 06/16] arm: topology: Define TC2 sched energy and
 provide it to scheduler
Message-ID: <20140603115015.GZ11096@twins.programming.kicks-ass.net>
References: <1400869003-27769-1-git-send-email-morten.rasmussen@arm.com>
 <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vRyMahX6VF+pdQvX"
Content-Disposition: inline
In-Reply-To: <1400869003-27769-7-git-send-email-morten.rasmussen@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vRyMahX6VF+pdQvX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 23, 2014 at 07:16:33PM +0100, Morten Rasmussen wrote:
> +static struct capacity_state cap_states_cluster_a7[] = {
> +	/* Cluster only power */
> +	 { .cap =  358, .power = 2967, }, /*  350 MHz */
> +	 { .cap =  410, .power = 2792, }, /*  400 MHz */
> +	 { .cap =  512, .power = 2810, }, /*  500 MHz */
> +	 { .cap =  614, .power = 2815, }, /*  600 MHz */
> +	 { .cap =  717, .power = 2919, }, /*  700 MHz */
> +	 { .cap =  819, .power = 2847, }, /*  800 MHz */
> +	 { .cap =  922, .power = 3917, }, /*  900 MHz */
> +	 { .cap = 1024, .power = 4905, }, /* 1000 MHz */
> +	};

So one thing I remember was that we spoke about restricting this to
frequency levels where the voltage changed.

Because voltage jumps were the biggest factor to energy usage.

Any word on that?

--vRyMahX6VF+pdQvX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjbZ3AAoJEHZH4aRLwOS6k+wP/iAWSFRkz+/cs5djHQ20w4aH
tpHWsW49yNN9nv1xuO765uGlosjocwsommQN00MqkYmeEh1J58AI0BhW+WmtXhW2
duQUix1z1mN3pFnK5lFt/EKK1OMIqh8q8Z9ML9nLLAYSvAOSqAzFKoMHNtn1C5tP
hnduYqHH0d9hX8u3g1rt+mpL5HpSv9QKgI7qzeVo2luyMzKcgN89EhnvmTF5amMz
gATpdy3hYMsbiykHJRoTpW83hlA/G3ACv/VKqsppiS48pwA5RLbBQxhQU9ZQG7Fl
pxuSiQGx8uxskcHnMmMp3xdkIDRry0wb7bKfPnDYeCPN2YZT33dR0fgIoNZLcga2
0Ccogu980hjil8LwbptMJ7WyRZbPmloL3jct+37E2Y2RGeN5x3zeOMWvypCmvauj
GWR+C/nadmhct2FH2Dn0OFTMpFN0St+p06oJAAjb5mew3pL9y9zDaC4pOUD65PnP
RL5Bbx4qIUoWlYCQNVzohfIcWEjsKKMkHJkF8Ja8lt/4dpwSzLhncpOMhb82n9pB
lJhJLqzloWvRgTTiINMdoZOlh6BApb7lX12um2l2uLZxBnGzSePW39kiqF9mtdmJ
4nkhR8mB9BXvMTaB6AF+VkjFEz0BxVE7bQLcKlzMg0EmIOiwnhBDALHDMJAVFc6i
QO3yoz+0JU7Q6q+Pp2+J
=oEeP
-----END PGP SIGNATURE-----

--vRyMahX6VF+pdQvX--
