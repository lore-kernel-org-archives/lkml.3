Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3KVB5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:57:20 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49826 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab3KVB5R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:57:17 -0500
Date: Thu, 21 Nov 2013 19:56:48 -0600
From: Felipe Balbi <balbi@ti.com>
To: Mark Brown <broonie@kernel.org>
CC: Olof Johansson <olof@lixom.net>, Felipe Balbi <balbi@ti.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: commit c368e5fc2a190923b786f2de3e79430ea3566a25 regresses MMC
Message-ID: <20131122015648.GA855@saruman.home>
Reply-To: <balbi@ti.com>
References: <20131120175814.GC27423@saruman.home>
 <20131120203400.GL2674@sirena.org.uk>
 <20131120205143.GA9182@saruman.home>
 <20131121024840.GA22970@saruman.home>
 <20131121104911.GM2674@sirena.org.uk>
 <CAOesGMi2wDz2PB7GJbfg3i4bRU+qgT+ubTa+WurQ96biyjaLsw@mail.gmail.com>
 <20131121205050.GF14725@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <20131121205050.GF14725@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Nov 21, 2013 at 08:50:50PM +0000, Mark Brown wrote:
> /me notes that he'd probably have been less grumpy if the message had
> a subject line that had content in it, even had it gone to the right

oh cut the crap already. It contained the commit sha1 and a pretty
self-explanatory "regresses MMC". You can't expect me to put everything
in the subject and you're only "grumpy" because you're too lazy to move
your neck 5 degrees to the right to read the rest of the line.

what a long thread for such a small issue Mark, just stop it already.
The issue is fixed in -next and that's what matters, everybody's happy.

I know I am with my working MMC on BBB.

--=20
balbi

--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSjrngAAoJEIaOsuA1yqREECIQAJNqXlnt8+FCC9VEy2epY7Sc
TpOINrhqtllU9nkUyz7OZ0RycSMPfZVBh/ScEB/W5ipDhmLjovCAkB4f+Cnwfrtt
UATzk5/Ou/6TuCGt+XIAgGUrOAihi4LLTdOY9S2MvCJ2ET1QZheeXn8bf5ZCn1py
E2KhBff+2F6WfqdF6jOwFUhUVzSaRvss0ibGbFLVz8HfABLOYXrlAWRQEO8om3uG
v6rw/yAo5CIUSFejOVEVhd9YqioGfRIAQVmxSRq0pra78QF9q79dWqPI6ZO2M9Xh
LriBpvrpdGnCKBosovdbZV7dfuSzCDCG7LdRRNKudyldkJGPAep6MjXjb5HNeyNc
eoKRbsAswgZZKuIwSPSlhVyMfXiNDoqRNygqC0AEWUTjEYsY+pSWCOAeAcu39c7M
lc69qOz0vQ1PZAlr/Qo52RLuZbcZs/eC3zSyIjAWIMcq7mfSg2Q4gW0K92yKIsvo
d+U5kkLAjWTGyL1IIGcVek1QdEE4a6vmVMXn9n/6IyhsxujSgfbKm5dHAYLkO1H/
650BEbfGX4ZNb9z3KM6oCyxqJAEbhaaWSOn4wF4SsLZr5xFMoWqJGE1HOIX0xBN0
A8VOcKZ1tjB/WTkHszn/sT/13FvrQs0RHJQdpcMXmJJo+FSg/lWRln5bV9uKKLDi
5f9Uv9nG2r9YtKqRU41y
=pwOK
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
