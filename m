Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbaDBNKo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 09:10:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50232 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758658AbaDBNKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 09:10:43 -0400
Date: Wed, 2 Apr 2014 14:10:28 +0100
From: Mark Brown <broonie@kernel.org>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Jean-Christophe PINCE <jean-christophe.pince@intel.com>,
        linux-janitors@vger.kernel.org
Message-ID: <20140402131028.GC2269@sirena.org.uk>
References: <1396384008-14353-1-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0eAbFZQk1SsvtJhS"
Content-Disposition: inline
In-Reply-To: <1396384008-14353-1-git-send-email-david.a.cohen@linux.intel.com>
X-Cookie: Printed on recycled paper.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: rbtree: improve 64bits memory alignment
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0eAbFZQk1SsvtJhS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 01, 2014 at 01:26:48PM -0700, David Cohen wrote:
> From: Jean-Christophe PINCE <jean-christophe.pince@intel.com>
>=20
> Change regcache_rbtree_node strcuture fields order to align the pointers =
on
> 64bits architectures.

Applied, thanks.  It seems like this is something there should be some
sort of tool for - it doesn't obviously fit into any of the existing
ones though.

--0eAbFZQk1SsvtJhS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPAxBAAoJELSic+t+oim9dssP/2lRt5fEPQtylVEkJKoT5Bhr
R3b1q8lo7Qq5Chpgb7M5N6B62Q2Ax2z2MV6Ks4JdcTzO9+y36e3JSq++AKX/t+B1
DJYBqBHb3z92aWzI9wroKjxUyiLN231Cp3rH5owKxg1BGRMkJpbjjtrcj7FujoTt
Pbf6P6ypPXC73MIpzDRl8IKxDznZ8AT9SMdgujJAanx70FoeyKpo0LarZ9cWV2xW
bbf6PRLpRuAwIiNa4sez/RJfIQ/5SfXVNyJvXQzsewoOvOcMMgvKCczqjrYgyQ1S
dLX0TgpnpQtwn+GbPmg9XWDnhwJTBmwR+I1Ksb2A1C726JPct62gcQWOn0/U3XWN
B75DNY7JrBuwqJ7h/8+LBxZHrQSoo774162cWeWP1h2WfKZIpJpoNsjAKyN9p6VT
LW6d3TBPTQQcY1avBN+OSGgIIw/n0VjniFPmlydL9CqlSzltl75g568MamRvVOPx
U+a2GjbEnrinFifQzQybu2lqABhEoxEXvE7mLm8tVcDhHiqkxw1BYjJwyVgPRKUf
VQRCKUSc4bvlU7gVt/rxerVj06hsRWs1+d0ix1R13J5230WAYrpDrEbOQL/Gpx2A
ncxSYqV/Ccy8QU71/5HV5fM0BBpzeYn36SVxgtatEoHlBHYQamJcHAdeHfCdTE8I
k3wcBdyBGJAcim4ftRE4
=H+TF
-----END PGP SIGNATURE-----

--0eAbFZQk1SsvtJhS--
