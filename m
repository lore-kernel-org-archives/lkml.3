Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab3CZAUE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 20:20:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:49234 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584Ab3CZAUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 20:20:02 -0400
Message-ID: <5150DBAA.1020100@infradead.org>
Date: Mon, 25 Mar 2013 16:20:10 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [PATCH] init/Kconfig: make EXPERT as config instead of menuconfig
References: <514BBBD2.9010602@huawei.com>
In-Reply-To: <514BBBD2.9010602@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/13 19:02, zhangwei(Jovi) wrote:
> There don't have any EXPERT menu guard, and no config item is
> included in EXPERT menu, so change it as a config, not menu.
> 
> This will make user more clear when they use 'make menuconfig'
> or 'make nconfig'.
> 
> Signed-off-by: zhangwei(Jovi) <jovi.zhangwei@huawei.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Michal Marek <mmarek@suse.cz>

Makes sense to me.

Acked-by: Randy Dunlap <rdunlap@infradead.org>


Thanks.

> ---
>  init/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 5341d72..0495453 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1177,7 +1177,7 @@ config SYSCTL
>  config ANON_INODES
>  	bool
> 
> -menuconfig EXPERT
> +config EXPERT
>  	bool "Configure standard kernel features (expert users)"
>  	# Unhide debug options, to make the on-by-default options visible
>  	select DEBUG_KERNEL
> 


-- 
~Randy
