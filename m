Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3HFIjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:39:22 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:52716 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828Ab3HFIjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:39:18 -0400
Date: Tue, 6 Aug 2013 17:39:16 +0900
From: Simon Horman <horms@verge.net.au>
To: Xishi Qiu <qiuxishi@huawei.com>
Cc: zhangyanfei@cn.fujitsu.com, ebiederm@xmission.com,
        kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] kexec: remove unnecessary return
Message-ID: <20130806083915.GC28493@verge.net.au>
References: <5200B534.7000202@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5200B534.7000202@huawei.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 04:35:00PM +0800, Xishi Qiu wrote:
> Code can not run here forever, so remove the unnecessary return.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Suggested-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Reviewed-by: Simon Horman <horms@verge.net.au>

> ---
>  kernel/kexec.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index 59f7b55..2a74f30 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -1474,11 +1474,8 @@ static int __init __parse_crashkernel(char *cmdline,
>  	if (first_colon && (!first_space || first_colon < first_space))
>  		return parse_crashkernel_mem(ck_cmdline, system_ram,
>  				crash_size, crash_base);
> -	else
> -		return parse_crashkernel_simple(ck_cmdline, crash_size,
> -				crash_base);
>  
> -	return 0;
> +	return parse_crashkernel_simple(ck_cmdline, crash_size, crash_base);
>  }
>  
>  /*
> -- 
> 1.7.1
> 
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
> 
