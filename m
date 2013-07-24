Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143Ab3GXBn5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:43:57 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55532 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750760Ab3GXBn4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:43:56 -0400
X-IronPort-AV: E=Sophos;i="4.89,731,1367942400"; 
   d="scan'208";a="7998914"
Message-ID: <51EF31FA.3030602@cn.fujitsu.com>
Date: Wed, 24 Jul 2013 09:46:34 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, joJoee@perches.com
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 01/21] acpi: Print Hot-Pluggable Field in SRAT.
References: <1374220774-29974-1-git-send-email-tangchen@cn.fujitsu.com> <1374220774-29974-2-git-send-email-tangchen@cn.fujitsu.com> <20130723184843.GG21100@mtj.dyndns.org>
In-Reply-To: <20130723184843.GG21100@mtj.dyndns.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 09:41:47,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/07/24 09:41:53
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 02:48 AM, Tejun Heo wrote:
> On Fri, Jul 19, 2013 at 03:59:14PM +0800, Tang Chen wrote:
>> The Hot-Pluggable field in SRAT suggests if the memory could be
>> hotplugged while the system is running. Print it as well when
>> parsing SRAT will help users to know which memory is hotpluggable.
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>> Reviewed-by: Wanpeng Li<liwanp@linux.vnet.ibm.com>
>
> Acked-by: Tejun Heo<tj@kernel.org>
>
> But a nit below
>
>> +	pr_info("SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx] %s\n",
>> +		node, pxm,
>> +		(unsigned long long) start, (unsigned long long) end - 1,
>> +		hotpluggable ? "Hot Pluggable" : "");
>
> The following would be more conventional.
>
>    "...10Lx]%s\n", ..., hotpluggable ? " Hot Pluggable" : ""
>
> Also, isn't "Hot Pluggable" a bit too verbose?  "hotplug" should be
> fine, I think.
>

Hi tj, Joe,

OK，will change it as you guys said.
Thank you very much.

Thanks.

