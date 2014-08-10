Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751426AbaHJIOz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 04:14:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38555 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaHJIOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 04:14:54 -0400
Date: Sun, 10 Aug 2014 10:14:25 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com
Subject: Re: [PATCH v3 tip/core/rcu 1/9] rcu: Add call_rcu_tasks()
Message-ID: <20140810081425.GT9918@twins.programming.kicks-ass.net>
References: <20140731215445.GA21933@linux.vnet.ibm.com>
 <1406843709-23396-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140808191326.GE3935@laptop>
 <20140808205826.GG5821@linux.vnet.ibm.com>
 <20140809061514.GK9918@twins.programming.kicks-ass.net>
 <20140809160137.GJ5821@linux.vnet.ibm.com>
 <20140809181920.GO9918@twins.programming.kicks-ass.net>
 <20140809182400.GJ3588@twins.programming.kicks-ass.net>
 <20140810012924.GO5821@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8XzOrflVn8HobiNv"
Content-Disposition: inline
In-Reply-To: <20140810012924.GO5821@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8XzOrflVn8HobiNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 09, 2014 at 06:29:24PM -0700, Paul E. McKenney wrote:
> On Sat, Aug 09, 2014 at 08:24:00PM +0200, Peter Zijlstra wrote:
> > On Sat, Aug 09, 2014 at 08:19:20PM +0200, Peter Zijlstra wrote:
> > > How about we simply assume 'idle' code, as defined by the rcu idle ho=
oks
> > > are safe? Why do we want to bend over backwards to cover this?
> >=20
> > The thing is, we already have the special rcu trace hooks for tracing
> > inside this rcu-idle section, so why go beyond this now?
>=20
> I have to defer to Steven and Masami on this one, but I would guess that
> they want the ability to trace the idle loop for the same reasons they
> stated earlier.

want want want, I want a damn pony but somehow I'm not getting one. Why
are they getting this?

--8XzOrflVn8HobiNv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT5ynhAAoJEHZH4aRLwOS6+B8QAKwY6OGwy87K6O2DXYLJzEOK
jFIXO/dKyEbbdkVowLlRQbeAVbgwzY/iCecUXiuSyb/jzKS8/jS0Us99dUtrXkzm
zjbtKLsItDbH1pWPqVzNFlkx7N093z51flXIR446+pwUKiWJ2+w5HMId+DaYwxWT
AoB0NFiNiOM4nCc0cJ3v/1OhYqNm4hpQ2cOs5T5QS+uZxgDB8CdcxKT0Nfe6Ley0
Yz428tYIocvPtNWG9Ke0UuE/TB6GkqlvKty3pKpT2fHervGx6GWPVuX9kqhvYgjG
89alFQ6cXtiJIXyPvPuPgsn2nl3K23SrlN/JQdMLPnDA7t9yZA/6Ppa7NAQMtoWM
Ni/FOLHGtLLWslrYM4lKUmF0p+P84l8ewbIGnUQEEm1wdCC6Aj7OghnlUQ0uvb09
7MIx38MmollbfRECGPrjI9ezZWAa9FvkgygK7b35twjWCpZHLALvJClIjOeb4Md3
v9rO6Zbq+tjRONzlWYtlk/vQh0XxQ8BbdmFe5ZminrxdyZfUNysMoGq7Mxx/KXIk
1/25QXfHHPDkKEpqWC2JJiB3NpO5tQjgyHY/KO+muLsvCECQ1bq0TQU+CsE0NP/5
eMM085/nUmhfblfkufv3A03ZGTdxmDkLtqyqgB0xKNU2qU+e2aGPzGgGOGNjFn5s
Y/9cHY8EV/0mDX1XLbL0
=aOuH
-----END PGP SIGNATURE-----

--8XzOrflVn8HobiNv--
