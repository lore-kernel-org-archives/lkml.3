Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbaHZMmU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:42:20 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34444 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754794AbaHZMmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:42:18 -0400
Message-ID: <53FC809E.8010706@ti.com>
Date: Tue, 26 Aug 2014 15:42:06 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>
CC: <dmaengine@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Jiri Kosina <trivial@kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH v2 trivial 5/6] video: mx3fb: Update comment for dmaengine_prep_slave_sg()
 API
References: <1405095208-14642-1-git-send-email-geert+renesas@glider.be> <1405095208-14642-5-git-send-email-geert+renesas@glider.be>
In-Reply-To: <1405095208-14642-5-git-send-email-geert+renesas@glider.be>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="Tv1BugU0Rxd7CoEuLpB1wEoxwdC1h3UH2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Tv1BugU0Rxd7CoEuLpB1wEoxwdC1h3UH2
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 11/07/14 19:13, Geert Uytterhoeven wrote:
> Commit 16052827d98fbc13c31ebad560af4bd53e2b4dd5 ("dmaengine/dma_slave:
> introduce inline wrappers") changed the code to use the new API, but fo=
rgot
> to update a comment.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-fbdev@vger.kernel.org
> --
> v2:
>   - New
> ---
>  drivers/video/fbdev/mx3fb.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/video/fbdev/mx3fb.c b/drivers/video/fbdev/mx3fb.c
> index c645a0a0c341..5e97baf92721 100644
> --- a/drivers/video/fbdev/mx3fb.c
> +++ b/drivers/video/fbdev/mx3fb.c
> @@ -1179,7 +1179,7 @@ static int mx3fb_pan_display(struct fb_var_screen=
info *var,
> =20
>  	/*
>  	 * We enable the End of Frame interrupt, which will free a tx-descrip=
tor,
> -	 * which we will need for the next device_prep_slave_sg(). The
> +	 * which we will need for the next dmaengine_prep_slave_sg(). The
>  	 * IRQ-handler will disable the IRQ again.
>  	 */
>  	init_completion(&mx3_fbi->flip_cmpl);
>=20

Thanks, queued for 3.18.

 Tomi



--Tv1BugU0Rxd7CoEuLpB1wEoxwdC1h3UH2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/ICeAAoJEPo9qoy8lh718rAP/0ETKzUi3WdSzfEJf1jh5WMN
NpaNPzZNnvBDWvmGFlOORhto0+LewE6kgIw1A+7ieRt0YZeeRmwUwaW5EISae2/h
RJC6zQcNuM2tz+vvism6IghfINxT1hxeydfO4yXluLxjU8P5f0+L7u0Omm03pCqW
92O/hwAJLBbp9TSh+IBiyyE+bHS/4Y6nCd0ZBeDLi0bOv3SRnlAS4hWhFcbQRehj
EBziFFVXhSZuOAtLCOFD/PDphu0+nUpTdF7fSMNtPJRhpe97tm1Wx8/Ij1WM9HOm
8KhJayOJGUI1yiCc9HsPbec1CXDdvSsu3GbryrkAGxkRjzwIme/6IF6Omv79TjLu
2PaFWzGQDG7y35jP4wMj4zNpKDmqiczNfwMrZcbkYqpbdByU1QFK2K6myYYVVtja
EyVOQErIId0vQ7BD7ief6+Nmov6zVEevXkn4FieXv+Gt+WX+FmFObpR0SWbPK4OD
09j6szsAl3l8RJXn440NL3gKb834pSWOjhb5eJ8nu4k44Kdt8q3sVvtNAPV6XtqC
FtwCmxiTggXoMpGUd36u8+hQ0ZuhesZ3eLeJ86mDaqnppCgjeJr81eBbCDq1bVGY
LMV4WN4PW76CqZ3Sr2838lbVTlz8CpK7EaX+iGI/1MPyBQ850ZDy8P4liqIeKFt2
6Ym24TenqfpAdH1RB31a
=1/8O
-----END PGP SIGNATURE-----

--Tv1BugU0Rxd7CoEuLpB1wEoxwdC1h3UH2--
