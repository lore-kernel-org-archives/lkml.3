Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751518AbaCXVtt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 17:49:49 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:45887 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750875AbaCXVtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 17:49:47 -0400
Date: Mon, 24 Mar 2014 22:49:43 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 01/12] drm/nouveau: fix missing newline
Message-ID: <20140324214942.GA17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-2-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-2-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 24, 2014 at 05:42:23PM +0900, Alexandre Courbot wrote:
> Add a missing newline at the end of a DRM_INFO message.
>=20
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpu/drm/nouveau/nouveau_drm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMKh2AAoJEN0jrNd/PrOhDXcP/3qHhqDUfIVhIf3wQoFbNBW3
lbjv1aC54vthGFF9KP2ztk0xeVJ8n414TPxLYKXByErrT9rOmCbYzNrfdmXL8+h8
TsT9XIt+wblbwo2cFX6R7GgqBI5UXLsu/fGyKpusTAYf0qvSogxnpegizJmiTZvP
kQDzkrew84CT2BydTPcjoDk7m0LCKODlS2ghykg8PGbKk4hakim1RkFrU96oNJNd
dVhdvatLBk3vUZPKARIdR5knjU7mqOw5TFr88e9hlZ7f8aWFDqVy75a2mULsFfPv
2Tx3rdtcKWkku/AOXDZyeuQeX9KYJasyxyjWEnbtKZsihATf9vJ6i/RyrOHHaZwr
wKtYu4ApKqqH+/SStLq87VI5jo+A4epUMzoWpehO2brc4e+6dyD/NGMzc33suF8k
qoZb/zS0KqNucQD3ZoBz8vSWyvITl+PYAPcebgWIHBv9GK7+NnBrOXFn1Od48GRv
7+o4G8B+rrvrpn0xEeRK+gwvYh8LhzQuVusjoVoiQwXVOcCHpRG3lxnPiywPCR+k
QW2KUT757sAz5v6hcIvBMfJv4ZJWWD6fBj2QPA6iVxJJY1mr0VLjSNOq5ffHn+rW
aeaNkaAkOpYxQHf42uTJzIkcUOSHqqPSb4SE8IKWLaGktUbV48l4EwZTnaAA9Ewj
Su9ZIscyYnzXW4mIzawj
=fBzn
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
