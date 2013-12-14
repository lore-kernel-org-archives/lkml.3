Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754230Ab3LNUeI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:34:08 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:56877 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab3LNUeH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:34:07 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:34:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: Re: [PATCH 2/3] drivers: rapidio: Include appropriate header file in
 rio-driver.c
Message-ID: <20131214203401.GI17601@leaf>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
 <955c21bd0ce986e1e616f8f912a57568421f5078.1386926041.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <955c21bd0ce986e1e616f8f912a57568421f5078.1386926041.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:20:29PM +0530, Rashika Kheria wrote:
> This patch includes the header file linux/rio_drv.h in rio-driver.c
> because functions rio_dev_get(), rio_dev_put(), rio_register_driver()
> and rio_unregister_driver() have their prototype declarations in
> linux/rio_drv.h.
> 
> Thus, it also eliminates the following warnings in rio-driver.c:
> 
> drivers/rapidio/rio-driver.c:57:17: warning: no previous prototype for ‘rio_dev_get’ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:74:6: warning: no previous prototype for ‘rio_dev_put’ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:143:5: warning: no previous prototype for ‘rio_register_driver’ [-Wmissing-prototypes]
> drivers/rapidio/rio-driver.c:162:6: warning: no previous prototype for ‘rio_unregister_driver’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/rapidio/rio-driver.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rapidio/rio-driver.c b/drivers/rapidio/rio-driver.c
> index c9ae692..df73419 100644
> --- a/drivers/rapidio/rio-driver.c
> +++ b/drivers/rapidio/rio-driver.c
> @@ -13,6 +13,7 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/rio.h>
> +#include <linux/rio_drv.h>
>  #include <linux/rio_ids.h>
>  
>  #include "rio.h"
> -- 
> 1.7.9.5
> 
