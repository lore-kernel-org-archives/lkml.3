Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbaEOIPC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:15:02 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40871 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754742AbaEOIO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:14:59 -0400
Date: Thu, 15 May 2014 10:14:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Carlos O'Donell" <carlos@redhat.com>
Cc: mtk.manpages@gmail.com, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Jakub Jelinek <jakub@redhat.com>,
        "linux-man@vger.kernel.org" <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Arnd Bergmann <arnd@arndb.de>, Steven Rostedt <rostedt@goodmis.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: futex(2) man page update help request
Message-ID: <20140515081444.GD11096@twins.programming.kicks-ass.net>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <CAKgNAkh+PWzT2SByaLk_OtiAXeZSkWoMgu+ivDOt1dTWVtaatQ@mail.gmail.com>
 <5373D0CA.2050204@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhjhOMouxCL2qD2w"
Content-Disposition: inline
In-Reply-To: <5373D0CA.2050204@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhjhOMouxCL2qD2w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 14, 2014 at 04:23:38PM -0400, Carlos O'Donell wrote:
> There are other syscalls like gettid() that have a:
> NOTE: There is no glibc wrapper for this system call; see NOTES.

Yes, can we finally fix that please? It gets tedious having to endlessly
copy/paste that thing around.

--zhjhOMouxCL2qD2w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdHd0AAoJEHZH4aRLwOS6g1YP/j7VD0EhW7eGTLZLQmy/3V9P
a5oY1BkBJM8N8qZ44FUOJPayRGvp9WqswxdP9WxNzqtEq0CkkhTiA5BeSLWHQ0s/
XVOV2Jr693a9wbRP5pBAxS89iMhFkBcPiRDF8yZVYgOSr7sWPv7CnZsQpPX32BYV
DkzBIwNIbmn+5XFH4c8KeGu3OUHXURfOgTGj/hQro2FpfUBLskKLtLEZj7eF0T1I
/0wErUDd8jqbtD7YJwdIFBP4QJGziUaA7HqOu8wFNJT7EP+q1TR2uP+sOgxImrDm
kHho/DBjlPyXjfJtJwzit67h3y4Q7x7RPslzRsIehGJbt3zhuy5oFSsn5IshwZRT
sCotmTEbg5KWxY5RyZap0a1eMqGaW7k6X0ffSaU4p3jGTAsEcUBgkzjTkt4zn2Ot
pofkkklyvkZcqKvwTTZ5INvaRqHvLY4sw7JTOs1oFbVGHnjexfpWj8Nf0S2ii4BU
8rdjwwUtRQqCMvmp1S63p4LJGBn+JPvyOjs/x7Iw6kKxfLE9DvW2Dx70Th6i6p24
fN39/mJg4boWdq6RwpcTfPvqnduUPOpmj1GPcPgv4tm/7sBr0gEjI1azrZLE+QyR
hrFLKwNxKaZGzHrCRkesbc7nm1PNncaPMYtjsssZjA93XnVmtanv5bexTA+bAp+k
kX5xKEdSp8/JpSupKUry
=lINj
-----END PGP SIGNATURE-----

--zhjhOMouxCL2qD2w--
