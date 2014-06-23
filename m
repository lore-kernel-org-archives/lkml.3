Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaFWWbp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:31:45 -0400
Received: from filter02.roch.ny.frontiernet.net ([66.133.183.227]:58462 "EHLO
	filter02.roch.ny.frontiernet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751194AbaFWWbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:31:43 -0400
X-Greylist: delayed 537 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2014 18:31:43 EDT
X-Originating-IP: [50.43.56.229]
X-Previous-IP: 50.43.56.229
Message-ID: <1403562152.12008.4.camel@Lunix2.home>
Subject: Re: [PATCH V2 08/22] amd: Use pci_zalloc_consistent
From: Don Fry <pcnet32@frontier.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 23 Jun 2014 15:22:32 -0700
In-Reply-To: <1403557507.20657.3.camel@joe-AO725>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
	 <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:05 -0700, Joe Perches wrote:
> Remove the now unnecessary memset too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> On Mon, 2014-06-23 at 12:15 -0700, Joe Perches wrote:
> > On Mon, 2014-06-23 at 11:02 -0700, Don Fry wrote:
> > > This causes the line length to be greater than 80 characters causing
> > > checkpatch to complain.
> 
> V2: Don Fry is an 80 column neatnik.
> 
> Please remember this depends on patch 1/22 being applied
> before this patch can be successfully applied.
> 
>  drivers/net/ethernet/amd/pcnet32.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
> index e7cc917..8099fdc 100644
> --- a/drivers/net/ethernet/amd/pcnet32.c
> +++ b/drivers/net/ethernet/amd/pcnet32.c
> @@ -484,15 +484,14 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
>  
>  	pcnet32_purge_tx_ring(dev);
>  
> -	new_tx_ring = pci_alloc_consistent(lp->pci_dev,
> -					   sizeof(struct pcnet32_tx_head) *
> -					   (1 << size),
> -					   &new_ring_dma_addr);

Acked-By: Don Fry <pcnet32@frontier.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


