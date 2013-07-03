Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab3GCUJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 16:09:52 -0400
Received: from sauhun.de ([89.238.76.85]:51526 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932690Ab3GCUJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 16:09:51 -0400
Date: Wed, 3 Jul 2013 22:09:43 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Vincent =?iso-8859-15?Q?Stehl=E9?= <vincent.stehle@freescale.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org,
        Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>
Subject: Re: [PATCH linux-next] i2c-designware: use div_u64 to fix link
Message-ID: <20130703200943.GA2958@katana>
References: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6TrnltStXW4iwmi0"
Content-Disposition: inline
In-Reply-To: <1372758414-21513-1-git-send-email-vincent.stehle@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 02, 2013 at 11:46:54AM +0200, Vincent Stehl=E9 wrote:
> This fixes the following link error:
>=20
>   drivers/built-in.o: In function `dw_i2c_probe':
>   of_iommu.c:(.text+0x18c8f0): undefined reference to `__aeabi_uldivmod'
>   make: *** [vmlinux] Error 1
>=20
> Signed-off-by: Vincent Stehl=E9 <vincent.stehle@freescale.com>

Applied to for-next, thanks!


--6TrnltStXW4iwmi0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR1IUGAAoJEBQN5MwUoCm280cP+weSZlgUEbzYzokVWjay2cvd
Hfz4TSUX8rRRJ6p8jCmuPH5T6PruPFPpo4NOsi9LqSAWtUUNoz0J4wIZyxoWIl87
belhcGiQJsTbpC9yFeojoO1mg1BLGYcdRccsHsVN1kw9D6v4Yf1LpFn5u9td0Q48
5qyHBgjw7E9NUjD+fVmIlWxmoVVrrx7t9IMQCzVI/LtnlUzx0yFAAeJWyyw8VOcC
c26qRjFkxnJ+/S+lbkFEieTdzFl82bFukyD+YalPCAkR+wSqkurCF14UoXBI6PYA
2cXgCPSrgLVsIK8VLnaKt/0Als+BVuXsCpzWDRJXSwmed/WsEzAIjE2SuKKzfCcl
XW29qXlelraXNyGtKtEI4CPjm6wkR1M/x32LfxbC48xow/NEk4Up3kWxTkqSzDNg
QzR4HFlPG2PX/0cauf/6hd3Yu65Hd8t2DTX/SM9BRQFVHjEMUDDDgXeXNO9QXTxD
V90AxD32aU5sssSoSBqHqV+qxECXAK72Bz3kpmAxevRQptvJQ6C8b25M6ZzXxH4+
UMh6i/32myEdo+52V/ZTyROf2bFRSuG3fgkvKZZSm0QzXzWa64x+yBoohCtolP/I
nob5y5FRPVurI60YZyjq1K27Tui7zWRCqv05cpx2i/Jfe9kPirSlMjuS98LWxP2t
yV9PLFTnwH1B9jw7N7Qv
=lYZH
-----END PGP SIGNATURE-----

--6TrnltStXW4iwmi0--
