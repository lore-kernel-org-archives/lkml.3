Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab3LQQh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:37:59 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:39452 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab3LQQh5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:37:57 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 17 Dec 2013 08:37:51 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        linux-ide@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: ide: Include appropriate header file in
 ide-pio-blacklist.c
Message-ID: <20131217163751.GC1062@leaf>
References: <d24d7befadfbfb9501d0e873f13e39fd42ec893b.1387278225.git.rashika.kheria@gmail.com>
 <2ec755ae03ae9f912f40a12a241f997909f380a1.1387278225.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2ec755ae03ae9f912f40a12a241f997909f380a1.1387278225.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 04:41:11PM +0530, Rashika Kheria wrote:
> Include appropriate header file include/linux/ide.h in file
> ide-pio-blacklist.c because function ide_scan_pio_blacklist() has it's
> prototype declaration in include/linux/ide.h.
> 
> This eliminates the following warning in ide-pio-blacklist.c:
> drivers/ide/ide-pio-blacklist.c:85:5: warning: no previous prototype for ‘ide_scan_pio_blacklist’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/ide/ide-pio-blacklist.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ide/ide-pio-blacklist.c b/drivers/ide/ide-pio-blacklist.c
> index a8c2c8f8..40e683a 100644
> --- a/drivers/ide/ide-pio-blacklist.c
> +++ b/drivers/ide/ide-pio-blacklist.c
> @@ -7,6 +7,7 @@
>   */
>  
>  #include <linux/string.h>
> +#include <linux/ide.h>
>  
>  static struct ide_pio_info {
>  	const char	*name;
> -- 
> 1.7.9.5
> 
