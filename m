Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab3FNFFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 01:05:49 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54115 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab3FNFFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 01:05:47 -0400
X-IronPort-AV: E=Sophos;i="4.87,863,1363104000"; 
   d="scan'208";a="7544126"
Message-ID: <51BAA557.7060501@cn.fujitsu.com>
Date: Fri, 14 Jun 2013 13:08:39 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Thomas Renninger <trenn@suse.de>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        Rik van Riel <riel@redhat.com>, jweiner@redhat.com,
        Prarit Bhargava <prarit@redhat.com>,
        the arch/x86 maintainers <x86@kernel.org>, linux-doc@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Pekka Enberg <penberg@kernel.org>,
        Jacob Shin <jacob.shin@amd.com>
Subject: Re: [Part1 PATCH v5 21/22] x86, mm: Make init_mem_mapping be able
 to be called several times
References: <1371128589-8953-1-git-send-email-tangchen@cn.fujitsu.com> <1371128589-8953-22-git-send-email-tangchen@cn.fujitsu.com> <aad34de7-8ff7-442d-ad8a-bed2a6e3edea@email.android.com> <CAE9FiQXjg1zZB8veUHH2u9T5G1X8VMdMyY528YDhJtsFjKPxPQ@mail.gmail.com>
In-Reply-To: <CAE9FiQXjg1zZB8veUHH2u9T5G1X8VMdMyY528YDhJtsFjKPxPQ@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:03:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/14 13:03:49,
	Serialize complete at 2013/06/14 13:03:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 06:47 AM, Yinghai Lu wrote:
> On Thu, Jun 13, 2013 at 11:35 AM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com>  wrote:
>> Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>>
>>> From: Yinghai Lu<yinghai@kernel.org>
>>>
>>> Prepare to put page table on local nodes.
>>>
>>> Move calling of init_mem_mapping() to early_initmem_init().
>>>
>>> Rework alloc_low_pages to allocate page table in following order:
>>>        BRK, local node, low range
>>>
>>> Still only load_cr3 one time, otherwise we would break xen 64bit again.
>>>
>>
>>
>>
>> Sigh..  Can that comment on Xen be removed please.  The issue was fixed last release  and I believe I already asked to remove that comment as it is not true anymore.
>
> Sorry about that again, I thought I removed that already.

Sorry I didn't notice that. Will remove it if Yinghai or I resend this 
patch-set.

Thanks.
