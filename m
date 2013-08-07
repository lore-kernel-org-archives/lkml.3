Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab3HGO2x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 10:28:53 -0400
Received: from sauhun.de ([89.238.76.85]:40905 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab3HGO2v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 10:28:51 -0400
Date: Wed, 7 Aug 2013 16:28:47 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Chew Chiau Ee <chiaue.ee.chew@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-designware: Manually set RESTART bit between messages
Message-ID: <20130807142847.GC2978@katana>
References: <1371798328-31931-1-git-send-email-chiaue.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <1371798328-31931-1-git-send-email-chiaue.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2013 at 03:05:28PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> If both IC_EMPTYFIFO_HOLD_MASTER_EN and IC_RESTART_EN are set to 1, the
> Designware I2C controller doesn't generate RESTART unless user specifical=
ly
> requests it by setting RESTART bit in IC_DATA_CMD register.
>=20
> Since IC_EMPTYFIFO_HOLD_MASTER_EN setting can't be detected from hardware
> register, we must always manually set the restart bit between messages.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Applied to for-next, thanks!


--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSAlmfAAoJEBQN5MwUoCm2VD4P/1WNmrgJ9RqvcZu0RC1ywyw9
ipBaT8CluIEtTBza02a32/52FnTR1wzIphc/+CK7qgv8OQtrqPBWDsu97vvtSoav
z043GFsm087eF0yYHwJAh8s59vfdGJKq5khh/BFbkrvyEko7xeOfTdFyXfKnD0wr
/G9MATLHoL3X/cLtY4qMkFUvGfgk2yOudyda1k+/eaEpXIp4wtQBnIsuVbqekZZh
rL5NvjBrZFWDmeoQqNmvCZYHQBqbIB+TCNezkEpryxn6H+IyHSgVUWz3LGB5QHJ9
KoQCVQ5giO9mf3J1AaNHRxjgGWBWYdL1ur2FtsxmvO87Na7ShK7iILkVFAEfAlSN
oagyVgy7nzmtXe1TCXftG89R5gXgRQilC0p0R2dNrmQVqONrfDueW+5weCZVNqED
WQtayIeHukUuBJ8fMJ+EYsJ9283WoBdBLIxP7JwBAU3ImK2jTrZQqh+S75qiPR/C
FAm8b57CiXGMaVBq62r9mUJlyyGAnT5jIsgBjIe3aNnba0I62D28QIAOPT03/OVM
mKNaFCOWnvlplpZgosjCJMo81/NV+tdvTwfNrH35ds3iXK34JWfz4s+1DCeQV530
nTgmajCbiIrnyd6Y6BERmjHUdJh5GA2gs8QoD2zDriU78QJtN1e149dzdChr7KLo
KKyyTemXS3jsxPGe5BVa
=1orb
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
