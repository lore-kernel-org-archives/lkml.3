Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3DLBK3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:10:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:6942 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab3DLBK2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:10:28 -0400
X-IronPort-AV: E=Sophos;i="4.87,459,1363104000"; 
   d="scan'208";a="7039528"
Message-ID: <51675FA1.9000203@cn.fujitsu.com>
Date: Fri, 12 Apr 2013 09:13:05 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Lin Feng <linfeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com,
        Arnd Bergmann <arnd@arndb.de>, tony@atomide.com,
        Ben Hutchings <ben@decadent.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux MM <linux-mm@kvack.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [PATCH 0/2] mm: vmemmap: add vmemmap_verify check for hot-add
 node/memory case
References: <1365415000-10389-1-git-send-email-linfeng@cn.fujitsu.com> <CAE9FiQVaByGOTjLVthRkEze_ekXm5LAKgKdHzrD+q1iYmjgZFQ@mail.gmail.com> <51666930.6090702@cn.fujitsu.com> <CAE9FiQU-zqFdSz-7yq5EgV1YCzyNH_BY36Ym3tdHVEHHY6cdNg@mail.gmail.com>
In-Reply-To: <CAE9FiQU-zqFdSz-7yq5EgV1YCzyNH_BY36Ym3tdHVEHHY6cdNg@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 09:08:57,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/12 09:09:08
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 11:10 PM, Yinghai Lu wrote:
> On Thu, Apr 11, 2013 at 12:41 AM, Tang Chen<tangchen@cn.fujitsu.com>  wrote:
>>
>> 3. If we add flag to memblock, we can mark different memory. And I remember
>>     you mentioned before that we can use memblock to reserve local node data
>>     for node-life-cycle data, like vmemmap, pagetable.
>>
>>     So are you doing the similar work now ?
>
> No, i did not start it yet.
>
>>
>>     If not, I think I can merge it into mine, and push a new patch-set with
>>     hot-add, hot-remove code modified to support putting vmemmap, pagetable,
>>     pgdat, page_cgroup, ..., on local node.
>
> Need to have it separated with moving_zone.
>
> 1. rework memblock to keep alive all the way for hotplug usage.
> 2. put pagetable and vmemap on the local node range with help of memblock.
>

OK，thanks for the comments. I'll merge it into my work and post an RFC 
patch-set soon.

Thanks. :)
