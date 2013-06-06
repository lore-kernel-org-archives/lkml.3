Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3FFJjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:39:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20220 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab3FFJjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:39:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,814,1363104000"; 
   d="scan'208";a="7478931"
Message-ID: <51B05983.5060009@cn.fujitsu.com>
Date: Thu, 06 Jun 2013 17:42:27 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>
CC: mingo@redhat.com, hpa@zytor.com, akpm@linux-foundation.org,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com, tj@kernel.org,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, lwoodman@redhat.com, riel@redhat.com,
        jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v3 07/13] x86, numa, mem-hotplug: Mark nodes which the
 kernel resides in.
References: <1369387762-17865-1-git-send-email-tangchen@cn.fujitsu.com> <1369387762-17865-8-git-send-email-tangchen@cn.fujitsu.com> <20130531162401.GA31139@dhcp-192-168-178-175.profitbricks.localdomain> <51AC4759.6090101@cn.fujitsu.com> <20130603131823.GA4729@dhcp-192-168-178-175.profitbricks.localdomain>
In-Reply-To: <20130603131823.GA4729@dhcp-192-168-178-175.profitbricks.localdomain>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 17:37:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/06/06 17:37:52,
	Serialize complete at 2013/06/06 17:37:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vasilis,

On 06/03/2013 09:18 PM, Vasilis Liaskovitis wrote:
......
>>
>> In such an early time, I think we can only get nid from
>> numa_meminfo. So as I
>> said above, I'd like to fix this problem by making memblock has correct nid.
>>
>> And I read the patch below. I think if we get nid from numa_meminfo,
>> than we
>> don't need to call memblock_get_region_node().
>>
>
> ok. If we update the memblock nid fields from numa_meminfo,
> memblock_get_region_node will always return the correct node id.
>

I have fixed this problem in this way. And I'll send the new patches 
next week.

Thanks. :)

