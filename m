Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab3FAP3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 11:29:07 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55140 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868Ab3FAP3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 11:29:00 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 1 Jun 2013 08:29:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, Michal Simek <monstr@monstr.eu>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org
Subject: Re: [PATCH v2 2/2] watchdog: xilinx: Setup the origin compatible
 string
Message-ID: <20130601152933.GC7751@roeck-us.net>
References: <cover.1369979787.git.michal.simek@xilinx.com>
 <88e5677451bf32bb31e99b7d2d5acd7d75bdba0e.1369979787.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88e5677451bf32bb31e99b7d2d5acd7d75bdba0e.1369979787.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 07:56:34AM +0200, Michal Simek wrote:
> Watchdog 1.01.a is also compatible with 1.00.a.
> Add the origin version to compatible list.
> 
> Signed-off-by: Michal Simek <michal.simek@xilinx.com>

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

> ---
> Changes in v2:
> - Extend compatible list with 1.00.a instead of replacing 1.01.a
>   reported by Guenter Roeck <linux@roeck-us.net>
> 
>  drivers/watchdog/of_xilinx_wdt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/watchdog/of_xilinx_wdt.c b/drivers/watchdog/of_xilinx_wdt.c
> index d4a35ab..4dd281f 100644
> --- a/drivers/watchdog/of_xilinx_wdt.c
> +++ b/drivers/watchdog/of_xilinx_wdt.c
> @@ -384,6 +384,7 @@ static int xwdt_remove(struct platform_device *dev)
> 
>  /* Match table for of_platform binding */
>  static struct of_device_id xwdt_of_match[] = {
> +	{ .compatible = "xlnx,xps-timebase-wdt-1.00.a", },
>  	{ .compatible = "xlnx,xps-timebase-wdt-1.01.a", },
>  	{},
>  };
> --
> 1.8.2.3
> 


