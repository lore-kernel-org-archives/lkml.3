Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbaGRBFi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 21:05:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759079AbaGRBFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 21:05:37 -0400
Date: Thu, 17 Jul 2014 18:05:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kiran Padwal <kiran.padwal21@gmail.com>
Cc: devel@driverdev.osuosl.org, gulsah.1004@gmail.com, wkang77@gmail.com,
        rusty@rustcorp.com.au, valentina.manea.m@gmail.com,
        linux-kernel@vger.kernel.org, rashika.kheria@gmail.com
Subject: Re: [PATCH] Staging: gdm724x: gdm_lte.c: fix missing blank line
 after variable declaration
Message-ID: <20140718010536.GA28618@kroah.com>
References: <1405569638-9435-1-git-send-email-kiran.padwal21@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405569638-9435-1-git-send-email-kiran.padwal21@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 09:30:38AM +0530, Kiran Padwal wrote:
> Checkpatch fix - Add missing blank line after variable declaration
> 
> Signed-off-by: Kiran Padwal <kiran.padwal21@gmail.com>
> ---
>  drivers/staging/gdm724x/gdm_lte.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/gdm724x/gdm_lte.c b/drivers/staging/gdm724x/gdm_lte.c
> index 64c55b9..bc6d574 100644
> --- a/drivers/staging/gdm724x/gdm_lte.c
> +++ b/drivers/staging/gdm724x/gdm_lte.c
> @@ -447,6 +447,7 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
>  	 */
>  	if (nic_type & NIC_TYPE_F_VLAN) {
>  		struct vlan_ethhdr *vlan_eth = (struct vlan_ethhdr *)skb->data;
> +
>  		nic->vlan_id = ntohs(vlan_eth->h_vlan_TCI) & VLAN_VID_MASK;
>  		data_buf = skb->data + (VLAN_ETH_HLEN - ETH_HLEN);
>  		data_len = skb->len - (VLAN_ETH_HLEN - ETH_HLEN);
> @@ -505,6 +506,7 @@ static int gdm_lte_tx(struct sk_buff *skb, struct net_device *dev)
>  static struct net_device_stats *gdm_lte_stats(struct net_device *dev)
>  {
>  	struct nic *nic = netdev_priv(dev);
> +
>  	return &nic->stats;
>  }
>  

Someone else sent me this same patch back in May, and it's in my tree.
Please always work against linux-next, or my staging-next branch of my
staging.git tree if you want to send me patches like this.

thanks,

greg k-h
