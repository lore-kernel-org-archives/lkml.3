Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab3LUKzB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:55:01 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:54988 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324Ab3LUKzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:55:00 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:54:23 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] drivers: dgnc: Include appropriate header file in
 dgnc_trace.c
Message-ID: <20131221105423.GE3611@leaf>
References: <20131221102238.GA3197@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221102238.GA3197@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:52:38PM +0530, Rashika Kheria wrote:
> Include appropriate header file dgnc/dgnc_trace.h in dgnc_trace.c
> because function dgnc_tracer_free() has its prototype declaration in the
> header file.
> 
> This eliminates the following warning in dgnc_trace.c:
> drivers/staging/dgnc/dgnc_trace.c:180:6: warning: no previous prototype for ‘dgnc_tracer_free’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/dgnc/dgnc_trace.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/dgnc/dgnc_trace.c b/drivers/staging/dgnc/dgnc_trace.c
> index a98b7d4..e2164e4 100644
> --- a/drivers/staging/dgnc/dgnc_trace.c
> +++ b/drivers/staging/dgnc/dgnc_trace.c
> @@ -35,6 +35,7 @@
>  #include <linux/vmalloc.h>
>  
>  #include "dgnc_driver.h"
> +#include "dgnc_trace.h"
>  
>  #define TRC_TO_CONSOLE 1
>  
> -- 
> 1.7.9.5
> 
