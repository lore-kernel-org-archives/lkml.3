Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569AbaFCOey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 10:34:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:41857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbaFCOex (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 10:34:53 -0400
Date: Tue, 3 Jun 2014 16:34:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patchlet][resend] sched: Fix up /proc/sched_debug to print only
 runnable tasks again
Message-ID: <20140603143446.GQ30445@twins.programming.kicks-ass.net>
References: <1401801261.5788.2.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5ZC8HHDsDfqlD0R9"
Content-Disposition: inline
In-Reply-To: <1401801261.5788.2.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5ZC8HHDsDfqlD0R9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 03, 2014 at 03:14:21PM +0200, Mike Galbraith wrote:
>=20
> Commit b32e86b430 dropped p->on_rq check, leading to printing tasks which
> used to live on runqueues, which is very noisy and highly annoying.

Yes,.. but also useful for the numa cruft :-(

When printing all we can get placement info for !running tasks.

Not sure what to do here..=20


--5ZC8HHDsDfqlD0R9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTjd0FAAoJEHZH4aRLwOS6rR4P/AwRq76tqRzucw5/I67Y/6eR
IcWbNa/OtA9a67dflPIGlAOihxLcFnTB2JQPxmNrZhhd7KtCjVM95RfsXjW7YbWA
+ysrG6CqxJ69dUYGY+s6AnOLnQyPuSeS3hzQ6FhUBODATcGyUgPsqJhKubo0Nd0g
nK90hjbhmRkjnBxqekdbdnE8AvYOIAjlNaMZxQe4vw7y1nWAriYbAKyYHm9P1HQl
3TXu/K+zFzpmqcx4eUsHyk14Z+Q4F04GuYcNKe3f5EtnA3C6SUQd6y5g9b/LrmgY
N/UwvGntGRzu3CfMn6k5eLpXdtlHR5/Mk2mkr2YXKEBHsWtyoKh07GWSCC4bJ/55
25f3uwePtgpunBkTwSDUU7575RGqN7TfO+cZk5dgVHUiIOqBhnmXs7ptxtW93n0J
0ucDN56ZW2ekGTK9LbEQWANPa8UgvbNguDeYsCwoxR7owPe1w4qezk5EhIEwBCF9
tyTMxnp6jB3yNQeD/bp0oETGo/soKZvqocwDjR/H9s7ZmuHqy3dwwsLEbglnp+6P
p/FNc7lRyEfa/dpXwlDej79wTEP+ch0oQiauX+GRSXen21d61DbEpCQWxurHDtL5
82rNOMdOh4CZ7QMt0JGwUZT9QjynICCN+LpfuWonzB0ASsi/uKU0CHyIqJ3uhaPj
1DVOxzTdSdosgs2GoWUM
=3n1V
-----END PGP SIGNATURE-----

--5ZC8HHDsDfqlD0R9--
