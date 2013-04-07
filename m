Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905Ab3DGPJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 11:09:11 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:53189 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858Ab3DGPJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 11:09:10 -0400
Message-ID: <51618C0A.1040205@gmail.com>
Date: Sun, 07 Apr 2013 23:08:58 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Simon Jeons <simon.jeons@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4, part3 00/15] accurately calculate memory statisitic
 information
References: <1365256509-29024-1-git-send-email-jiang.liu@huawei.com> <5160CD19.8070705@gmail.com>
In-Reply-To: <5160CD19.8070705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2013 09:34 AM, Simon Jeons wrote:
> Hi Jiang,
> On 04/06/2013 09:54 PM, Jiang Liu wrote:
>> Jiang Liu (15):
>>    mm: fix build warnings caused by free_reserved_area()
>>    mm: enhance free_reserved_area() to support poisoning memory with
>>      zero
>>    mm/ARM64: kill poison_init_mem()
>>    mm/x86: use free_reserved_area() to simplify code
>>    mm/tile: use common help functions to free reserved pages
>>    mm, powertv: use free_reserved_area() to simplify code
>>    mm, acornfb: use free_reserved_area() to simplify code
>>    mm: fix some trivial typos in comments
>>    mm: use managed_pages to calculate default zonelist order
>>    mm: accurately calculate zone->managed_pages for highmem zones
>>    mm: use a dedicated lock to protect totalram_pages and
>>      zone->managed_pages
>>    mm: make __free_pages_bootmem() only available at boot time
>>    mm: correctly update zone->mamaged_pages
>>    mm: concentrate modification of totalram_pages into the mm core
>>    mm: report available pages as "MemTotal" for each NUMA node
> 
> What I interested in is how you test different platform? I don't think you can have all the physical platform.
> 
Hi Simon,
	That's one issue I'm facing, I only have limited hardware platforms for testing,
so I could ask for help from the community to review and test the patch series.
	Regards!
	Gerry	

