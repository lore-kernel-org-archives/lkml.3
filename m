Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932487AbaICMWD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 08:22:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59044 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170AbaICMV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 08:21:59 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Greg Donald <gdonald@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linux.com>,
        Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: staging: rtl8723au: Fix return is not a function, parentheses are not required error
References: <1409532379-1697-1-git-send-email-gdonald@gmail.com>
Date: Wed, 03 Sep 2014 14:21:38 +0200
In-Reply-To: <1409532379-1697-1-git-send-email-gdonald@gmail.com> (Greg
	Donald's message of "Sun, 31 Aug 2014 19:46:19 -0500")
Message-ID: <wrfjoauwdhd9.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Donald <gdonald@gmail.com> writes:
> Fix checkpatch.pl return is not a function, parentheses are not required error
>
> Signed-off-by: Greg Donald <gdonald@gmail.com>
> ---
>  drivers/staging/rtl8723au/include/osdep_service.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Yes please!

Acked-by: Jes Sorensen <Jes.Sorensen@redhat.com>

>
> diff --git a/drivers/staging/rtl8723au/include/osdep_service.h
> b/drivers/staging/rtl8723au/include/osdep_service.h
> index 51a5d7b..dedb418 100644
> --- a/drivers/staging/rtl8723au/include/osdep_service.h
> +++ b/drivers/staging/rtl8723au/include/osdep_service.h
> @@ -54,7 +54,7 @@ struct rtw_queue {
>  
>  static inline struct list_head *get_list_head(struct rtw_queue *queue)
>  {
> -	return (&queue->queue);
> +	return &queue->queue;
>  }
>  
>  static inline int rtw_netif_queue_stopped(struct net_device *pnetdev)
