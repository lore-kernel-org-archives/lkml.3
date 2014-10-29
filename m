Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349AbaJ2Gcz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 02:32:55 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:49108 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219AbaJ2Gcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 02:32:53 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Topic: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Thread-Index: AQHP8bvmvV8vePNHPEKsRX+GA9Vg3JxDoQwegAL+onA=
Date: Wed, 29 Oct 2014 06:32:48 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E890BC@EU-MBX-02.mgc.mentorg.com>
References: <1414396745-8845-1-git-send-email-sanjeev_sharma@mentor.com>
 <wrfjioj5aonx.fsf@redhat.com>
In-Reply-To: <wrfjioj5aonx.fsf@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Jes Sorensen [mailto:Jes.Sorensen@redhat.com] 
Sent: Monday, October 27, 2014 2:13 PM
To: Sharma, Sanjeev
Cc: Larry.Finger@lwfinger.net; gregkh@linuxfoundation.org; linux-wireless@vger.kernel.org; devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.

Sanjeev Sharma <sanjeev_sharma@mentor.com> writes:
> This is a patch to the rtw_cmd.c file that fixes Error reported by 
> checkpatch.
>
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 83 
> +++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 43 deletions(-)
>
> diff --git a/drivers/staging/rtl8723au/core/rtw_cmd.c 
> b/drivers/staging/rtl8723au/core/rtw_cmd.c
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

This makes the line longer than 80 characters, that is worse than the 'problem' you are fixing.

Jes

Hello jes,

How it can be worse because checkpatch treating this as an Error and line longer than 80 character is warning reported by checkpatch and I could see that in entire staging directory,
every maintainer most of the time ignore the 80 column limit and give priority to Error.

Please let me know your comment .

Sanjeev Sharma 
