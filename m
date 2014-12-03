Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaLCGIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 01:08:46 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:39152 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaLCGIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 01:08:45 -0500
Date: Wed, 3 Dec 2014 11:38:37 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Sean Cleator <seancleator@hotmail.co.uk>
Cc: gregkh@linuxfoundation.org, Lior Dotan <liodot@gmail.com>,
        Christopher Harrer <charrer@alacritech.com>,
        David Matlack <matlackdavid@gmail.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Joe Perches <joe@perches.com>, Vincent Heuken <me@vincentheuken.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: slicoss: Fix long line issues in slicoss.c
Message-ID: <20141203060837.GC17730@sudip-PC>
References: <BLU436-SMTP148E68C36A6855503BCB5FFE97A0@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BLU436-SMTP148E68C36A6855503BCB5FFE97A0@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2014 at 11:45:00PM +0000, Sean Cleator wrote:
> 
>  A patch to the slicoss.c file to fix some of the long line issues found by the
>  checkpath.pl tool 
>  Signed-off-by: Sean Cleator <seancleator@hotmail.co.uk>

do not use whitespace before Signed-off-by

thanks
sudip

> 
> ---
>  drivers/staging/slicoss/slicoss.c | 39 ++++++++++++++++++++++++++-------------
>  1 file changed, 26 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
> index 56ca3b6..4df4a7e 100644
> --- a/drivers/staging/slicoss/slicoss.c
> +++ b/drivers/staging/slicoss/slicoss.c
> @@ -498,12 +498,14 @@ static int slic_card_download(struct adapter *adapter)
>  			slic_reg32_write(&slic_regs->slic_wcs,
>  					 baseaddress + codeaddr, FLUSH);
>  			/* Write out instruction to low addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  
>  			/* Write out instruction to high addr */
> -			slic_reg32_write(&slic_regs->slic_wcs, instruction, FLUSH);
> +			slic_reg32_write(&slic_regs->slic_wcs,
> +					instruction, FLUSH);
>  			instruction = *(u32 *)(fw->data + index);
>  			index += 4;
>  		}
> @@ -1533,14 +1535,18 @@ retry_rcvqfill:
>  				dev_err(dev, "%s: LOW 32bits PHYSICAL ADDRESS == 0\n",
>  					__func__);
>  				dev_err(dev, "skb[%p] PROBLEM\n", skb);
> -				dev_err(dev, "         skbdata[%p]\n", skb->data);
> +				dev_err(dev, "         skbdata[%p]\n",
> +						skb->data);
>  				dev_err(dev, "         skblen[%x]\n", skb->len);
>  				dev_err(dev, "         paddr[%p]\n", paddr);
>  				dev_err(dev, "         paddrl[%x]\n", paddrl);
>  				dev_err(dev, "         paddrh[%x]\n", paddrh);
> -				dev_err(dev, "         rcvq->head[%p]\n", rcvq->head);
> -				dev_err(dev, "         rcvq->tail[%p]\n", rcvq->tail);
> -				dev_err(dev, "         rcvq->count[%x]\n", rcvq->count);
> +				dev_err(dev, "         rcvq->head[%p]\n",
> +						rcvq->head);
> +				dev_err(dev, "         rcvq->tail[%p]\n",
> +						rcvq->tail);
> +				dev_err(dev, "         rcvq->count[%x]\n",
> +						rcvq->count);
>  				dev_err(dev, "SKIP THIS SKB!!!!!!!!\n");
>  				goto retry_rcvqfill;
>  			}
> @@ -1549,14 +1555,18 @@ retry_rcvqfill:
>  				dev_err(dev, "%s: LOW 32bits PHYSICAL ADDRESS == 0\n",
>  					__func__);
>  				dev_err(dev, "skb[%p] PROBLEM\n", skb);
> -				dev_err(dev, "         skbdata[%p]\n", skb->data);
> +				dev_err(dev, "         skbdata[%p]\n",
> +						skb->data);
>  				dev_err(dev, "         skblen[%x]\n", skb->len);
>  				dev_err(dev, "         paddr[%p]\n", paddr);
>  				dev_err(dev, "         paddrl[%x]\n", paddrl);
>  				dev_err(dev, "         paddrh[%x]\n", paddrh);
> -				dev_err(dev, "         rcvq->head[%p]\n", rcvq->head);
> -				dev_err(dev, "         rcvq->tail[%p]\n", rcvq->tail);
> -				dev_err(dev, "         rcvq->count[%x]\n", rcvq->count);
> +				dev_err(dev, "         rcvq->head[%p]\n",
> +						rcvq->head);
> +				dev_err(dev, "         rcvq->tail[%p]\n",
> +						rcvq->tail);
> +				dev_err(dev, "         rcvq->count[%x]\n",
> +						rcvq->count);
>  				dev_err(dev, "GIVE TO CARD ANYWAY\n");
>  			}
>  #endif
> @@ -1885,7 +1895,8 @@ static void slic_xmit_fail(struct adapter *adapter,
>  			break;
>  		case XMIT_FAIL_HOSTCMD_FAIL:
>  			dev_err(&adapter->netdev->dev,
> -				"xmit_start skb[%p] type[%x] No host commands available\n", skb, skb->pkt_type);
> +				"xmit_start skb[%p] type[%x] No host commands available\n",
> +				skb, skb->pkt_type);
>  			break;
>  		}
>  	}
> @@ -2097,7 +2108,8 @@ static void slic_interrupt_card_up(u32 isr, struct adapter *adapter,
>  				}
>  			} else if (isr & ISR_XDROP) {
>  				dev_err(&dev->dev,
> -						"isr & ISR_ERR [%x] ISR_XDROP\n", isr);
> +						"isr & ISR_ERR [%x] ISR_XDROP\n",
> +						isr);
>  			} else {
>  				dev_err(&dev->dev,
>  						"isr & ISR_ERR [%x]\n",
> @@ -2341,7 +2353,8 @@ static int slic_if_init(struct adapter *adapter)
>  				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
>  #else
>  		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
> -		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
> +		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr,
> +				FLUSH);
>  #endif
>  		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
>  					adapter->bit64reglock.flags);
> -- 
> 2.1.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
