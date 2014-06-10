Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaFJPsT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:48:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:50174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735AbaFJPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:48:18 -0400
Date: Tue, 10 Jun 2014 17:48:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Kevin Hilman <khilman@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 6/6] nohz: Use IPI implicit full barrier against
 rq->nr_running r/w
Message-ID: <20140610154813.GE3213@twins.programming.kicks-ass.net>
References: <1402413309-3415-1-git-send-email-fweisbec@gmail.com>
 <1402413309-3415-7-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="V7LzxcfGKRikha15"
Content-Disposition: inline
In-Reply-To: <1402413309-3415-7-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--V7LzxcfGKRikha15
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 10, 2014 at 05:15:09PM +0200, Frederic Weisbecker wrote:
> +       /*
> +	* More than one running task need preemption.
> +	* nr_running update is assumed to be visible
> +	* after IPI is sent from wakers.
> +	*/

That looks like whitespace damage.

--V7LzxcfGKRikha15
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlyi9AAoJEHZH4aRLwOS6cYIP/iLbvzgwos4+YQsR+PXIWZ9N
VgYnOwS/8Phw7KTILa/enFrPX8k47rypkfQs105kSk7l5O+9m8XCKryTI5+AEAcI
0unW5ROFPnqyUCjAmJxaxTWoIK/XcjL5dvcHlK4MSjwK9BKhn3J1cqFcRpeQAzx6
Q/5tR022EuXJO4M4+3v21ObZXuRnKowEED+IbnQzegAztFp4EqIxC0AIWVpAq8ii
SQw53xD9lcFZ7trrlpG39zq9tVr9Iq8akrxm/Fty7J8n/+95Ic5t2Jm1NlgsZBHm
XV3kAtQCbye2e4bKg2p1HrFeWoq7uYd5SD7M8MvW8gCerD6ujAQ/ndkIwKqB/EzR
V0A9S+lTaSqoF8IxqsY0d+y7BXNjOHwxdKxQ/DQggSTNkKqxBiSeYH+/Ji6xCT6B
CmSH40FI+nLXsWwiEWEDAmyjpSSM2BuWSBmboqx2xolJybT8HRr16kTjpJ4Wj7Jh
xJaRbjELrk18HlRAuceLml9IfsHgZNskmUtqB8EWPJ5kpBtPc6+kTWMnNy4qRrFh
OzDwj6Rdyubef+GbZvycsH/5BJXN02QyC0yg+7UsrSk7ez2cM5cGwx/wsj9qAnE+
PHoVb8HFCb/+lbJTtkW3y7kFuipmax1n8kQx+t6IIYplyv9mTkktebvv9VJA3o/A
FXH4Cr6ZAhpTNOyYl7v6
=I8L9
-----END PGP SIGNATURE-----

--V7LzxcfGKRikha15--
