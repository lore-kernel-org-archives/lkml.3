Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3KUUvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:51:17 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59292 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753861Ab3KUUvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:51:16 -0500
Date: Thu, 21 Nov 2013 20:50:50 +0000
From: Mark Brown <broonie@kernel.org>
To: Olof Johansson <olof@lixom.net>
Cc: Felipe Balbi <balbi@ti.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-ID: <20131121205050.GF14725@sirena.org.uk>
References: <20131120175814.GC27423@saruman.home>
 <20131120203400.GL2674@sirena.org.uk>
 <20131120205143.GA9182@saruman.home>
 <20131121024840.GA22970@saruman.home>
 <20131121104911.GM2674@sirena.org.uk>
 <CAOesGMi2wDz2PB7GJbfg3i4bRU+qgT+ubTa+WurQ96biyjaLsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Pql/uPZNXIm1JCle"
Content-Disposition: inline
In-Reply-To: <CAOesGMi2wDz2PB7GJbfg3i4bRU+qgT+ubTa+WurQ96biyjaLsw@mail.gmail.com>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Pql/uPZNXIm1JCle
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2013 at 12:27:06PM -0800, Olof Johansson wrote:

> If you have one email address listed in MAINTAINERS, and do all your
> actual work with another identity, you might want to look at your
> workflow a bit. I suggest either signing off with the MAINTAINERS

The only thing that uses the work address is patches and signoffs, all
my e-mail traffic is done from my kernel.org address (including patch
posts).

> email address, or changing the entries of that file. People should
> expect to be able to email you on the address you sign off with.

Unfortunately my employer can't cope with that at present and I don't
really want to use my work address for everything since all the stuff
=66rom upstream DoSs the stuff that pays the bills.  I wouldn't mind if
people mailed both, but if you're going to pick a single one then the
one listed in MAINTAINERS is the way forwards (which generally is the
address people manage to pick).

/me notes that he'd probably have been less grumpy if the message had
a subject line that had content in it, even had it gone to the right
mailbox there's a good chance I'd never even have opened the mail due to
that - if anything it going to the wrong place actually worked around
the subject line here.

--Pql/uPZNXIm1JCle
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSjnInAAoJELSic+t+oim9oDgP/34R0SqmILHILWrtkNFBDE9v
7HwE6jXjlQ84safDUk040X3npHld5DeIdJ6OZxRsSZdzvyUQIxAO3VLDFUC9zzUV
GrYH5+Gm3nWwjDczrQtctUZHn5jjOUpno+coiALSpCW//Ca933bW6wkO0ZW8cfTp
CCQ4cxUgTTIZf8y52yqjU4O0ImFNn2+AhtXojIs+3zDTinkTWz/gt6hKI7r5ZN1H
fBl9xnuiv0sPO1WTytvKIYiCkfpC3bt4USOSMzhAXLfQcv4pV4eyV2bUTzUzCUGA
usgoCiAMfdgQFb8oqi4LXMFYYHjpcKqEKIerNXS1BWlIbQiq85iL2WQJ2jam3uh7
mrZ9XejZKOM8wD6rAVfY3szmTyqaDjzhlhySF9RP+XvoYrfOqARNY77xPJrUj19Y
MwL31S5E3i+21SJkaI6Kqc27h2GbsnnutKiUIZlqQyzZSe+WwHr2TSKKoavwg6XH
9UjBp8JKEC0il4CCGEkWtqJAw8s+MEgTy14vtqpo+OZngkYNubmM/ci7cNgMgomu
IO+Rfzfff7Z/MFMuS1wc9wG7iZhSMUbfjCQC0eQMDQJJYdsUpQgic+u/cRsJQ6Vm
HHmI53ZMkKt75xfR5R5zKLzxvMPRVnWqbfkI3tzjKSzocYFzXfe3C2+Fq0PRnE+v
ZU6SyprWmU979QJ5NDP8
=HZwY
-----END PGP SIGNATURE-----

--Pql/uPZNXIm1JCle--
