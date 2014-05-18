Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654AbaERPrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 11:47:42 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:38421 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaERPrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 11:47:40 -0400
MIME-Version: 1.0
In-Reply-To: <1400426361-19596-14-git-send-email-navin.patidar@gmail.com>
References: <1400426361-19596-1-git-send-email-navin.patidar@gmail.com>
	<1400426361-19596-14-git-send-email-navin.patidar@gmail.com>
Date: Sun, 18 May 2014 21:17:40 +0530
Message-ID: <CAPV97ydFT8v6ph2W+qVuqRUb754DuuZ3+aWR82XgC39k6efxRA@mail.gmail.com>
Subject: Re: [PATCH 13/28] staging: rtl8188eu: Remove unused funtion phy_TxPwrIdxToDbm()
From: navin patidar <navin.patidar@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        navin patidar <navin.patidar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject line of this patch isn't correct, so please ignore it.
I've submitted new patch with "[PATCH 13/28] staging: rtl8188eu:
Remove unused funtion PHY_ScanOperationBackup8188E()"
subject line.

regards,
navin patidar

On Sun, May 18, 2014 at 8:49 PM, navin patidar <navin.patidar@gmail.com> wrote:
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c |    8 --------
>  1 file changed, 8 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
> index a7872c8..941ff74 100644
> --- a/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
> +++ b/drivers/staging/rtl8188eu/hal/rtl8188e_phycfg.c
> @@ -754,14 +754,6 @@ PHY_SetTxPowerLevel8188E(
>         rtl8188e_PHY_RF6052SetOFDMTxPower(Adapter, &ofdmPowerLevel[0], &BW20PowerLevel[0], &BW40PowerLevel[0], channel);
>  }
>
> -void
> -PHY_ScanOperationBackup8188E(
> -               struct adapter *Adapter,
> -               u8 Operation
> -       )
> -{
> -}
> -
>  /*-----------------------------------------------------------------------------
>   * Function:    PHY_SetBWModeCallback8192C()
>   *
> --
> 1.7.10.4
>
