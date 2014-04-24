Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaDXV7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 17:59:15 -0400
Received: from zimbra.real-time.com ([63.170.91.9]:55393 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaDXV6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 17:58:32 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Apr 2014 17:58:32 EDT
Date: Fri, 25 Apr 2014 07:49:08 +1000
From: James Cameron <quozl@laptop.org>
To: Masanari Iida <standby24x7@gmail.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: rtl8192e: Fix typo in rtl8192e
Message-ID: <20140424214908.GE12124@us.netrek.org>
References: <1398358121-26805-1-git-send-email-standby24x7@gmail.com>
 <1398358121-26805-2-git-send-email-standby24x7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398358121-26805-2-git-send-email-standby24x7@gmail.com>
Organization: Netrek Vanilla Server Dictator
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2014 at 01:48:41AM +0900, Masanari Iida wrote:
> Fix spelling typo in comments within rtl8192e.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c | 2 +-
>  drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c    | 2 +-
>  drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        | 2 +-
>  drivers/staging/rtl8192e/rtl819x_TSProc.c         | 2 +-
>  drivers/staging/rtl8192e/rtllib_rx.c              | 2 +-
>  drivers/staging/rtl8192e/rtllib_softmac.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 

...

> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..59494f5 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -1213,7 +1213,7 @@ static iw_handler r8192_wx_handlers[] = {
>  };
>  
>  /*
> - * the following rule need to be follwing,
> + * the following rule need to be following,
>   * Odd : get (world access),
>   * even : set (root access)
>   * */

The change is good, and a better change might be "s/rule/rules" and
"s/following/followed".

On the other hand, no other driver mentions this implementation detail
of IW_IS_SET in declaration of iw_priv_args, so perhaps the whole
comment block should be removed.

Either way;

Reviewed-by: James Cameron <quozl@laptop.org>

p.s. nice to see you again.

-- 
James Cameron
http://quozl.linux.org.au/
