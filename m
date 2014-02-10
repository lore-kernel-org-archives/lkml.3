Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBJMOk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:14:40 -0500
Received: from mail-ee0-f50.google.com ([74.125.83.50]:51935 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaBJMOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:14:39 -0500
Date: Mon, 10 Feb 2014 13:14:33 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        gnurou@gmail.com
Subject: Re: [PATCH] drm/nouveau/fifo: allocate usermem as needed
Message-ID: <20140210121431.GD20143@ulmo.nvidia.com>
References: <1392011821-2406-1-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lc9FT7cWel8HagAv"
Content-Disposition: inline
In-Reply-To: <1392011821-2406-1-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lc9FT7cWel8HagAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Feb 10, 2014 at 02:57:01PM +0900, Alexandre Courbot wrote:
> Memory was always allocated for 4096 channels. Change this to allocate
> what we actually need according to the number of channels we use.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Looks good to me:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--lc9FT7cWel8HagAv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+MKnAAoJEN0jrNd/PrOh7fEP/1Z7mQnIaUIK9Z40DcxFTgAk
J/+CGg3z4gLbDiBG9Cqw0cXKv9GRGMAy34AJiec2RubQZk3So87n8uTKcUT/nWSR
vpRBovyd70Byzs+bEkOOkUtGWXXgkbI0CPsxL1inL6sCGfEU+e76QkA/bbe3T4pP
N29LV+uFJQU4FG2rcOkFhqKe4hQe/edc4/b9RC7U9WP2paVI/Ex5Fu6MuGoKssri
1//6SyC72Afv5Pkk2weV2jB+ikUJEkodZovvIE39+aFEWA7LDTlmVOaYrZWuKLIH
t7hLVGNaWsRAIC6ntAyqoAgyd0ONFV0hams071CM7Ey/xtilG3N7gKoBSVKBx0+A
YCPRbr4IgPtdeoxbaYNTzYHkoa4L4QI64FsNxCbY5fSseZznBwellbgJmRVW6CYU
fzjGo3Mh+AIg1hfizYgm6r6wTOGZetpfsaupfei8PN7mNyfOxBZ6JOw2B1o7g4bS
Q9yw0wjq9cJ8tyou/SaSRxM1dJzSoumfeDb3sBcBuiV0C2v29eBz45td7sEDnvJu
kTb+z3EM98t0nmfzsH02Lnt/D/Dyr0JgSGEHr7SdL2sJRy4+DsaCs3JCo4ZiT+nn
D1vVNXpjxeJs2N/DcJt5DCE7W3dUKbkvRKgrqAEadsWjkR/QPSgRzStSwEi9+NB7
FNtV732ZNcOtv4dARF2m
=vm+j
-----END PGP SIGNATURE-----

--lc9FT7cWel8HagAv--
