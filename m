Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758709Ab3EWLb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 07:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758600Ab3EWLbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 07:31:23 -0400
Date: Thu, 23 May 2013 14:31:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next RFC 1/8] macvlan: switch to use IS_ENABLED()
Message-ID: <20130523113144.GA17993@redhat.com>
References: <1369278753-2533-1-git-send-email-jasowang@redhat.com>
 <1369278753-2533-2-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369278753-2533-2-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 11:12:26AM +0800, Jason Wang wrote:
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  include/linux/if_macvlan.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/if_macvlan.h b/include/linux/if_macvlan.h
> index 84dde1d..e47ad46 100644
> --- a/include/linux/if_macvlan.h
> +++ b/include/linux/if_macvlan.h
> @@ -8,7 +8,7 @@
>  #include <net/netlink.h>
>  #include <linux/u64_stats_sync.h>
>  
> -#if defined(CONFIG_MACVTAP) || defined(CONFIG_MACVTAP_MODULE)
> +#if IS_ENABLED(CONFIG_MACVTAP)
>  struct socket *macvtap_get_socket(struct file *);
>  #else
>  #include <linux/err.h>
> -- 
> 1.7.1
