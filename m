Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752231Ab3EZK0O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:26:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61124 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab3EZK0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:26:11 -0400
Date: Sun, 26 May 2013 12:26:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: airlied@linux.ie, linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] drm/tegra: Fix syncpoint increment return code
Message-ID: <20130526102607.GF1652@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-7-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <1368791388-31441-7-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2013 at 02:49:48PM +0300, Arto Merilainen wrote:
> Add syncpoint increment to return a proper return code based on the
> return value from host1x.
>=20
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/gpu/host1x/drm/drm.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Maybe this should be folded into patch 5 because it is related to the
fact that host1x_syncpt_incr() now returns proper error codes?

Thierry

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoeM/AAoJEN0jrNd/PrOhOcQP/A8bTVbRudqsLjxCuC0fZdpH
F4ZsvRyOENuLu9uXEzUgcHYlAmZ82r2r9FV5BxUnk9sw/W2wJjije1w8V3oDwlCG
ufXBGI7/QjilXMaAlQEYcU9HBKRZVRedtDwpRclPy9fh0BsuospINBri2sFKOYqB
wx827Y+/aIMe161QcKX9ePMFQ2F/m9OFAxpYABA8HUHZH0Hc08yy6//KmFlVAe3u
M68uK/1A/93gW6TKBH+ad2rSPQ6lamjspKIaIgbeCQtseGG9L0nZ0vaQ7WqDWjMC
eFEhW4resB3VHvLyhTNMAR6fZlf+npJu3UIT6HOL/KVUtCVmVkp1vlYixwvLO2K0
PMpLFouVeN/9Ye7UDSl1bYng2I5CamP6iEAmpvIxMIMxEw/MEXGJU5OrAq25PFnN
6d58VAo1JKWMVSu5hRh1ifwnb9QvxIVaObWYhZI1UF4T2pY4jsJzXKWKqX8QyyaA
oLrYx6j+vjHGUTvqYhBKFc59rM2huOVRhP4XlGpyHmThTND7Trha4SoX6kK6pOo5
98mpNT9Xo6fjY8rTkfRRRLTki3EHxK7x68ZeEEfDDXbCP6OybOH1c8OG6ERg4r52
3+BbTWP+BH5FFFyCf91Ic3Yore34MY6l9a0HfTmSHbuJzXi1VOA9UkZh882cpS2L
owYt6LXYuayLIcwsw2u2
=axDN
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
