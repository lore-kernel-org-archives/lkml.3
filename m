Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757240Ab3A1CAN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 21:00:13 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:12334 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3A1CAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 21:00:06 -0500
X-IronPort-AV: E=Sophos;i="4.84,549,1355068800"; 
   d="scan'208";a="6651314"
Message-ID: <5105D57D.3050900@cn.fujitsu.com>
Date: Mon, 28 Jan 2013 09:33:49 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Simon Jeons <simon.jeons@gmail.com>, akpm@linux-foundation.org,
        rientjes@google.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        wujianguo@huawei.com, wency@cn.fujitsu.com, hpa@zytor.com,
        linfeng@cn.fujitsu.com, laijs@cn.fujitsu.com, mgorman@suse.de,
        yinghai@kernel.org, glommer@parallels.com, jiang.liu@huawei.com,
        julian.calaby@gmail.com, sfr@canb.auug.org.au, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH Bug fix 0/5] Bug fix for physical memory hot-remove.
References: <1358854984-6073-1-git-send-email-tangchen@cn.fujitsu.com> <1358944171.3351.1.camel@kernel> <20130125131740.GA1615@dhcp22.suse.cz>
In-Reply-To: <20130125131740.GA1615@dhcp22.suse.cz>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:33:31,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/01/28 09:33:38,
	Serialize complete at 2013/01/28 09:33:38
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 09:17 PM, Michal Hocko wrote:
> On Wed 23-01-13 06:29:31, Simon Jeons wrote:
>> On Tue, 2013-01-22 at 19:42 +0800, Tang Chen wrote:
>>> Here are some bug fix patches for physical memory hot-remove. All these
>>> patches are based on the latest -mm tree.
>>> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm
>>>
>>> And patch1 and patch3 are very important.
>>> patch1: free compound pages when freeing memmap, otherwise the kernel
>>>          will panic the next time memory is hot-added.
>>> patch3: the old way of freeing pagetable pages was wrong. We should never
>>>          split larger pages into small ones.
>>>
>>>
>>
>> Hi Tang,
>>
>> I remember your big physical memory hot-remove patchset has already
>> merged by Andrew, but where I can find it? Could you give me git tree
>> address?
>
> Andrew tree is also mirrored into a git tree.
> http://git.kernel.org/?p=linux/kernel/git/mhocko/mm.git;a=summary
>
> It contains only Memory management patches on top of the last major
> release (since-.X.Y branch).

Hi Michal,

I'm not sure I got your meaning. :)

In http://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git akpm,
I can find the following commit.

commit deed0460e01b3968f2cf46fb94851936535b7e0d
Author: Tang Chen <tangchen@cn.fujitsu.com>
Date:   Sat Jan 19 11:07:13 2013 +1100

     memory-hotplug: do not allocate pgdat if it was not freed when 
offline.


This is one of memory hot-remove patches. Please try to update the 
mirror tree,
and try to find the above commit.

Thanks. :)

