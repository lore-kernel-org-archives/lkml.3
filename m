Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab3CYRH3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 13:07:29 -0400
Received: from hermes.synopsys.com ([198.182.44.81]:42551 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab3CYRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 13:07:27 -0400
Message-ID: <5150843B.1020804@synopsys.com>
Date: Mon, 25 Mar 2013 22:37:07 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Jiang Liu <liuj97@gmail.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Jiang Liu <jiang.liu@huawei.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Jianguo Wu <wujianguo@huawei.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [RFC PATCH v2, part4 00/39] Simplify mem_init() implementations
 and kill num_physpages
References: <1364109934-7851-1-git-send-email-jiang.liu@huawei.com> <1364112719.1975.4.camel@dabdike.int.hansenpartnership.com> <51507916.6030402@gmail.com>
In-Reply-To: <51507916.6030402@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.153]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 09:49 PM, Jiang Liu wrote:
> Hi James,
> 	Thanks for reminder, my patch series have been screwed up.
> I will send another version and build a git tree on github.
> 	Thanks!
> 	Gerry

Please don't forget conversion of the newly added arc and metag arches !

Thx,
-Vineet

> On 03/24/2013 04:11 PM, James Bottomley wrote:
>> On Sun, 2013-03-24 at 15:24 +0800, Jiang Liu wrote:
>>> The original goal of this patchset is to fix the bug reported by
>>> https://bugzilla.kernel.org/show_bug.cgi?id=53501
>>> Now it has also been expanded to reduce common code used by memory
>>> initializion.
>>>
>>> This is the last part, previous three patch sets could be accessed at:
>>> http://marc.info/?l=linux-mm&m=136289696323825&w=2
>>> http://marc.info/?l=linux-mm&m=136290291524901&w=2
>>> http://marc.info/?l=linux-mm&m=136345342831592&w=2
>>>
>>> This patchset applies to
>>> https://git.kernel.org/pub/scm/linux/kernel/git/mhocko/mm.git since-3.8
>>
>> You're going to have to have a git tree for this if you want this series
>> testing on other architectures.  Plus cc'ing linux-arch would be a good
>> idea for that case.  The patch series seems to be screwed up in the
>> numbering:  The parisc patches 26/39 and 27/39 are identical.
>>
>> James
>>
>>
>>
>>
>>
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

