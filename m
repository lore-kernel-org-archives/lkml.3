Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaHISYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 14:24:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43486 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751949AbaHISYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 14:24:37 -0400
Date: Sat, 9 Aug 2014 20:24:00 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140809182400.GJ3588@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1xx5Q0+Cw+ObE54D"
Content-Disposition: inline
In-Reply-To: <20140809181920.GO9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1xx5Q0+Cw+ObE54D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 09, 2014 at 08:19:20PM +0200, Peter Zijlstra wrote:
> How about we simply assume 'idle' code, as defined by the rcu idle hooks
> are safe? Why do we want to bend over backwards to cover this?

The thing is, we already have the special rcu trace hooks for tracing
inside this rcu-idle section, so why go beyond this now?

--1xx5Q0+Cw+ObE54D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5mdAAAoJEHZH4aRLwOS6N5oQAIwhUDzu/p9OAPTBVbwURjKj
/EE0k9z7J1AC6VmqPyFp/HhwjbSfpvUIDn5CswbW1jFClPvgWrlWlih3NonL7Ktn
1meKHmmIdn7FXrVzFM2C7aRfKq+YXol52qW/gXwyHGibv80GTxnT4qPDGCMHHs6V
sFEFmHqjQtnXRd1xunTZ0wSLDYDQV1Uz4/JI1I1SUIZ8zYQfUftI3ljbbjq/wylZ
Jvm8oqC8QThICeSiwHzQOeJx1IWS71O1cVAGKOnN+5xwi61h+rvqDFEDRevIebzN
ehW5Vk4057keY50xLXaW754ym/Ijtd36RIYNXV5pq36mhJzzmoimoOKpqicWsFOh
IfdPP82PpJulChUEUReiO2UNGQ/KLY1AWK1cydSM2AxGjV1jkWP4Zcyt+d2ukhkq
Z9Xh0HMGUMtxAQg183oLIAW9t0FYrcBflAswC94MocAMKxnviGD39wVCAIpveyhQ
vZYXLgMLOK2+dvN/qH/UBBxkgRvJUQ6MG2AHI9hYtNqyXTTllfUh5VJCCzxqOUiq
kSZ5jwUyQLqANy4FmJ3O8TbIJ2wPB8tR2KLphD2LAXQuqByhcKxoUlz2L1TsOt3c
U0FhkhwDaCHtn3ReJSwQVyCxsR6KQpdM5lBhRugenKpUPhzN93NTzyFgDMQNLg7n
bWaWqO66q2jNF1zHrz/U
=Pnvp
-----END PGP SIGNATURE-----

--1xx5Q0+Cw+ObE54D--
