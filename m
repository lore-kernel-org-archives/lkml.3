Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3AKMHw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 07:07:52 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:65452 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab3AKMHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 07:07:40 -0500
X-IronPort-AV: E=Sophos;i="4.84,452,1355068800"; 
   d="scan'208";a="6568160"
Message-ID: <50F00052.80809@cn.fujitsu.com>
Date: Fri, 11 Jan 2013 20:06:42 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>, Wu Jianguo <wujianguo@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmots: memory-hotplug: implement register_page_bootmem_info_section
 of sparse-vmemmap fix
References: <20130111095658.GC7286@dhcp22.suse.cz> <20130111101745.GD7286@dhcp22.suse.cz> <20130111102924.GE7286@dhcp22.suse.cz> <20130111104759.GF7286@dhcp22.suse.cz>
In-Reply-To: <20130111104759.GF7286@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:07:02,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/11 20:07:02,
	Serialize complete at 2013/01/11 20:07:02
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/11/2013 06:47 PM, Michal Hocko wrote:
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index ddd3b58..d8edf52 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -32,6 +32,7 @@
>  #include <linux/memory_hotplug.h>
>  #include <linux/nmi.h>
>  #include <linux/gfp.h>
> +#include <linux/memory_hotplug.h>
except for this,

Tested-by: Lin Feng <linfeng@cn.fujitsu.com>
