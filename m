Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994AbaG1Q5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 12:57:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:59926 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825AbaG1Q5o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 12:57:44 -0400
Date: Mon, 28 Jul 2014 18:57:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Jason Low <jason.low2@hp.com>, mingo@kernel.org, aswin@hp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip/master 3/7] locking/mcs: Remove obsolete comment
Message-ID: <20140728165733.GU19379@twins.programming.kicks-ass.net>
References: <1406524724-17946-1-git-send-email-davidlohr@hp.com>
 <1406524724-17946-3-git-send-email-davidlohr@hp.com>
 <1406566175.2411.13.camel@j-VirtualBox>
 <1406566438.25428.6.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oMox5YjQTvUj8F+q"
Content-Disposition: inline
In-Reply-To: <1406566438.25428.6.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--oMox5YjQTvUj8F+q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 09:53:58AM -0700, Davidlohr Bueso wrote:
> Well, it's not hard to see where the contention is when working on
> locking issues with perf. With mutexes there are only two sources,
> either the task is just spinning trying to get the lock, or its gone to
> the slowpath, and you can see a lot of contention on the wait_lock.=20
>=20
> So unless I'm missing something, I don't think we'd need to make this
> noinline again -- although I forget why it was changed in the first
> place.

Not to mention that there's no actual caller of this function in the
entire kernel ;-) Currently its just 'documentation' describing what an
actual MCS lock looks like.

--oMox5YjQTvUj8F+q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1oD9AAoJEHZH4aRLwOS6H2oP/jVuKgJBINUFzgzspFbtaiX9
Ga2SAamST0fucc9MEmZKjT8P/181HZTrhcwdYL1DyW6ohdnWN0gUApSUDntHE9wY
jOWttFL/92n02bXXe3Px2xTUw0kOCbY7q7l8OuWJDcKdztJB5bjs13ljVCV0whOY
3hiDClYGZVuClNzaWpfY8nuDThArw+uLtARYMsRovUcGUWGjyKttFe48F/wHv2d+
Yvs3d0u69lG0QEySXULSd/D6zZwEwRqEMUECrv5y873SJJPQVz78Ne6hXgBrs+J3
Qa/QggvwTwsOcBWEuNIESVwQ1tt+8GNYbg1NHTPnjwMg7jYWHFIdPWsY/lMERtve
4vCG+0YECMhT+pdAsWWyicDoBXTaLOw2/1tT2fay9mRrjjN2aBlt6PW80y0Qljdj
if2y2C/HAq+UeTT06S81D9DiBjhOR2KNZdyx11bow0zdS7ZGL8JxQnkISkgeaM9W
YLgUqbS2SrWfImqJMH5kJoQg0wK818niTo8yGQrHKk3e2R4o+CvkfGQdddx/86ci
VM5aWjnST2Q5DEQDOHjdcXl31fXmtYSfICaRY4ToGsT9EKYxDy2cVQcXn9uT4W/u
LcRP/z0rem71nVAXU/ru1ky3QYqVDxbUKWFRaNvCeKH1WpNPoJlRKQQu0d9r1mdA
trmVVJbLH6pU8Vit3CqL
=RVDX
-----END PGP SIGNATURE-----

--oMox5YjQTvUj8F+q--
