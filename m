Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174AbaFYF5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:57:25 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:47743 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbaFYF5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:57:24 -0400
Date: Wed, 25 Jun 2014 07:57:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
Message-ID: <20140625055708.GG6758@twins.programming.kicks-ass.net>
References: <1403538095-31256-1-git-send-email-riel@redhat.com>
 <20140624151454.2a05082e@annuminas.surriel.com>
 <20140625050735.GB28774@twins.programming.kicks-ass.net>
 <20140625052144.GH3588@twins.programming.kicks-ass.net>
 <53AA5D2C.9000401@redhat.com>
 <20140625053138.GF6758@twins.programming.kicks-ass.net>
 <53AA608F.50301@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Nachn7RqbTHiMSEX"
Content-Disposition: inline
In-Reply-To: <53AA608F.50301@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Nachn7RqbTHiMSEX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 01:39:27AM -0400, Rik van Riel wrote:
>=20
> Here it goes:
>=20
> When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
> on a CPU is determined by the group the task is in. The active groups
> on the source and destination CPU can be different, resulting in a
> different load contribution by the same task at its source and at its
> destination. As a result, the load needs to be calculated separately
> for each CPU, instead of estimated once with task_h_load.
>=20
> Getting this calculation right allows some workloads to converge,
> where previously the last thread could get stuck on another node,
> without being able to migrate to its final destination.
>=20

Thanks!

>=20
>=20
> - --=20
> All rights reversed
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1
> Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/
>=20
> iQEcBAEBAgAGBQJTqmCPAAoJEM553pKExN6D4/IH/1Ez7G3jAnYFpQYvH/wSm75V
> kbH+mouLAqeICjHRdXAr1SGuD8i85JeUeDU2+SymdhC+hwZXbvR/aQfX0/ok4kN7
> e7kJbaNS6Lrq3bDjm74aTpMKB+zK2OExqR1DQBXwynbUahAyx3+9uXNDYp35yZwo
> tt+h3Rdrmy2lTTpE0fuEjGc8ODrEJjeWyYAVxT/aQXnwgfXfp6BZ1SEXyRRmrxR0
> BunsgWTO7uBxGGEIZrrm/l7mdIrsi4oAN9C4RA7v6LMR6cUW9Fj5o6iva9X714wG
> txP4/AGowucS5VckN1RIaM8/pzMB3MVuAmCTX4PqWg1jf3eggcQpe5/4/bVYUqQ=3D
> =3DQgYM
> -----END PGP SIGNATURE-----

http://www.tummy.com/blogs/2008/09/05/enigmail-message-composition-and-mutt/

--Nachn7RqbTHiMSEX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTqmS0AAoJEHZH4aRLwOS6++0QAJbsc8C7/Vf/yxEBzLtGL7EF
FR4C5bYdrNZtK8WqOspsjED0OArs/vR54Y15kE+k3mthAEH9+pkJg6Z1n/eJu0R5
zv1HhM+02vbCwrFUFv86w+e+0zG0yyOYfr/cssGpXrn88y88XR95KuvLHXLI00CW
UO4gmp9eiwb83CzeVUKyHTD5iTEbfa2MLD5mSHja1A0figocPfk1B6Jko5aBGCB8
yKpHFO0chDnxSMVIKe8tvvYDtJIPKy6brzVw1QOI28YwrDyrCTvhZH0kkIW50oyc
B4SNik0Tj7wgKAXGlhOXhJBS7HrMF57AYXmK7lbK5l4+liUWltElq9d+2qUYEMMv
7a4etCi36flQbovUdrPHZtZAjsra7aorBhZS/m6TKZFvcoVKjWXaB0unlXh89TVz
yOLqAxN/uNTgvrXrFi8YGFGZqfM+CCcVbjfgSsfE5MlWTSvnUR2UMgq25tgAdlxe
B6nYCRvRtVEJKnCZk6D+wdPhPjcwHZ0jyQ6Ar4dhLfq3awIoPveLhV3JMArc/XmD
hvtKr8ozJMSb9IU7fu8dLZ2F4LPoP7+jRz1n6jmS7Buolex8kb6+W9DLKSDDU+E8
JY03jVSjyQ592VR4qbBjChAGEzov9CyBngyTbca0QvUJdJ09E3CxIZWufn21+PoO
iprunWLZIHTkKztJJXDD
=J3f6
-----END PGP SIGNATURE-----

--Nachn7RqbTHiMSEX--
