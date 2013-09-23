Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab3IWQqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 12:46:36 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:58961 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWQqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 12:46:34 -0400
Message-ID: <52407058.8070806@gmail.com>
Date: Tue, 24 Sep 2013 00:46:16 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, rjw@sisk.pl, lenb@kernel.org,
        tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, toshi.kani@hp.com,
        zhangyanfei@cn.fujitsu.com, liwanp@linux.vnet.ibm.com, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v3 4/5] x86, mem-hotplug: Support initialize page tables
 from low to high.
References: <1379064655-20874-1-git-send-email-tangchen@cn.fujitsu.com> <1379064655-20874-5-git-send-email-tangchen@cn.fujitsu.com> <20130923155331.GE14547@htj.dyndns.org>
In-Reply-To: <20130923155331.GE14547@htj.dyndns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello tejun,

On 09/23/2013 11:53 PM, Tejun Heo wrote:
> Hey,
> 
> On Fri, Sep 13, 2013 at 05:30:54PM +0800, Tang Chen wrote:
>> init_mem_mapping() is called before SRAT is parsed. And memblock will allocate
>> memory for page tables. To prevent page tables being allocated within hotpluggable
>> memory, we will allocate page tables from the end of kernel image to the higher
>> memory.
> 
> The same comment about patch split as before.  Please make splitting
> out memory_map_from_high() a separate patch.  Also, please choose one
> pair to describe the direction.  The series is currently using four
> variants - top_down/bottom_up, high_to_low/low_to_high,
> from_high/from_low. rev/[none].  Please choose one and stick with it.

OK. will do the split and choose one pair. Thanks for the reminding again.

> 
> Thanks.
> 


-- 
Thanks.
Zhang Yanfei
