Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbaLTKaL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 05:30:11 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:59260 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaLTKaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 05:30:09 -0500
Date: Sat, 20 Dec 2014 02:30:04 -0800
From: Jeremiah Mahler <jmmahler@gmail.com>
To: Gangadhar V <gangs.freelancer@gmail.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8188eu : rtw_ap.c : Fixed a space coding
 style issue.
Message-ID: <20141220103004.GA28416@hudson.localdomain>
Mail-Followup-To: Jeremiah Mahler <jmmahler@gmail.com>,
	Gangadhar V <gangs.freelancer@gmail.com>,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
References: <1419069934-10382-1-git-send-email-gangs.freelancer@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419069934-10382-1-git-send-email-gangs.freelancer@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gangadhar,

It is looking better but it still needs some work :)

Be sure to add a version number to your subject line when you release
a new version of your patch so reviewers know it is not an entirely
new patch.

  [PATCH v2]

'git format-patch' will do this automatically with the '-v' option if you
are using that.

Also in the subject line, tags shouldn't include spaces.
e.g. 'rtl8188eu:' not 'rtl8188eu :'.

You don't need to include the file name ('rtw_ap.c') in the subject
line.

On Sat, Dec 20, 2014 at 03:35:34PM +0530, Gangadhar V wrote:
> Fixed a Space Coding style issue which was found when running checkpatch.pl script 
> on rtw_ap.c.

Log messages should be less than 80 characters wide.  I like to use 72
so that it doesn't wrap even after several replies.

> 
> Signed-off-by: Gangadhar V <gangs.freelancer@gmail.com>

Is this your full legal name?  Is your last name 'V'?

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

This looks reasonable.  There are only two checkpatch errors and you
fixed them both.

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

Time for version 3! :)

-- 
- Jeremiah Mahler
