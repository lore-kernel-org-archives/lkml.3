Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932371Ab3BSKTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 05:19:19 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:59960 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616Ab3BSKTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 05:19:17 -0500
X-AuditID: cbfee691-b7f556d000001a24-6f-512351a4e7d7
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Dongjin Kim'" <tobetter@gmail.com>, "'unlisted-recipients:'"@samsung.com,
        "'no To-header on input'"@samsung.com
Cc: "'Jaehoon Chung'" <jh80.chung@samsung.com>,
        "'Sachin Kamat'" <sachin.kamat@linaro.org>,
        "'Chris Ball'" <cjb@laptop.org>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Will Newton'" <will.newton@imgtec.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
In-reply-to: <1361210793-5710-1-git-send-email-tobetter@gmail.com>
Subject: RE: [PATCH v3] mmc: dw_mmc: Add MSHC compatible for Exynos4412
Date: Tue, 19 Feb 2013 19:19:15 +0900
Message-id: <000501ce0e8a$91ef7c30$b5ce7490$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=ks_c_5601-1987
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4OArr686mrEyJuS0mOpRPVLZpS3AAQR9uw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrEIsWRmVeSWpSXmKPExsVy+t8zI90lgcqBBk+2cllc3jWHzeLI/35G
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLu3j3EXHBSpGLP2UesDYy/BboYOTgkBEwk9qyS6WLk
	BDLFJC7cW8/WxcjFISSwjFHix52frDA1Z9cqgdQICSxilGjrDIOo+cMocaFjGxNIgk1AS+Lv
	mzfMILaIQKnE5QevmEGKmAXWMkmsf3qUGaLbUeLIuiYWEJtTwEli57duMFtYwF3i3ZbZrCA2
	i4CqxMFNk8DqeQVsJdr/zGSCsAUlfky+B1bPLGAg8X5WHyuELS+xec1bZohD1SUe/dUFMUUE
	jCSa72pCVIhI7HvxjhHkHAmBVewSr1o2s0OsEpD4NvkQC0SrrMSmA8yQcJCUOLjiBssERolZ
	SBbPQrJ4FpLFs5CsWMDIsopRNLUguaA4Kb3IVK84Mbe4NC9dLzk/dxMjJL4m7mC8f8D6EGMy
	0PqJzFKiyfnA+MwriTc0NjYxMzE1Mbc0NTclTVhJnFf+kkygkEB6YklqdmpqQWpRfFFpTmrx
	IUYmDk6pBkYJlswLZ+5P2iqhJxJ4yjN14qvt749MXO7tNOWzGPsFkZmP/xjv3h67cfNk08Re
	scstts8nVtU6F3G+artzZlJY+AfBku0VzGJZDcUBB/8811K5ovZhh1bSNVMHmxW67c0qAf9X
	Pri/4Fn1Edmmn7LycRwvj9/8dyL88VTVW+9+f/E9VP7uktAGJZbijERDLeai4kQA4Bg1KMUC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsVy+t9jAd0lgcqBBs+Xslpc3jWHzeLI/35G
	ByaPz5vkAhijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwC
	dN0yc4BGKymUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1DQmC6zEyQAMJ6xgz7t49xFxwUqRi
	z9lHrA2MvwW6GDk4JARMJM6uVepi5AQyxSQu3FvPBmILCSxilGjrDOti5AKy/zBKXOjYxgSS
	YBPQkvj75g0ziC0iUCpx+cErZpAiZoG1TBLrnx5lhuh2lDiyrokFxOYUcJLY+a0bzBYWcJd4
	t2U2K4jNIqAqcXDTJLB6XgFbifY/M5kgbEGJH5PvgdUzCxhIvJ/Vxwphy0tsXvOWGeJodYlH
	f3VBTBEBI4nmu5oQFSIS+168Y5zAKDQLyaBZSAbNQjJoFpKWBYwsqxhFUwuSC4qT0nMN9YoT
	c4tL89L1kvNzNzGC4/eZ1A7GlQ0WhxgFOBiVeHg9XJQChVgTy4orcw8xSnAwK4nwzrdUDhTi
	TUmsrEotyo8vKs1JLT7EmAz050RmKdHkfGBqySuJNzQ2MTOyNDKzMDIxNydNWEmcl/HUkwAh
	gfTEktTs1NSC1CKYLUwcnFINjIY37r5Z0BJQNo3/V6tmi+2P6dJCqof3/w9sShFsuqhybpXp
	q8pF36Petl9o1Zztxypo275n1yYtRvuCxfIOcUH1Guz3ctc63W2dz+uuacV8536h17F1315m
	dn2PSC5cUuH8KfhiyDHntaw/hQVuLHXiNO3afPjIcacrahtbtTbsOPAxc17vFCWW4oxEQy3m
	ouJEANdJ1QIjAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 19, 2013, Dongjin Kim wrote:
> This patch adds the compatible string for MSHC controller of Exynos4412, and
> share the controller specific properties with Exynos5250 since they have same
> features. Its driver data name is changed to exynos_drv_data instead SoC
> specific name.

It's not actually same.
Exynos4412 doesn't have forward compatibilities for Exynos5250.
I agree that functionality of exynos_drv_data is common.
These functions have been implemented for existing Exynos*.
But in case of caps, it can't applied completely.
I'm concerning about this.

Thanks,
Seungwon Jeon
> 
> Cc: Jaehoon Chung <jh80.chung@samsung.com>
> Cc: Sachin Kamat <sachin.kamat@linaro.org>
> Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> ---
>  drivers/mmc/host/dw_mmc-exynos.c |   12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/mmc/host/dw_mmc-exynos.c b/drivers/mmc/host/dw_mmc-exynos.c
> index 4d50da6..38cd03c 100644
> --- a/drivers/mmc/host/dw_mmc-exynos.c
> +++ b/drivers/mmc/host/dw_mmc-exynos.c
> @@ -199,8 +199,8 @@ static int dw_mci_exynos_setup_bus(struct dw_mci *host,
>  	return 0;
>  }
> 
> -/* Exynos5250 controller specific capabilities */
> -static unsigned long exynos5250_dwmmc_caps[4] = {
> +/* Exynos4412/Exynos5250 controller specific capabilities */
> +static unsigned long exynos_dwmmc_caps[4] = {
>  	MMC_CAP_UHS_DDR50 | MMC_CAP_1_8V_DDR |
>  		MMC_CAP_8_BIT_DATA | MMC_CAP_CMD23,
>  	MMC_CAP_CMD23,
> @@ -208,8 +208,8 @@ static unsigned long exynos5250_dwmmc_caps[4] = {
>  	MMC_CAP_CMD23,
>  };
> 
> -static const struct dw_mci_drv_data exynos5250_drv_data = {
> -	.caps			= exynos5250_dwmmc_caps,
> +static const struct dw_mci_drv_data exynos_drv_data = {
> +	.caps			= exynos_dwmmc_caps,
>  	.init			= dw_mci_exynos_priv_init,
>  	.setup_clock		= dw_mci_exynos_setup_clock,
>  	.prepare_command	= dw_mci_exynos_prepare_command,
> @@ -219,8 +219,10 @@ static const struct dw_mci_drv_data exynos5250_drv_data = {
>  };
> 
>  static const struct of_device_id dw_mci_exynos_match[] = {
> +	{ .compatible = "samsung,exynos4412-dw-mshc",
> +			.data = &exynos_drv_data, },
>  	{ .compatible = "samsung,exynos5250-dw-mshc",
> -			.data = &exynos5250_drv_data, },
> +			.data = &exynos_drv_data, },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, dw_mci_exynos_match);
> --
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

