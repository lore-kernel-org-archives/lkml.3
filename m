Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3CAHnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 02:43:10 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59037 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751816Ab3CAHnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 02:43:09 -0500
Date: Fri, 1 Mar 2013 15:42:36 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, ldewangan@nvidia.com,
        lgirdwood@gmail.com, Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH v2 1/2] regulator: palmas fix SMPS no voltages
Message-ID: <20130301074232.GK25302@opensource.wolfsonmicro.com>
References: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQ77YLfPrO/qF/pM"
Content-Disposition: inline
In-Reply-To: <1361637341-22214-1-git-send-email-ian@slimlogic.co.uk>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQ77YLfPrO/qF/pM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 23, 2013 at 04:35:40PM +0000, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>=20
> Number of voltages for SMPS regulators was off by one.

Applied, thanks.

--LQ77YLfPrO/qF/pM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRMFviAAoJELSic+t+oim9L8cQAIVivB4PyqHa0YAENjCM0zgw
w5WEv3jCTCiZpd/SW8UCW0snGY7cgfIaB79NDb7IpK/olV3d8WRDIS442gHJH90C
3zxg1kJgTw9UVecrJ8tTeqWVcbyCxl5JXkJoTaDtOtXu8etY2tkA/3+nip+6+fPN
tmYYuHDJKDisynfO5jKg7E1T+KzemdOp4ezJz3TSjMjIRKUq+C9SysnkL/SXAJ4w
LSIlXmob2VSI0DaNhbLnHW8HganneiM+GCoG5VbOh53Ld9yHIo17n/0gvN4asWjP
8szHcxvqzlSDGLk+YSCYzkKC74BrD003uXckjwfjvM8gxpsRgXvF0waaUMYaN2gy
mxGSAhZZ8WHrIBod5hyaHvSD3kOc1SGLq9CpZrjysqRxwz8mAiqwXTiDVNWeFX8C
eyMt7ZLToHVoEHMhK7w2PRcFULdGtJwlfFlJ5Fpm6OqSX+6ua9GIenBWc+ij47qz
bofKjZOgDKm+TwASliH3tqG258dPkrxkBUiLbPhm7+uNM6L56vWDpK8hXb0VdR3x
x9dmCZ3qnxghdTaUTUqUNAOfsVXwCwtAhvquueS5Kr3AtpzREAIrF+7MXXWx/1Wn
Zg/5Gvn6Xs9q2IoHncfAfB7iNn/6eNa9owfxxNCBOPGgmZaW7Y8vrXPqUCGjqbTE
MtXL7yuI8jEVQeRmqn5i
=jB7Y
-----END PGP SIGNATURE-----

--LQ77YLfPrO/qF/pM--
