Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110AbaLTPoV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 10:44:21 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49197 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448AbaLTPoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 10:44:17 -0500
Date: Sat, 20 Dec 2014 07:44:13 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
        ebru.akagunduz@gmail.com, paulmck@linux.vnet.ibm.com,
        heenasirwani@gmail.com, cengelma@gmx.at, standby24x7@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] Staging:rtl8188eu:Fixed a space coding style issue.
Message-ID: <20141220154413.GA31570@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gangadhar Vukkesala <gangs.freelancer@gmail.com>,
	gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
	ebru.akagunduz@gmail.com, paulmck@linux.vnet.ibm.com,
	heenasirwani@gmail.com, cengelma@gmx.at, standby24x7@gmail.com,
	linux-kernel@vger.kernel.org
References: <1419086822-3045-1-git-send-email-gangs.freelancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419086822-3045-1-git-send-email-gangs.freelancer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gangadhar,

It is looking much better.  Just a few more nit picks though :)

In the subject line, tags usually have ':' next to the tag with a
space between.  Also, I usually keep them lowercase.

  staging: rtl8188eu: (then your description)

On Sat, Dec 20, 2014 at 08:17:02PM +0530, Gangadhar Vukkesala wrote:
> Fixed a Space Coding style issue which was found when running checkpatch.pl

"Space Coding" is not a noun so it does not need to be capitalized.

> script on rtw_ap.c.
> 
> Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Name looks good.

> ---
>  drivers/staging/rtl8188eu/core/rtw_ap.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/rtl8188eu/core/rtw_ap.c b/drivers/staging/rtl8188eu/core/rtw_ap.c
> index d61842e..da19145 100644
> --- a/drivers/staging/rtl8188eu/core/rtw_ap.c
> +++ b/drivers/staging/rtl8188eu/core/rtw_ap.c
> @@ -509,7 +509,7 @@ void add_RATid(struct adapter *padapter, struct sta_info *psta, u8 rssi_level)
>  		tx_ra_bitmap |= ((raid<<28)&0xf0000000);
>  
>  		DBG_88E("%s => mac_id:%d , raid:%d , bitmap = 0x%x, arg = 0x%x\n",
> -			__func__ , psta->mac_id, raid , tx_ra_bitmap, arg);
> +			__func__, psta->mac_id, raid, tx_ra_bitmap, arg);
>  
>  		/* bitmap[0:27] = tx_rate_bitmap */
>  		/* bitmap[28:31]= Rate Adaptive id */
> -- 
> Gangadhar V
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

If you fix those few things there is nothing else that I would have a
complaint about.

-- 
- Jeremiah Mahler
