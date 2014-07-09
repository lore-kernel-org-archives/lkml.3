Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbaGICBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:01:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55662 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163AbaGICBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:01:31 -0400
Message-ID: <1404871272.26540.36.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 000/125] 3.2.61-rc1 review
From: Ben Hutchings <ben@decadent.org.uk>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Date: Wed, 09 Jul 2014 03:01:12 +0100
In-Reply-To: <53BC9A89.20809@roeck-us.net>
References: <lsq.1404846109.699842714@decadent.org.uk>
	 <53BC9A89.20809@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-KxzP9Atd+Mvohm5LA3c5"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KxzP9Atd+Mvohm5LA3c5
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-07-08 at 18:27 -0700, Guenter Roeck wrote:
[...]
> Qemu images fail to build for mips, mips64, and x86.
>=20
> Build error seems to be always the same.
>=20
> lib/nlattr.c: In function 'nla_parse':
> lib/nlattr.c:201:3: error: dereferencing pointer to incomplete type
> make[1]: *** [lib/nlattr.o] Error 1
>=20
> Culprit is bfc5184b69 (netlink: rate-limit leftover bytes warning
> and print process name). In 3.2, it is necessary to include <linux/sched.=
h>
> explicitly to get the definition of 'struct task_struct'.

Thanks - I saw this same regression occurred with 3.4.y, but somehow I
missed what the solution was, and it didn't affect my x86_64 build.
It's odd that the compiler doesn't report the name of the incomplete
type - seems like that would have saved us some time.

Ben.

> Details are available at http://server.roeck-us.net:8010/builders.
>=20
> Guenter
>=20

--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken.

--=-KxzP9Atd+Mvohm5LA3c5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU7yicue/yOyVhhEJAQoFIw//XrHtfva0LcsN8hmUWjHgqa4bOIDDsvJP
omCtYkIfyzzNUgGIQ1AdwdAo67rwrESg1hIDs6tacFW6Q3xPHdI5AXhHTv05D0Qd
adY/TwE6oa+InQgNxkQgDSrvcglbJ5p8iahK6MLpCXc7IF8PecSXhdJyROvzh/Tb
6kb6ssHLtPi7vvhXqSKHDqUmPGZAj7c+iNrT2Z0J9HAj1pMIg3uvdXew2ZK5Kpg+
tl+L6ar9XkJKgyYrHyVOx/D7FN547AwG9HY23WZmjbp+QKqJNeSK+DyEgLAJYZbt
YxFZjP8Ex7viEczuxVEJBfSC4JCKRHb7amGEJoCET4xRtgFFdW4VdkvFC5VY6Kbm
7XwMwB9tUGImeQkxu4rnRQkRlnQihug0qpiO5aSdv32evmZ2YQgO5dcSPYoA6lfW
k1sQqwIjAwW9DYcJMHK9wRL67BS3QzlnPzYfggptyhsZAoa3RCMhEU5STPCc04+a
eX9K0oZPJOVYcvhSv0DPurHoKGxRgGuyE+vy7AfluJf7rGp/aFom2YUZ1pCsKaXq
wpyGE8Z0rNcRpo9zM94/9FeYrAjt0rzaMundXexrFs1ZTe55IbHFGspvTgZcOBWT
Z1sfBUx6I8GRN0Q4QvWxoMS729Nytcuxb/3poYymCZz7/cFsZCP8Su16gMDmOx7c
OxEgNGNfZKg=
=HLkG
-----END PGP SIGNATURE-----

--=-KxzP9Atd+Mvohm5LA3c5--
