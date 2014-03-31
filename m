Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaCaI4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 04:56:47 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:25224 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627AbaCaI4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 04:56:45 -0400
Date: Mon, 31 Mar 2014 11:56:42 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: paulmcquad <paulmcquad@gmail.com>
Cc: gregkh@linuxfoundation.org, gamerh2o@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: Staging:et131x: change memcpy()  ether_addr_copy()
Message-ID: <20140331085642.GL6991@mwanda>
References: <5335F74A.9020507@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5335F74A.9020507@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 28, 2014 at 10:27:22PM +0000, paulmcquad wrote:
> >From 63f3c8948d5264ab22695502b201ff50edb9028d Mon Sep 17 00:00:00 2001
> From: Paul McQuade <paulmcquad@gmail.com>
> Date: Fri, 28 Mar 2014 22:16:22 +0000
> Subject: [PATCH] Staging:et131x: change memcpy()  ether_addr_copy()

Don't include this header block.

> 
> replace memcpy() with ether_addr_copy()
> make checkpatch.pl clean

Patch doesn't apply to linux-next.

> @@ -4337,7 +4337,7 @@ static void et131x_multicast(struct net_device *netdev)
>      netdev_for_each_mc_addr(ha, netdev) {
>          if (i == NIC_MAX_MCAST_LIST)
>              break;
> -        memcpy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);
> +    ether_addr_copy(adapter->multicast_list[i++], ha->addr, ETH_ALEN);

There is an indenting error here.

regards,
dan carpenter

