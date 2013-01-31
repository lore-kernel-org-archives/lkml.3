Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3AaMh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 07:37:59 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751743Ab3AaMh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 07:37:57 -0500
Date: Thu, 31 Jan 2013 20:37:48 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] ASoC: Ux500: Fix build error pertaining to missing
 include file
Message-ID: <20130131123744.GG11078@opensource.wolfsonmicro.com>
References: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="27ZtN5FSuKKSZcBU"
Content-Disposition: inline
In-Reply-To: <1359635640-1932-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--27ZtN5FSuKKSZcBU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 31, 2013 at 12:34:00PM +0000, Lee Jones wrote:
> Some compilers complain when building sound for MOP500:
>=20
> sound/soc/ux500/mop500.c:27:27:
>         fatal error: mop500_ab8500.h: No such file or directory

Should be kernel version dependant I expect...

--27ZtN5FSuKKSZcBU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRCmWFAAoJELSic+t+oim9lFsP/31bIijLKhxyktmcvsgO4CbH
r+hqtp3XshSWLmNoIkj0NhegZsw/WTHTDk2ubL3RQ9RAJnZ4yjwVz0Qa1d4JjeHs
7Udz4lxcJcIrBsetEBaW4MDtphUtZ3tJAvnyy+h/mgm0ZsWYKuoHW3eQXZqEHyYq
ZkCDCFCFzQnJlORT+NrwwkIacL/C9ljl9kDo6GA1N2wwHRw2j1YWWjzh/vbhwo4g
Bw0NQF10kNUnhfHcAgO4mi838mggP9fXhGqRyOLhu8nPZhi5jq+ScNb2eAz25W7R
1hqBaK5C6OhQh3xc1OLZSEvL0q09g45fB4pz9k7dctZG0wRnqzmpbh3qDaPI7EbI
G1g5kEUrPB1gAgycIh2rmVjmJHrA3KopJDOqR4zDr7AmHdX0FzyF6holXpm7hqyG
8HZ262V0QqQxTPSsUkZdzM1rmrzn3fYP3w3xJnOr9w83v1gASSIVJgGcRKD6JMRb
qoykXrGTF4+BzTdfDyXn4MJ6RdtpIwmmECFnv1CVXtAJM6gRNc1LS3joWcL3s1d7
uJ1qAtmapg+kIuUyY3bI35I3aP+0w0zwxpps4pdifCBfKL+YwH15UAyysbEkg1f+
Tl3RIGNt3sTNb8cUyS6Os3kzyQqRyzb6oX/eckKBDU1292O6Xg3uh7q+l2XwHysG
Fg1fxMXtoGrZYfbPQyKc
=Ns3O
-----END PGP SIGNATURE-----

--27ZtN5FSuKKSZcBU--
