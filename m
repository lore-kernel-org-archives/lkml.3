Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbaEWPVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:21:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:50960 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaEWPVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:21:51 -0400
Date: Fri, 23 May 2014 17:21:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, mingo@kernel.org, tj@kernel.org, rusty@rustcorp.com.au,
        akpm@linux-foundation.org, fweisbec@gmail.com, hch@infradead.org,
        mgorman@suse.de, riel@redhat.com, bp@suse.de, rostedt@goodmis.org,
        mgalbraith@suse.de, ego@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        oleg@redhat.com, rjw@rjwysocki.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] CPU hotplug, stop-machine: Plug race-window that
 leads to "IPI-to-offline-CPU"
Message-ID: <20140523152145.GF30445@twins.programming.kicks-ass.net>
References: <20140523101134.17924.31463.stgit@srivatsabhat.in.ibm.com>
 <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OpkDJjDTRXa+mPUW"
Content-Disposition: inline
In-Reply-To: <20140523101216.17924.62447.stgit@srivatsabhat.in.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OpkDJjDTRXa+mPUW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:42:20PM +0530, Srivatsa S. Bhat wrote:
>        Re-enable interrupts                          Re-enable interrupts
>=20
>                                                      The pending IPI is n=
oted
>                                                      immediately, but ala=
s,
>                                                      the CPU is offline at
>                                                      this point.
>=20

So wasn't clear_local_APIC() (and the arch function __cpu_disable() in
general) wipe all pending interrup state?

--OpkDJjDTRXa+mPUW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTf2eJAAoJEHZH4aRLwOS6ZGcQAIyXrTQFoZF+FNd0nTm2/tt7
3clzweOOzV5zahsakWVlacDZKcAYrvc8WstMEjIgsWYZzJC9WdvqPVZeNknLRQ24
uchv62gLyd4081/NtS7euEMk0Wk/l4hmKIjk615dEy2/3k/sxYOTxwGWTwUIRcUJ
X/qCRSp/KypCagwnb2F2MGjJ6o401lP0RqMyZ7z97eTBjxg1hwO9slQiY3EWSls/
Z4QonnzpqHKK4VWa3tLLLjpL+U1k8IrjtTeS5ipoy9kIOtQ59LxP3PMGlEMZtTJ8
qcN4ttiON1YsP2TGUsrtUa2x5hRAGVUsJHPp8Yha5xx3X8ASIeu48mC8G5A+oyOC
8TTE0o7oLjLccLEVaPIbFzBEvNtV2Jg6fr21KLArv7RmMRFFDgL41/3/up3btRTD
PE88lV6AtTojnTHn/58Pe5i8J4MLNzMBNWdEeZdZbiMHRr3De45WkkAr6DbiRIW3
K0w+DwCmAG4vFcQuTuh7CuOSeQLfKtuxoEorDiqL/VdbKd8RahVA5iBc7RYi+y3r
zz3eZhiJChxywwD8xAvYlvHQfrlyMkuSrlgfQNDP6sjLBgvdb0AvKy6txcB10gf2
YYfgItKVLKMrfUGIiFOWZ/oYsJ1AjpRU1LsrZszqDcZsxAiGJfXVxojsBX1AyDYS
/ZD/jAC0PFkQImHDHOt6
=+H+r
-----END PGP SIGNATURE-----

--OpkDJjDTRXa+mPUW--
