Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaIYG5K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 02:57:10 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57434 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbaIYG5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 02:57:08 -0400
Date: Thu, 25 Sep 2014 08:57:05 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Kiran Padwal <kiran.padwal@smartplayin.com>
Cc: swarren@wwwdotorg.org, vinod.koul@intel.com, dan.j.williams@intel.com,
        ldewangan@nvidia.com, dmaengine@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, kiran.padwal21@gmail.com
Subject: Re: [PATCH 2/5] DMA: Remove .owner field for driver
Message-ID: <20140925065704.GE12423@ulmo>
References: <1411540764-27571-1-git-send-email-kiran.padwal@smartplayin.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AjmyJqqohANyBN/e"
Content-Disposition: inline
In-Reply-To: <1411540764-27571-1-git-send-email-kiran.padwal@smartplayin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AjmyJqqohANyBN/e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 12:09:23PM +0530, Kiran Padwal wrote:
[...]
> diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
> index 16efa60..a6c0b3f 100644
> --- a/drivers/dma/tegra20-apb-dma.c
> +++ b/drivers/dma/tegra20-apb-dma.c
> @@ -1597,7 +1597,6 @@ static const struct dev_pm_ops tegra_dma_dev_pm_ops = {
>  static struct platform_driver tegra_dmac_driver = {
>  	.driver = {
>  		.name	= "tegra-apbdma",
> -		.owner = THIS_MODULE,
>  		.pm	= &tegra_dma_dev_pm_ops,
>  		.of_match_table = tegra_dma_of_match,
>  	},

Acked-by: Thierry Reding <treding@nvidia.com>

--AjmyJqqohANyBN/e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUI7zAAAoJEN0jrNd/PrOhW5kP/1Xj4rhyUhkcJKCBAzEYqiDw
m0s5PUV2NtnjRvNJcLleu0XG4tgOFaUfy589riDn5rqP2Z7irP4HuubSl4174xWR
3jJ+UI+KanUFBvpE1uAn70vRU5ElYH08cmtw+qOtPqLOV/n9rUFjelKnu92wgEXI
ukK6CacAoxdtvh3TIwqNthu1t0l/Q8Ex1ltbXxmk8rZFNa8Dgqm0azcdyCRTsQ+p
Asi+Yz8dwCf5RgQuOf0M5EuKjgy/b3+NLgY9GGq7HMwy2MDRDE7SVNA8CrOFi3d3
lbTxBbRZpYjlhPbNTS4DITCaCzU5P/nvN+9eF/IbpBX2HKPqm87P5OM2b3wvwf2o
l+EdBAePxrb5ovc37/GM/zT4GbC3VXFU2O1YJIPhoQ+dJ83YtArQ//GqRPXbGSZy
RI6r2Nr8qcXYxpZ6QT63En5QQfmgSyiKysRFbFk1ffk65Lag/e12Ia2ZIwO/8Q+E
r5Eom29IsYKSJPgDRKj++IOudzbsuGkdmHDyL5y6Nefb/JpGoq8bhJtuyi6BuExO
mIA7R+P1ELFBS7tfto0h+enqXvdkmfTAnC+tmqIl0SIFHDbjB7icXm3Av3Exoc61
C6/nWNeYIVHslistwHTt25V9qYdr8Ng+aWf/GRTOn17ZQ78YpbaXj15TJEbXzL8Y
lEubLCNU/ZvhEuLiU/x2
=SWTd
-----END PGP SIGNATURE-----

--AjmyJqqohANyBN/e--
