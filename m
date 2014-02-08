Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaBHUEu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 15:04:50 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:57140 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaBHUEt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 15:04:49 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 8 Feb 2014 12:04:43 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Tarnyagin <dmitry.tarnyagin@lockless.no>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 02/13] net: Include appropriate header file in
 caif/caif_dev.c
Message-ID: <20140208200443.GB20885@leaf>
References: <6f029c895035908595957fb16ab445c82793c77d.1391888654.git.rashika.kheria@gmail.com>
 <30885a464918e0f7cbb55b5c521a048f3e369c27.1391888654.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <30885a464918e0f7cbb55b5c521a048f3e369c27.1391888654.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 09, 2014 at 01:19:43AM +0530, Rashika Kheria wrote:
> Include appropriate header file net/caif/caif_dev.h in caif/caif_dev.c
> because it has prototype declarations of function defined in
> caif/caif_dev.c.
> 
> This eliminates the following file in caif/caif_dev.c:
> net/caif/caif_dev.c:303:6: warning: no previous prototype for ‘caif_enroll_dev’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  net/caif/caif_dev.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
> index 4dca159..edbca46 100644
> --- a/net/caif/caif_dev.c
> +++ b/net/caif/caif_dev.c
> @@ -22,6 +22,7 @@
>  #include <net/pkt_sched.h>
>  #include <net/caif/caif_device.h>
>  #include <net/caif/caif_layer.h>
> +#include <net/caif/caif_dev.h>
>  #include <net/caif/cfpkt.h>
>  #include <net/caif/cfcnfg.h>
>  #include <net/caif/cfserl.h>
> -- 
> 1.7.9.5
> 
