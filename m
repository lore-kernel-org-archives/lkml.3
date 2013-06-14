Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab3FNCxv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:53:51 -0400
Received: from relay3.sgi.com ([192.48.152.1]:35951 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750970Ab3FNCxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:53:50 -0400
Date: Thu, 13 Jun 2013 21:53:48 -0500
From: Robin Holt <holt@sgi.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Robin Holt <holt@sgi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Trivial PATCH 14/33] sgi: xpc: Convert use of typedef
 ctl_table to struct ctl_table
Message-ID: <20130614025348.GV3658@sgi.com>
References: <cover.1371177118.git.joe@perches.com>
 <4a2276e3c9bc2afc3b67651972a2a2b7f83b161c.1371177118.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a2276e3c9bc2afc3b67651972a2a2b7f83b161c.1371177118.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 07:37:39PM -0700, Joe Perches wrote:
> This typedef is unnecessary and should just be removed.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Robin Holt <holt@sgi.com>

> ---
>  drivers/misc/sgi-xp/xpc_main.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/misc/sgi-xp/xpc_main.c b/drivers/misc/sgi-xp/xpc_main.c
> index d971817..82dc574 100644
> --- a/drivers/misc/sgi-xp/xpc_main.c
> +++ b/drivers/misc/sgi-xp/xpc_main.c
> @@ -92,7 +92,7 @@ int xpc_disengage_timelimit = XPC_DISENGAGE_DEFAULT_TIMELIMIT;
>  static int xpc_disengage_min_timelimit;	/* = 0 */
>  static int xpc_disengage_max_timelimit = 120;
>  
> -static ctl_table xpc_sys_xpc_hb_dir[] = {
> +static struct ctl_table xpc_sys_xpc_hb_dir[] = {
>  	{
>  	 .procname = "hb_interval",
>  	 .data = &xpc_hb_interval,
> @@ -111,7 +111,7 @@ static ctl_table xpc_sys_xpc_hb_dir[] = {
>  	 .extra2 = &xpc_hb_check_max_interval},
>  	{}
>  };
> -static ctl_table xpc_sys_xpc_dir[] = {
> +static struct ctl_table xpc_sys_xpc_dir[] = {
>  	{
>  	 .procname = "hb",
>  	 .mode = 0555,
> @@ -126,7 +126,7 @@ static ctl_table xpc_sys_xpc_dir[] = {
>  	 .extra2 = &xpc_disengage_max_timelimit},
>  	{}
>  };
> -static ctl_table xpc_sys_dir[] = {
> +static struct ctl_table xpc_sys_dir[] = {
>  	{
>  	 .procname = "xpc",
>  	 .mode = 0555,
> -- 
> 1.8.1.2.459.gbcd45b4.dirty
