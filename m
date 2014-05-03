Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361AbaECVJS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 17:09:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750972AbaECVJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 17:09:16 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] staging: rtl8723au: fix some confusing indenting
References: <20140503201919.GB32753@mwanda>
Date: Sat, 03 May 2014 23:09:07 +0200
In-Reply-To: <20140503201919.GB32753@mwanda> (Dan Carpenter's message of "Sat,
	3 May 2014 23:19:19 +0300")
Message-ID: <wrfjvbtmpo24.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> writes:
> The break and the "unknown++" are at the same indent level so my static
> checker complains.  The if statement should be indented more.
>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Urgh yes, that should be cleaned up!

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> index eb7b98e..4ad80e7 100644
> --- a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> +++ b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
> @@ -1235,8 +1235,8 @@ static int rtw_validate_frame_ies(const u8 *start, uint len)
>  		case WLAN_EID_ERP_INFO:
>  		case WLAN_EID_EXT_SUPP_RATES:
>  		case WLAN_EID_VENDOR_SPECIFIC:
> -		if (rtw_validate_vendor_specific_ies(pos, elen))
> -			unknown++;
> +			if (rtw_validate_vendor_specific_ies(pos, elen))
> +				unknown++;
>  			break;
>  		case WLAN_EID_RSN:
>  		case WLAN_EID_PWR_CAPABILITY:
