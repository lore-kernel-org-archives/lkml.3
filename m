Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969AbaEPKQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 06:16:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50229 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717AbaEPKQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 06:16:58 -0400
Date: Fri, 16 May 2014 12:16:43 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
Message-ID: <20140516101643.GP13658@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
 <20140512200135.GL1421@htj.dyndns.org>
 <53718119.1090000@cn.fujitsu.com>
 <537180B9.6080407@oracle.com>
 <53739F3B.4060608@linux.vnet.ibm.com>
 <53758B12.8060609@cn.fujitsu.com>
 <20140516093530.GN11096@twins.programming.kicks-ass.net>
 <20140516101505.GO13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wAI/bQb0EMvlZCHl"
Content-Disposition: inline
In-Reply-To: <20140516101505.GO13658@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wAI/bQb0EMvlZCHl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 16, 2014 at 12:15:05PM +0200, Peter Zijlstra wrote:
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5126,7 +5126,6 @@ static int sched_cpu_active(struct notif
>  				      unsigned long action, void *hcpu)
>  {
>  	switch (action & ~CPU_TASKS_FROZEN) {
> -	case CPU_STARTING:
>  	case CPU_DOWN_FAILED:
>  		set_cpu_active((long)hcpu, true);
>  		return NOTIFY_OK;

In fact, I dropped this part as it conflicts with another patch I have,
and setting it again isn't a big problem.

  http://lkml.kernel.org/r/1399574859-11714-1-git-send-email-minyard@acm.org


--wAI/bQb0EMvlZCHl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdeWLAAoJEHZH4aRLwOS6Kr0QALFBvi/3Tg+oZ6VnbEbQffld
nDBkLzveJ9pOdR9uKH4gTwQ8LgVcbh7aNRkHrYUOQr7/N8WZuhlpInZka+uB6SzB
57AMxpevIgzwIJrUFpDnPQLIgOuwHiKGsM8oCcWd/f6ttPrCND1DaE0lw6YFer47
unjJdamYDCC4tliPDQHfUogjZ8lukTjWd+X4GXOb4hsoRsjlHGf9DW0/yGr0vbH6
4thi3/DJ1qtWpKhpWdM13lyNhLIrBGbzq+VWOXVhcnbr7DytD7dDAFYLhU8G6Cj3
IXM6qgSaRFU/CubSIbFWXUCG6gTy9DPOrMNndDiYrkgOciVBAGjDgRJcetQcaA1F
2mKImbIQCjiGcJ1e48PmaFVc3zOL2T3WOKH5cgRSMrt+Plqao06dSyiMOqFMP3N1
6UtLZzXtTaYVyum+qtD8Cimwcpmg97HYmXREx05aJuNxy4pQ8vPbqZ2ZqcwwqYWS
x0nOR9xF09eK3NGESbwAWmScj9vRvNOTbisza3HVng+Yk5ZQFOgu0kVotgAwVeg0
7fEk+hWaLkPby9MWT3X044OtA1p+pXL2s2MeivOoEdFG3CT2audse0LfBXTTD4t5
ZR3D7Ipte5s4mbl4vlYuOWlDmVuyw+wkFPNyJ320S1PekVQAj1LTUrl/UBBRiYeN
V59tuvH+KBryY0HktiCq
=/lDB
-----END PGP SIGNATURE-----

--wAI/bQb0EMvlZCHl--
