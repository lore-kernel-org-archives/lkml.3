Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaFFEaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 00:30:09 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:41338 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbaFFEaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 00:30:07 -0400
Date: Thu, 5 Jun 2014 21:29:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: guanxuetao <guanxuetao@mprc.pku.edu.cn>
Cc: gxt@mprc.pku.edu.cn, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] UniCore32 update for v3.15-rc8
Message-ID: <20140606042959.GA19182@roeck-us.net>
References: <20140605053032.E84EE146058C@linuxdev-32>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <20140605053032.E84EE146058C@linuxdev-32>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 01:30:32PM +0800, guanxuetao wrote:
> Hi Linus,
>=20
> This is unicore32 pull request for v3.15-rc8.
>=20
> This pull request includes bugfixes to make unicore32 successfully build =
under defconfig,
> and some changes for allmodconfig (though not finished).
>=20
> Please pull tags/for-linus with following updates. I hope it works this t=
ime.
>=20
> Thanks for your patience.
>=20
> Xuetao Guan
>=20
> The following changes since commit cae61ba37b4c2672704cbd8a626fbd85be7e67=
d9:
>=20
>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2014-06-=
02 18:16:41 -0700)
>=20
> are available in the git repository at:
>=20
>=20
>   git://github.com/gxt/linux.git tags/for-linus
>=20
> for you to fetch changes up to 8c76c188d498a85c5b1a1f10840da57129a108a0:
>=20
>   unicore32: Remove ARCH_HAS_CPUFREQ config option (2014-06-05 08:36:03 +=
0800)
>=20
> ----------------------------------------------------------------
> UniCore32 bug fixes for 3.15-rc8
>=20

FWIW: Compile-tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTkUPHAAoJEMsfJm/On5mBqrkP/RPZn3O5TV70bGZWWggIcM3Y
WrXcyK1u4TJWrkWForU4D3Dupddtq56XJLOBHzYixVhM6FwTGMj0gtOeQpN03R6b
qK0sGRPf2m37+SVi6RziY64QVb27/qHnO8qzZhR0doSUxN8yDU3sPDpP3pkx7+GL
YNaaLaZz2piFkiB+YUeFa/NiC+TaEquyEsXV46Su8UbdGxa1nV88Q1Vzdz9OqPl+
1+7jCo+yHWJ2rODNyyl3u9SMehTSzxlWCSWmPWHSFGOLANGulAkgB3yqRV+OLZx5
VuOTbQUZ/5jploX3AcuSPMBNBzOZOKfru7sDbtl9xta4nswmekbMDzKdmiRV4cwy
AWOYMCK7jYA47xJBVeINlSNSkjO7lu0wDfLxaZ+eBiPnOyQ4McesWQ98K3MlBXpb
h+KlP4JDwXrEj2An0rHOaKAlDwv9Y35c0a1rVvniIqQXpe/ukLPCxlC2N5Z1Zfky
QyU4ZhEFdaVvLayl+h94CM+t/bg0YckmWbmi67C65g3e7oFyYYKS8xTZ4X6NhFHH
8x4SB/9YuHbWuKhI8mTtDyAZ0RC+ZmN6G2TDTZGEyds2rDqcNDOphTxJSpfXcd6A
EhocxX00Jm97a2A7qCw0UYI6XeeU9/tvv1RjshdqMJp1BHJZVaPTu5eWaPQyIUv5
V09Ty6i8v+A1qYofAnUY
=6L/c
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
