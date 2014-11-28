Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751405AbaK1Mfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:35:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750960AbaK1Mfc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:35:32 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Athira Lekshmi <andnlnbn18@gmail.com>
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        ruchandani.tina@gmail.com, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Drivers:staging:rtl8723au:core: Fixed checkpatch error
References: <1417176974-18604-1-git-send-email-andnlnbn18@gmail.com>
Date: Fri, 28 Nov 2014 07:35:23 -0500
In-Reply-To: <1417176974-18604-1-git-send-email-andnlnbn18@gmail.com> (Athira
	Lekshmi's message of "Fri, 28 Nov 2014 17:46:14 +0530")
Message-ID: <wrfjoarry038.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athira Lekshmi <andnlnbn18@gmail.com> writes:
> Fixed the checkpatch error:
> ERROR: spaces required around that '>'
>
> Signed-off-by: Athira Lekshmi <andnlnbn18@gmail.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
> index 44eae8e..9f1cdd4 100644
> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
> @@ -960,7 +960,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>  		/*  check traffic for  powersaving. */
>  			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
>  			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
> -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
> +			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
>  				bEnterPS = false;
>  			else
>  				bEnterPS = true;

NACK - I already stated this! Making the line longer than 80 characters
is worse then the 'problem' this fixes.

Jes
