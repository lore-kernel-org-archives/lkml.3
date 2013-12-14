Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3LNUdb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 15:33:31 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45077 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753596Ab3LNUda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 15:33:30 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 14 Dec 2013 12:33:22 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matt Porter <mporter@kernel.crashing.org>,
        Alexandre Bounine <alexandre.bounine@idt.com>
Subject: Re: [PATCH 1/3] drivers: rapidio: Include appropriate header file in
 rio-access.c
Message-ID: <20131214203322.GH17601@leaf>
References: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8522e3b2fefdb6625e9d7ae651cfa2dfd4733293.1386926041.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 14, 2013 at 06:16:28PM +0530, Rashika Kheria wrote:
> This patch includes appropriate header file linux/rio_drv.h in
> rio-access.c because functions __rio_local_read_config_8,
> __rio_local_read_config_16, __rio_local_read_config_32,
> __rio_local_write_config_8, __rio_local_write_config_16,
> __rio_local_write_config_32, rio_mport_read_config_8,
> rio_mport_read_config_16, rio_mport_read_config_32,
> rio_mport_write_config_8, rio_mport_write_config_16,
> rio_mport_write_config_32 and rio_mport_send_doorbell have their
> prototype declaration in linux/rio_drv.h.
> 
> Thus, it also eliminates the following warning in rio-access.c:
> 
> drivers/rapidio/rio-access.c:79:1: warning: no previous prototype for ‘__rio_local_read_config_8’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:80:1: warning: no previous prototype for ‘__rio_local_read_config_16’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:81:1: warning: no previous prototype for ‘__rio_local_read_config_32’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:82:1: warning: no previous prototype for ‘__rio_local_write_config_8’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:83:1: warning: no previous prototype for ‘__rio_local_write_config_16’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:84:1: warning: no previous prototype for ‘__rio_local_write_config_32’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:139:1: warning: no previous prototype for ‘rio_mport_read_config_8’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:140:1: warning: no previous prototype for ‘rio_mport_read_config_16’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:141:1: warning: no previous prototype for ‘rio_mport_read_config_32’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:142:1: warning: no previous prototype for ‘rio_mport_write_config_8’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:143:1: warning: no previous prototype for ‘rio_mport_write_config_16’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:144:1: warning: no previous prototype for ‘rio_mport_write_config_32’ [-Wmissing-prototypes]
> drivers/rapidio/rio-access.c:163:5: warning: no previous prototype for ‘rio_mport_send_doorbell’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/rapidio/rio-access.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/rapidio/rio-access.c b/drivers/rapidio/rio-access.c
> index a3824ba..5e6c7eb 100644
> --- a/drivers/rapidio/rio-access.c
> +++ b/drivers/rapidio/rio-access.c
> @@ -11,6 +11,7 @@
>   */
>  
>  #include <linux/rio.h>
> +#include <linux/rio_drv.h>
>  #include <linux/module.h>
>  
>  /*
> -- 
> 1.7.9.5
> 
