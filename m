Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967001Ab3HIAi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 20:38:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:20461 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1758211Ab3HIAi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 20:38:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,842,1367942400"; 
   d="scan'208";a="8158196"
Message-ID: <520439C9.3080601@cn.fujitsu.com>
Date: Fri, 09 Aug 2013 08:37:29 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: robert.moore@intel.com, lv.zheng@intel.com, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, tj@kernel.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH part2 0/4] acpi: Trivial fix and improving for memory
 hotplug.
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com> <1851799.n4moZnvj4u@vostro.rjw.lan>
In-Reply-To: <1851799.n4moZnvj4u@vostro.rjw.lan>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/09 08:37:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/08/09 08:37:28,
	Serialize complete at 2013/08/09 08:37:28
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 10:09 PM, Rafael J. Wysocki wrote:
> On Thursday, August 08, 2013 01:03:55 PM Tang Chen wrote:
>> This patch-set does some trivial fix and improving in ACPI code
>> for memory hotplug.
>>
>> Patch 1,3,4 have been acked.
>>
>> Tang Chen (4):
>>    acpi: Print Hot-Pluggable Field in SRAT.
>>    earlycpio.c: Fix the confusing comment of find_cpio_data().
>>    acpi: Remove "continue" in macro INVALID_TABLE().
>>    acpi: Introduce acpi_verify_initrd() to check if a table is invalid.
>>
>>   arch/x86/mm/srat.c |   11 ++++--
>>   drivers/acpi/osl.c |   84 +++++++++++++++++++++++++++++++++++++++------------
>>   lib/earlycpio.c    |   27 ++++++++--------
>>   3 files changed, 85 insertions(+), 37 deletions(-)
>
> It looks like this part doesn't depend on the other parts, is that correct?

No, it doesn't. And this patch-set can be merged first.

Thanks.

