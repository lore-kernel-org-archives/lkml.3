Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755244Ab3HFIoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 04:44:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:12338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754958Ab3HFIoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 04:44:16 -0400
X-IronPort-AV: E=Sophos;i="4.89,825,1367942400"; 
   d="scan'208";a="8131974"
Message-ID: <5200B75F.6050906@cn.fujitsu.com>
Date: Tue, 06 Aug 2013 16:44:15 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Xishi Qiu <qiuxishi@huawei.com>
CC: ebiederm@xmission.com, kexec@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] kexec: remove unnecessary return
References: <5200B534.7000202@huawei.com>
In-Reply-To: <5200B534.7000202@huawei.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 16:42:53,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/06 16:42:54
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013/8/6 16:35, Xishi Qiu 写道:
> Code can not run here forever, so remove the unnecessary return.
> 
> Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
> Suggested-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

Reviewed-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>

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
> 


-- 
Thanks.
Zhang Yanfei
