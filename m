Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbaBLKSh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:18:37 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:36928 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740AbaBLKSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:18:32 -0500
Date: Wed, 12 Feb 2014 11:18:29 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Osipenko <digetx@gmail.com>
Cc: tbergstrom@nvidia.com, airlied@linux.ie, swarren@wwwdotorg.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drm/tegra: Add guard to avoid double disable/enable
 of RGB outputs
Message-ID: <20140212101828.GC3409@ulmo.nvidia.com>
References: <1392138747-18198-1-git-send-email-digetx@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S1BNGpv0yoYahz37"
Content-Disposition: inline
In-Reply-To: <1392138747-18198-1-git-send-email-digetx@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S1BNGpv0yoYahz37
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 11, 2014 at 09:12:27PM +0400, Dmitry Osipenko wrote:
> Add guard to check whether RGB output is already enabled in the way it's
> done for HDMI output. Fixes possible hang on trying to disable output twi=
ce
> (first time during driver probe and second on fb registering).
>=20
> Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
> ---
>  drivers/gpu/drm/tegra/rgb.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)

Applied, thanks!

Thierry

--S1BNGpv0yoYahz37
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+0p0AAoJEN0jrNd/PrOhc7UP/1um5TkQhc9Ae3hI8a+vO0Pa
1nnh69A0E6jUkln7QK6naAYHhZrI6Y6fiorWH1N8eF8fcdc/nHX5VwsHoQ7Lw3OJ
/3evRPTyf0e/w5gUALTai92dP7uTra4PrH8zB4RW8TU5/gCoCQD3+YccZcgNjFvw
phd5hE1lnwRcoS4+G6CetXRHS/zB1oiNedc7Z+X+L7U2L/rVQVxbC0QJdsYcefGY
gGcIUonEZkZgefKkiNKULsHNMxiBWAcWdsGVJWA9FqJnqiHfHmqrBfIY9Ob2/U5K
hulIFA3hjRNTZ3EGjtYZ2Q4aJdSIAj4ijRKkK2fiUvxYZsQ2+LBIIW3HLt85Elb2
ugEm14TijQGneUOzNAGAAtioqtY/ITdgOh4c3Vu1nSVIsMpUPrsYZ1bKf0Os7BWS
XtxYinlAWRCML/23mQZC+DepGNvL/N29rB3R5b7c7xawoutmpNQKqukmInJ15Te9
kYL96JN1TNvk2a3QI9OumI9VYAt/nyERgTSbCjeqcHLNPgL7JHs4CfI3A07EYEAt
+nRRSyZR5Hg82nn42xHI4Wm/Ms0CWXvUmUDn1b3D0Gi65+6vAgOWg0WiSwciROEh
6I0nnptWF8aekZZ3lNIXGJMJhb5Cr1LRWmL1PWsGLjK5rfSvPHEQwSt+/tOsskqY
FwlGaQxqe2ItkYZn/P/l
=IpyN
-----END PGP SIGNATURE-----

--S1BNGpv0yoYahz37--
