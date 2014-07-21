Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaGUGcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:32:05 -0400
Received: from smtp4.infomaniak.ch ([84.16.68.92]:40465 "EHLO
	smtp4.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbaGUGcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:32:03 -0400
X-Greylist: delayed 335 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jul 2014 02:32:02 EDT
Message-ID: <53CCB282.7070901@brownhat.org>
Date: Mon, 21 Jul 2014 08:26:10 +0200
From: Daniele Venzano <venza@brownhat.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: davem@davemloft.net, joe@perches.com, netdev@vger.kernel.org
Subject: Re: [PATCH 24/30] sis900: remove unnecessary break after return
References: <1405866475-24754-1-git-send-email-fabf@skynet.be> <1405866475-24754-5-git-send-email-fabf@skynet.be>
In-Reply-To: <1405866475-24754-5-git-send-email-fabf@skynet.be>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/07/2014 16:27, Fabian Frederick ha scritto:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
Signed-off-by: Daniele Venzano <venza@brownhat.org>

> ---
>  drivers/net/ethernet/sis/sis900.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sis/sis900.c b/drivers/net/ethernet/sis/sis900.c
> index 6072f09..7bea17c 100644
> --- a/drivers/net/ethernet/sis/sis900.c
> +++ b/drivers/net/ethernet/sis/sis900.c
> @@ -2258,7 +2258,6 @@ static int sis900_set_config(struct net_device *dev, struct ifmap *map)
>  		case IF_PORT_100BASEFX: /* 100BaseFx */
>                  	/* These Modes are not supported (are they?)*/
>  			return -EOPNOTSUPP;
> -			break;
>  
>  		default:
>  			return -EINVAL;
> 


-- 
Daniele Venzano
http://www.brownhat.org

