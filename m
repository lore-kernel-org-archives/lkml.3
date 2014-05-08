Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753247AbaEHH7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:59:37 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:26003 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620AbaEHH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:59:36 -0400
Date: Thu, 8 May 2014 10:59:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Adithya K <linux.challenge1@gmail.com>
Cc: standby24x7@gmail.com, khoroshilov@ispras.ru, arnd@arndb.de,
        burzalodowa@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [PATCH] Staging: gdm72xx Fix minor coding style problems
Message-ID: <20140508075913.GX4963@mwanda>
References: <n>
 <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399530237-1788-1-git-send-email-user@akrishna-Latitude-E6430>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 11:53:57AM +0530, Adithya K wrote:
> This is patch for fixing of minor coding style problems.
> 
> Signed-off-by: Adithya K <linux.challenge1@gmail.com>
> ---
>  drivers/staging/gdm72xx/gdm_qos.c   |    3 ++-
>  drivers/staging/gdm72xx/gdm_sdio.c  |    1 +
>  drivers/staging/gdm72xx/gdm_usb.c   |    2 +-
>  drivers/staging/gdm72xx/gdm_wimax.c |    3 +++
>  drivers/staging/gdm72xx/usb_boot.c  |    1 +
>  5 files changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
> index 50d43ad..5ed32b9 100644
> --- a/drivers/staging/gdm72xx/gdm_qos.c
> +++ b/drivers/staging/gdm72xx/gdm_qos.c
> @@ -229,6 +229,7 @@ static u32 extract_qos_list(struct nic *nic, struct list_head *head)
>  					entry = list_entry(
>  					qcb->qos_list[i].prev,
>  					struct qos_entry_s, list);
> +
>  					list_move_tail(&entry->list, head);
>  					qcb->csr[i].qos_buf_count++;
>  

This one is wrong.  It's not something I care about but since the patch
needs to be redone, then please leave it out.

> diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
> index 20539d8..8fd1b1f 100644
> --- a/drivers/staging/gdm72xx/gdm_usb.c
> +++ b/drivers/staging/gdm72xx/gdm_usb.c
> @@ -759,7 +759,7 @@ static int k_mode_thread(void *arg)
>  			spin_lock_irqsave(&k_lock, flags2);
>  		}
>  		wait_event_interruptible_lock_irq(k_wait,
> -						  !list_empty(&k_list) || k_mode_stop,
> +		!list_empty(&k_list) || k_mode_stop,
>  						  k_lock);
>  		spin_unlock_irqrestore(&k_lock, flags2);
>  	}

This one is totally wrong.  Please resend withouth this chunk.

regards,
dan carpenter

