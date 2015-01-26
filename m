Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbbAZMoJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 07:44:09 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57916 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145AbbAZMoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 07:44:07 -0500
Message-ID: <54C63672.6010700@ti.com>
Date: Mon, 26 Jan 2015 14:43:30 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
CC: Ferenc Bakonyi <fero@drama.obuda.kando.hu>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        <linux-nvidia@lists.surfsouth.com>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] video: hgafb: remove unneeded comparison
References: <1421165699-9033-1-git-send-email-sudipm.mukherjee@gmail.com>
In-Reply-To: <1421165699-9033-1-git-send-email-sudipm.mukherjee@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="K12w4wi7VGcoJSC0P1uKSCCT5xQQ2BBcn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--K12w4wi7VGcoJSC0P1uKSCCT5xQQ2BBcn
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 13/01/15 18:14, Sudip Mukherjee wrote:
> var->yoffset is of the type __u32, hence the comparison will always
> be false.
>=20
> Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
> ---
>  drivers/video/fbdev/hgafb.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/drivers/video/fbdev/hgafb.c b/drivers/video/fbdev/hgafb.c
> index 5ff9fe2..15d3ccf 100644
> --- a/drivers/video/fbdev/hgafb.c
> +++ b/drivers/video/fbdev/hgafb.c
> @@ -417,8 +417,7 @@ static int hgafb_pan_display(struct fb_var_screenin=
fo *var,
>  			     struct fb_info *info)
>  {
>  	if (var->vmode & FB_VMODE_YWRAP) {
> -		if (var->yoffset < 0 ||=20
> -		    var->yoffset >=3D info->var.yres_virtual ||
> +		if (var->yoffset >=3D info->var.yres_virtual ||
>  		    var->xoffset)
>  			return -EINVAL;
>  	} else {
>=20

Thanks, queued for 3.20.

 Tomi



--K12w4wi7VGcoJSC0P1uKSCCT5xQQ2BBcn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxjZyAAoJEPo9qoy8lh71td0P/j55yqcoaYO9dNSx7aPJaue8
rsJueRFAN5+ZhV1Pr9WHMhcePXqC2jLP771EycLvZ1EHnVMm+J5vwXF+1rjo8CQr
/7iUy74fUCF3iADjloI8pHyfDMi40jSfr+OWM2nmwRrBE0becH75kZVFGJIqymOf
bj0Wp1/yYhcN4LJZ2MvLDi/iG/gAK4hHWtcLyZqIVsyKq/3H8xaZqOL39JIPC/kY
kZ4tQjOeWDfY77rqKoDa5rhe8/pxx1lDUV91MpzN/ZMnk/SCK3Ml6eL6KIIrLNkK
qtZKGcwdEzMjxxoMGa/7bmMWYcx/cOt6Zkg2ED33IuZ++nUMqbm+1cZpzZPSeaez
quZ9cp7pxj62qLmFzpBnJaNBmuUa6Nji4UIWCVhG87/6Lo3o7VlgkvQfT7RJ5pd+
6Fit7/xG9Oi4Y4uKqCxuWSElmfDVq4GgA1lsDXE8BMGhIpF6xaXrBAC6wQX02CoZ
VfuRrDzh6Yb7Di07v/oZcB8KP48ojzs1wZbpZeR8CrVrD68TWGXDQ9sTaQ1UOUtF
prT8JuDSvjBHlntn9xh8XSjlaMDZHHGRWDRFiDXGId1PCjY8yWT44cZHRu5CNK4G
dv8gpubSCsx1JpPzNz/UXJT1c+D4Y3f6uDlisuAGZqODDzPvgcmagq2W6M/Ra0Nl
Q0nFQKFnm9LdC9sRLJsi
=KMA7
-----END PGP SIGNATURE-----

--K12w4wi7VGcoJSC0P1uKSCCT5xQQ2BBcn--
