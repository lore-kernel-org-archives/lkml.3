Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaDZRJt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:09:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43196 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470AbaDZRJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:09:47 -0400
Message-ID: <535BE84F.2060502@infradead.org>
Date: Sat, 26 Apr 2014 10:09:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, Larry.Finger@lwfinger.net,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org
CC: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, quozl@laptop.org
Subject: Re: [PATCH/V2] staging: rtl8192e: Fix typo in rtl8192e
References: <20140424214908.GE12124@us.netrek.org> <1398522950-31439-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1398522950-31439-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/14 07:35, Masanari Iida wrote:
> Fix spelling typo in comments within rtl8192e.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> Reviewed-by: James Cameron <quozl@laptop.org>
> 
> ---
>  drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c | 2 +-
>  drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c    | 2 +-
>  drivers/staging/rtl8192e/rtl8192e/rtl_wx.c        | 2 +-
>  drivers/staging/rtl8192e/rtl819x_TSProc.c         | 2 +-
>  drivers/staging/rtl8192e/rtllib_rx.c              | 2 +-
>  drivers/staging/rtl8192e/rtllib_softmac.c         | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
> index 5f10e40..79d86b9 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_cmdpkt.c
> @@ -373,7 +373,7 @@ u32 cmpk_message_handle_rx(struct net_device *dev,
>  		default:
>  
>  			RT_TRACE(COMP_CMDPKT, "---->cmpk_message_handle_rx():"
> -				 "unknow CMD Element\n");
> +				 "unknown CMD Element\n");
>  			return 1;
>  		}
>  
> diff --git a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
> index 5d6d304..b4bfafe 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/r8192E_phy.c
> @@ -1555,7 +1555,7 @@ static bool SetRFPowerState8190(struct net_device *dev,
>  
>  		default:
>  			bResult = false;
> -			RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknow state"
> +			RT_TRACE(COMP_ERR, "SetRFPowerState8190(): unknown state"
>  				 " to set: 0x%X!!!\n", eRFPowerState);
>  			break;
>  		}
> diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> index 498995d..091dfe7 100644
> --- a/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> +++ b/drivers/staging/rtl8192e/rtl8192e/rtl_wx.c
> @@ -1213,7 +1213,7 @@ static iw_handler r8192_wx_handlers[] = {
>  };
>  
>  /*
> - * the following rule need to be follwing,
> + * the followed rules need to be following,

      the following rules need to be followed:
or
      these listed rules need to be followed:
or
      this list of rules should be used:

etc.

>   * Odd : get (world access),
>   * even : set (root access)
>   * */
> diff --git a/drivers/staging/rtl8192e/rtl819x_TSProc.c b/drivers/staging/rtl8192e/rtl819x_TSProc.c
> index 29608e5..52b2977 100644
> --- a/drivers/staging/rtl8192e/rtl819x_TSProc.c
> +++ b/drivers/staging/rtl8192e/rtl819x_TSProc.c
> @@ -79,7 +79,7 @@ static void RxPktPendingTimeout(unsigned long data)
>  
>  		if (index > REORDER_WIN_SIZE) {
>  			RTLLIB_DEBUG(RTLLIB_DL_ERR, "RxReorderIndicatePacket():"
> -				     " Rx Reorer struct buffer full!!\n");
> +				     " Rx Reorder struct buffer full!!\n");
>  			spin_unlock_irqrestore(&(ieee->reorder_spinlock),
>  					       flags);
>  			return;
> diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
> index 6c8a8e1..7413816 100644
> --- a/drivers/staging/rtl8192e/rtllib_rx.c
> +++ b/drivers/staging/rtl8192e/rtllib_rx.c
> @@ -712,7 +712,7 @@ static void RxReorderIndicatePacket(struct rtllib_device *ieee,
>  
>  		if (index > REORDER_WIN_SIZE) {
>  			RTLLIB_DEBUG(RTLLIB_DL_ERR, "RxReorderIndicatePacket():"
> -				     " Rx Reorer struct buffer full!!\n");
> +				     " Rx Reorder struct buffer full!!\n");
>  			spin_unlock_irqrestore(&(ieee->reorder_spinlock),
>  					       flags);
>  			return;
> diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
> index 4bf72bc..d65cba4 100644
> --- a/drivers/staging/rtl8192e/rtllib_softmac.c
> +++ b/drivers/staging/rtl8192e/rtllib_softmac.c
> @@ -543,7 +543,7 @@ void rtllib_softmac_scan_syncro(struct rtllib_device *ieee, u8 is_mesh)
>  				goto out; /* scan completed */
>  		} while (!ieee->active_channel_map[ch]);
>  
> -		/* this fuction can be called in two situations
> +		/* this function can be called in two situations
>  		 * 1- We have switched to ad-hoc mode and we are
>  		 *    performing a complete syncro scan before conclude
>  		 *    there are no interesting cell and to create a
> 


-- 
~Randy
