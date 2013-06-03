Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab3FCB4k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 21:56:40 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:46608 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755276Ab3FCB4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 21:56:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,790,1363104000"; 
   d="scan'208";a="7440605"
Message-ID: <51ABF873.8090409@cn.fujitsu.com>
Date: Mon, 03 Jun 2013 09:59:15 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 06/13] memblock, numa: Introduce flag into memblock.
References: <1369387762-17865-1-git-send-email-tangchen@cn.fujitsu.com> <1369387762-17865-7-git-send-email-tangchen@cn.fujitsu.com> <20130603013034.GA31743@hacker.(null)>
In-Reply-To: <20130603013034.GA31743@hacker.(null)>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 09:54:46,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/03 09:54:51,
	Serialize complete at 2013/06/03 09:54:51
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Li,

On 06/03/2013 09:30 AM, Wanpeng Li wrote:
> On Fri, May 24, 2013 at 05:29:15PM +0800, Tang Chen wrote:
>> There is no flag in memblock to discribe what type the memory is.
>
> s/discribe/describe

OK.
......
>>
>> +#define MEMBLK_FLAGS_DEFAULT	0
>> +
>
> MEMBLK_FLAGS_DEFAULT is one of the memblock flags, it should also include in
> memblock_flags emum.
>

Hum, here I think I can change all the flags in the enum into macro. 
Seems that
the macro is easier to use.

Thanks. :)

