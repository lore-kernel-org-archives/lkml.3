Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbaDXR6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:58:35 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:58367 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758813AbaDXR6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:58:31 -0400
Date: Thu, 24 Apr 2014 12:58:25 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: <airlied@linux.ie>, <airlied@redhat.com>, <robdclark@gmail.com>,
        <bparrot@ti.com>, <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [PATCH] drm/tilcdc increase allowable supported resolution
Message-ID: <20140424175825.GC4659@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393873738-27327-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lCAWRPmW1mITcIfM"
Content-Disposition: inline
In-Reply-To: <1393873738-27327-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lCAWRPmW1mITcIfM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 03, 2014 at 01:08:58PM -0600, Felipe Balbi wrote:
> From: Darren Etheridge <detheridge@ti.com>
>=20
> 1680x1050 appears to also be within the bandwidth capabilities
> of the device and memory infrastructure.
>=20
> Signed-off-by: Darren Etheridge <detheridge@ti.com>

ping

> ---
>  drivers/gpu/drm/tilcdc/tilcdc_drv.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.h b/drivers/gpu/drm/tilcdc=
/tilcdc_drv.h
> index 5bb64e3..b47ec24 100644
> --- a/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> +++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.h
> @@ -43,7 +43,7 @@
>   * with optimized DDR & EMIF settings tweaked 1920x1080@24 appears to
>   * be supportable
>   */
> -#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1280*1024*60)
> +#define TILCDC_DEFAULT_MAX_BANDWIDTH  (1680*1050*60)
> =20
> =20
>  struct tilcdc_drm_private {
> --=20
> 1.9.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
balbi

--lCAWRPmW1mITcIfM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTWVDBAAoJEIaOsuA1yqREtTIP/iiwlj9wWlvYvfrH5Sfn2hBd
yoQnIf8v0h5YpVCPYgo08LoBEuY1OcbIefeckreBEHIKZZviPuHNtKadaNlzs1XM
404yiF/PEhUrVHK/PTVaK0TvpetbpGYvGPUo6H6IrTkIRh+M5x6tmJCNx0dPm3UY
wH3lbpvpdlw5qgb2EFmQoghSCy7AVGprGC1gNJt6j6zwWQwDG5HuK2a+zIQLDZSz
OGh8OiRPIu9RmJvsXSHm1FkaB9EngtYWWFICnSVw+qgFZivvIffYU0YNUPu1df7f
wX8xfG3r9Qqy5o0eELm7V+hiIeEXobsAc5aquDGzOg7WJ0s5txe+DKFqHwX4YZzG
LfPm1T57D5NE+9+pukeDZ0H3Opsa8zTt7jCsyGMO5RfptM88wdyLT8257tnQMimp
3LvMFILoGbGygGSqzXEhwgyKkwAbjd2gWN+TxlrI91uxOa+C6eVrdsxkaEb6vBqV
NkG7ItTtOTwa+4roVSZfImAN/S6DBLH4RsLcaZK0DPCuzaSZywqimaiPuh9aJF7P
/f1LVlzq8+wB/hLYt+cjYolifEY37osJ67dXsIycl/v+ryANdQ9yRzYfrD/tRxjH
uxFOWlns8tpvTjhZrmAdTwpMr1pEzmuLv5hmJPZ1oCtmxzL8Pj/bjTGuWmw1XyWR
iqIZLNpgH/TGnGTCSIs6
=j1wY
-----END PGP SIGNATURE-----

--lCAWRPmW1mITcIfM--
