Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbaFWWm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 18:42:27 -0400
Received: from filter04.dlls.pa.frontiernet.net ([199.224.80.234]:54559 "EHLO
	filter04.dlls.pa.frontiernet.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbaFWWm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 18:42:26 -0400
X-Originating-IP: [50.43.56.229]
X-Previous-IP: 50.43.56.229
Message-ID: <1403563331.12008.5.camel@Lunix2.home>
Subject: Re: [PATCH] amd: Neaten and remove unnecessary OOM messages
From: Don Fry <pcnet32@frontier.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 23 Jun 2014 15:42:11 -0700
In-Reply-To: <1403559395.20657.8.camel@joe-AO725>
References: <cover.1403530604.git.joe@perches.com>
	 <c7cdaa8e080157cdabb92278a4c3beba89b49070.1403530604.git.joe@perches.com>
	 <1403546524.12008.2.camel@Lunix2.home>
	 <1403550950.15811.15.camel@joe-AO725> <1403557507.20657.3.camel@joe-AO725>
	 <1403559395.20657.8.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:36 -0700, Joe Perches wrote:
> Make the code flow a little better for 80 columns.
> 
> Use a consistent style for the RX and TX rings allocation.
> Use BIT macro.
> Use a temporary unsiged int entries for (1<<size).
> Remove the OOM messages as they duplicate the generic
> OOM and dump_stack() provided by the memory subsystem.
> Reflow allocs to 80 columns.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/ethernet/amd/pcnet32.c | 43 ++++++++++++++++----------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
> index 8099fdc..4a8fdc4 100644
> --- a/drivers/net/ethernet/amd/pcnet32.c
> +++ b/drivers/net/ethernet/amd/pcnet32.c
> @@ -481,36 +481,32 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
>  	dma_addr_t *new_dma_addr_list;

Acked-By: Don Fry <pcnet32@frontier.com>

> 
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


