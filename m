Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757299AbaEIRQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 13:16:47 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757224AbaEIRQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 13:16:45 -0400
Date: Fri, 9 May 2014 19:16:40 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Juri Lelli <juri.lelli@gmail.com>,
        Dario Faggioli <raistlin@linux.it>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 0/3] sched: sched_setattr/sched_getattr fixes and
 improvements
Message-ID: <20140509171640.GA30445@twins.programming.kicks-ass.net>
References: <536CEAEE.4010609@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BzJ6Fzq6EYQX8BP0"
Content-Disposition: inline
In-Reply-To: <536CEAEE.4010609@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BzJ6Fzq6EYQX8BP0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 09, 2014 at 04:49:18PM +0200, Michael Kerrisk (man-pages) wrote:
> Peter,
>=20
> While looking at your sched_setattr()/sched_getatr() documentation,=20
> I noticed a bug in the handling of -EFBIG, and a couple of places=20
> in the code where the error handling logic could be streamlined.
> Patches follow.

Thanks!

--BzJ6Fzq6EYQX8BP0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTbQ14AAoJEHZH4aRLwOS626UQAKhzInLbabeazHkC4JSg2442
zZ3XgFo7kIWoMlcf8/vhJ/z5j40dfDG8h9d00JvrC3ymaaVVViQEve3wcQlhJ+Uq
3mBvCtYHicOwVpXFWpjonQCjfyu/DVeJhgxUKqpuXtdXxwG4U0PrB6FecdIcOfcr
7b0iREBaLmLaN0hLhmDyfkr9R72HlJs6Wt4ocxM+Pt0OY+HZdLCWcsjp9DFbtDw0
MoO3rgkcUJ7i4yAAvpzd7/Qk2qZLvSaUR2ITHLUaDsA/QS+maaCLMKRN0l4MsZXr
vNBgk7+sK8TtuKz5nmZ4nHRQRRSgUM91ymwQ9HkRdkHCQm4zDrXcbklrGN8p79yg
UQ6b4f5UWgWnRGT74sk9cTxCBSusR/CdBDXS0L2js0B1y2oO+LsGJf7B72tQCL5f
sDdBJ1QagbrwawudYhsMHPZyafUPTvNRkOEIoNKR7Qz9G0UR/Wa72BOIFo9yaahj
jRQppkMoae4WggFlKx0vZ9+V+U1Egs+lwR0J5T6Db4o2tUja/EgPZ2XQT+ulk4uK
cYr6Unl9lBe/1JeaI3AiO3Yg7bpICjNAZrkdOxR3/bhBiV1Bb3QjeKEhu2wf7kPC
mmC5R4n3BsueEmE7kHGoYd8T17T1lZihQOoAaC7i2msCkDlO1Tj+3ZEk66SToOAQ
fjCdZJIWklEubx/YKDgH
=Bj1T
-----END PGP SIGNATURE-----

--BzJ6Fzq6EYQX8BP0--
