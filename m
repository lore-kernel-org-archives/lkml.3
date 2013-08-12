Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397Ab3HLOZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:25:24 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49031 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3HLOZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:25:22 -0400
Message-ID: <5208F043.7020409@gmail.com>
Date: Mon, 12 Aug 2013 22:25:07 +0800
From: Tang Chen <imtangchen@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tang Chen <tangchen@cn.fujitsu.com>, robert.moore@intel.com,
        lv.zheng@intel.com, rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de,
        mingo@elte.hu, hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org, imtangchen@gmail.com
Subject: Re: [PATCH part2 1/4] acpi: Print Hot-Pluggable Field in SRAT.
References: <1375938239-18769-1-git-send-email-tangchen@cn.fujitsu.com> <1375938239-18769-2-git-send-email-tangchen@cn.fujitsu.com> <20130812141551.GD15892@htj.dyndns.org>
In-Reply-To: <20130812141551.GD15892@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 10:15 PM, Tejun Heo wrote:
> On Thu, Aug 08, 2013 at 01:03:56PM +0800, Tang Chen wrote:
>> +	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]%s\n",
>> +		node, pxm,
>> +		(unsigned long long) start, (unsigned long long) end - 1,
>> +		hotpluggable ? " Hot Pluggable" : "");
>
> Wouldn't it be better to just print "hotplug"?

Sure, followed.

Thanks.



