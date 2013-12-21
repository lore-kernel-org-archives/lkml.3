Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869Ab3LUK4H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:56:07 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:44155 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754700Ab3LUK4G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:56:06 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:55:56 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 2/2] drivers: dgap: Include appropriate header file in
 dgap_trace.c
Message-ID: <20131221105556.GG3611@leaf>
References: <20131221102825.GA3257@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221102825.GA3257@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:58:25PM +0530, Rashika Kheria wrote:
> Include appropriate header file dgap/dgap_trace.h in dgap_trace.c
> because function dgap_tracer_free() have its prototype declaration in
> the header file.
> 
> This eliminates the following warning in dgap_trace.c:
> drivers/staging/dgap/dgap_trace.c:181:6: warning: no previous prototype for ‘dgap_tracer_free’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/dgap/dgap_trace.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/dgap/dgap_trace.c b/drivers/staging/dgap/dgap_trace.c
> index 0f9a956..6c8b510 100644
> --- a/drivers/staging/dgap/dgap_trace.c
> +++ b/drivers/staging/dgap/dgap_trace.c
> @@ -37,6 +37,7 @@
>  #include <linux/vmalloc.h>
>  
>  #include "dgap_driver.h"
> +#include "dgap_trace.h"
>  
>  #define TRC_TO_CONSOLE 1
>  
> -- 
> 1.7.9.5
> 
