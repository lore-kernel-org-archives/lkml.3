Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaIWFvb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 01:51:31 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:50057 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbaIWFva (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 01:51:30 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 01:51:29 EDT
Message-ID: <54210912.1000203@mellanox.com>
Date: Tue, 23 Sep 2014 08:45:54 +0300
From: Amir Vadai <amirv@mellanox.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] mellanox: Change en_print to return void
References: <1411407622.2952.49.camel@joe-AO725>
In-Reply-To: <1411407622.2952.49.camel@joe-AO725>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.8.17.67]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/22/2014 8:40 PM, Joe Perches wrote:
> No caller or macro uses the return value so make it void.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
> This change is associated to a desire to eventually
> change printk to return void.
> 
>  drivers/net/ethernet/mellanox/mlx4/en_main.c | 17 +++++++----------
>  drivers/net/ethernet/mellanox/mlx4/mlx4_en.h |  4 ++--
>  2 files changed, 9 insertions(+), 12 deletions(-)

Thanks Joe.

Acked-By: Amir Vadai <amirv@mellanox.com>



