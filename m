Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3DOMOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:14:22 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:21093 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442Ab3DOMOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:14:20 -0400
X-AuditID: cbfee68e-b7f946d000001e37-ed-516bef1a0630
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>, "'Chris Ball'" <cjb@laptop.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Bing Zhao'" <bzhao@marvell.com>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Olof Johansson'" <olof@lixom.net>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1365698338-27503-1-git-send-email-dianders@chromium.org>
In-reply-to: <1365698338-27503-1-git-send-email-dianders@chromium.org>
Subject: RE: [PATCH] mmc: dw_mmc: exynos: Turn SDIO interrupts on
Date: Mon, 15 Apr 2013 21:14:17 +0900
Message-id: <001701ce39d2$c0dbf8c0$4293ea40$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac420y61+gjzK/dASFCqEvUS/c7HFQC+hvyw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKIsWRmVeSWpSXmKPExsVy+t8zY12p99mBBj1zpCzmbT3KarH99UY2
	i7PLDrJZ3PjVxmpxedccNosj//sZLU5d/8xmcfJPL6PFsRlLGB04PWY3XGTxOHRlLaPHnWt7
	2DyunGhi9Zi88CKzR9+WVYwenzfJBbBHcdmkpOZklqUW6dslcGU873rIVvCNp6J58hK2BsZL
	XF2MnBwSAiYSTxaeY4ewxSQu3FvP1sXIxSEksIxR4tqLdcwwRTfmPGKBSExnlLh5+TgjhPOH
	UaJ1yR+wdjYBLYm/b96AdYgIeEm82P2AGaSIWaCdSWLBv9csIAkhAVeJybdegzVwCrhJPP9/
	GmgSB4ewgKPEzf8GIGEWAVWJyS/mMIHYvAK2Eq8729ggbEGJH5PvgY1hFjCQeD+rjxXClpfY
	vOYtM8gYCQF1iUd/dUFMEQEjiaOvMyEqRCT2vXgHdrKEQC+HRMuSJ+wQqwQkvk0+xALRKiux
	6QDUv5ISB1fcYJnAKDELyeJZSBbPQrJ4FpIVCxhZVjGKphYkFxQnpRcZ6RUn5haX5qXrJefn
	bmKERHnfDsabB6wPMSYDrZ/ILCWanA9MEnkl8YbGZkYWpiamxkbmlmakCSuJ86q1WAcKCaQn
	lqRmp6YWpBbFF5XmpBYfYmTi4JRqYMxmvu7+8e3N+6wPnjt0G6SvPGB00nK5vvTHH7c+JWqy
	f5y0aseyazbP4xKKlndkXbq/1NaAa2Kr6uPr++7maL7+7/OC6dvyD2d95jg0zq15oXL3zufF
	1ZWmPxSbgsJfZO39XbS7vW+W3L8jB/fK/D1j7CpWXn0748CCHtHOhuVrH2yoKFTvaVivxFKc
	kWioxVxUnAgA51yBlAgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEKsWRmVeSWpSXmKPExsVy+t9jQV2p99mBBg2bRC3mbT3KarH99UY2
	i7PLDrJZ3PjVxmpxedccNosj//sZLU5d/8xmcfJPL6PFsRlLGB04PWY3XGTxOHRlLaPHnWt7
	2DyunGhi9Zi88CKzR9+WVYwenzfJBbBHNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjq
	GlpamCsp5CXmptoqufgE6Lpl5gDdpqRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfI
	AA0krGPMeN71kK3gG09F8+QlbA2Ml7i6GDk5JARMJG7MecQCYYtJXLi3nq2LkYtDSGA6o8TN
	y8cZIZw/jBKtS/6wg1SxCWhJ/H3zhhnEFhHwknix+wEzSBGzQDuTxIJ/r8FGCQm4Sky+9Rqs
	gVPATeL5/9NAkzg4hAUcJW7+NwAJswioSkx+MYcJxOYVsJV43dnGBmELSvyYfA9sDLOAgcT7
	WX2sELa8xOY1b5lBxkgIqEs8+qsLYooIGEkcfZ0JUSEise/FO8YJjEKzkAyahWTQLCSDZiFp
	WcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/dxMjOIU8k97BuKrB4hCjAAejEg/vBO3sQCHW
	xLLiytxDjBIczEoivE+OAoV4UxIrq1KL8uOLSnNSiw8xJgP9OZFZSjQ5H5je8kriDY1NzIws
	jcwsjEzMzUkTVhLnPdhqHSgkkJ5YkpqdmlqQWgSzhYmDU6qBcWOz2oM5Hc5pS/5tfqOXE/Io
	XnDS2/vCicsfn/F6GmmlP9vG+ORNdc+lG/lX8DLpvWRK13zqOWm2QG9w8zbr4xWvfCPEnP+q
	7Nf6UrFs4uzbP8V/LPuueX21Uay3d98iceG8FOkrybKFfo5vOvWW8DSrJktkrGVMrCor2dR7
	4fAdxSOti56eV2Ipzkg01GIuKk4EAEtOa/JlAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Friday, April 12, 2013, Doug Anderson wrote:
> The mmc part in exynos supports SDIO interrupts and they work fine, so
> turn the capability on.  With this I see download speeds increase
> about 10x.  This is a port of a change present in the Chrome OS tree
> that can be found at <https://gerrit.chromium.org/gerrit/#/c/26729/>.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index c7f0976..3a227be 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -192,10 +192,10 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>  /* Common capabilities of Exynos4/Exynos5 SoC */
>  static unsigned long exynos_dwmmc_caps[4] = {
>  	MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
> -		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
> -	MMC_CAP_CMD23,
> -	MMC_CAP_CMD23,
> -	MMC_CAP_CMD23,
> +		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> +	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
This line for [1]
> +	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
> +	MMC_CAP_CMD23 | MMC_CAP_SDIO_IRQ,
[1] is for mshc1. mshc1 is only used for SDIO.
As I know, The others are improper for SDIO.

Thanks,
Seungwon Jeon
>  };
> 
>  static const struct dw_mci_drv_data exynos_drv_data = {
> --
> 1.8.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

