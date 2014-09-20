Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200AbaITJ2o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 05:28:44 -0400
Received: from sauhun.de ([89.238.76.85]:58370 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbaITJ2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 05:28:42 -0400
Date: Sat, 20 Sep 2014 11:29:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Raymond Tan <raymond.tan@intel.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Romain Baeriswyl <romainba@abilis.com>
Subject: Re: [PATCH 1/1] i2c: designware: add support of platform data to set
 I2C mode
Message-ID: <20140920092909.GE1612@katana>
References: <1409712098-13997-1-git-send-email-raymond.tan@intel.com>
 <1409712098-13997-2-git-send-email-raymond.tan@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3XA6nns4nE4KvaS/"
Content-Disposition: inline
In-Reply-To: <1409712098-13997-2-git-send-email-raymond.tan@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3XA6nns4nE4KvaS/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 03, 2014 at 10:41:38AM +0800, Raymond Tan wrote:
> From: "Tan, Raymond" <raymond.tan@intel.com>
>=20
> Use the platform data to set the clk_freq when there is no DT configurati=
on
> available. The clk_freq in turn will determine the I2C speed mode.
>=20
> In Quark, there is currently no other configuration mechanism other than
> board files.
>=20
> Signed-off-by: Raymond Tan <raymond.tan@intel.com>
> Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Reviewed-by: Hock Leong Kweh <hock.leong.kweh@intel.com>

Applied to for-next, thanks!


--3XA6nns4nE4KvaS/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUHUjkAAoJEBQN5MwUoCm2yi4P/RO6ty3kZoLmNTCFyKHWZ8j9
ZA/3q2hJdiPl0yTKK3ffxyepRVUDGBYgyR9h9rzJrQ1wzL7RvS/2xlMQFTiiYYVH
9+vF3LG11eV90mDLOaDIp4irNKmvp6TqcHGuzjNwq5CEHpcDltvKaVnferG4V6yK
aEH509sKv48m5wq7rOxkG2m16s8JwHXmVkK1X0LTTfmwDeDUxljjBvFJE8WqH5nO
RsI32sSSNhPwa7b7qOBnp9X/DC/PAn3X3xix/kTTKZDX/35ylkRMFsvonGcbE1ll
ypTcwTBy/C98Y+jsCzDKlrMGfFLDNKJXhAlNyZC3LOIu2G7g9Z3iJ3LEtazhj187
sqG8hABFaUXEB6KCPx9KLTHsW4s5YbGtX1YEKvRCV8LhLiVQYFHu5+60Suqv3JKU
ISy5EM12Oj3ypf4Bc8qVKnLO6lD2mENVSIep/Mv6JlftslI+5BuqYhBH5haiIkJ9
6lBvqQ43t2U45J6FzGsJ1e31G13LNLs2bqDLmv/QP+Jn+nv94751kUQPeV9yfvyy
ZTQauhhr67YMci5VvopyewtgCbcd0JqY68mLdIHr4TPv8u2PRVEsJw+lnDbnR+Ub
rU7BfrO3MW8t+KEK7QnD7jfjbJJfUQAR+35AfbVDsKzPSy+CZRusHPvTbqBwYzGW
aFG48xgtlekJ3rDMB7nI
=B1ML
-----END PGP SIGNATURE-----

--3XA6nns4nE4KvaS/--
