Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885AbaLTJLE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 04:11:04 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:37331 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbaLTJKh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 04:10:37 -0500
Date: Sat, 20 Dec 2014 01:10:34 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gangadhar <gangs.freelancer@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu : rtw_ap.c : Fixed a space coding
 style issue.
Message-ID: <20141220091034.GA2513@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gangadhar <gangs.freelancer@gmail.com>, gregkh@linuxfoundation.org,
	linux-kernel@vger.kernel.org
References: <1419065708-10045-1-git-send-email-gangs.freelancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419065708-10045-1-git-send-email-gangs.freelancer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gangadhar,

On Sat, Dec 20, 2014 at 02:25:08PM +0530, Gangadhar wrote:
> From: gangadharv <gangs.freelancer@gmail.com>
> 
> Fixed a Coding style issue.
> 
> Signed-off-by: Gangadhar V <gangs.freelancer@gmail.com>

Your Signed-off-by doesn't much your From line.
Also, is this the full name you would use to sign off with on
legal documents?

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
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
- Jeremiah Mahler
