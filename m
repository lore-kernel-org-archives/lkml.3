Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaHLJn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 05:43:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:38682 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbaHLJnz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 05:43:55 -0400
Date: Tue, 12 Aug 2014 11:43:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Kirill Tkhai <ktkhai@parallels.com>
Cc: linux-kernel@vger.kernel.org, pjt@google.com, oleg@redhat.com,
        rostedt@goodmis.org, umgwanakikbuti@gmail.com, tkhai@yandex.ru,
        tim.c.chen@linux.intel.com, mingo@kernel.org, nicolas.pitre@linaro.org
Subject: Re: [PATCH v4 3/6] sched: Teach scheduler to understand
 ONRQ_MIGRATING state
Message-ID: <20140812094340.GS9918@twins.programming.kicks-ass.net>
References: <20140806075138.24858.23816.stgit@tkhai>
 <1407312379.8424.38.camel@tkhai>
 <20140812075523.GN9918@twins.programming.kicks-ass.net>
 <1407832463.23412.2.camel@tkhai>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8rpgEfAtZgdcISZ7"
Content-Disposition: inline
In-Reply-To: <1407832463.23412.2.camel@tkhai>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8rpgEfAtZgdcISZ7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2014 at 12:34:23PM +0400, Kirill Tkhai wrote:
> I don't have objections. Should I resend the series (also with new [4/6] log
> commentary)?

Nah, I'll keep the patches as I have them now, I'll push them out to the
queue.git tree somewhat later today so you can have a peek.

--8rpgEfAtZgdcISZ7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6eHMAAoJEHZH4aRLwOS6Jr8P/RR9C7l4SZRnSumXofjFjfhj
U3NqkOe4X+6QWXa2Z0uUHjRZHUMjliE6Dc4Hmy2XPoWKcSFz5RSO4bLDcOoez8oR
QfY7zTDv9kjdivawJhLo1tdJj5ILvYYKVOk1luo8ceM/LXrD8/GDbXbOv5eKMnzo
C12gJeaCwh3MPFx9a2Tvo2AMT4/7NyWvlNtchSstiDX6H659zLsND1f2lhdjJiRx
56E53t8HWuswiOOrTkCsmPZOfJc79Rcq9BErU+eFmTY20olsAh1Op1GMQLMS8G7s
MbJEORCwmFPCa7stHc9DrjjshxZaeOt07kdfgfpbRcsm9IVIkzXeEZs05CN/sgti
oOpSIBVpD0ddWL85F0AzseQNctq8hjSYxDlzK5go5y5eBzv7JF0Ep/QoW5xn0Gk+
4IriYurzX/KLG4chGGX9yJAAR/AcpzbL4T1AEFbXyTzr4qTl+4kpg1egi2bY3Vu+
kPAiAArWuFaoYR6wyy7S6Mk+ZLfqji7XLUpPs+oq5l5UUv6ULpxWuJqNQziIqZZs
qpRKY/0kovyAnyZNCwvt4M1tfMz42t8f6Ca3/HMcasoDTO+AuiqYnggXhGPIZGdW
/ISQ2/j8adz4IH6QTG7p71a/KOw2a4WuRBde665L7wjYbeH1PFiF6BmdbYwmrKHo
5+aTLvaGHKiRmk1+wSCD
=93EH
-----END PGP SIGNATURE-----

--8rpgEfAtZgdcISZ7--
