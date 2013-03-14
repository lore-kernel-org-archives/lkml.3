Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab3CNJkb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:40:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50894 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab3CNJka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:40:30 -0400
Date: Thu, 14 Mar 2013 10:40:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Hiroshi Doyu <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] memory: tegra30: Fix build error w/o PM
Message-ID: <20130314094018.GA23538@avionic-0098.mockup.avionic-design.de>
References: <1363252334-4672-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <1363252334-4672-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:t0ArtarzCcVphFUrf5nrXxrUA4WweeeMrBnT3itE0Ri
 9lt8QoAk16IZmiXznK+8zMM8KHvYB4YshbCjlzG3ZiMJD/mb7v
 FO4RUwKISbsAb9v5oGYoNvCm4TQOYn+bZuMhJxMPxplBSAWkaV
 Sk/EzvMeqIOZu7YXVn6QazADgz3Pxkdj78C7VsKnoyspVSbDRk
 I0+XF5m97haHAuG8lJqlZdhj0eVi+L45w2HeTtikoAf1lCMMmx
 pQXgT7jBW+I8iwiIDul1tnMq9vI3aSmLE4EMJsfVQF5ezqXe2n
 c1MAY5qqwCHN9OwjoL1wx7boKzo5Zj06mD6sZcfq/IWVW1Rc0H
 HmC/xvzayM3Y1mMQ3y99+1NwC1MSg995S9M78nGdf720CAQuvD
 aWi2KhpMldR7UlZay3Px5VL3agXnZEeyzI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 14, 2013 at 11:12:10AM +0200, Hiroshi Doyu wrote:
> Make this depend on CONFIG_PM.
>=20
> Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
> ---
>  drivers/memory/tegra30-mc.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/memory/tegra30-mc.c b/drivers/memory/tegra30-mc.c
> index 0b97598..f4ae074 100644
> --- a/drivers/memory/tegra30-mc.c
> +++ b/drivers/memory/tegra30-mc.c
> @@ -268,6 +268,7 @@ static const u32 tegra30_mc_ctx[] =3D {
>  	MC_INTMASK,
>  };
> =20
> +#ifdef CONFIG_PM
>  static int tegra30_mc_suspend(struct device *dev)
>  {
>  	int i;
> @@ -291,6 +292,7 @@ static int tegra30_mc_resume(struct device *dev)
>  	mc_readl(mc, MC_TIMING_CONTROL);
>  	return 0;
>  }
> +#endif
> =20
>  static UNIVERSAL_DEV_PM_OPS(tegra30_mc_pm,
>  			    tegra30_mc_suspend,

Reviewed-by: Thierry Reding <thierry.reding@avionic-design.de>

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRQZsCAAoJEN0jrNd/PrOhnmYQAJrN0S9XON566kglm1yuZrJO
HDniJfgM5mMZ7HzqeZtAM+bw+5ECKw5suzZ4zj0HUBuc4SXUtIzqWd6CASLXhzTo
G5OPJZ8+tXk1+ADlb9/MGK6K9TrWhX3Vu/CYwC2K+HIY48A79wGtg+KYV+ZMYe2c
ND4nZ5okJ+wv4buBJr6J8/89YJJAt8jaJQCoEVHjrRz3y12mkwwglb9bMdEisMk4
OgXIoYuswFtmYka6IL/zCTQaZnlu5taAXh+91pUggr94hlYRe8NC5zFtnGhdIoJB
glag/aSeIrwYOEOVLG2pdPi05VkRYmWKXtAeIm/2H62LYDeCk+9P0AigkKqfiORP
lM0lU2TOq0hQx3EJYGgOkoMP8AJzJBQLWWwoMR1L6D3Z5QOW7xKuF7mz+TXmydCL
OFEtMPGt+9m2megobO4N+xVA5p717OaCz9PljOePNtCQy4JIArcfeXCxypaAme+I
nkOlTWvJQ7dG1kcN9eDVaelS2yabmqDQRz77pw5WC0fHUy4nLH+TUOphwA4js5L2
nWLJf8T6WvVneaqSA5Wxkss7LZBddDjEbdZtYUPQutYhVYKxjkyT04B3RCOk0lCm
Xxdli64Fuf4F/JnQM1/Q69EbeIo6qRTO0FhoC9nrFMVhoyGcgWtxjKBcdACxVurK
u4KCVZx8qg+lKlbNHjnx
=p35M
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
