Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab3K2K4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 05:56:52 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:56314 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3K2K4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 05:56:50 -0500
Date: Fri, 29 Nov 2013 11:56:01 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Fabio Estevam <festevam@gmail.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 1/2] regulator: core: Replace checks of
 have_full_constraints with a function
Message-ID: <20131129105600.GJ22771@ulmo.nvidia.com>
References: <1385569457-8650-1-git-send-email-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BOmey7/79ja+7F5w"
Content-Disposition: inline
In-Reply-To: <1385569457-8650-1-git-send-email-broonie@kernel.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BOmey7/79ja+7F5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 27, 2013 at 04:24:16PM +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
>=20
> Simple code reorganisation so we can change the logic for deciding what
> full constraints are more easily.
>=20
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/core.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)

I see that you've already applied them, but for what it's worth:

Reviewed-by: Thierry Reding <treding@nvidia.com>

--BOmey7/79ja+7F5w
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSmHLAAAoJEN0jrNd/PrOhdqIP/iWRS+2v4noJGouO1i5ZDaVx
4sUGWVhm162GVDiG+TDqfOkgAJu8i6etcCeTmy0Bpkc9gCOUhqZufVnUR3/CJebo
b9ujRol2FE8nPksZHV0YNrYF3g/NPRtkfJl+vXKXqB7xthzWwsr65k/VK4qT8mFP
jAhwnC93m22WjrDV2jcXQq5xJfnTmGGEGbYh//ZdjQmLh6pNINARRlj3tWsbaQp2
oMa7t7oXmLGc97m7535jx+f7xzDQIPciyfABVrh56VmYyHqqBSR2Ai1yyGNywXRi
KL5V0J8tAEMp9tqOVP5ilLx2Z8Q4IJpxhLGITxH/kObLKZqWVLPiC2T6P/dNBx8f
98lQY43zQYzkpqn4VJHtq6ZcOO4iIUYIqoW0MbtaUR6zzr0Mg9c+FRA7O3aVIdvB
aeng1OqGxFLnAGBEDSY3VJyNzo8FGEqL2R2mKXJBQXuOQ9T5ot8aJLrVlBG1oZlU
BmPrfuDJZL6SkBoF9Thr8sSN32VNcBv5lmFSFbSWTs5v9n9K9fGhpB3bEFMT/eE4
YJIC9skxePXyINZ3ORbxMGIPrZA7JgMGS0SvrjDk/Nv0gVIyUsua7wt+16jl0B54
ryPuJidXxd9L0sTHnld/PYMLsv6mjfVcC4JGbBAWrp4oCuQBooQYTS/DNQkj4rtu
f0kPRIhVHz86T2F3ChWU
=2wqP
-----END PGP SIGNATURE-----

--BOmey7/79ja+7F5w--
