Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752221AbaBHUPG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:15:06 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:35698 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751951AbaBHUPC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:15:02 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:14:54 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
Subject: Re: [PATCH 12/13] net: Include appropriate header file in
 netfilter/nft_lookup.c
Message-ID: <20140208201454.GL20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <401aceca1fc3f95097624fe8433635491b39248d.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <401aceca1fc3f95097624fe8433635491b39248d.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:39:20AM +0530, Rashika Kheria wrote:
> Include appropriate header file net/netfilter/nf_tables_core.h in
> net/netfilter/nft_lookup.c because it has prototype declaration of
> functions defined in net/netfilter/nft_lookup.c.
> 
> This eliminates the following warning in net/netfilter/nft_lookup.c:
> net/netfilter/nft_lookup.c:133:12: warning: no previous prototype for ‘nft_lookup_module_init’ [-Wmissing-prototypes]
> net/netfilter/nft_lookup.c:138:6: warning: no previous prototype for ‘nft_lookup_module_exit’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  net/netfilter/nft_lookup.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
> index 8a6116b..bb4ef4c 100644
> --- a/net/netfilter/nft_lookup.c
> +++ b/net/netfilter/nft_lookup.c
> @@ -16,6 +16,7 @@
>  #include <linux/netfilter.h>
>  #include <linux/netfilter/nf_tables.h>
>  #include <net/netfilter/nf_tables.h>
> +#include <net/netfilter/nf_tables_core.h>
>  
>  struct nft_lookup {
>  	struct nft_set			*set;
> -- 
> 1.7.9.5
> 
