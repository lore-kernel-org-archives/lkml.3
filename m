Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab3FOKJl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 06:09:41 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:39782 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab3FOKJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 06:09:39 -0400
Date: Sat, 15 Jun 2013 12:09:36 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/omap: change "!CONFIG_FB_OMAP2" to "!FB_OMAP2"
Message-ID: <20130615100935.GA2477@mithrandir>
References: <1363204102.1335.6.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <1363204102.1335.6.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 13, 2013 at 08:48:22PM +0100, Paul Bolle wrote:
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested. Perhaps the first test that people with access to the relevant
> hardware might do, is to test _before applying this patch_ with FB_OMAP2
> set. Perhaps this negative dependency isn't needed at all. Or is it
> obvious?

I don't think you need access to hardware to test this. Checking that
the dependencies work properly (using menuconfig for example) and
build testing should be enough.

>  drivers/gpu/drm/omapdrm/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/omapdrm/Kconfig b/drivers/gpu/drm/omapdrm/Kc=
onfig
> index 09f65dc..45875a0 100644
> --- a/drivers/gpu/drm/omapdrm/Kconfig
> +++ b/drivers/gpu/drm/omapdrm/Kconfig
> @@ -1,7 +1,7 @@
> =20
>  config DRM_OMAP
>  	tristate "OMAP DRM"
> -	depends on DRM && !CONFIG_FB_OMAP2
> +	depends on DRM && !FB_OMAP2
>  	depends on ARCH_OMAP2PLUS || ARCH_MULTIPLATFORM
>  	depends on OMAP2_DSS
>  	select DRM_KMS_HELPER

Regardless of whether the dependency is needed or not, the typo should
be fixed, so:

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRvD1fAAoJEN0jrNd/PrOh4vkQAJlGgL6eOjujuoAwSTR4nmWc
fonYX16HfY8Ttcc52vHgINTHBQaD56OsfVNyNwyuzxf3w0SaxLtxLPeLPCDFcfaQ
KDgITTzLb3sj8LjLR0IgC7uVdIKis4+TktNVGEKa1jcrjrUIYaglX5EuK9gPofz1
5My8yMbRYOmvnKuxYOcN21M7GmBBYBFEhPa5fvilvj+AdxTc5us6/KcEZgixEaYi
yybxujZrtXl7zriTfNyJ12BHptsWDgE6TN9YM7NuMsA0iuQSx3vbR4WtlTMhBTbB
8o+XPaSa6SqmKfVCVduD2UyjItAg3DKnseOCJ+iskcidpQS7Ubj9x9LxlmiCq+Hk
VmEVgJaksnzGz+n2if0kEAufbxPnAKcIRnX48dnrmVfBKq/LPIXBLbHoZ73ihW+E
K4YlA3T6zV0j1nTJ6LOpQZDSxPVGl+RaR5MADUYhoQyMiU1DO9Ptwb+N1IIeD8L2
Cp+zHiJYEprPHaFsZoblifmi6ggHJthKWqRmHOE1n1WujK+3+MXsVVceTb1RcNFB
/hxg6E5/gpVVg5snCagCmddD7RGAeBCSuZYoL42zVpM/72U9qaFsMnGLOVFC4YsY
d+/vaD57+7agU8Vq934JYSROF133HHY3eezT0Ow8ytHrgSWeZR4se4YpDrGWUPiX
CV1RdUiwCGNLWZLSLM6q
=ls+N
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
