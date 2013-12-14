Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab3LNUbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:31:51 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:52524 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab3LNUbt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:31:49 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:31:42 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Sachin Kamat <sachin.kamat@linaro.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 5/9] drivers: net: Put prototype declaration for
 function sbni_probe() in sbni.c
Message-ID: <20131214203142.GG17601@leaf>
References: <a610f6ee6bb992b91e43bdc851f3db62fc3decd5.1386911123.git.rashika.kheria@gmail.com>
 <dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dd984c99d43214c39b23f95e9a58f3a675147e69.1386911124.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 05:55:42PM +0530, Rashika Kheria wrote:
> This patch declares the prototype for the function sbni_probe() in file sbni.c.
> 
> Thus, it also removes the following warning in wan/sbni.c:
> drivers/net/wan/sbni.c:224:12: warning: no previous prototype for ‘sbni_probe’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/net/wan/sbni.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
> index 388ddf6..5061ffd 100644
> --- a/drivers/net/wan/sbni.c
> +++ b/drivers/net/wan/sbni.c
> @@ -221,6 +221,7 @@ static void __init sbni_devsetup(struct net_device *dev)
>  	dev->netdev_ops = &sbni_netdev_ops;
>  }
>  
> +int __init sbni_probe(int unit);
>  int __init sbni_probe(int unit)
>  {
>  	struct net_device *dev;
> -- 
> 1.7.9.5
> 
