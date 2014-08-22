Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbaHVJbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 05:31:44 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59486 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbaHVJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 05:31:42 -0400
Date: Fri, 22 Aug 2014 11:31:39 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] sound: tegra: tegra_asoc_utils.h: Fix typo in include
 guard
Message-ID: <20140822093137.GA10253@ulmo>
References: <1408699627-7364-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <1408699627-7364-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 22, 2014 at 11:27:07AM +0200, Rasmus Villemoes wrote:
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>  sound/soc/tegra/tegra_asoc_utils.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/sound/soc/tegra/tegra_asoc_utils.h b/sound/soc/tegra/tegra_a=
soc_utils.h
> index 9577121..ca80376 100644
> --- a/sound/soc/tegra/tegra_asoc_utils.h
> +++ b/sound/soc/tegra/tegra_asoc_utils.h
> @@ -21,7 +21,7 @@
>   */
> =20
>  #ifndef __TEGRA_ASOC_UTILS_H__
> -#define __TEGRA_ASOC_UTILS_H_
> +#define __TEGRA_ASOC_UTILS_H__
> =20
>  struct clk;
>  struct device;

Hehe, good catch.

Acked-by: Thierry Reding <treding@nvidia.com>

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9w35AAoJEN0jrNd/PrOhykAP/0I7U/Re3ToHKhxX3UuO+b3Z
iTN4TRR8bYGkd0HTSxdBXVfgXj479UhFRKAzsNWvx/DivXNI7ll6xtzIcT5BALYk
tEz2axYuz7hZw4yYeMughAJxPqoHF8iU+lDcMvmYFh1zLcpUwbwldKwOJ1TKZaYY
2xpeZ1W+zdDcBJoOGAsZwt1wL5d6Dhjq0v/148XrohpeRadNBJGuQMcUWd4lRqD4
JJFPrMrmQjgb7wSRL/z5UosJd0MEA+k3Fxak95OFSWeYPlggFyiVv969LmlvyoU5
kfw5CZPQXPaNNalQMObEXhBfN9MkrEEKY1RL3b1DNh1hs0ow5bEdFzRUrUFk68h1
VYcSpLMj7E/jULTto+gBYQkTDSC4+VO08RWuxaeBBZDrDfdH0p/o3hnTdRETHcuP
iF1+xfjiUjl8BJWPsv1dtaepU+hB8O1seKAO2pHBlRo5DsmaFDHoLkTq5nWfSmLH
1ggV9GulgINJN4gepBKp/OGiBH5aJMHDTt657IXJFptHWf5GZBwIJrr+Q26S8sux
5Z1eSGj8AnA5dZ2L0IWGhrl8cO2llEPR7/XjxBSYa+me1UNvMd6D1zysZtbveGC+
pux/UIhGWHgDGinqAy29H1gkJKBJ0S/s8Z1T4viGVYUVV4SDGV5VDB8qZOKrgegv
0PxhGSOSXB8jvYQ7wOvP
=rQL8
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
