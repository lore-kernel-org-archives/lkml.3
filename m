Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbaJ0Ioo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 04:44:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaJ0Ion (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 04:44:43 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Sanjeev Sharma <sanjeev_sharma@mentor.com>
Cc: <Larry.Finger@lwfinger.net>, <gregkh@linuxfoundation.org>,
        <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
Date: Mon, 27 Oct 2014 09:43:14 +0100
In-Reply-To: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
	(Sanjeev Sharma's message of "Mon, 27 Oct 2014 13:29:05 +0530")
Message-ID: <wrfjioj5aonx.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sanjeev Sharma <sanjeev_sharma@mentor.com> writes:
> This is a patch to the rtw_cmd.c file that fixes
> Error reported by checkpatch.
>
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 83 +++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c b/drivers/staging/rtl8723au/core/rtw_cmd.c
> index 4eaa502..c1f6254 100644
> --- a/drivers/staging/rtl8723au/core/rtw_cmd.c
> +++ b/drivers/staging/rtl8723au/core/rtw_cmd.c
> @@ -957,7 +957,7 @@ static void traffic_status_watchdog(struct rtw_adapter *padapter)
>  		/*  check traffic for  powersaving. */
>  			if (((pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod +
>  			      pmlmepriv->LinkDetectInfo.NumTxOkInPeriod) > 8) ||
> -			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod >2)
> +			    pmlmepriv->LinkDetectInfo.NumRxUnicastOkInPeriod > 2)
>  				bEnterPS = false;
>  			else
>  				bEnterPS = true;

This makes the line longer than 80 characters, that is worse than the
'problem' you are fixing.

Jes
