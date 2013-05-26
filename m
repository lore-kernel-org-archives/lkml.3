Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3EZKR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:17:27 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36576 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab3EZKRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:17:23 -0400
Date: Sun, 26 May 2013 12:17:19 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: thierry.reding@avionic-design.de, airlied@linux.ie,
        linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/6] gpu: host1x: Fix client_managed type
Message-ID: <20130526101718.GD1652@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-5-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <1368791388-31441-5-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2013 at 02:49:46PM +0300, Arto Merilainen wrote:
> client_managed field in syncpoint structure was defined as an
> integer. The field holds, however, only a boolean value. This patch
> modifies the type to boolean.
>=20
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/gpu/host1x/drm/gr2d.c |    2 +-
>  drivers/gpu/host1x/syncpt.c   |    8 ++++----
>  drivers/gpu/host1x/syncpt.h   |    6 +++---
>  3 files changed, 8 insertions(+), 8 deletions(-)

Looks good. I'll wait for v2 of the series before applying this to make
things easier.

Thierry

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoeEuAAoJEN0jrNd/PrOhEckQAJgu1tKUf7rkWCOFWZTuWJ1N
T3teimxD1g77C4QiejiFx+PdZra/PneRWVsuJYTFwfKOZ706adg8vnP8fsdpXWB+
Mngyg230JY+NTIqlMjFSxuOlzBHD/HW2zW38tgF2+Du+q2BuDKtVG+1ucQUT2pX7
EHRhiwjqxXq9aXbZf1H4XiVpaG6lXFFaLTNGDSpd51ponBICBmcx8UDZLqw/3CvQ
OuvDQP1J+V720g3ri5Zyq7JiO9CzzDQARlNNtGW5m4QN9fM/GkoEj/K0xniS0F5A
zRylsjJn+n3ELBJfsrBayod+kDFPw+pHVvBRM3EUcaWrS6oUkXmGBeGX8AgGXalA
omTd3K5dpKG/i2IfehpQBO4z1Dc20G2YQzKyaW6F7ptJHMWkOgEc3bd/hzYObtbF
zaFvU/rNm7pNPRqwTdsCxReqtlVfvyDZSZuV040sa6venQf3N011nS0BN6JPOzNt
dcDa6JGzD9m8kLnvtAAkJ2QIlPuLZdTuZ8yYETBfDXhnsRUgnyk2qOQ780jwRowW
olUkZrc2DGPGMK05mVAuvJwjtlurov6tNyCI7WlbWxqxl/xPoQupSXnyD2SMuzSZ
W/e4zz7v63ReFk4RFyIOLM5Z/0pIAwUA8VQ7DGbsa4D8MGXM10A/f2thpCyJflIE
4GJLfXwsQgmo7iAs8JYG
=nZLz
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
