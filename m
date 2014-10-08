Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbaJHOtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:49:12 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:60454 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbaJHOtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:49:10 -0400
Message-ID: <1412779746.11091.176.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: randconfig build error with next-20141008, in
 drivers/net/ethernet/mellanox/mlx4/en_tx.c
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, amirv@mellanox.com,
        netdev <netdev@vger.kernel.org>
Date: Wed, 08 Oct 2014 07:49:06 -0700
In-Reply-To: <CA+r1ZhiU6uzE-CQcTJoH2JxrS06H+5Paaofz+3Ugzon02mxD8Q@mail.gmail.com>
References: <CA+r1ZhiU6uzE-CQcTJoH2JxrS06H+5Paaofz+3Ugzon02mxD8Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-08 at 07:42 -0700, Jim Davis wrote:
> Building with the attached random configuration file,
> 
> drivers/net/ethernet/mellanox/mlx4/en_tx.c: In function ‘mlx4_en_process_tx_cq’:
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:395:27: error: ‘struct netdev_queue’
> has no member named ‘dql’
>   prefetchw(&ring->tx_queue->dql.limit);
>                            ^
> drivers/net/ethernet/mellanox/mlx4/en_tx.c: In function ‘mlx4_en_xmit’:
> drivers/net/ethernet/mellanox/mlx4/en_tx.c:740:27: error: ‘struct netdev_queue’
> has no member named ‘dql’
>   prefetchw(&ring->tx_queue->dql);
>                            ^
> make[5]: *** [drivers/net/ethernet/mellanox/mlx4/en_tx.o] Error 1

Thanks for the report, I'll take care of this.




