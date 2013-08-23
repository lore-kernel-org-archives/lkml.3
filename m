Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab3HWM4Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 08:56:25 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:22139 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755006Ab3HWM4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 08:56:20 -0400
X-AuditID: cbfee68e-b7f756d000004512-c3-52175bf323f6
Message-id: <52175BFB.2070405@samsung.com>
Date: Fri, 23 Aug 2013 21:56:27 +0900
From: Jaehoon Chung <jh80.chung@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Doug Anderson <dianders@chromium.org>
Cc: Chris Ball <cjb@laptop.org>, Seungwon Jeon <tgih.jun@samsung.com>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Grundler <grundler@chromium.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Olof Johansson <olof@lixom.net>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] mmc: dw_mmc: Set timeout to max upon resume
References: <1377188348-3418-1-git-send-email-dianders@chromium.org>
 <1377188348-3418-4-git-send-email-dianders@chromium.org>
In-reply-to: <1377188348-3418-4-git-send-email-dianders@chromium.org>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDIsWRmVeSWpSXmKPExsWyRsSkUPdztHiQwbpbIhaP1yxmsngwbxub
	xfbXG9kszi47yGbx6sgPJot3814wW1zeNYfN4sj/fkaLU9c/s1l8uH+R2WLVrj+MDtwesxsu
	snjsnHWX3aNn5xlGj0NX1jJ6XDnRxOrRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGWven2Qt
	eMBV8W/uE5YGxjscXYycHBICJhI/L31ih7DFJC7cW88GYgsJLGWUmPjNBabmQn8LcxcjF1B8
	OqNE3553UM5rRonbr16DdfMKaEl8f3OZGcRmEVCV2L16MhOIzSagI7H923EwW1QgTOLFq13M
	EPWCEj8m32MBsUUENCWeNbwEizMLvGWSmLBNDcQWFnCXeH3zGdRF9RK77h4A28Up4Crx63E7
	E0S9jsT+1mlsELa8xOY1b8GOkxD4yy4x9+51RoiDBCS+TT4EtIwDKCErsekAM8RnkhIHV9xg
	mcAoNgvJSbOQjJ2FZOwCRuZVjKKpBckFxUnpRUZ6xYm5xaV56XrJ+bmbGIExe/rfs74djDcP
	WB9iTAZaOZFZSjQ5HxjzeSXxhsZmRhamJqbGRuaWZqQJK4nzqrVYBwoJpCeWpGanphakFsUX
	leakFh9iZOLglGpgjPtyKPm3zT+DNymhP0uPrpnj90N9+3beLJ51Aq936oV/mFvvIb30oNPu
	TWfajiafO1V9SL26V1zqA0/+t13xqt7M5bnOfvvZSv4m6G1Z5+J09drVCOejy/qP1Kh3RkZY
	lnDu3zbJkT/5YmvDsobG+ovXd8nZpetKud2MK5Hd7H9V36DM65ePEktxRqKhFnNRcSIA9N5j
	nO8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFKsWRmVeSWpSXmKPExsVy+t9jQd3P0eJBBk+Wclk8XrOYyeLBvG1s
	Fttfb2SzOLvsIJvFqyM/mCzezXvBbHF51xw2iyP/+xktTl3/zGbx4f5FZotVu/4wOnB7zG64
	yOKxc9Zddo+enWcYPQ5dWcvoceVEE6tH35ZVjB6fN8kFsEc1MNpkpCampBYppOYl56dk5qXb
	KnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAF2ppFCWmFMKFApILC5W0rfDNCE0xE3X
	AqYxQtc3JAiux8gADSSsYcxY8/4ka8EDrop/c5+wNDDe4ehi5OSQEDCRuNDfwgxhi0lcuLee
	rYuRi0NIYDqjRN+ed8wQzmtGiduvXrODVPEKaEl8f3MZrINFQFVi9+rJTCA2m4COxPZvx8Fs
	UYEwiRevdjFD1AtK/Jh8jwXEFhHQlHjW8BIszizwlkliwjY1EFtYwF3i9c1nbCC2kEC9xK67
	B8B2cQq4Svx63M4EUa8jsb91GhuELS+xec1b5gmMArOQrJiFpGwWkrIFjMyrGEVTC5ILipPS
	cw31ihNzi0vz0vWS83M3MYJTwjOpHYwrGywOMQpwMCrx8E5wFgsSYk0sK67MPcQowcGsJML7
	UVo8SIg3JbGyKrUoP76oNCe1+BBjMjAEJjJLiSbnA9NVXkm8obGJmZGlkbmhhZGxOWnCSuK8
	B1qtA4UE0hNLUrNTUwtSi2C2MHFwSjUwOvSqViW5cu7SjIh4c4jt6fUfhx/GnhE9ttr9xMej
	888wuPG+X/PJLFB9YnP5TJcK/5ykXS2VfhZPRdrPSCTWZirqL/oY2S7m0XwoqlaY5YWKYEOw
	50ZHqy9rFqcfTnrQaPvhsEWMQvGcHP5rIrtdapkNppmY/ZXtOatbkMgzX35pwLSVcxYpsRRn
	JBpqMRcVJwIAuoFke00DAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Jaehoon Chung <jh80.chung@samsung.com>

On 08/23/2013 01:19 AM, Doug Anderson wrote:
> The TMOUT register is initted to 0xffffffff at probe time but isn't
> initted after suspend/resume.  Add an init of this value.
> 
> No problems were observed without this (it will also get initted in
> __dw_mci_start_request if there is data to send), but it makes the
> register dump before and after suspend cleaner.
> 
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Seungwon Jeon <tgih.jun@samsung.com>
> Reviewed-by: Tomasz Figa <t.figa@samsung.com>
> ---
> Changes in v6: None
> Changes in v5: None
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/mmc/host/dw_mmc.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index f6c7545..6a9a846 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -2506,6 +2506,9 @@ int dw_mci_resume(struct dw_mci *host)
>  	/* Restore the old value at FIFOTH register */
>  	mci_writel(host, FIFOTH, host->fifoth_val);
>  
> +	/* Put in max timeout */
> +	mci_writel(host, TMOUT, 0xFFFFFFFF);
> +
>  	mci_writel(host, RINTSTS, 0xFFFFFFFF);
>  	mci_writel(host, INTMASK, SDMMC_INT_CMD_DONE | SDMMC_INT_DATA_OVER |
>  		   SDMMC_INT_TXDR | SDMMC_INT_RXDR |
> 

