Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898AbaGTHmZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:42:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:33565 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbaGTHmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:42:24 -0400
Date: Sun, 20 Jul 2014 09:42:16 +0200
From: Sebastian Reichel <sre@kernel.org>
To: weiyj_lk@163.com
Cc: Tom Gundersen <teg@jklm.no>, David Herrmann <dh.herrmann@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] HSI: ssi_protocol: Fix sparse non static symbol
 warning
Message-ID: <20140720074215.GB19112@earth.universe>
References: <1405833440-6731-1-git-send-email-weiyj_lk@163.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <1405833440-6731-1-git-send-email-weiyj_lk@163.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jul 20, 2014 at 01:17:20PM +0800, weiyj_lk@163.com wrote:
> Fixes the following sparse warning:
>=20
> drivers/hsi/clients/ssi_protocol.c:904:6: warning:
>  symbol 'ssip_port_event' was not declared. Should it be static?
>=20
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to linux-hsi.git:

https://git.kernel.org/cgit/linux/kernel/git/sre/linux-hsi.git/commit/?h=3D=
for-next&id=3D0a0ea07d3dff0918484f01c576f098dd4911b1af

-- Sebastian

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTy3LWAAoJENju1/PIO/qaiPYQAJIgKq+ZE4hBFBqm0o0YbKI8
ddVQeq4EB9vZFObpYJTcy5rQcXhuqmvJ6EHM9HPTcO7SC80nEIUit2uAEr/34sbU
peQ4CCt45kQ1aiDKrBbNdJsUkBeTpyV6nEAKfDzFVLfXRLg/gnXkpbji/K3eHd1G
wToqJAKcLHP7YDhpskJzkbyqph0ppHTCm1Mh+MfnkT0EUDVaYnXmN5X1vZxOKzMG
63h0Z+IgO7PV3hDrV0c4YsN0KhQbEgUXPvxH+ybz1raI6lR7AdZ+o6+jUC+aC6Qa
WfAAmf5Imiyi+gCUByghI+aUb3Ag364v2j1ruysOXkrw0iqcipjI6oGqqZWBGxVD
vpYO9cUtzVVGmgOCQSlz9R0No+dRIb1vxccqobP0BiECCVhxoJoW2tbFzdhZPx3H
pzLD4Mf2k1H0NTAMhUQykOwvTEMtr1WNL97Q1MVDp2KYu5B03enHjE3XV0uRnRX8
ZFwsQoDaLaH4AmJBNdoyCoUjzvGUnapRhEED5QlooqtFP2ZiKU4xQxZQvKVah6Ii
Kx3kHBkFnRb8APhzexr25wvJlZBntjPHSc1tcXLovXh3TxxVEUN26lp6jWWBzlbV
W77gXRDbKMbWDKrRobNh71g5M9s2aiXo/WPMRGOYntGDvoQhhhfJKaqdpDRyIus2
z8pFOvuLYMvor0ddUvzJ
=QNtt
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
