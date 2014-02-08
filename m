Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaBHUFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:05:09 -0500
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:46915 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbaBHUFG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:05:06 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:04:59 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 03/13] net: Include appropriate header file in
 caif/cfsrvl.c
Message-ID: <20140208200459.GC20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <6b6ceef0f79bffec0ec14784dc3d921d53231a3b.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6b6ceef0f79bffec0ec14784dc3d921d53231a3b.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:21:51AM +0530, Rashika Kheria wrote:
> Include appropriate header file net/caif/caif_dev.h in caif/cfsrvl.c
> because it has prototype declaration of functions defined in
> caif/cfsrvl.c.
> 
> This eliminates the following warning in caif/cfsrvl.c:
> net/caif/cfsrvl.c:198:6: warning: no previous prototype for ‘caif_free_client’ [-Wmissing-prototypes]
> net/caif/cfsrvl.c:208:6: warning: no previous prototype for ‘caif_client_register_refcnt’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  net/caif/cfsrvl.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/caif/cfsrvl.c b/net/caif/cfsrvl.c
> index 353f793..a6e1154 100644
> --- a/net/caif/cfsrvl.c
> +++ b/net/caif/cfsrvl.c
> @@ -15,6 +15,7 @@
>  #include <net/caif/caif_layer.h>
>  #include <net/caif/cfsrvl.h>
>  #include <net/caif/cfpkt.h>
> +#include <net/caif/caif_dev.h>
>  
>  #define SRVL_CTRL_PKT_SIZE 1
>  #define SRVL_FLOW_OFF 0x81
> -- 
> 1.7.9.5
> 
