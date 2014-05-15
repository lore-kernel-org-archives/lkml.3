Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaEOOAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 10:00:04 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:48169 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaEOOAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 10:00:01 -0400
Date: Thu, 15 May 2014 10:59:56 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2014-05-15
Message-ID: <20140515135956.GC1966@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140515135600.GB1966@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <20140515135600.GB1966@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

forgot to sign it..

2014-05-15 Gustavo Padovan <gustavo@padovan.org>:

> Hi John,
>=20
> This pull request contains a very important fix for 3.15. Here we fix the
> permissions of a debugfs file that would otherwise allow unauthorized use=
rs
> to write content to it.
>=20
> Please pull! Thanks.
>=20
>         Gustavo
>=20
> ---
> The following changes since commit 1fb4e09a7e780b915dbd172592ae7e2a4c0710=
65:
>=20
>   Bluetooth: Add support for Lite-on [04ca:3007] (2014-04-25 09:47:16 +03=
00)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git m=
aster
>=20
> for you to fetch changes up to 40b9397a1a61a37917b93e7d57e6f2faf3a086b4:
>=20
>   Bluetooth: Fix L2CAP LE debugfs entries permissions (2014-05-14 09:07:0=
7 -0700)
>=20
> ----------------------------------------------------------------
> Samuel Ortiz (1):
>       Bluetooth: Fix L2CAP LE debugfs entries permissions
>=20
>  net/bluetooth/l2cap_core.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTdMhcAAoJEPs3PUX4s20oGIgP+gP0dgmbjQTQdrMARhnp1z3E
FvtAGWenWYX1jwuQV+j/C1z5HWTRRPf4aBeW3v9PNVFIVuGOMj2eWjeJ13S6JRBc
X22zA6ailg5yNUnevd0FL4IW8VwI17asuHeO8Kct0LKSh9kp2p87bhiOtlOmjGcY
tvpZmOykLM2TItdCgk/c+fzW+10RU+PI3wBI9Kt6McpPe5iKcl0gG2q3A4N2AbtQ
h+n56rw1phaReSZfdNcoQtAOweZWLDSA6njNsAJ/4qKee0Ke6y3sviI+jK1E82b7
T1UshVaIFV1I0QJCd5hY6Ojf9g94JaL+F8bGPIXid+0bPvb0hoshTJY3Hi4RPm0i
VKXyAxTn0ADeHUs9OLGN9ZSa6CDI4hiExRlasgrgeMFyLqBmwSdtAx017a8x62AJ
6/pKGpuBFO6fUZkGz/5UGvyAsbWMTlsRbqhRqJG17O0jufrbXfmg4/adytQ9ml3A
dnbej0TrbGdndJ6sLQwtEsA2qwFBh3mYQr0ojWH57AJ0QRKXXTpkQoaFXe4sHUG9
GB6yVafIrNsI0GAyMnsc4gcPh+VXekKknQ05AG8SeLXC079tosk3/+lKRdOefU8c
MqlUwOqyeMwwggAVh9M5taqolYfXK83tGtE5X+mE8ei5Z6XVRL3WAXTuWHjXsHAJ
WlyuxN6o6L0vi0aprEn4
=89+s
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
